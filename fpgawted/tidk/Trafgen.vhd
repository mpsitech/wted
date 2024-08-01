-- file Trafgen.vhd
-- Trafgen easy model controller implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 30 Jun 2024
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Tidk.all;

entity Trafgen is
	port (
		reset: in std_logic;
		mclk: in std_logic;

		resetMemclk: in std_logic;
		memclk: in std_logic;

		memTWrAXI_awaddr: out std_logic_vector(19 downto 0);
		memTWrAXI_awready: in std_logic;
		memTWrAXI_awvalid: out std_logic;
		memTWrAXI_wdata: out std_logic_vector(31 downto 0);
		memTWrAXI_wlast: out std_logic;
		memTWrAXI_wready: in std_logic;
		memTWrAXI_wvalid: out std_logic;

		reqToDdrifWr: out std_logic;
		ackToDdrifWr: in std_logic;

		rng: out std_logic;

		reqInvSet: in std_logic;
		ackInvSet: out std_logic;

		setRng: in std_logic_vector(7 downto 0)
	);
end Trafgen;

architecture Rtl of Trafgen is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Neotrng_v1_0 is
		generic (
			NUM_CELLS: natural := 3;
			NUM_INV_START: natural := 3;
			NUM_INV_INC: natural := 2;
			NUM_INV_DELAY: natural := 2;
			POST_PROC_EN: boolean := true;
			IS_SIM: boolean := false
		);
		port (
			clk_i: in std_logic;
			enable_i: in std_logic;
			data_o: out std_logic_vector(7 downto 0);
			valid_o: out std_logic
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- copy data from setbuf to DDR memory (egr)
	type stateEgr_t is (
		stateEgrInit,
		stateEgrStart,
		stateEgrRunA, stateEgrRunB, stateEgrRunC
	);
	signal stateEgr: stateEgr_t := stateEgrInit;

	signal memTWrAXI_awaddr_sig: std_logic_vector(19 downto 0);
	signal memTWrAXI_awvalid_sig: std_logic;
	signal memTWrAXI_wdata_sig: std_logic_vector(31 downto 0);
	signal memTWrAXI_wlast_sig: std_logic;
	signal memTWrAXI_wvalid_sig: std_logic;

	signal reqToDdrifWr_sig: std_logic;

	-- IP sigs.egr.cust --- INSERT

	---- main operation (op)
	type stateOp_t is (
		stateOpInit,
		stateOpInv,
		stateOpGetRnA, stateOpGetRnB
	);
	signal stateOp: stateOp_t := stateOpInit;

	signal ackInvSet_sig: std_logic;
	signal rng_sig: std_logic;
	signal enLenrng: std_logic;
	signal len: std_logic_vector(2 downto 0); -- in bursts: allow max. 2 kB i.e. 8 bursts for 128-bit interface
	signal enOfsrng: std_logic;
	signal ofs: std_logic_vector(7 downto 0);

	-- IP sigs.op.cust --- INSERT

	---- myLenrng
	signal lenrn: std_logic_vector(7 downto 0);
	signal validLenrn: std_logic;

	---- myOfsrng
	signal ofsrn: std_logic_vector(7 downto 0);
	signal validOfsrn: std_logic;

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myLenrng : Neotrng_v1_0
		generic map (
			NUM_CELLS => 3,
			NUM_INV_START => 3,
			NUM_INV_INC => 2,
			NUM_INV_DELAY => 2,
			POST_PROC_EN => true,
			IS_SIM => false
		)
		port map (
			clk_i => mclk,
			enable_i => enLenrng,
			data_o => lenrn,
			valid_o => validLenrn
		);

	myOfsrng : Neotrng_v1_0
		generic map (
			NUM_CELLS => 3,
			NUM_INV_START => 3,
			NUM_INV_INC => 2,
			NUM_INV_DELAY => 2,
			POST_PROC_EN => true,
			IS_SIM => false
		)
		port map (
			clk_i => mclk,
			enable_i => enOfsrng,
			data_o => ofsrn,
			valid_o => validOfsrn
		);

	------------------------------------------------------------------------
	-- implementation: copy data from setbuf to DDR memory (egr)
	------------------------------------------------------------------------

	-- IP impl.egr.wiring --- BEGIN
	memTWrAXI_awaddr <= memTWrAXI_awaddr_sig;
	memTWrAXI_awvalid_sig <= '1' when stateEgr=stateEgrRunB else '0';
	memTWrAXI_awvalid <= memTWrAXI_awvalid_sig;
	memTWrAXI_wdata <= memTWrAXI_wdata_sig;
	memTWrAXI_wlast <= memTWrAXI_wlast_sig;
	memTWrAXI_wvalid_sig <= '1' when stateEgr=stateEgrRunC else '0';
	memTWrAXI_wvalid <= memTWrAXI_wvalid_sig;

	reqToDdrifWr_sig <= '1' when stateEgr=stateEgrRunB else '0';
	reqToDdrifWr <= reqToDdrifWr_sig;
	-- IP impl.egr.wiring --- END

	-- IP impl.egr.rising --- BEGIN
	process (resetMemclk, memclk, stateEgr)
		-- IP impl.egr.vars --- BEGIN
		-- IP impl.egr.vars --- END

	begin
		if resetMemclk='1' then
			-- IP impl.egr.asyncrst --- BEGIN
			stateEgr <= stateEgrInit;
			memTWrAXI_awaddr_sig <= (others => '0');
			memTWrAXI_wdata_sig <= (others => '0');
			memTWrAXI_wlast_sig <= '1';

			-- IP impl.egr.asyncrst --- END

		elsif rising_edge(memclk) then
			if stateEgr=stateEgrInit then
				-- IP impl.egr.syncrst --- BEGIN
				memTWrAXI_awaddr_sig <= (others => '0');
				memTWrAXI_wdata_sig <= (others => '0');
				memTWrAXI_wlast_sig <= '1';

				-- IP impl.egr.syncrst --- END

				if !rng_sig_memclk then
					stateEgr <= stateEgrInit;

				else
					stateEgr <= stateEgrStart;
				end if;

			elsif stateEgr=stateEgrStart then
				-- IP impl.egr.start.ext --- INSERT

				if !rng_sig_memclk then
					stateEgr <= stateEgrInit;

				else
					-- IP impl.egr.start --- INSERT

					stateEgr <= stateEgrRunA;
				end if;

			elsif stateEgr=stateEgrRunA then
				if !rng_sig_memclk then
					stateEgr <= stateEgrInit;

				else
					-- IP impl.egr.runA.setAddr --- INSERT

					stateEgr <= stateEgrRunB;
				end if;

			elsif stateEgr=stateEgrRunB then
				if (ackToDdrifWr='1' and memTWrAXI_awready='1') then
					stateEgr <= stateEgrRunC;
				end if;

			elsif stateEgr=stateEgrRunC then
				if memTWrAXI_wready='1' then
					-- IP impl.egr.runC.inc --- INSERT

					if beatEgr=15 then
						if !rng_sig_memclk or burstEgr=burstEgrLast then
							stateEgr <= stateEgrInit;

						else
							-- IP impl.egr.runC.nextBurst --- INSERT

							stateEgr <= stateEgrRunA;
						end if;

					else
						if nextBeat then
							stateEgr <= stateEgrRunC;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.egr.rising --- END

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	-- IP impl.op.wiring --- BEGIN
	ackInvSet_sig <= '1' when stateOp=stateOpInv else '0';
	ackInvSet <= ackInvSet_sig;
	rng <= rng_sig;
	enLenrng <= '1' when stateOp=stateOpGetRnA else '0';
	enOfsrng <= '1' when stateOp=stateOpGetRnB else '0';
	-- IP impl.op.wiring --- END

	-- IP impl.op.rising --- BEGIN
	process (reset, mclk, stateOp)
		-- IP impl.op.vars --- BEGIN
		-- IP impl.op.vars --- END

	begin
		if reset='1' then
			-- IP impl.op.asyncrst --- BEGIN
			stateOp <= stateOpInit;
			rng_sig <= '0';
			len <= (others => '0');
			ofs <= (others => '0');

			-- IP impl.op.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateOp=stateOpInit or (stateOp/=stateOpInv and reqInvSet='1')) then
				if reqInvSet='1' then
					-- IP impl.op.init.invSet --- INSERT

					stateOp <= stateOpInv;

				elsif rng_sig='1' then
					stateOp <= stateOpGetRnA;

				else
					-- IP impl.op.syncrst --- BEGIN
					rng_sig <= '0';
					len <= (others => '0');
					ofs <= (others => '0');

					-- IP impl.op.syncrst --- END

					stateOp <= stateOpInit;
				end if;

			elsif stateOp=stateOpInv then
				if reqInvSet='0' then
					stateOp <= stateOpInit;
				end if;

			elsif stateOp=stateOpGetRnA then
				if validLenrn='1' then
					-- IP impl.op.getRnA --- INSERT

					stateOp <= stateOpGetRnB;
				end if;

			elsif stateOp=stateOpGetRnB then
				if validOfsrn='1' then
					-- IP impl.op.getRnB --- INSERT

					stateOp <= stateOpGetRnA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.op.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Rtl;
