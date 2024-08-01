-- file Client.vhd
-- Client easy model controller implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 30 Jun 2024
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Zudk.all;

entity Client is
	port (
		reset: in std_logic;
		mclk: in std_logic;

		resetMemclk: in std_logic;
		memclk: in std_logic;

		memCRdAXI_araddr: out std_logic_vector(19 downto 0);
		memCRdAXI_arready: in std_logic;
		memCRdAXI_arvalid: out std_logic;
		memCRdAXI_rdata: in std_logic_vector(127 downto 0);
		memCRdAXI_rlast: in std_logic;
		memCRdAXI_rready: out std_logic;
		memCRdAXI_rresp: in std_logic_vector(1 downto 0);
		memCRdAXI_rvalid: in std_logic;

		reqToDdrifRd: out std_logic;
		ackToDdrifRd: in std_logic;

		memCWrAXI_awaddr: out std_logic_vector(19 downto 0);
		memCWrAXI_awready: in std_logic;
		memCWrAXI_awvalid: out std_logic;
		memCWrAXI_wdata: out std_logic_vector(127 downto 0);
		memCWrAXI_wlast: out std_logic;
		memCWrAXI_wready: in std_logic;
		memCWrAXI_wvalid: out std_logic;

		reqToDdrifWr: out std_logic;
		ackToDdrifWr: in std_logic;

		reqInvLoadGetbuf: in std_logic;
		ackInvLoadGetbuf: out std_logic;

		reqInvStoreSetbuf: in std_logic;
		ackInvStoreSetbuf: out std_logic;

		reqGetbufToHostif: in std_logic;
		ackGetbufToHostif: out std_logic;
		dneGetbufToHostif: in std_logic;
		avllenGetbufToHostif: out std_logic_vector(31 downto 0);

		reqSetbufFromHostif: in std_logic;
		ackSetbufFromHostif: out std_logic;
		dneSetbufFromHostif: in std_logic;
		avllenSetbufFromHostif: out std_logic_vector(31 downto 0);

		getbufToHostifAXIS_tready: in std_logic;
		getbufToHostifAXIS_tvalid: out std_logic;
		getbufToHostifAXIS_tdata: out std_logic_vector(63 downto 0);
		getbufToHostifAXIS_tlast: out std_logic;

		setbufFromHostifAXIS_tready: out std_logic;
		setbufFromHostifAXIS_tvalid: in std_logic;
		setbufFromHostifAXIS_tdata: in std_logic_vector(63 downto 0);
		setbufFromHostifAXIS_tlast: in std_logic;

		stateGetbufB_dbg: out std_logic_vector(7 downto 0);
		stateSetbufB_dbg: out std_logic_vector(7 downto 0)
	);
end Client;

architecture Rtl of Client is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Dpbram_size2kB_a128b64 is
		port (
			clkA: in std_logic;

			enA: in std_logic;
			weA: in std_logic_vector(0 downto 0);

			addrA: in std_logic_vector(6 downto 0);
			doutA: out std_logic_vector(127 downto 0);
			dinA: in std_logic_vector(127 downto 0);

			clkB: in std_logic;

			enB: in std_logic;
			weB: in std_logic_vector(0 downto 0);

			addrB: in std_logic_vector(7 downto 0);
			doutB: out std_logic_vector(63 downto 0);
			dinB: in std_logic_vector(63 downto 0)
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- copy data from setbuf to DDR memory (egr)
	type stateEgr_t is (
		stateEgrInit,
		stateEgrInv,
		stateEgrTrylock,
		stateEgrCopyA, stateEgrCopyB, stateEgrCopyC,
		stateEgrUnlock
	);
	signal stateEgr: stateEgr_t := stateEgrInit;

	signal ackInvStoreSetbuf_sig: std_logic;

	signal memCWrAXI_awaddr_sig: std_logic_vector(19 downto 0);
	signal memCWrAXI_awvalid_sig: std_logic;
	signal memCWrAXI_wdata_sig: std_logic_vector(127 downto 0);
	signal memCWrAXI_wlast_sig: std_logic;
	signal memCWrAXI_wvalid_sig: std_logic;

	signal a0Egrstr: natural range 0 to 127;
	signal lenEgrstr: natural range 0 to 16;

	signal setbufClearNotKeep: std_logic;
	signal reqToDdrifWr_sig: std_logic;

	-- IP sigs.egr.cust --- INSERT

	---- continuous streaming from buffers (egrstr)
	type stateEgrstr_t is (
		stateEgrstrInit,
		stateEgrstrIdle,
		stateEgrstrLoad,
		stateEgrstrRun,
		stateEgrstrDone
	);
	signal stateEgrstr: stateEgrstr_t := stateEgrstrInit;

	signal enSetbuf: std_logic;
	signal enSetbufm1: std_logic;

	signal aSetbuf: natural range 0 to 127;
	signal aSetbuf_vec: std_logic_vector(6 downto 0);

	type egrfifo_t is array (0 to 2) of std_logic_vector(127 downto 0);
	signal egrfifo: egrfifo_t;

	signal ixRdEgrfifo: natural range 0 to 2;
	signal ixWrEgrfifo: natural range 0 to 2;

	signal egrAXIS_tdata: std_logic_vector(127 downto 0);
	signal egrAXIS_tvalid: std_logic;
	signal egrAXIS_tlast: std_logic;

	-- IP sigs.egrstr.cust --- INSERT

	---- get buffer mutex management (getbuf)
	type stateGetbuf_t is (
		stateGetbufInit,
		stateGetbufReady,
		stateGetbufAck
	);
	signal stateGetbuf: stateGetbuf_t := stateGetbufInit;

	type lock_t is (lockIdle, lockBuf, lockBufB);
	signal getbufLock: lock_t;
	signal lenGetbuf: std_logic_vector(31 downto 0);

	-- IP sigs.getbuf.cust --- INSERT

	---- get buffer B/hostif-facing operation (getbufB)
	type stateGetbufB_t is (
		stateGetbufBInit,
		stateGetbufBIdle,
		stateGetbufBTrylock,
		stateGetbufBXferA, stateGetbufBXferB,
		stateGetbufBDone,
		stateGetbufBUnlock
	);
	signal stateGetbufB: stateGetbufB_t := stateGetbufBInit;

	signal ackGetbufToHostif_sig: std_logic;

	signal getbufToHostifAXIS_tvalid_sig: std_logic;
	signal getbufToHostifAXIS_tlast_sig: std_logic;

	signal enGetbufB: std_logic;

	signal aGetbufB: natural range 0 to 255;
	signal aGetbufB_vec: std_logic_vector(7 downto 0);

	signal getbufClearNotKeep: std_logic;

	-- IP sigs.getbufB.cust --- INSERT

	---- copy data from DDR memory to getbuf (igr)
	type stateIgr_t is (
		stateIgrInit,
		stateIgrInv,
		stateIgrTrylock,
		stateIgrCopyA, stateIgrCopyB, stateIgrCopyC,
		stateIgrUnlock
	);
	signal stateIgr: stateIgr_t := stateIgrInit;

	signal ackInvLoadGetbuf_sig: std_logic;

	signal memCRdAXI_araddr_sig: std_logic_vector(19 downto 0);
	signal memCRdAXI_arvalid_sig: std_logic;

	signal memCRdAXI_rready_sig: std_logic;
	signal reqToDdrifRd_sig: std_logic;
	signal enGetbuf: std_logic;

	signal aGetbuf: natural range 0 to 127;
	signal aGetbuf_vec: std_logic_vector(6 downto 0);

	signal lenGetbuf_sig: std_logic_vector(31 downto 0);

	-- IP sigs.igr.cust --- INSERT

	---- set buffer mutex management (setbuf)
	type stateSetbuf_t is (
		stateSetbufInit,
		stateSetbufReady,
		stateSetbufAck
	);
	signal stateSetbuf: stateSetbuf_t := stateSetbufInit;

	signal setbufLock: lock_t;
	signal lenSetbuf: std_logic_vector(31 downto 0);

	-- IP sigs.setbuf.cust --- INSERT

	---- set buffer B/hostif-facing operation (setbufB)
	type stateSetbufB_t is (
		stateSetbufBInit,
		stateSetbufBIdle,
		stateSetbufBTrylock,
		stateSetbufBWrite,
		stateSetbufBDone,
		stateSetbufBUnlock
	);
	signal stateSetbufB: stateSetbufB_t := stateSetbufBInit;

	signal ackSetbufFromHostif_sig: std_logic;
	signal setbufFromHostifAXIS_tready_sig: std_logic;
	signal enSetbufB: std_logic;

	signal aSetbufB: natural range 0 to 255;
	signal aSetbufB_vec: std_logic_vector(7 downto 0);
	signal lenSetbufB: std_logic_vector(31 downto 0);

	-- IP sigs.setbufB.cust --- INSERT

	---- mclk to memclk CDC sampling (mclkToMemclkSample)

	signal ackEgrToSetbufUnlock_memclk: std_logic;
	signal dnyEgrToSetbufLock_memclk: std_logic;
	signal ackEgrToSetbufLock_memclk: std_logic;
	signal ackIgrToGetbufUnlock_memclk: std_logic;
	signal dnyIgrToGetbufLock_memclk: std_logic;
	signal ackIgrToGetbufLock_memclk: std_logic;
	signal reqInvStoreSetbuf_sig_memclk: std_logic;
	signal reqInvLoadGetbuf_sig_memclk: std_logic;

	-- IP sigs.mclkToMemclkSample.cust --- INSERT

	---- memclk to mclk CDC sampling (memclkToMclkSample)

	signal reqEgrToSetbufUnlock_mclk: std_logic;
	signal reqEgrToSetbufLock_mclk: std_logic;
	signal reqIgrToGetbufUnlock_mclk: std_logic;
	signal reqIgrToGetbufLock_mclk: std_logic;
	signal ackInvStoreSetbuf_sig_mclk: std_logic;
	signal ackInvLoadGetbuf_sig_mclk: std_logic;

	-- IP sigs.memclkToMclkSample.cust --- INSERT

	---- memclk to mclk CDC stretching (memclkToMclkStretch)

	signal reqEgrToSetbufUnlock_to_mclk: std_logic;
	signal reqEgrToSetbufLock_to_mclk: std_logic;
	signal reqIgrToGetbufUnlock_to_mclk: std_logic;
	signal reqIgrToGetbufLock_to_mclk: std_logic;
	signal ackInvStoreSetbuf_sig_to_mclk: std_logic;
	signal ackInvLoadGetbuf_sig_to_mclk: std_logic;

	-- IP sigs.memclkToMclkStretch.cust --- INSERT

	---- mySetbuf
	signal drdSetbuf: std_logic_vector(127 downto 0);

	---- handshake
	-- egr to egrstr
	signal reqEgrToEgrstr: std_logic;
	signal ackEgrToEgrstr: std_logic;
	signal dneEgrToEgrstr: std_logic;

	-- egr to egrstr
	signal egrAXIS_tready: std_logic;
	signal egrAXIS_tvalud: std_logic;

	-- igr to getbuf
	signal reqIgrToGetbufLock: std_logic;
	signal ackIgrToGetbufLock: std_logic;
	signal dnyIgrToGetbufLock: std_logic;

	-- igr to getbuf
	signal reqIgrToGetbufUnlock: std_logic;
	signal ackIgrToGetbufUnlock: std_logic;

	-- getbufB to getbuf
	signal reqGetbufBToGetbufLock: std_logic;
	signal ackGetbufBToGetbufLock: std_logic;
	signal dnyGetbufBToGetbufLock: std_logic;

	-- getbufB to getbuf
	signal reqGetbufBToGetbufUnlock: std_logic;
	signal ackGetbufBToGetbufUnlock: std_logic;

	-- egr to setbuf
	signal reqEgrToSetbufLock: std_logic;
	signal ackEgrToSetbufLock: std_logic;
	signal dnyEgrToSetbufLock: std_logic;

	-- egr to setbuf
	signal reqEgrToSetbufUnlock: std_logic;
	signal ackEgrToSetbufUnlock: std_logic;

	-- setbufB to setbuf
	signal reqSetbufBToSetbufLock: std_logic;
	signal ackSetbufBToSetbufLock: std_logic;
	signal dnySetbufBToSetbufLock: std_logic;

	-- setbufB to setbuf
	signal reqSetbufBToSetbufUnlock: std_logic;
	signal ackSetbufBToSetbufUnlock: std_logic;

	---- other
	signal reqInvLoadGetbuf_sig: std_logic;
	signal reqInvStoreSetbuf_sig: std_logic;
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myGetbuf : Dpbram_size2kB_a128b64
		port map (
			clkA => memclk,

			enA => enGetbuf,
			weA => (others => '1'),

			addrA => aGetbuf_vec,
			doutA => open,
			dinA => memCRdAXI_rdata,

			clkB => mclk,

			enB => enGetbufB,
			weB => (others => '0'),

			addrB => aGetbufB_vec,
			doutB => getbufToHostifAXIS_tdata,
			dinB => (others => '0')
		);

	mySetbuf : Dpbram_size2kB_a128b64
		port map (
			clkA => memclk,

			enA => enSetbuf,
			weA => (others => '0'),

			addrA => aSetbuf_vec,
			doutA => drdSetbuf,
			dinA => (others => '0'),

			clkB => mclk,

			enB => enSetbufB,
			weB => (others => '1'),

			addrB => aSetbufB_vec,
			doutB => open,
			dinB => setbufFromHostifAXIS_tdata
		);

	------------------------------------------------------------------------
	-- implementation: copy data from setbuf to DDR memory (egr)
	------------------------------------------------------------------------

	-- IP impl.egr.wiring --- RBEGIN

	ackInvStoreSetbuf_sig <= '1' when stateEgr=stateEgrInv else '0';
	ackInvStoreSetbuf <= ackInvStoreSetbuf_sig_mclk;

	memCWrAXI_awaddr <= memCWrAXI_awaddr_sig;

	memCWrAXI_awvalid_sig <= '1' when stateEgr=stateEgrCopyB else '0';
	memCWrAXI_awvalid <= memCWrAXI_awvalid_sig;

	memCWrAXI_wvalid <= egrAXIS_tvalid;

	memCWrAXI_wdata <= egrAXIS_tdata;

	memCWrAXI_wlast <= '0' when (reqEgrToEgrstr='1' and ackEgrToEgrstr='0') or egrAXIS_tlast='0' else '1';

	--memCWrAXI_bready <= memCWrAXI_bready_sig;
	--memCWrAXI_bready_sig <= '1';

	reqEgrToEgrstr <= '1' when stateEgr=stateEgrCopyB or stateEgr=stateEgrCopyC else '0';

	egrAXIS_tready <= memCWrAXI_wready;

	reqToDdrifWr <= '1' when stateEgr=stateEgrCopyB else '0';
	--reqToDdrifWr <= reqToDdrifWr_sig;

	reqEgrToSetbufLock <= '1' when stateEgr=stateEgrTrylock else '0';

	reqEgrToSetbufUnlock <= '1' when stateEgr=stateEgrUnlock else '0';
	-- IP impl.egr.wiring --- REND

	-- IP impl.egr.rising --- BEGIN
	process (resetMemclk, memclk, stateEgr)
		-- IP impl.egr.vars --- RBEGIN
		constant NBurstEgr: natural := 2048/16/16; -- 8
		variable burstEgr: natural range 0 to NBurstEgr-1;
		-- IP impl.egr.vars --- REND

	begin
		if resetMemclk='1' then
			-- IP impl.egr.asyncrst --- RBEGIN
			stateEgr <= stateEgrInit;
			memCWrAXI_awaddr_sig <= (others => '0');
			setbufClearNotKeep <= '0';

			a0Egrstr <= 0;
			lenEgrstr <= 0;

			burstEgr := 0;
			-- IP impl.egr.asyncrst --- REND

		elsif rising_edge(memclk) then
			if stateEgr=stateEgrInit then
				-- IP impl.egr.syncrst --- RBEGIN
				memCWrAXI_awaddr_sig <= (others => '0');
				setbufClearNotKeep <= '0';

				a0Egrstr <= 0;
				lenEgrstr <= 0;
	
				burstEgr := 0;
				-- IP impl.egr.syncrst --- REND

				if reqInvStoreSetbuf_sig_memclk='1' then
					stateEgr <= stateEgrInv;

				else
					stateEgr <= stateEgrInit;
				end if;

			elsif stateEgr=stateEgrInv then
				if reqInvStoreSetbuf_sig_memclk='0' then
					stateEgr <= stateEgrTrylock;
				end if;

			elsif stateEgr=stateEgrTrylock then
				if ackEgrToSetbufLock_memclk='1' then
					stateEgr <= stateEgrCopyA;

				elsif dnyEgrToSetbufLock_memclk='1' then
					stateEgr <= stateEgrInit;
				end if;

			elsif stateEgr=stateEgrCopyA then
				-- IP impl.egr.copyA.setAddr --- IBEGIN
				a0Egrstr <= to_integer(to_unsigned(burstEgr, 3) & "0000");
				lenEgrstr <= 16;
				-- IP impl.egr.copyA.setAddr --- IEND

				stateEgr <= stateEgrCopyB;

			elsif stateEgr=stateEgrCopyB then
				if (ackToDdrifWr='1' and memCWrAXI_awready='1') then
					stateEgr <= stateEgrCopyC;
				end if;

			elsif stateEgr=stateEgrCopyC then
				if dneEgrToEgrstr='1' then
					if burstEgr=NBurstEgr-1 then
						-- IP impl.egr.copyC.done --- IBEGIN
						burstEgr := 0;

						setbufClearNotKeep <= '1';
						-- IP impl.egr.copyC.done --- IEND

						stateEgr <= stateEgrUnlock;

					else
						-- IP impl.egr.copyC.nextBurst --- IBEGIN
						memCWrAXI_awaddr_sig <= std_logic_vector(unsigned(memCWrAXI_awaddr_sig) + 1);

						burstEgr := burstEgr + 1;
						-- IP impl.egr.copyC.nextBurst --- IEND

						stateEgr <= stateEgrCopyA;
					end if;
				end if;

			elsif stateEgr=stateEgrUnlock then
				if ackEgrToSetbufUnlock_memclk='1' then
					stateEgr <= stateEgrInit;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.egr.rising --- END

	------------------------------------------------------------------------
	-- implementation: continuous streaming from buffers (egrstr)
	------------------------------------------------------------------------

	-- IP impl.egrstr.wiring --- RBEGIN
	aSetbuf_vec <= std_logic_vector(to_unsigned(aSetbuf, 7));

	ackEgrToEgrstr <= '1' when stateEgrstr=stateEgrstrRun or stateEgrstr=stateEgrstrDone else '0';
	dneEgrToEgrstr <= '1' when stateEgrstr=stateEgrstrDone else '0';

	egrAXIS_tvalid <= '1' when stateEgrstr=stateEgrstrRun else '0';
	-- IP impl.egrstr.wiring --- REND

	-- IP impl.egrstr.rising --- BEGIN
	process (resetMemclk, memclk, stateEgrstr)
		-- IP impl.egrstr.vars --- RBEGIN
		variable wordEgrLast: natural range 0 to 15;
		variable wordEgrRd: natural range 0 to 15;
		variable wordEgrWr: natural range 0 to 15;

		variable i: natural range 0 to 2; -- correct choice for register-less BlockRAM
		-- IP impl.egrstr.vars --- REND

	begin
		if resetMemclk='1' then
			-- IP impl.egrstr.asyncrst --- RBEGIN
			stateEgrstr <= stateEgrstrInit;
			enSetbuf <= '0';
			enSetbufm1 <= '0';
			aSetbuf <= 0;
			egrfifo <= (others => (others => '0'));
			ixRdEgrfifo <= 0;
			ixWrEgrfifo <= 0;
			egrAXIS_tdata <= (others => '0');
			egrAXIS_tlast <= '1';

			wordEgrLast := 0;
			wordEgrRd := 0;
			wordEgrWr := 0;

			i := 0;
			-- IP impl.egrstr.asyncrst --- REND

		elsif rising_edge(memclk) then
			if stateEgrstr=stateEgrstrInit then
				-- IP impl.egrstr.syncrst --- RBEGIN
				enSetbuf <= '0';
				enSetbufm1 <= '0';
				aSetbuf <= 0;
				egrfifo <= (others => (others => '0'));
				ixRdEgrfifo <= 0;
				ixWrEgrfifo <= 0;
				egrAXIS_tdata <= (others => '0');
				egrAXIS_tlast <= '1';

				wordEgrLast := 0;
				wordEgrRd := 0;
				wordEgrWr := 0;

				i := 0;
				-- IP impl.egrstr.syncrst --- REND

				stateEgrstr <= stateEgrstrIdle;

			elsif stateEgrstr=stateEgrstrIdle then
				if reqEgrToEgrstr='1' then
					-- IP impl.egrstr.idle.start --- IBEGIN
					enSetbuf <= '1';
					aSetbuf <= a0Egrstr;

					wordEgrLast := lenEgrstr - 1;
					wordEgrRd := 0;
					wordEgrWr := 0;

					i := 0;
					-- IP impl.egrstr.idle.start --- IEND

					stateEgrstr <= stateEgrstrLoad;
				end if;

			elsif stateEgrstr=stateEgrstrLoad then
				if i=0 then
					-- IP impl.egrstr.load.one --- IBEGIN
					enSetbuf <= '1';
					aSetbuf <= aSetbuf + 1;

					i := i + 1;
					-- IP impl.egrstr.load.one --- IEND

					stateEgrstr <= stateEgrstrLoad;

				elsif i=1 then
					-- IP impl.egrstr.load.two --- IBEGIN
					enSetbuf <= '1';
					aSetbuf <= aSetbuf + 1;

					egrfifo(ixWrEgrfifo) <= drdSetbuf;
					ixWrEgrfifo <= 1;

					i := i + 1;
					-- IP impl.egrstr.load.two --- IEND

					stateEgrstr <= stateEgrstrLoad;

				else
					-- IP impl.egrstr.load.done --- IBEGIN
					enSetbuf <= '1';
					enSetbufm1 <= '1';

					aSetbuf <= aSetbuf + 1;

					egrfifo(ixWrEgrfifo) <= drdSetbuf;
					ixWrEgrfifo <= 2;

					egrAXIS_tdata <= egrfifo(ixRdEgrfifo);
					ixRdEgrfifo <= 1;

					egrAXIS_tlast <= '0';

					wordEgrRd := 0; -- corresponding to egrAXIS_tdata
					wordEgrWr := 3; -- corresponding to aBufB
					-- IP impl.egrstr.load.done --- IEND

					stateEgrstr <= stateEgrstrRun;
				end if;

			elsif stateEgrstr=stateEgrstrRun then
				-- IP impl.egrstr.run.ext --- IBEGIN
				-- update post FIFO-to-stream
				if egrAXIS_tready='1' then
					if ixRdEgrfifo=2 then
						ixRdEgrfifo <= 0;
					else
						ixRdEgrfifo <= ixRdEgrfifo + 1;
					end if;
				end if;

				-- update post buf-to-FIFO
				if enSetbufm1='1' then
					egrfifo(ixWrEgrfifo) <= drdSetbuf;

					if ixWrEgrfifo=2 then
						ixWrEgrfifo <= 0;
					else
						ixWrEgrfifo <= ixWrEgrfifo + 1;
					end if;
				end if;
				-- IP impl.egrstr.run.ext --- IEND

				if egrAXIS_tready='1' and egrAXIS_tlast='1' then
					enSetbuf <= '0'; -- IP impl.egrstr.run.done --- ILINE

					stateEgrstr <= stateEgrstrDone;

				else
					-- IP impl.egrstr.run.nextWord --- IBEGIN
					if egrAXIS_tready='1' then
						-- initiate FIFO-to-stream
						egrAXIS_tdata <= egrfifo(ixRdEgrfifo);

						wordEgrRd := wordEgrRd + 1;

						if wordEgrRd=wordEgrLast then
							egrAXIS_tlast <= '1';
						end if;
					end if;

					-- initiate buf-to-FIFO
					enSetbufm1 <= enSetbuf;

					if egrAXIS_tready='1' and wordEgrWr/=wordEgrLast then
						enSetbuf <= '1';
						aSetbuf <= aSetbuf + 1;

						wordEgrWr := wordEgrWr + 1;

					else
						enSetbuf <= '0';
					end if;
					-- IP impl.egrstr.run.nextWord --- IEND

					stateEgrstr <= stateEgrstrRun;
				end if;

			elsif stateEgrstr=stateEgrstrDone then
				if reqEgrToEgrstr='0' then
					stateEgrstr <= stateEgrstrInit;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.egrstr.rising --- END

	------------------------------------------------------------------------
	-- implementation: get buffer mutex management (getbuf)
	------------------------------------------------------------------------

	-- IP impl.getbuf.wiring --- BEGIN
	-- IP impl.getbuf.wiring --- END

	-- IP impl.getbuf.rising --- BEGIN
	process (reset, mclk, stateGetbuf)
		-- IP impl.getbuf.vars --- BEGIN
		-- IP impl.getbuf.vars --- END

	begin
		if reset='1' then
			-- IP impl.getbuf.asyncrst --- BEGIN
			stateGetbuf <= stateGetbufInit;
			getbufLock <= lockIdle;
			lenGetbuf <= (others => '0');
			ackIgrToGetbufLock <= '0';
			dnyIgrToGetbufLock <= '0';
			ackIgrToGetbufUnlock <= '0';
			ackGetbufBToGetbufLock <= '0';
			dnyGetbufBToGetbufLock <= '0';
			ackGetbufBToGetbufUnlock <= '0';

			-- IP impl.getbuf.asyncrst --- END

		elsif rising_edge(mclk) then
			if stateGetbuf=stateGetbufInit then
				-- IP impl.getbuf.syncrst --- BEGIN
				getbufLock <= lockIdle;
				lenGetbuf <= (others => '0');
				ackIgrToGetbufLock <= '0';
				dnyIgrToGetbufLock <= '0';
				ackIgrToGetbufUnlock <= '0';
				ackGetbufBToGetbufLock <= '0';
				dnyGetbufBToGetbufLock <= '0';
				ackGetbufBToGetbufUnlock <= '0';

				-- IP impl.getbuf.syncrst --- END

				stateGetbuf <= stateGetbufReady;

			elsif stateGetbuf=stateGetbufReady then
				if reqIgrToGetbufLock='1' then
					-- IP impl.getbuf.ready.bufLock --- IBEGIN
					if getbufLock=lockBufB then
						dnyIgrToGetbufLock <= '1';
					else
						getbufLock <= lockBuf;
						ackIgrToGetbufLock <= '1';
					end if;
					-- IP impl.getbuf.ready.bufLock --- IEND

					stateGetbuf <= stateGetbufAck;

				elsif reqIgrToGetbufUnlock='1' then
					-- IP impl.getbuf.ready.bufUnlock --- IBEGIN
					if getbufLock=lockBuf then
						lenGetbuf <= lenGetbuf_sig;
					end if;
					getbufLock <= lockIdle;
					ackIgrToGetbufUnlock <= '1';
					-- IP impl.getbuf.ready.bufUnlock --- IEND

					stateGetbuf <= stateGetbufAck;

				elsif reqGetbufBToGetbufLock='1' then
					-- IP impl.getbuf.ready.bufBLock --- IBEGIN
					if getbufLock=lockBuf then
						dnyGetbufBToGetbufLock <= '1';
					else
						getbufLock <= lockBufB;
						ackGetbufBToGetbufLock <= '1';
					end if;
					-- IP impl.getbuf.ready.bufBLock --- IEND

					stateGetbuf <= stateGetbufAck;

				elsif reqGetbufBToGetbufUnlock='1' then
					-- IP impl.getbuf.ready.bufBUnlock --- IBEGIN
					if getbufLock=lockBufB and getbufClearNotKeep='1' then
						lenGetbuf <= (others => '0');
					end if;
					getbufLock <= lockIdle;
					ackGetbufBToGetbufUnlock <= '1';
					-- IP impl.getbuf.ready.bufBUnlock --- IEND

					stateGetbuf <= stateGetbufAck;
				end if;

			elsif stateGetbuf=stateGetbufAck then
				if ((ackIgrToGetbufLock='1' or dnyIgrToGetbufLock='1') and reqIgrToGetbufLock='0') then
					-- IP impl.getbuf.ack.bufLock --- IBEGIN
					ackIgrToGetbufLock <= '0';
					dnyIgrToGetbufLock <= '0';
					-- IP impl.getbuf.ack.bufLock --- IEND

					stateGetbuf <= stateGetbufReady;

				elsif (ackIgrToGetbufUnlock='1' and reqIgrToGetbufUnlock='0') then
					ackIgrToGetbufUnlock <= '0'; -- IP impl.getbuf.ack.bufUnlock --- ILINE

					stateGetbuf <= stateGetbufReady;

				elsif ((ackGetbufBToGetbufLock='1' or dnyGetbufBToGetbufLock='1') and reqGetbufBToGetbufLock='0') then
					-- IP impl.getbuf.ack.bufBLock --- IBEGIN
					ackGetbufBToGetbufLock <= '0';
					dnyGetbufBToGetbufLock <= '0';
					-- IP impl.getbuf.ack.bufBLock --- IEND

					stateGetbuf <= stateGetbufReady;

				elsif (ackGetbufBToGetbufUnlock='1' and reqGetbufBToGetbufUnlock='0') then
					ackGetbufBToGetbufUnlock <= '0'; -- IP impl.getbuf.ack.bufBUnlock --- ILINE

					stateGetbuf <= stateGetbufReady;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.getbuf.rising --- END

	------------------------------------------------------------------------
	-- implementation: get buffer B/hostif-facing operation (getbufB)
	------------------------------------------------------------------------

	-- IP impl.getbufB.wiring --- RBEGIN
	ackGetbufToHostif_sig <= '1' when (stateGetbufB=stateGetbufBXferA or stateGetbufB=stateGetbufBXferB or stateGetbufB=stateGetbufBDone) else '0';
	ackGetbufToHostif <= ackGetbufToHostif_sig;

	avllenGetbufToHostif <= std_logic_vector(to_unsigned(2048, 32)) when getbufLock=lockIdle else (others => '0');

	getbufToHostifAXIS_tvalid_sig <= '1' when stateGetbufB=stateGetbufBXferB else '0';
	getbufToHostifAXIS_tvalid <= getbufToHostifAXIS_tvalid_sig;
	getbufToHostifAXIS_tlast_sig <= '0' when (stateGetbufB=stateGetbufBXferB and aGetbufB/=2048/8-1) else '1';
	getbufToHostifAXIS_tlast <= getbufToHostifAXIS_tlast_sig;

	enGetbufB <= '1' when stateGetbufB=stateGetbufBXferA else '0';

	aGetbufB_vec <= std_logic_vector(to_unsigned(aGetbufB, 8));

	reqGetbufBToGetbufLock <= '1' when stateGetbufB=stateGetbufBTrylock else '0';

	reqGetbufBToGetbufUnlock <= '1' when stateGetbufB=stateGetbufBUnlock else '0';
	-- IP impl.getbufB.wiring --- REND

	stateGetbufB_dbg <= x"00" when stateGetbufB=stateGetbufBInit
				else x"10" when stateGetbufB=stateGetbufBIdle
				else x"20" when stateGetbufB=stateGetbufBTrylock
				else x"30" when stateGetbufB=stateGetbufBXferA
				else x"31" when stateGetbufB=stateGetbufBXferB
				else x"40" when stateGetbufB=stateGetbufBDone
				else x"50" when stateGetbufB=stateGetbufBUnlock
				else (others => '1');

	-- IP impl.getbufB.rising --- BEGIN
	process (reset, mclk, stateGetbufB)
		-- IP impl.getbufB.vars --- BEGIN
		-- IP impl.getbufB.vars --- END

	begin
		if reset='1' then
			-- IP impl.getbufB.asyncrst --- BEGIN
			stateGetbufB <= stateGetbufBInit;
			aGetbufB <= 0;
			getbufClearNotKeep <= '0';

			-- IP impl.getbufB.asyncrst --- END

		elsif rising_edge(mclk) then
			if stateGetbufB=stateGetbufBInit then
				-- IP impl.getbufB.syncrst --- BEGIN
				aGetbufB <= 0;
				getbufClearNotKeep <= '0';

				-- IP impl.getbufB.syncrst --- END

				stateGetbufB <= stateGetbufBIdle;

			elsif stateGetbufB=stateGetbufBIdle then
				if reqGetbufToHostif='1' then
					stateGetbufB <= stateGetbufBTrylock;
				end if;

			elsif stateGetbufB=stateGetbufBTrylock then
				if ackGetbufBToGetbufLock='1' then
					stateGetbufB <= stateGetbufBXferA;

				elsif dnyGetbufBToGetbufLock='1' then
					stateGetbufB <= stateGetbufBIdle;
				end if;

			elsif stateGetbufB=stateGetbufBXferA then
				stateGetbufB <= stateGetbufBXferB;

			elsif stateGetbufB=stateGetbufBXferB then
				if getbufToHostifAXIS_tready='1' then
					if aGetbufB=2048/8-1 then
						stateGetbufB <= stateGetbufBDone;

					else
						aGetbufB <= aGetbufB + 1; -- IP impl.getbufB.xferB.inc --- ILINE

						stateGetbufB <= stateGetbufBXferA;
					end if;

				elsif reqGetbufToHostif='0' then
					getbufClearNotKeep <= '0'; -- IP impl.getbufB.xferB.cnc --- ILINE

					stateGetbufB <= stateGetbufBUnlock;
				end if;

			elsif stateGetbufB=stateGetbufBDone then
				if dneGetbufToHostif='1' then
					getbufClearNotKeep <= '1'; -- IP impl.getbufB.done.success --- ILINE

					stateGetbufB <= stateGetbufBUnlock;

				elsif reqGetbufToHostif='0' then
					getbufClearNotKeep <= '0'; -- IP impl.getbufB.done.fail --- ILINE

					stateGetbufB <= stateGetbufBUnlock;
				end if;

			elsif stateGetbufB=stateGetbufBUnlock then
				if (reqGetbufToHostif='0' and ackGetbufBToGetbufUnlock='1') then
					stateGetbufB <= stateGetbufBInit;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.getbufB.rising --- END

	------------------------------------------------------------------------
	-- implementation: copy data from DDR memory to getbuf (igr)
	------------------------------------------------------------------------

	-- IP impl.igr.wiring --- RBEGIN
	ackInvLoadGetbuf_sig <= '1' when stateIgr=stateIgrInv else '0';
	ackInvLoadGetbuf <= ackInvLoadGetbuf_sig_mclk;

	memCRdAXI_araddr <= memCRdAXI_araddr_sig;

	memCRdAXI_arvalid_sig <= '1' when stateIgr=stateIgrCopyB else '0';
	memCRdAXI_arvalid <= memCRdAXI_arvalid_sig;

	memCRdAXI_rready_sig <= '1' when stateIgr=stateIgrCopyC else '0';
	memCRdAXI_rready <= memCRdAXI_rready_sig;

	reqToDdrifRd_sig <= '1' when stateIgr=stateIgrCopyB else '0';
	reqToDdrifRd <= reqToDdrifRd_sig;

	enGetbuf <= '1' when stateIgr=stateIgrCopyC else '0';

	aGetbuf_vec <= std_logic_vector(to_unsigned(aGetbuf, 7));

	reqIgrToGetbufLock <= '1' when stateIgr=stateIgrTrylock else '0';

	reqIgrToGetbufUnlock <= '1' when stateIgr=stateIgrUnlock else '0';
	-- IP impl.igr.wiring --- REND

	-- IP impl.igr.rising --- BEGIN
	process (resetMemclk, memclk, stateIgr)
		-- IP impl.igr.vars --- RBEGIN
		constant NBurstIgr: natural := 2048/16/16; -- 8
		variable burstIgr: natural range 0 to NBurstIgr-1;

		constant NBeatIgr: natural := 16;
		variable beatIgr: natural range 0 to NBeatIgr-1;
		-- IP impl.igr.vars --- REND

	begin
		if resetMemclk='1' then
			-- IP impl.igr.asyncrst --- RBEGIN
			stateIgr <= stateIgrInit;
			memCRdAXI_araddr_sig <= (others => '0');
			aGetbuf <= 0;
			lenGetbuf_sig <= (others => '0');

			burstIgr := 0;
			beatIgr := 0;
			-- IP impl.igr.asyncrst --- REND

		elsif rising_edge(memclk) then
			if stateIgr=stateIgrInit then
				-- IP impl.igr.syncrst --- RBEGIN
				memCRdAXI_araddr_sig <= (others => '0');
				aGetbuf <= 0;
				lenGetbuf_sig <= (others => '0');

				burstIgr := 0;
				beatIgr := 0;
				-- IP impl.igr.syncrst --- REND

				if reqInvLoadGetbuf_sig_memclk='1' then
					stateIgr <= stateIgrInv;

				else
					stateIgr <= stateIgrInit;
				end if;

			elsif stateIgr=stateIgrInv then
				if reqInvLoadGetbuf_sig_memclk='0' then
					stateIgr <= stateIgrTrylock;
				end if;

			elsif stateIgr=stateIgrTrylock then
				if ackIgrToGetbufLock_memclk='1' then
					stateIgr <= stateIgrCopyA;

				elsif dnyIgrToGetbufLock_memclk='1' then
					stateIgr <= stateIgrInit;
				end if;

			elsif stateIgr=stateIgrCopyA then
				-- IP impl.igr.copyA --- IBEGIN
				aGetbuf <= 0;

				burstIgr := 0;
				beatIgr := 0;
				-- IP impl.igr.copyA --- IEND

				stateIgr <= stateIgrCopyB;

			elsif stateIgr=stateIgrCopyB then
				if (ackToDdrifRd='1' and memCRdAXI_arready='1') then
					stateIgr <= stateIgrCopyC;
				end if;

			elsif stateIgr=stateIgrCopyC then
				if memCRdAXI_rvalid='1' then
					-- IP impl.igr.copyC.inc --- IBEGIN
					if aGetbuf/=2048/16-1 then
						aGetbuf <= aGetbuf + 1;
					end if;
					-- IP impl.igr.copyC.inc --- IEND

					if beatIgr=NBeatIgr-1 then
						beatIgr := 0; -- IP impl.igr.copyC.burstDone --- ILINE

						if burstIgr=NBurstIgr-1 then
							-- IP impl.igr.copyC.done --- IBEGIN
							lenGetbuf_sig <= std_logic_vector(to_unsigned(2048, 32));

							burstIgr := 0;
							-- IP impl.igr.copyC.done --- IEND

							stateIgr <= stateIgrUnlock;

						else
							-- IP impl.igr.copyC.nextBurst --- IBEGIN
							burstIgr := burstIgr + 1;

							memCRdAXI_araddr_sig <= std_logic_vector(unsigned(memCRdAXI_araddr_sig) + 1);
							-- IP impl.igr.copyC.nextBurst --- IEND

							stateIgr <= stateIgrCopyB;
						end if;

					else
						beatIgr := beatIgr + 1; -- IP impl.igr.copyC.nextBeat --- ILINE

						stateIgr <= stateIgrCopyC;
					end if;
				end if;

			elsif stateIgr=stateIgrUnlock then
				if ackIgrToGetbufUnlock_memclk='1' then
					stateIgr <= stateIgrInit;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.igr.rising --- END

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
			ackEgrToSetbufLock <= '0';
			dnyEgrToSetbufLock <= '0';
			ackEgrToSetbufUnlock <= '0';
			ackSetbufBToSetbufLock <= '0';
			dnySetbufBToSetbufLock <= '0';
			ackSetbufBToSetbufUnlock <= '0';

			-- IP impl.setbuf.asyncrst --- END

		elsif rising_edge(mclk) then
			if stateSetbuf=stateSetbufInit then
				-- IP impl.setbuf.syncrst --- BEGIN
				setbufLock <= lockIdle;
				lenSetbuf <= (others => '0');
				ackEgrToSetbufLock <= '0';
				dnyEgrToSetbufLock <= '0';
				ackEgrToSetbufUnlock <= '0';
				ackSetbufBToSetbufLock <= '0';
				dnySetbufBToSetbufLock <= '0';
				ackSetbufBToSetbufUnlock <= '0';

				-- IP impl.setbuf.syncrst --- END

				stateSetbuf <= stateSetbufReady;

			elsif stateSetbuf=stateSetbufReady then
				if reqEgrToSetbufLock='1' then
					-- IP impl.setbuf.ready.bufLock --- IBEGIN
					if setbufLock=lockBufB then
						dnyEgrToSetbufLock <= '1';
					else
						setbufLock <= lockBuf;
						ackEgrToSetbufLock <= '1';
					end if;
					-- IP impl.setbuf.ready.bufLock --- IEND

					stateSetbuf <= stateSetbufAck;

				elsif reqEgrToSetbufUnlock='1' then
					-- IP impl.setbuf.ready.bufUnlock --- IBEGIN
					if setbufLock=lockBuf and setbufClearNotKeep='1' then
						lenSetbuf <= (others => '0');
					end if;
					setbufLock <= lockIdle;
					ackEgrToSetbufUnlock <= '1';
					-- IP impl.setbuf.ready.bufUnlock --- IEND

					stateSetbuf <= stateSetbufAck;

				elsif reqSetbufBToSetbufLock='1' then
					-- IP impl.setbuf.ready.bufBLock --- IBEGIN
					if setbufLock=lockBuf then
						dnySetbufBToSetbufLock <= '1';
					else
						setbufLock <= lockBufB;
						ackSetbufBToSetbufLock <= '1';
					end if;
					-- IP impl.setbuf.ready.bufBLock --- IEND

					stateSetbuf <= stateSetbufAck;

				elsif reqSetbufBToSetbufUnlock='1' then
					-- IP impl.setbuf.ready.bufBUnlock --- IBEGIN
					if setbufLock=lockBufB then
						lenSetbuf <= lenSetbufB;
					end if;
					setbufLock <= lockIdle;
					ackSetbufBToSetbufUnlock <= '1';
					-- IP impl.setbuf.ready.bufBUnlock --- IEND

					stateSetbuf <= stateSetbufAck;
				end if;

			elsif stateSetbuf=stateSetbufAck then
				if ((ackEgrToSetbufLock='1' or dnyEgrToSetbufLock='1') and reqEgrToSetbufLock='0') then
					-- IP impl.setbuf.ack.bufLock --- IBEGIN
					ackEgrToSetbufLock <= '0';
					dnyEgrToSetbufLock <= '0';
					-- IP impl.setbuf.ack.bufLock --- IEND

					stateSetbuf <= stateSetbufReady;

				elsif (ackEgrToSetbufUnlock='1' and reqEgrToSetbufUnlock='0') then
					ackEgrToSetbufLock <= '0'; --- IP impl.setbuf.ack.bufUnlock --- ILINE

					stateSetbuf <= stateSetbufReady;

				elsif ((ackSetbufBToSetbufLock='1' or dnySetbufBToSetbufLock='1') and reqSetbufBToSetbufLock='0') then
					-- IP impl.setbuf.ack.bufBLock --- IBEGIN
					ackSetbufBToSetbufLock <= '0';
					dnySetbufBToSetbufLock <= '0';
					-- IP impl.setbuf.ack.bufBLock --- IEND

					stateSetbuf <= stateSetbufReady;

				elsif (ackSetbufBToSetbufUnlock='1' and reqSetbufBToSetbufUnlock='0') then
					ackSetbufBToSetbufUnlock <= '0'; -- IP impl.setbuf.ack.bufBUnlock --- ILINE

					stateSetbuf <= stateSetbufReady;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.setbuf.rising --- END

	------------------------------------------------------------------------
	-- implementation: set buffer B/hostif-facing operation (setbufB)
	------------------------------------------------------------------------

	-- IP impl.setbufB.wiring --- RBEGIN
	ackSetbufFromHostif_sig <= '1' when stateSetbufB=stateSetbufBWrite else '0';
	ackSetbufFromHostif <= ackSetbufFromHostif_sig;

	avllenSetbufFromHostif <= std_logic_vector(to_unsigned(2048, 32)) when setbufLock=lockIdle else (others => '0');

	setbufFromHostifAXIS_tready_sig <= '1' when stateSetbufB=stateSetbufBWrite else '0';
	setbufFromHostifAXIS_tready <= setbufFromHostifAXIS_tready_sig;

	enSetbufB <= '1' when (stateSetbufB=stateSetbufBWrite and setbufFromHostifAXIS_tvalid='1') else '0';

	aSetbufB_vec <= std_logic_vector(to_unsigned(aSetbufB, 8));

	reqSetbufBToSetbufLock <= '1' when stateSetbufB=stateSetbufBTrylock else '0';

	reqSetbufBToSetbufUnlock <= '1' when stateSetbufB=stateSetbufBUnlock else '0';
	-- IP impl.setbufB.wiring --- REND

	stateSetbufB_dbg <= x"00" when stateSetbufB=stateSetbufBInit
				else x"10" when stateSetbufB=stateSetbufBIdle
				else x"20" when stateSetbufB=stateSetbufBTrylock
				else x"30" when stateSetbufB=stateSetbufBWrite
				else x"40" when stateSetbufB=stateSetbufBDone
				else x"50" when stateSetbufB=stateSetbufBUnlock
				else (others => '1');

	-- IP impl.setbufB.rising --- BEGIN
	process (reset, mclk, stateSetbufB)
		-- IP impl.setbufB.vars --- BEGIN
		-- IP impl.setbufB.vars --- END

	begin
		if reset='1' then
			-- IP impl.setbufB.asyncrst --- BEGIN
			stateSetbufB <= stateSetbufBInit;
			aSetbufB <= 0;
			lenSetbufB <= (others => '0');

			-- IP impl.setbufB.asyncrst --- END

		elsif rising_edge(mclk) then
			if stateSetbufB=stateSetbufBInit then
				-- IP impl.setbufB.syncrst --- BEGIN
				aSetbufB <= 0;
				lenSetbufB <= (others => '0');

				-- IP impl.setbufB.syncrst --- END

				stateSetbufB <= stateSetbufBIdle;

			elsif stateSetbufB=stateSetbufBIdle then
				if reqSetbufFromHostif='1' then
					stateSetbufB <= stateSetbufBTrylock;
				end if;

			elsif stateSetbufB=stateSetbufBTrylock then
				if ackSetbufBToSetbufLock='1' then
					stateSetbufB <= stateSetbufBWrite;

				elsif dnySetbufBToSetbufLock='1' then
					stateSetbufB <= stateSetbufBIdle;
				end if;

			elsif stateSetbufB=stateSetbufBWrite then
				if setbufFromHostifAXIS_tvalid='1' then
					if (setbufFromHostifAXIS_tlast='1' or aSetbufB=2048/8-1) then
						-- IP impl.setbufB.write.updLen --- IBEGIN
						lenSetbufB <= std_logic_vector(to_unsigned(aSetbufB + 1, 29) & "000");
						-- IP impl.setbufB.write.updLen --- IEND

						stateSetbufB <= stateSetbufBDone;

					else
						aSetbufB <= aSetbufB + 1; -- IP impl.setbufB.write.inc --- ILINE

						stateSetbufB <= stateSetbufBWrite;
					end if;

				elsif (reqSetbufFromHostif='0' or aSetbufB=2048/8-1) then
					-- IP impl.setbufB.write.reset --- IBEGIN
					lenSetbufB <= (others => '0');
					-- IP impl.setbufB.write.reset --- IEND

					stateSetbufB <= stateSetbufBDone;
				end if;

			elsif stateSetbufB=stateSetbufBDone then
				if reqSetbufFromHostif='0' then
					stateSetbufB <= stateSetbufBUnlock;
				end if;

			elsif stateSetbufB=stateSetbufBUnlock then
				if ackSetbufBToSetbufUnlock='1' then
					stateSetbufB <= stateSetbufBInit;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.setbufB.rising --- END

	------------------------------------------------------------------------
	-- implementation: mclk to memclk CDC sampling (mclkToMemclkSample)
	------------------------------------------------------------------------

	-- IP impl.mclkToMemclkSample.wiring --- BEGIN
	-- IP impl.mclkToMemclkSample.wiring --- END

	-- IP impl.mclkToMemclkSample.rising --- BEGIN
	process (resetMemclk, memclk)
		-- IP impl.mclkToMemclkSample.vars --- BEGIN
		variable ackEgrToSetbufUnlock_last: std_logic;
		variable dnyEgrToSetbufLock_last: std_logic;
		variable ackEgrToSetbufLock_last: std_logic;
		variable ackIgrToGetbufUnlock_last: std_logic;
		variable dnyIgrToGetbufLock_last: std_logic;
		variable ackIgrToGetbufLock_last: std_logic;
		variable reqInvStoreSetbuf_sig_last: std_logic;
		variable reqInvLoadGetbuf_sig_last: std_logic;
		-- IP impl.mclkToMemclkSample.vars --- END

	begin
		if resetMemclk='1' then
			-- IP impl.mclkToMemclkSample.asyncrst --- BEGIN
			ackEgrToSetbufUnlock_memclk <= '0';
			dnyEgrToSetbufLock_memclk <= '0';
			ackEgrToSetbufLock_memclk <= '0';
			ackIgrToGetbufUnlock_memclk <= '0';
			dnyIgrToGetbufLock_memclk <= '0';
			ackIgrToGetbufLock_memclk <= '0';
			reqInvStoreSetbuf_sig_memclk <= '0';
			reqInvLoadGetbuf_sig_memclk <= '0';

			ackEgrToSetbufUnlock_last := '0';
			dnyEgrToSetbufLock_last := '0';
			ackEgrToSetbufLock_last := '0';
			ackIgrToGetbufUnlock_last := '0';
			dnyIgrToGetbufLock_last := '0';
			ackIgrToGetbufLock_last := '0';
			reqInvStoreSetbuf_sig_last := '0';
			reqInvLoadGetbuf_sig_last := '0';
			-- IP impl.mclkToMemclkSample.asyncrst --- END

		elsif rising_edge(memclk) then
			if ackEgrToSetbufUnlock=ackEgrToSetbufUnlock_last then
				ackEgrToSetbufUnlock_memclk <= ackEgrToSetbufUnlock;
			end if;
			ackEgrToSetbufUnlock_last := ackEgrToSetbufUnlock;

			if dnyEgrToSetbufLock=dnyEgrToSetbufLock_last then
				dnyEgrToSetbufLock_memclk <= dnyEgrToSetbufLock;
			end if;
			dnyEgrToSetbufLock_last := dnyEgrToSetbufLock;

			if ackEgrToSetbufLock=ackEgrToSetbufLock_last then
				ackEgrToSetbufLock_memclk <= ackEgrToSetbufLock;
			end if;
			ackEgrToSetbufLock_last := ackEgrToSetbufLock;

			if ackIgrToGetbufUnlock=ackIgrToGetbufUnlock_last then
				ackIgrToGetbufUnlock_memclk <= ackIgrToGetbufUnlock;
			end if;
			ackIgrToGetbufUnlock_last := ackIgrToGetbufUnlock;

			if dnyIgrToGetbufLock=dnyIgrToGetbufLock_last then
				dnyIgrToGetbufLock_memclk <= dnyIgrToGetbufLock;
			end if;
			dnyIgrToGetbufLock_last := dnyIgrToGetbufLock;

			if ackIgrToGetbufLock=ackIgrToGetbufLock_last then
				ackIgrToGetbufLock_memclk <= ackIgrToGetbufLock;
			end if;
			ackIgrToGetbufLock_last := ackIgrToGetbufLock;

			if reqInvStoreSetbuf_sig=reqInvStoreSetbuf_sig_last then
				reqInvStoreSetbuf_sig_memclk <= reqInvStoreSetbuf_sig;
			end if;
			reqInvStoreSetbuf_sig_last := reqInvStoreSetbuf_sig;

			if reqInvLoadGetbuf_sig=reqInvLoadGetbuf_sig_last then
				reqInvLoadGetbuf_sig_memclk <= reqInvLoadGetbuf_sig;
			end if;
			reqInvLoadGetbuf_sig_last := reqInvLoadGetbuf_sig;

		end if;
	end process;
	-- IP impl.mclkToMemclkSample.rising --- END

	------------------------------------------------------------------------
	-- implementation: memclk to mclk CDC sampling (memclkToMclkSample)
	------------------------------------------------------------------------

	-- IP impl.memclkToMclkSample.wiring --- BEGIN
	-- IP impl.memclkToMclkSample.wiring --- END

	-- IP impl.memclkToMclkSample.rising --- BEGIN
	process (reset, mclk)
		-- IP impl.memclkToMclkSample.vars --- BEGIN
		variable reqEgrToSetbufUnlock_last: std_logic;
		variable reqEgrToSetbufLock_last: std_logic;
		variable reqIgrToGetbufUnlock_last: std_logic;
		variable reqIgrToGetbufLock_last: std_logic;
		variable ackInvStoreSetbuf_sig_last: std_logic;
		variable ackInvLoadGetbuf_sig_last: std_logic;
		-- IP impl.memclkToMclkSample.vars --- END

	begin
		if reset='1' then
			-- IP impl.memclkToMclkSample.asyncrst --- BEGIN
			reqEgrToSetbufUnlock_mclk <= '0';
			reqEgrToSetbufLock_mclk <= '0';
			reqIgrToGetbufUnlock_mclk <= '0';
			reqIgrToGetbufLock_mclk <= '0';
			ackInvStoreSetbuf_sig_mclk <= '0';
			ackInvLoadGetbuf_sig_mclk <= '0';

			reqEgrToSetbufUnlock_last := '0';
			reqEgrToSetbufLock_last := '0';
			reqIgrToGetbufUnlock_last := '0';
			reqIgrToGetbufLock_last := '0';
			ackInvStoreSetbuf_sig_last := '0';
			ackInvLoadGetbuf_sig_last := '0';
			-- IP impl.memclkToMclkSample.asyncrst --- END

		elsif rising_edge(mclk) then
			if reqEgrToSetbufUnlock_to_mclk=reqEgrToSetbufUnlock_last then
				reqEgrToSetbufUnlock_mclk <= reqEgrToSetbufUnlock_to_mclk;
			end if;
			reqEgrToSetbufUnlock_last := reqEgrToSetbufUnlock_to_mclk;

			if reqEgrToSetbufLock_to_mclk=reqEgrToSetbufLock_last then
				reqEgrToSetbufLock_mclk <= reqEgrToSetbufLock_to_mclk;
			end if;
			reqEgrToSetbufLock_last := reqEgrToSetbufLock_to_mclk;

			if reqIgrToGetbufUnlock_to_mclk=reqIgrToGetbufUnlock_last then
				reqIgrToGetbufUnlock_mclk <= reqIgrToGetbufUnlock_to_mclk;
			end if;
			reqIgrToGetbufUnlock_last := reqIgrToGetbufUnlock_to_mclk;

			if reqIgrToGetbufLock_to_mclk=reqIgrToGetbufLock_last then
				reqIgrToGetbufLock_mclk <= reqIgrToGetbufLock_to_mclk;
			end if;
			reqIgrToGetbufLock_last := reqIgrToGetbufLock_to_mclk;

			if ackInvStoreSetbuf_sig_to_mclk=ackInvStoreSetbuf_sig_last then
				ackInvStoreSetbuf_sig_mclk <= ackInvStoreSetbuf_sig_to_mclk;
			end if;
			ackInvStoreSetbuf_sig_last := ackInvStoreSetbuf_sig_to_mclk;

			if ackInvLoadGetbuf_sig_to_mclk=ackInvLoadGetbuf_sig_last then
				ackInvLoadGetbuf_sig_mclk <= ackInvLoadGetbuf_sig_to_mclk;
			end if;
			ackInvLoadGetbuf_sig_last := ackInvLoadGetbuf_sig_to_mclk;

		end if;
	end process;
	-- IP impl.memclkToMclkSample.rising --- END

	------------------------------------------------------------------------
	-- implementation: memclk to mclk CDC stretching (memclkToMclkStretch)
	------------------------------------------------------------------------

	-- IP impl.memclkToMclkStretch.wiring --- BEGIN
	-- IP impl.memclkToMclkStretch.wiring --- END

	-- IP impl.memclkToMclkStretch.rising --- BEGIN
	process (resetMemclk, memclk)
		-- IP impl.memclkToMclkStretch.vars --- BEGIN
		constant imax: natural := 4;

		variable reqEgrToSetbufUnlock_i: natural range 0 to imax;
		variable reqEgrToSetbufLock_i: natural range 0 to imax;
		variable reqIgrToGetbufUnlock_i: natural range 0 to imax;
		variable reqIgrToGetbufLock_i: natural range 0 to imax;
		variable ackInvStoreSetbuf_sig_i: natural range 0 to imax;
		variable ackInvLoadGetbuf_sig_i: natural range 0 to imax;
		-- IP impl.memclkToMclkStretch.vars --- END

	begin
		if resetMemclk='1' then
			-- IP impl.memclkToMclkStretch.asyncrst --- BEGIN
			reqEgrToSetbufUnlock_to_mclk <= '0';
			reqEgrToSetbufLock_to_mclk <= '0';
			reqIgrToGetbufUnlock_to_mclk <= '0';
			reqIgrToGetbufLock_to_mclk <= '0';
			ackInvStoreSetbuf_sig_to_mclk <= '0';
			ackInvLoadGetbuf_sig_to_mclk <= '0';

			reqEgrToSetbufUnlock_i := 0;
			reqEgrToSetbufLock_i := 0;
			reqIgrToGetbufUnlock_i := 0;
			reqIgrToGetbufLock_i := 0;
			ackInvStoreSetbuf_sig_i := 0;
			ackInvLoadGetbuf_sig_i := 0;
			-- IP impl.memclkToMclkStretch.asyncrst --- END

		elsif rising_edge(memclk) then
			if reqEgrToSetbufUnlock_i=imax then
				if reqEgrToSetbufUnlock/=reqEgrToSetbufUnlock_to_mclk then
					reqEgrToSetbufUnlock_to_mclk <= reqEgrToSetbufUnlock;
					reqEgrToSetbufUnlock_i := 0;
				end if;
			else
				reqEgrToSetbufUnlock_i := reqEgrToSetbufUnlock_i + 1;
			end if;

			if reqEgrToSetbufLock_i=imax then
				if reqEgrToSetbufLock/=reqEgrToSetbufLock_to_mclk then
					reqEgrToSetbufLock_to_mclk <= reqEgrToSetbufLock;
					reqEgrToSetbufLock_i := 0;
				end if;
			else
				reqEgrToSetbufLock_i := reqEgrToSetbufLock_i + 1;
			end if;

			if reqIgrToGetbufUnlock_i=imax then
				if reqIgrToGetbufUnlock/=reqIgrToGetbufUnlock_to_mclk then
					reqIgrToGetbufUnlock_to_mclk <= reqIgrToGetbufUnlock;
					reqIgrToGetbufUnlock_i := 0;
				end if;
			else
				reqIgrToGetbufUnlock_i := reqIgrToGetbufUnlock_i + 1;
			end if;

			if reqIgrToGetbufLock_i=imax then
				if reqIgrToGetbufLock/=reqIgrToGetbufLock_to_mclk then
					reqIgrToGetbufLock_to_mclk <= reqIgrToGetbufLock;
					reqIgrToGetbufLock_i := 0;
				end if;
			else
				reqIgrToGetbufLock_i := reqIgrToGetbufLock_i + 1;
			end if;

			if ackInvStoreSetbuf_sig_i=imax then
				if ackInvStoreSetbuf_sig/=ackInvStoreSetbuf_sig_to_mclk then
					ackInvStoreSetbuf_sig_to_mclk <= ackInvStoreSetbuf_sig;
					ackInvStoreSetbuf_sig_i := 0;
				end if;
			else
				ackInvStoreSetbuf_sig_i := ackInvStoreSetbuf_sig_i + 1;
			end if;

			if ackInvLoadGetbuf_sig_i=imax then
				if ackInvLoadGetbuf_sig/=ackInvLoadGetbuf_sig_to_mclk then
					ackInvLoadGetbuf_sig_to_mclk <= ackInvLoadGetbuf_sig;
					ackInvLoadGetbuf_sig_i := 0;
				end if;
			else
				ackInvLoadGetbuf_sig_i := ackInvLoadGetbuf_sig_i + 1;
			end if;

		end if;
	end process;
	-- IP impl.memclkToMclkStretch.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- IBEGIN
	reqInvLoadGetbuf_sig <= reqInvLoadGetbuf;
	reqInvStoreSetbuf_sig <= reqInvStoreSetbuf;
	-- IP impl.oth.cust --- IEND

end Rtl;
