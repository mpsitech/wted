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
use work.Tidk.all;

entity Client is
	port (
		reset: in std_logic;
		mclk: in std_logic;

		resetMemclk: in std_logic;
		memclk: in std_logic;

		memCRdAXI_araddr: out std_logic_vector(19 downto 0);
		memCRdAXI_arready: in std_logic;
		memCRdAXI_arvalid: out std_logic;
		memCRdAXI_rdata: in std_logic_vector(31 downto 0);
		memCRdAXI_rlast: in std_logic;
		memCRdAXI_rready: out std_logic;
		memCRdAXI_rresp: in std_logic_vector(1 downto 0);
		memCRdAXI_rvalid: in std_logic;

		reqToDdrifRd: out std_logic;
		ackToDdrifRd: in std_logic;

		memCWrAXI_awaddr: out std_logic_vector(19 downto 0);
		memCWrAXI_awready: in std_logic;
		memCWrAXI_awvalid: out std_logic;
		memCWrAXI_wdata: out std_logic_vector(31 downto 0);
		memCWrAXI_wlast: out std_logic;
		memCWrAXI_wready: in std_logic;
		memCWrAXI_wvalid: out std_logic;
		memCWrAXI_bready: out std_logic;
		memCWrAXI_bresp: in std_logic_vector(1 downto 0);
		memCWrAXI_bvalid: in std_logic;

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
		getbufToHostifAXIS_tdata: out std_logic_vector(31 downto 0);
		getbufToHostifAXIS_tlast: out std_logic;

		setbufFromHostifAXIS_tready: out std_logic;
		setbufFromHostifAXIS_tvalid: in std_logic;
		setbufFromHostifAXIS_tdata: in std_logic_vector(31 downto 0);
		setbufFromHostifAXIS_tlast: in std_logic;

		stateGetbufB_dbg: out std_logic_vector(7 downto 0);
		stateSetbufB_dbg: out std_logic_vector(7 downto 0)
	);
end Client;

architecture Rtl of Client is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Dpram_size4kB_a32b32 is
		port (
			resetA: in std_logic;
			clkA: in std_logic;

			enA: in std_logic;
			weA: in std_logic;

			aA: in std_logic_vector(9 downto 0);
			drdA: out std_logic_vector(31 downto 0);
			dwrA: in std_logic_vector(31 downto 0);

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

	signal ackInvStoreSetbuf_sig: std_logic;

	signal memCWrAXI_awaddr_sig: std_logic_vector(19 downto 0);
	signal memCWrAXI_awvalid_sig: std_logic;
	signal memCWrAXI_wlast_sig: std_logic;
	signal memCWrAXI_wvalid_sig: std_logic;
	signal memCWrAXI_bready_sig: std_logic;

	signal reqToDdrifWr_sig: std_logic;
	signal enSetbuf: std_logic;

	signal aSetbuf: natural range 0 to 1023;
	signal aSetbuf_vec: std_logic_vector(9 downto 0);

	-- IP sigs.egr.cust --- INSERT

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

	signal aGetbufB: natural range 0 to 1023;
	signal aGetbufB_vec: std_logic_vector(9 downto 0);

	signal getbufClearNotKeep: std_logic;

	-- IP sigs.getbufB.cust --- INSERT

	---- copy data from DDR memory to getbuf (igr)
	type stateIgr_t is (
		stateIgrInit,
		stateIgrIdle,
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

	signal aGetbuf: natural range 0 to 1023;
	signal aGetbuf_vec: std_logic_vector(9 downto 0);

	-- IP sigs.igr.cust --- INSERT

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

	signal aSetbufB: natural range 0 to 1023;
	signal aSetbufB_vec: std_logic_vector(9 downto 0);
	signal lenSetbufB: natural range 0 to 4095;

	-- IP sigs.setbufB.cust --- INSERT

	---- handshake
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
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myGetbuf : Dpram_size4kB_a32b32
		port map (
			resetA => '0',
			clkA => memclk,

			enA => enGetbuf,
			weA => '1',

			aA => aGetbuf_vec,
			drdA => open,
			dwrA => memCRdAXI_rdata,

			resetB => '0',
			clkB => mclk,

			enB => enGetbufB,
			weB => '0',

			aB => aGetbufB_vec,
			drdB => getbufToHostifAXIS_tdata,
			dwrB => (others => '0')
		);

	mySetbuf : Dpram_size4kB_a32b32
		port map (
			resetA => '0',
			clkA => memclk,

			enA => enSetbuf,
			weA => '0',

			aA => aSetbuf_vec,
			drdA => memCWrAXI_wdata,
			dwrA => (others => '0'),

			resetB => '0',
			clkB => mclk,

			enB => enSetbufB,
			weB => '1',

			aB => aSetbufB_vec,
			drdB => open,
			dwrB => setbufFromHostifAXIS_tdata
		);

	------------------------------------------------------------------------
	-- implementation: copy data from setbuf to DDR memory (egr)
	------------------------------------------------------------------------

	-- IP impl.egr.wiring --- BEGIN
	ackInvStoreSetbuf_sig <= '1' when stateEgr=stateEgrInv else '0';
	ackInvStoreSetbuf <= ackInvStoreSetbuf_sig;

	memCWrAXI_awaddr <= memCWrAXI_awaddr_sig;
	memCWrAXI_awvalid_sig <= '1' when stateEgr=stateEgrCopyB else '0';
	memCWrAXI_awvalid <= memCWrAXI_awvalid_sig;
	memCWrAXI_wlast <= memCWrAXI_wlast_sig;
	memCWrAXI_wvalid_sig <= '1' when stateEgr=stateEgrCopyC else '0';
	memCWrAXI_wvalid <= memCWrAXI_wvalid_sig;
	memCWrAXI_bready_sig <= '1';
	memCWrAXI_bready <= memCWrAXI_bready_sig;

	reqToDdrifWr_sig <= '1' when stateEgr=stateEgrCopyB else '0';
	reqToDdrifWr <= reqToDdrifWr_sig;

	aSetbuf_vec <= std_logic_vector(to_unsigned(aSetbuf, 10));

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
			memCWrAXI_awaddr_sig <= (others => '0');
			memCWrAXI_wlast_sig <= '1';
			enSetbuf <= '0';
			aSetbuf <= 0;

			-- IP impl.egr.asyncrst --- END

		elsif rising_edge(memclk) then
			if stateEgr=stateEgrInit then
				-- IP impl.egr.syncrst --- BEGIN
				memCWrAXI_awaddr_sig <= (others => '0');
				memCWrAXI_wlast_sig <= '1';
				enSetbuf <= '0';
				aSetbuf <= 0;

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
					-- IP impl.getbuf.ready.bufLock --- INSERT

					stateGetbuf <= stateGetbufAck;

				elsif reqIgrToGetbufUnlock='1' then
					-- IP impl.getbuf.ready.bufUnlock --- INSERT

					stateGetbuf <= stateGetbufAck;

				elsif reqGetbufBToGetbufLock='1' then
					-- IP impl.getbuf.ready.bufBLock --- INSERT

					stateGetbuf <= stateGetbufAck;

				elsif reqGetbufBToGetbufUnlock='1' then
					-- IP impl.getbuf.ready.bufBUnlock --- INSERT

					stateGetbuf <= stateGetbufAck;
				end if;

			elsif stateGetbuf=stateGetbufAck then
				if ((ackIgrToGetbufLock='1' or dnyIgrToGetbufLock='1') and reqIgrToGetbufLock='0') then
					-- IP impl.getbuf.ack.bufLock --- INSERT

					stateGetbuf <= stateGetbufReady;

				elsif (ackIgrToGetbufUnlock='1' and reqIgrToGetbufUnlock='0') then
					-- IP impl.getbuf.ack.bufUnlock --- INSERT

					stateGetbuf <= stateGetbufReady;

				elsif ((ackGetbufBToGetbufLock='1' or dnyGetbufBToGetbufLock='1') and reqGetbufBToGetbufLock='0') then
					-- IP impl.getbuf.ack.bufBLock --- INSERT

					stateGetbuf <= stateGetbufReady;

				elsif (ackGetbufBToGetbufUnlock='1' and reqGetbufBToGetbufUnlock='0') then
					-- IP impl.getbuf.ack.bufBUnlock --- INSERT

					stateGetbuf <= stateGetbufReady;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.getbuf.rising --- END

	------------------------------------------------------------------------
	-- implementation: get buffer B/hostif-facing operation (getbufB)
	------------------------------------------------------------------------

	-- IP impl.getbufB.wiring --- BEGIN
	ackGetbufToHostif_sig <= '1' when (stateGetbufB=stateGetbufBXferA or stateGetbufB=stateGetbufBXferB or stateGetbufB=stateGetbufBDone) else '0';
	ackGetbufToHostif <= ackGetbufToHostif_sig;

	getbufToHostifAXIS_tvalid_sig <= '1' when stateGetbufB=stateGetbufBXferB else '0';
	getbufToHostifAXIS_tvalid <= getbufToHostifAXIS_tvalid_sig;
	getbufToHostifAXIS_tlast_sig <= '0' when (stateGetbufB=stateGetbufBXferB and aGetbufB/=2048/8-1) else '1';
	getbufToHostifAXIS_tlast <= getbufToHostifAXIS_tlast_sig;

	enGetbufB <= '1' when stateGetbufB=stateGetbufBXferA else '0';

	aGetbufB_vec <= std_logic_vector(to_unsigned(aGetbufB, 10));

	reqGetbufBToGetbufLock <= '1' when stateGetbufB=stateGetbufBTrylock else '0';

	reqGetbufBToGetbufUnlock <= '1' when stateGetbufB=stateGetbufBUnlock else '0';
	-- IP impl.getbufB.wiring --- END

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
					if aGetbufB=4096/4-1 then
						stateGetbufB <= stateGetbufBDone;

					else
						-- IP impl.getbufB.xferB.inc --- INSERT

						stateGetbufB <= stateGetbufBXferA;
					end if;

				elsif reqGetbufToHostif='0' then
					-- IP impl.getbufB.xferB.cnc --- INSERT

					stateGetbufB <= stateGetbufBUnlock;
				end if;

			elsif stateGetbufB=stateGetbufBDone then
				if dneGetbufToHostif='1' then
					-- IP impl.getbufB.done.success --- INSERT

					stateGetbufB <= stateGetbufBUnlock;

				elsif reqGetbufToHostif='0' then
					-- IP impl.getbufB.done.fail --- INSERT

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

	-- IP impl.igr.wiring --- BEGIN
	ackInvLoadGetbuf_sig <= '1' when stateIgr=stateIgrInv else '0';
	ackInvLoadGetbuf <= ackInvLoadGetbuf_sig;

	memCRdAXI_araddr <= memCRdAXI_araddr_sig;
	memCRdAXI_arvalid_sig <= '1' when stateIgr=stateIgrCopyB else '0';
	memCRdAXI_arvalid <= memCRdAXI_arvalid_sig;

	memCRdAXI_rready_sig <= '1' when stateIgr=stateIgrCopyC else '0';
	memCRdAXI_rready <= memCRdAXI_rready_sig;
	reqToDdrifRd_sig <= '1' when stateIgr=stateIgrCopyB else '0';
	reqToDdrifRd <= reqToDdrifRd_sig;
	enGetbuf <= '1' when stateIgr=stateIgrCopyC else '0';

	aGetbuf_vec <= std_logic_vector(to_unsigned(aGetbuf, 10));

	reqIgrToGetbufLock <= '1' when stateIgr=stateIgrTrylock else '0';

	reqIgrToGetbufUnlock <= '1' when stateIgr=stateIgrUnlock else '0';
	-- IP impl.igr.wiring --- END

	-- IP impl.igr.rising --- BEGIN
	process (resetMemclk, memclk, stateIgr)
		-- IP impl.igr.vars --- BEGIN
		-- IP impl.igr.vars --- END

	begin
		if resetMemclk='1' then
			-- IP impl.igr.asyncrst --- BEGIN
			stateIgr <= stateIgrInit;
			memCRdAXI_araddr_sig <= (others => '0');
			aGetbuf <= 0;

			-- IP impl.igr.asyncrst --- END

		elsif rising_edge(memclk) then
			if stateIgr=stateIgrInit then
				-- IP impl.igr.syncrst --- BEGIN
				memCRdAXI_araddr_sig <= (others => '0');
				aGetbuf <= 0;

				stateIgr <= stateIgrIdle;
				-- IP impl.igr.syncrst --- END

			elsif stateIgr=stateIgrIdle then
				-- IP impl.igr.idle --- INSERT

			elsif stateIgr=stateIgrInv then
				-- IP impl.igr.inv --- INSERT

			elsif stateIgr=stateIgrTrylock then
				-- IP impl.igr.trylock --- INSERT

			elsif stateIgr=stateIgrCopyA then
				-- IP impl.igr.copyA --- INSERT

			elsif stateIgr=stateIgrCopyB then
				-- IP impl.igr.copyB --- INSERT

			elsif stateIgr=stateIgrCopyC then
				-- IP impl.igr.copyC --- INSERT

			elsif stateIgr=stateIgrUnlock then
				-- IP impl.igr.unlock --- INSERT
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
					-- IP impl.setbuf.ready.bufLock --- INSERT

					stateSetbuf <= stateSetbufAck;

				elsif reqEgrToSetbufUnlock='1' then
					-- IP impl.setbuf.ready.bufUnlock --- INSERT

					stateSetbuf <= stateSetbufAck;

				elsif reqSetbufBToSetbufLock='1' then
					-- IP impl.setbuf.ready.bufBLock --- INSERT

					stateSetbuf <= stateSetbufAck;

				elsif reqSetbufBToSetbufUnlock='1' then
					-- IP impl.setbuf.ready.bufBUnlock --- INSERT

					stateSetbuf <= stateSetbufAck;
				end if;

			elsif stateSetbuf=stateSetbufAck then
				if ((ackEgrToSetbufLock='1' or dnyEgrToSetbufLock='1') and reqEgrToSetbufLock='0') then
					-- IP impl.setbuf.ack.bufLock --- INSERT

					stateSetbuf <= stateSetbufReady;

				elsif (ackEgrToSetbufUnlock='1' and reqEgrToSetbufUnlock='0') then
					-- IP impl.setbuf.ack.bufUnlock --- INSERT

					stateSetbuf <= stateSetbufReady;

				elsif ((ackSetbufBToSetbufLock='1' or dnySetbufBToSetbufLock='1') and reqSetbufBToSetbufLock='0') then
					-- IP impl.setbuf.ack.bufBLock --- INSERT

					stateSetbuf <= stateSetbufReady;

				elsif (ackSetbufBToSetbufUnlock='1' and reqSetbufBToSetbufUnlock='0') then
					-- IP impl.setbuf.ack.bufBUnlock --- INSERT

					stateSetbuf <= stateSetbufReady;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.setbuf.rising --- END

	------------------------------------------------------------------------
	-- implementation: set buffer B/hostif-facing operation (setbufB)
	------------------------------------------------------------------------

	-- IP impl.setbufB.wiring --- BEGIN
	ackSetbufFromHostif_sig <= '1' when stateSetbufB=stateSetbufBWrite else '0';
	ackSetbufFromHostif <= ackSetbufFromHostif_sig;
	setbufFromHostifAXIS_tready_sig <= '1' when stateSetbufB=stateSetbufBWrite else '0';
	setbufFromHostifAXIS_tready <= setbufFromHostifAXIS_tready_sig;
	enSetbufB <= '1' when (stateSetbufB=stateSetbufBWrite and setbufFromHostifAXIS_tvalid='1') else '0';

	aSetbufB_vec <= std_logic_vector(to_unsigned(aSetbufB, 10));

	reqSetbufBToSetbufLock <= '1' when stateSetbufB=stateSetbufBTrylock else '0';

	reqSetbufBToSetbufUnlock <= '1' when stateSetbufB=stateSetbufBUnlock else '0';
	-- IP impl.setbufB.wiring --- END

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
			lenSetbufB <= 0;

			-- IP impl.setbufB.asyncrst --- END

		elsif rising_edge(mclk) then
			if stateSetbufB=stateSetbufBInit then
				-- IP impl.setbufB.syncrst --- BEGIN
				aSetbufB <= 0;
				lenSetbufB <= 0;

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
					if (setbufFromHostifAXIS_tlast='1' or aSetbufB=4096/4-1) then
						-- IP impl.setbufB.write.updLen --- INSERT

						stateSetbufB <= stateSetbufBDone;

					else
						-- IP impl.setbufB.write.inc --- INSERT

						stateSetbufB <= stateSetbufBWrite;
					end if;

				elsif (reqSetbufFromHostif='0' or aSetbufB=4096/4-1) then
					-- IP impl.setbufB.write.reset --- INSERT

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
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Rtl;
