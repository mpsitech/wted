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
		memTWrAXI_bready: out std_logic;
		memTWrAXI_bresp: in std_logic_vector(1 downto 0);
		memTWrAXI_bvalid: in std_logic;

		reqToDdrifWr: out std_logic;
		ackToDdrifWr: in std_logic;

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

	component Dpram_size4kB_a8b32 is
		port (
			resetA: in std_logic;
			clkA: in std_logic;

			enA: in std_logic;
			weA: in std_logic;

			aA: in std_logic_vector(11 downto 0);
			drdA: out std_logic_vector(7 downto 0);
			dwrA: in std_logic_vector(7 downto 0);

			resetB: in std_logic;
			clkB: in std_logic;

			enB: in std_logic;
			weB: in std_logic;

			aB: in std_logic_vector(9 downto 0);
			drdB: out std_logic_vector(31 downto 0);
			dwrB: in std_logic_vector(31 downto 0)
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- copy data from setbuf to DDR memory (egr)
	type stateEgr_t is (
		stateEgrInit,
		stateEgrIdle,
		stateEgrInv,
		stateEgrTrylock,
		stateEgrCopyA, stateEgrCopyB, stateEgrCopyC,
		stateEgrUnlock
	);
	signal stateEgr: stateEgr_t := stateEgrInit;

	signal memTWrAXI_awaddr_sig: std_logic_vector(19 downto 0);
	signal memTWrAXI_awvalid_sig: std_logic;
	signal memTWrAXI_wlast_sig: std_logic;
	signal memTWrAXI_wvalid_sig: std_logic;
	signal memTWrAXI_bready_sig: std_logic;

	signal reqToDdrifWr_sig: std_logic;
	signal enSetbufB: std_logic;

	signal aSetbufB: natural range 0 to 1023;
	signal aSetbufB_vec: std_logic_vector(9 downto 0);

	-- IP sigs.egr.cust --- INSERT

	---- main operation (op)
	type stateOp_t is (
		stateOpInit,
		stateOpIdle,
		stateOpInv,
		stateOpGetRnA, stateOpGetRnB,
		stateOpTrylock,
		stateOpFill,
		stateOpUnlock
	);
	signal stateOp: stateOp_t := stateOpInit;

	signal ackInvSet_sig: std_logic;
	signal enSetbuf: std_logic;

	signal aSetbuf: natural range 0 to 4095;
	signal aSetbuf_vec: std_logic_vector(11 downto 0);
	signal lenSetbuf: natural range 0 to 4095;

	signal dwrSetbuf: std_logic_vector(7 downto 0);
	signal enLenrng: std_logic;
	signal enOfsrng: std_logic;

	-- IP sigs.op.cust --- INSERT

	---- set buffer mutex management (setbuf)
	type stateSetbuf_t is (
		stateSetbufInit,
		stateSetbufReady,
		stateSetbufAck
	);
	signal stateSetbuf: stateSetbuf_t := stateSetbufInit;

	type lock_t is (lockIdle, lockBuf, lockBufB);
	signal setbufLock: lock_t;
	signal lenSetbuf: std_logic_vector(31 downto 0);

	-- IP sigs.setbuf.cust --- INSERT

	---- myLenrng
	signal lenrn: std_logic_vector(7 downto 0);
	signal validLenrn: std_logic;

	---- myOfsrng
	signal ofsrn: std_logic_vector(7 downto 0);
	signal validOfsrn: std_logic;

	---- handshake
	-- op to setbuf
	signal reqOpToSetbufLock: std_logic;
	signal ackOpToSetbufLock: std_logic;
	signal dnyOpToSetbufLock: std_logic;

	-- op to setbuf
	signal reqOpToSetbufUnlock: std_logic;
	signal ackOpToSetbufUnlock: std_logic;

	-- egr to setbuf
	signal reqEgrToSetbufLock: std_logic;
	signal ackEgrToSetbufLock: std_logic;
	signal dnyEgrToSetbufLock: std_logic;

	-- egr to setbuf
	signal reqEgrToSetbufUnlock: std_logic;
	signal ackEgrToSetbufUnlock: std_logic;

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

	mySetbuf : Dpram_size4kB_a8b32
		port map (
			resetA => '0',
			clkA => mclk,

			enA => enSetbuf,
			weA => '1',

			aA => aSetbuf_vec,
			drdA => open,
			dwrA => dwrSetbuf,

			resetB => '0',
			clkB => memclk,

			enB => enSetbufB,
			weB => '0',

			aB => aSetbufB_vec,
			drdB => memTWrAXI_wdata,
			dwrB => (others => '0')
		);

	------------------------------------------------------------------------
	-- implementation: copy data from setbuf to DDR memory (egr)
	------------------------------------------------------------------------

	-- IP impl.egr.wiring --- BEGIN
	memTWrAXI_awaddr <= memTWrAXI_awaddr_sig;
	memTWrAXI_awvalid_sig <= '1' when stateEgr=stateEgrCopyB else '0';
	memTWrAXI_awvalid <= memTWrAXI_awvalid_sig;
	memTWrAXI_wlast <= memTWrAXI_wlast_sig;
	memTWrAXI_wvalid_sig <= '1' when stateEgr=stateEgrCopyC else '0';
	memTWrAXI_wvalid <= memTWrAXI_wvalid_sig;
	memTWrAXI_bready_sig <= '1';
	memTWrAXI_bready <= memTWrAXI_bready_sig;

	reqToDdrifWr_sig <= '1' when stateEgr=stateEgrCopyB else '0';
	reqToDdrifWr <= reqToDdrifWr_sig;

	aSetbufB_vec <= std_logic_vector(to_unsigned(aSetbufB, 10));

	reqEgrToSetbufLock <= '1' when stateEgr=stateEgrTrylock else '0';

	reqEgrToSetbufUnlock <= '1' when stateEgr=stateEgrUnlock else '0';
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
			memTWrAXI_wlast_sig <= '1';
			enSetbufB <= '0';
			aSetbufB <= 0;

			-- IP impl.egr.asyncrst --- END

		elsif rising_edge(memclk) then
			if stateEgr=stateEgrInit then
				-- IP impl.egr.syncrst --- BEGIN
				memTWrAXI_awaddr_sig <= (others => '0');
				memTWrAXI_wlast_sig <= '1';
				enSetbufB <= '0';
				aSetbufB <= 0;

				stateEgr <= stateEgrIdle;
				-- IP impl.egr.syncrst --- END

			elsif stateEgr=stateEgrIdle then
				-- IP impl.egr.idle --- INSERT

			elsif stateEgr=stateEgrInv then
				-- IP impl.egr.inv --- INSERT

			elsif stateEgr=stateEgrTrylock then
				-- IP impl.egr.trylock --- INSERT

			elsif stateEgr=stateEgrCopyA then
				-- IP impl.egr.copyA --- INSERT

			elsif stateEgr=stateEgrCopyB then
				-- IP impl.egr.copyB --- INSERT

			elsif stateEgr=stateEgrCopyC then
				-- IP impl.egr.copyC --- INSERT

			elsif stateEgr=stateEgrUnlock then
				-- IP impl.egr.unlock --- INSERT
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
	enSetbuf <= '1' when state(write) and setbufFromHostifAXIS_tvalid else '0';

	aSetbuf_vec <= std_logic_vector(to_unsigned(aSetbuf, 12));

	enLenrng <= '1' when stateOp=stateOpGetRnA else '0';
	enOfsrng <= '1' when stateOp=stateOpGetRnB else '0';

	reqOpToSetbufLock <= '1' when stateOp=stateOpTrylock else '0';

	reqOpToSetbufUnlock <= '1' when stateOp=stateOpUnlock else '0';
	-- IP impl.op.wiring --- END

	-- IP impl.op.rising --- BEGIN
	process (reset, mclk, stateOp)
		-- IP impl.op.vars --- BEGIN
		-- IP impl.op.vars --- END

	begin
		if reset='1' then
			-- IP impl.op.asyncrst --- BEGIN
			stateOp <= stateOpInit;
			aSetbuf <= 0;
			lenSetbuf <= 0;
			dwrSetbuf <= (others => '0');

			-- IP impl.op.asyncrst --- END

		elsif rising_edge(mclk) then
			if stateOp=stateOpInit then
				-- IP impl.op.syncrst --- BEGIN
				aSetbuf <= 0;
				lenSetbuf <= 0;
				dwrSetbuf <= (others => '0');

				stateOp <= stateOpIdle;
				-- IP impl.op.syncrst --- END

			elsif stateOp=stateOpIdle then
				-- IP impl.op.idle --- INSERT

			elsif stateOp=stateOpInv then
				-- IP impl.op.inv --- INSERT

			elsif stateOp=stateOpGetRnA then
				-- IP impl.op.getRnA --- INSERT

			elsif stateOp=stateOpGetRnB then
				-- IP impl.op.getRnB --- INSERT

			elsif stateOp=stateOpTrylock then
				-- IP impl.op.trylock --- INSERT

			elsif stateOp=stateOpFill then
				-- IP impl.op.fill --- INSERT

			elsif stateOp=stateOpUnlock then
				-- IP impl.op.unlock --- INSERT
			end if;
		end if;
	end process;
	-- IP impl.op.rising --- END

	------------------------------------------------------------------------
	-- implementation: set buffer mutex management (setbuf)
	------------------------------------------------------------------------

	-- IP impl.setbuf.wiring --- BEGIN
	-- IP impl.setbuf.wiring --- END

	-- IP impl.setbuf.rising --- BEGIN
	process (reset, mclk, stateSetbuf)
		-- IP impl.setbuf.vars --- BEGIN
		-- IP impl.setbuf.vars --- END

	begin
		if reset='1' then
			-- IP impl.setbuf.asyncrst --- BEGIN
			stateSetbuf <= stateSetbufInit;
			setbufLock <= lockIdle;
			lenSetbuf <= (others => '0');
			ackOpToSetbufLock <= '0';
			dnyOpToSetbufLock <= '0';
			ackOpToSetbufUnlock <= '0';
			ackEgrToSetbufLock <= '0';
			dnyEgrToSetbufLock <= '0';
			ackEgrToSetbufUnlock <= '0';

			-- IP impl.setbuf.asyncrst --- END

		elsif rising_edge(mclk) then
			if stateSetbuf=stateSetbufInit then
				-- IP impl.setbuf.syncrst --- BEGIN
				setbufLock <= lockIdle;
				lenSetbuf <= (others => '0');
				ackOpToSetbufLock <= '0';
				dnyOpToSetbufLock <= '0';
				ackOpToSetbufUnlock <= '0';
				ackEgrToSetbufLock <= '0';
				dnyEgrToSetbufLock <= '0';
				ackEgrToSetbufUnlock <= '0';

				-- IP impl.setbuf.syncrst --- END

				stateSetbuf <= stateSetbufReady;

			elsif stateSetbuf=stateSetbufReady then
				if reqOpToSetbufLock='1' then
					-- IP impl.setbuf.ready.bufLock --- INSERT

					stateSetbuf <= stateSetbufAck;

				elsif reqOpToSetbufUnlock='1' then
					-- IP impl.setbuf.ready.bufUnlock --- INSERT

					stateSetbuf <= stateSetbufAck;

				elsif reqEgrToSetbufLock='1' then
					-- IP impl.setbuf.ready.bufBLock --- INSERT

					stateSetbuf <= stateSetbufAck;

				elsif reqEgrToSetbufUnlock='1' then
					-- IP impl.setbuf.ready.bufBUnlock --- INSERT

					stateSetbuf <= stateSetbufAck;
				end if;

			elsif stateSetbuf=stateSetbufAck then
				if ((ackOpToSetbufLock='1' or dnyOpToSetbufLock='1') and reqOpToSetbufLock='0') then
					-- IP impl.setbuf.ack.bufLock --- INSERT

					stateSetbuf <= stateSetbufReady;

				elsif (ackOpToSetbufUnlock='1' and reqOpToSetbufUnlock='0') then
					-- IP impl.setbuf.ack.bufUnlock --- INSERT

					stateSetbuf <= stateSetbufReady;

				elsif ((ackEgrToSetbufLock='1' or dnyEgrToSetbufLock='1') and reqEgrToSetbufLock='0') then
					-- IP impl.setbuf.ack.bufBLock --- INSERT

					stateSetbuf <= stateSetbufReady;

				elsif (ackEgrToSetbufUnlock='1' and reqEgrToSetbufUnlock='0') then
					-- IP impl.setbuf.ack.bufBUnlock --- INSERT

					stateSetbuf <= stateSetbufReady;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.setbuf.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Rtl;
