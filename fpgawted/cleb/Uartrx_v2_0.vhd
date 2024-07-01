-- file Uartrx_v2_0.vhd
-- Uartrx_v2_0 module implementation
-- copyright: (C) 2016-2018 MPSI Technologies GmbH
-- author: Alexander Wirthmueller
-- date created: 6 Aug 2016
-- date modified: 6 Apr 2018
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Uartrx_v2_0 is
	generic(
		fMclk: natural := 50000; -- in kHz

		fSclk: natural range 100 to 50000000 := 115200
	);
	port(
		reset: in std_logic;

		mclk: in std_logic;

		req: in std_logic;
		ack: out std_logic;
		dne: out std_logic;

		len: in std_logic_vector(31 downto 0);

		AXIS_tready: in std_logic; -- expect this to be 1
		AXIS_tvalid: out std_logic;
		AXIS_tdata: out std_logic_vector(7 downto 0);
		AXIS_tlast: out std_logic;

		rxd: in std_logic;

		burst: in std_logic
	);
end Uartrx_v2_0;

architecture Rtl of Uartrx_v2_0 is

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	-- unsolicited transfer monitor (mon)
	type stateMon_t is (
		stateMonInit,
		stateMonIdle,
		stateMonBusy
	);
	signal stateMon: stateMon_t := stateMonInit;

	signal rng: std_logic;

	-- receive operation (recv)
	type stateRecv_t is (
		stateRecvInit,
		stateRecvWaitStart,
		stateRecvStart, -- strb low
		stateRecvData, -- strb low
		stateRecvStop,
		stateRecvDone
	);
	signal stateRecv: stateRecv_t := stateRecvInit;

	constant tbit: natural := ((1000*fMclk)/fSclk);
	constant tbithalf: natural := ((500*fMclk)/fSclk);

	signal ack_sig: std_logic;

	signal AXIS_tvalid_sig: std_logic;
	signal AXIS_tdata_sig: std_logic_vector(7 downto 0);
	signal AXIS_tlast_sig: std_logic;

begin

	------------------------------------------------------------------------
	-- implementation: unsolicited transfer monitor (mon)
	------------------------------------------------------------------------

	rng <= '1' when stateMon=stateMonBusy else '0';

	process (reset, mclk, stateMon)
		variable i: natural range 0 to tbit;
		variable j: natural range 0 to 10;

	begin
		if reset='1' then
			stateMon <= stateMonInit;

		elsif rising_edge(mclk) then
			if stateMon=stateMonInit then
				i := 0;
				j := 0;

				stateMon <= stateMonIdle;

			elsif stateMon=stateMonIdle then
				if req='0' and rxd='0' then
					stateMon <= stateMonBusy;
				end if;

			elsif stateMon=stateMonBusy then
				if rxd='0' then
					i := 0;
					j := 0;

				else
					i := i + 1;

					if i=tbit then
						i := 0;

						j := j + 1;
						if j=9 then
							j := 0;
							stateMon <= stateMonInit;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: receive operation (recv)
	------------------------------------------------------------------------

	dne <= '1' when stateRecv=stateRecvDone else '0';

	ack <= ack_sig;

	AXIS_tvalid <= AXIS_tvalid_sig;
	AXIS_tdata <= AXIS_tdata_sig;
	AXIS_tlast <= AXIS_tlast_sig;

	process (reset, mclk, stateRecv)
		variable draw: std_logic_vector(7 downto 0);

		variable bitcnt: natural range 0 to 7;
		variable bytecnt: natural;

		variable i: natural range 0 to tbit;

	begin
		if reset='1' then
			stateRecv <= stateRecvInit;
			ack_sig <= '0';
			AXIS_tvalid_sig <= '0';
			AXIS_tdata_sig <= (others => '0');
			AXIS_tlast_sig <= '0';

		elsif rising_edge(mclk) then
			if (stateRecv=stateRecvInit or req='0') then
				ack_sig <= '0';
				AXIS_tvalid_sig <= '0';
				AXIS_tdata_sig <= (others => '0');
				AXIS_tlast_sig <= '0';

				draw := (others => '0');

				bytecnt := 0;

				if req='0' then
					stateRecv <= stateRecvInit;

				else
					if (burst='1' or rng='0') then
						stateRecv <= stateRecvWaitStart;
					end if;
				end if;

			elsif stateRecv=stateRecvWaitStart then
				AXIS_tvalid_sig <= '0';

				if rxd='0' then
					ack_sig <= '1';

					i := 0;

					stateRecv <= stateRecvStart;
				end if;
			
			elsif stateRecv=stateRecvStart then
				i := i + 1;
				if i=tbithalf then -- sample mid-bit
					i := 0;

					bitcnt := 0;

					stateRecv <= stateRecvData;
				end if;
			
			elsif stateRecv=stateRecvData then
				i := i + 1;
				if i=tbit then
					i := 0;

					draw(bitcnt) := rxd;

					if bitcnt=7 then
						if bytecnt=to_integer(unsigned(len)) then -- bytes received minus one
							AXIS_tlast_sig <= '1';
						end if;

						bitcnt := 0;

						stateRecv <= stateRecvStop;
					else
						bitcnt := bitcnt + 1;
					end if;
				end if;

			elsif stateRecv=stateRecvStop then
				--AXIS_tvalid_sig <= '0';

				i := i + 1;
				if i=tbit then
					i := 0;
					
					if rxd='1' then
						AXIS_tvalid_sig <= '1';
						AXIS_tdata_sig <= draw;

						if AXIS_tlast_sig='1' then
							stateRecv <= stateRecvDone; -- TBD: check if _tlast='1' is OK while _tvalid='0'

						else
							bytecnt := bytecnt + 1; -- bytes received

							stateRecv <= stateRecvWaitStart;
						end if;

					else
						stateRecv <= stateRecvInit; -- should not happen
					end if;
				end if;

			elsif stateRecv=stateRecvDone then
				AXIS_tvalid_sig <= '0';

				-- if req='0' then
				-- 	stateRecv <= stateRecvInit;
				-- end if;
			end if;
		end if;
	end process;

end Rtl;
