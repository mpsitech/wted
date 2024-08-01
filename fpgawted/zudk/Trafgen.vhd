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
use work.Zudk.all;

entity Trafgen is
	port (
		reset: in std_logic;
		mclk: in std_logic;

		resetMemclk: in std_logic;
		memclk: in std_logic;

		memTWrAXI_awaddr: out std_logic_vector(19 downto 0);
		memTWrAXI_awready: in std_logic;
		memTWrAXI_awvalid: out std_logic;
		memTWrAXI_wdata: out std_logic_vector(127 downto 0);
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
	signal memTWrAXI_wdata_sig: std_logic_vector(127 downto 0);
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

	---- mclk to memclk CDC sampling (mclkToMemclkSample)

	signal ofs_memclk: std_logic_vector(7 downto 0);
	signal len_memclk: std_logic_vector(2 downto 0);
	signal rng_sig_memclk: std_logic;

	-- IP sigs.mclkToMemclkSample.cust --- INSERT

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

	-- IP impl.egr.wiring --- RBEGIN

	memTWrAXI_awaddr <= memTWrAXI_awaddr_sig;

	memTWrAXI_awvalid_sig <= '1' when stateEgr=stateEgrRunB else '0';
	memTWrAXI_awvalid <= memTWrAXI_awvalid_sig;

	memTWrAXI_wvalid_sig <= '1' when stateEgr=stateEgrRunC else '0';
	memTWrAXI_wvalid <= memTWrAXI_wvalid_sig;

	memTWrAXI_wdata <= memTWrAXI_wdata_sig;

	memTWrAXI_wlast <= memTWrAXI_wlast_sig;

	reqToDdrifWr_sig <= '1' when stateEgr=stateEgrRunB else '0';
	reqToDdrifWr <= reqToDdrifWr_sig;
	-- IP impl.egr.wiring --- REND

	-- IP impl.egr.rising --- BEGIN
	process (resetMemclk, memclk, stateEgr)
		-- IP impl.egr.vars --- RBEGIN
		variable burstEgr: natural range 0 to 2048/16/16-1;
		variable burstEgrLast: natural range 0 to 2048/16/16-1;

		variable beatEgr: natural range 0 to 15;

		constant imax: natural := 100; -- pause between transactions
		variable i: natural range 0 to imax;
		-- IP impl.egr.vars --- REND

	begin
		if resetMemclk='1' then
			-- IP impl.egr.asyncrst --- RBEGIN
			stateEgr <= stateEgrInit;
			memTWrAXI_awaddr_sig <= (others => '0');
			memTWrAXI_wdata_sig <= (others => '0');
			memTWrAXI_wlast_sig <= '1';

			burstEgr := 0;
			burstEgrLast := 0;
			-- IP impl.egr.asyncrst --- REND

		elsif rising_edge(memclk) then
			if stateEgr=stateEgrInit then
				-- IP impl.egr.syncrst --- RBEGIN
				memTWrAXI_awaddr_sig <= (others => '0');
				memTWrAXI_wdata_sig <= (others => '0');
				memTWrAXI_wlast_sig <= '1';

				burstEgr := 0;
				burstEgrLast := 0;

				beatEgr := 0;

				i := 0;
				-- IP impl.egr.syncrst --- REND

				if rng_sig_memclk='0' then
					stateEgr <= stateEgrInit;

				else
					stateEgr <= stateEgrStart;
				end if;

			elsif stateEgr=stateEgrStart then
				i := i + 1; -- IP impl.egr.start.ext --- ILINE

				if rng_sig_memclk='0' then
					stateEgr <= stateEgrInit;

				else
					-- IP impl.egr.start --- IBEGIN
					i := 0;

					for i in 0 to 15 loop
						memTWrAXI_wdata_sig((i+1)*8-1 downto i*8) <= std_logic_vector(unsigned(ofs_memclk) + i);
					end loop;

					burstEgr := 0;
					burstEgrLast := to_integer(unsigned(len_memclk));
					-- IP impl.egr.start --- IEND

					stateEgr <= stateEgrRunA;
				end if;

			elsif stateEgr=stateEgrRunA then
				if rng_sig_memclk='0' then
					stateEgr <= stateEgrInit;

				else
					-- IP impl.egr.runA.setAddr --- IBEGIN
					memTWrAXI_awaddr_sig(2 downto 0) <= std_logic_vector(to_unsigned(burstEgr, 3));
					memTWrAXI_awaddr_sig(16 downto 3) <= (others => '0');
					memTWrAXI_awaddr_sig(19 downto 17) <= (others => '0');

					memTWrAXI_wlast_sig <= '0';

					beatEgr := 0;
					-- IP impl.egr.runA.setAddr --- IEND

					stateEgr <= stateEgrRunB;
				end if;

			elsif stateEgr=stateEgrRunB then
				if (ackToDdrifWr='1' and memTWrAXI_awready='1') then
					stateEgr <= stateEgrRunC;
				end if;

			elsif stateEgr=stateEgrRunC then
				if memTWrAXI_wready='1' then
					-- IP impl.egr.runC.inc --- IBEGIN
					for i in 0 to 15 loop
						memTWrAXI_wdata_sig((i+1)*8-1 downto i*8+4) <= std_logic_vector(unsigned(memTWrAXI_wdata_sig((i+1)*8-1 downto i*8+4)) + 1);
					end loop;
					-- IP impl.egr.runC.inc --- IEND

					if beatEgr=15 then
						if rng_sig_memclk='0' or burstEgr=burstEgrLast then
							stateEgr <= stateEgrInit;

						else
							burstEgr := burstEgr + 1; -- IP impl.egr.runC.nextBurst --- ILINE

							stateEgr <= stateEgrRunA;
						end if;

					else
						-- IP impl.egr.runC.nextBeat --- IBEGIN
						for i in 0 to 15 loop
							memTWrAXI_wdata_sig((i+1)*8-1 downto i*8) <= std_logic_vector(unsigned(memTWrAXI_wdata_sig((i+1)*8-1 downto i*8)) + 1);
						end loop;

						if beatEgr=14 then
							memTWrAXI_wlast_sig <= '1';
						end if;

						beatEgr := beatEgr + 1;
						-- IP impl.egr.runC.nextBeat --- IEND

						stateEgr <= stateEgrRunC;
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
		-- IP impl.op.vars --- RBEGIN
		variable len_lcl: std_logic_vector(2 downto 0);
		-- IP impl.op.vars --- REND

	begin
		if reset='1' then
			-- IP impl.op.asyncrst --- RBEGIN
			stateOp <= stateOpInit;
			rng_sig <= '0';
			len <= (others => '0');
			ofs <= (others => '0');

			len_lcl := (others => '0');
			-- IP impl.op.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (stateOp=stateOpInit or (stateOp/=stateOpInv and reqInvSet='1')) then
				if reqInvSet='1' then
					-- IP impl.op.init.invSet --- IBEGIN
					if setRng=tru8 then
						rng_sig <= '1';
					else
						rng_sig <= '0';
					end if;
					-- IP impl.op.init.invSet --- IEND

					stateOp <= stateOpInv;

				elsif rng_sig='1' then
					stateOp <= stateOpGetRnA;

				else
					-- IP impl.op.syncrst --- RBEGIN
					len <= (others => '0');
					ofs <= (others => '0');

					len_lcl := (others => '0');
					-- IP impl.op.syncrst --- REND

					stateOp <= stateOpInit;
				end if;

			elsif stateOp=stateOpInv then
				if reqInvSet='0' then
					stateOp <= stateOpInit;
				end if;

			elsif stateOp=stateOpGetRnA then
				if validLenrn='1' then
					len_lcl := lenrn(2 downto 0); -- IP impl.op.getRnA --- ILINE

					stateOp <= stateOpGetRnB;
				end if;

			elsif stateOp=stateOpGetRnB then
				if validOfsrn='1' then
					-- IP impl.op.getRnB --- IBEGIN
					len <= len_lcl;
					ofs <= ofsrn;
					-- IP impl.op.getRnB --- IEND

					stateOp <= stateOpGetRnA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.op.rising --- END

	------------------------------------------------------------------------
	-- implementation: mclk to memclk CDC sampling (mclkToMemclkSample)
	------------------------------------------------------------------------

	-- IP impl.mclkToMemclkSample.wiring --- BEGIN
	-- IP impl.mclkToMemclkSample.wiring --- END

	-- IP impl.mclkToMemclkSample.rising --- BEGIN
	process (resetMemclk, memclk)
		-- IP impl.mclkToMemclkSample.vars --- BEGIN
		variable ofs_last: std_logic_vector(7 downto 0);
		variable len_last: std_logic_vector(2 downto 0);
		variable rng_sig_last: std_logic;
		-- IP impl.mclkToMemclkSample.vars --- END

	begin
		if resetMemclk='1' then
			-- IP impl.mclkToMemclkSample.asyncrst --- BEGIN
			ofs_memclk <= (others => '0');
			len_memclk <= (others => '0');
			rng_sig_memclk <= '0';

			ofs_last := (others => '0');
			len_last := (others => '0');
			rng_sig_last := '0';
			-- IP impl.mclkToMemclkSample.asyncrst --- END

		elsif rising_edge(memclk) then
			if ofs=ofs_last then
				ofs_memclk <= ofs;
			end if;
			ofs_last := ofs;

			if len=len_last then
				len_memclk <= len;
			end if;
			len_last := len;

			if rng_sig=rng_sig_last then
				rng_sig_memclk <= rng_sig;
			end if;
			rng_sig_last := rng_sig;

		end if;
	end process;
	-- IP impl.mclkToMemclkSample.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Rtl;
