-- file Ddrif.vhd
-- Ddrif ddrmux_Easy_v1_0 implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 30 Jun 2024
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Tidk.all;

entity Ddrif is
	port (
		reset: in std_logic;
		mclk: in std_logic;
		tkclk: in std_logic;
		resetMemclk: in std_logic;
		memclk: in std_logic;

		getStatsNRdA: out std_logic_vector(31 downto 0);
		getStatsNWrA: out std_logic_vector(31 downto 0);
		getStatsNWrB: out std_logic_vector(31 downto 0);

		reqRdA: in std_logic;
		ackRdA: out std_logic;

		rdAAXI_araddr: in std_logic_vector(19 downto 0);
		rdAAXI_arready: out std_logic;
		rdAAXI_arvalid: in std_logic;
		rdAAXI_rdata: out std_logic_vector(31 downto 0);
		rdAAXI_rlast: out std_logic;
		rdAAXI_rready: in std_logic;
		rdAAXI_rresp: out std_logic_vector(1 downto 0);
		rdAAXI_rvalid: out std_logic;

		reqWrA: in std_logic;
		ackWrA: out std_logic;

		wrAAXI_awaddr: in std_logic_vector(19 downto 0);
		wrAAXI_awready: out std_logic;
		wrAAXI_awvalid: in std_logic;
		wrAAXI_wdata: in std_logic_vector(31 downto 0);
		wrAAXI_wlast: in std_logic;
		wrAAXI_wready: out std_logic;
		wrAAXI_wvalid: in std_logic;

		reqWrB: in std_logic;
		ackWrB: out std_logic;

		wrBAXI_awaddr: in std_logic_vector(19 downto 0);
		wrBAXI_awready: out std_logic;
		wrBAXI_awvalid: in std_logic;
		wrBAXI_wdata: in std_logic_vector(31 downto 0);
		wrBAXI_wlast: in std_logic;
		wrBAXI_wready: out std_logic;
		wrBAXI_wvalid: in std_logic;

		ddrAXI_arid: out std_logic_vector(5 downto 0);
		ddrAXI_araddr: out std_logic_vector(31 downto 0);
		ddrAXI_arburst: out std_logic_vector(1 downto 0);
		ddrAXI_arcache: out std_logic_vector(3 downto 0);
		ddrAXI_arlen: out std_logic_vector(7 downto 0);
		ddrAXI_arlock: out std_logic_vector(0 downto 0);
		ddrAXI_arprot: out std_logic_vector(2 downto 0);
		ddrAXI_arqos: out std_logic_vector(3 downto 0);
		ddrAXI_arready: in std_logic;
		ddrAXI_arregion: out std_logic_vector(3 downto 0);
		ddrAXI_arsize: out std_logic_vector(2 downto 0);
		ddrAXI_arvalid: out std_logic;

		ddrAXI_rid: in std_logic_vector(5 downto 0);
		ddrAXI_rdata: in std_logic_vector(511 downto 0);
		ddrAXI_rlast: in std_logic;
		ddrAXI_rready: out std_logic;
		ddrAXI_rresp: in std_logic_vector(1 downto 0);
		ddrAXI_rvalid: in std_logic;

		ddrAXI_awid: out std_logic_vector(5 downto 0);
		ddrAXI_awaddr: out std_logic_vector(31 downto 0);
		ddrAXI_awburst: out std_logic_vector(1 downto 0);
		ddrAXI_awcache: out std_logic_vector(3 downto 0);
		ddrAXI_awlen: out std_logic_vector(7 downto 0);
		ddrAXI_awlock: out std_logic_vector(0 downto 0);
		ddrAXI_awprot: out std_logic_vector(2 downto 0);
		ddrAXI_awqos: out std_logic_vector(3 downto 0);
		ddrAXI_awready: in std_logic;
		ddrAXI_awregion: out std_logic_vector(3 downto 0);
		ddrAXI_awsize: out std_logic_vector(2 downto 0);
		ddrAXI_awvalid: out std_logic;

		ddrAXI_wdata: out std_logic_vector(511 downto 0);
		ddrAXI_wlast: out std_logic;
		ddrAXI_wready: in std_logic;
		ddrAXI_wstrb: out std_logic_vector(63 downto 0);
		ddrAXI_wvalid: out std_logic;

		ddrAXI_bid: in std_logic_vector(5 downto 0);
		ddrAXI_bready: out std_logic;
		ddrAXI_bresp: in std_logic_vector(1 downto 0);
		ddrAXI_bvalid: in std_logic
	);
end Ddrif;

architecture Rtl of Ddrif is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- rdA geared egress operation (rdAGearEgr)
	type stateRdAGearEgr_t is (
		stateRdAGearEgrIdle,
		stateRdAGearEgrWaitFull,
		stateRdAGearEgrXfer,
		stateRdAGearEgrDone
	);
	signal stateRdAGearEgr: stateRdAGearEgr_t := stateRdAGearEgrIdle;

	signal rdAAXI_arready_oprt: std_logic;
	signal rdAAXI_rdata_oprt: std_logic_vector(31 downto 0);
	signal rdAAXI_rlast_oprt: std_logic;
	signal rdAAXI_rvalid_oprt: std_logic;

	signal rdAReady: boolean;
	signal rdAA: std_logic_vector(31 downto 0);

	-- IP sigs.rdAGearEgr.cust --- INSERT

	---- rdA geared ingress operation (rdAGearIgr)
	type stateRdAGearIgr_t is (
		stateRdAGearIgrIdle,
		stateRdAGearIgrAddr,
		stateRdAGearIgrXfer
	);
	signal stateRdAGearIgr: stateRdAGearIgr_t := stateRdAGearIgrIdle;

	signal rdAAXI_araddr_sig: std_logic_vector(15 downto 0);
	signal rdAAXI_arvalid_sig: std_logic;
	signal rdAAXI_rready_sig: std_logic;

	signal reqRdA_sig: std_logic;
	signal rdAFull: boolean;
	type burstbuf_t is array 0 to NBeat-1 of std_logic_vector(wD-1 downto 0);
	signal rdABuf: burstbuf_t;

	-- IP sigs.rdAGearIgr.cust --- INSERT

	---- read access negotiation (read)
	type stateRead_t is (
		stateReadInit,
		stateReadIdle,
		stateReadLocked
	);
	signal stateRead: stateRead_t := stateReadInit;

	constant NRd: natural := 1;
	signal aRd: natural;
	signal ackRd: std_logic;

	signal ackRdA_sig: std_logic;

	signal ddrAXI_arlen_sig: std_logic_vector(7 downto 0);
	type mutex_t is (mutexIdle, mutexA, mutexB);
	signal rdmutex: mutex_t;
	signal strbRdlock: std_logic;

	signal rdAAXI_rdata_sig: std_logic_vector(511 downto 0);
	signal rdAAXI_rlast_sig: std_logic;
	signal rdAAXI_rresp_sig: std_logic_vector(1 downto 0);
	signal rdAAXI_rvalid_sig: std_logic;

	-- IP sigs.read.cust --- INSERT

	---- accumulate statistics (stats)
	type stateStats_t is (
		stateStatsCollectA, stateStatsCollectB
	);
	signal stateStats: stateStats_t := stateStatsCollectA;

	signal NRdA: std_logic_vector(31 downto 0);
	signal NWrA: std_logic_vector(31 downto 0);
	signal NWrB: std_logic_vector(31 downto 0);

	-- IP sigs.stats.cust --- INSERT

	---- wrA geared egress operation (wrAGearEgr)
	type stateWrAGearEgr_t is (
		stateWrAGearEgrIdle,
		stateWrAGearEgrAddr,
		stateWrAGearEgrXfer,
		stateWrAGearEgrResp
	);
	signal stateWrAGearEgr: stateWrAGearEgr_t := stateWrAGearEgrIdle;

	signal wrAAXI_awaddr_sig: std_logic_vector(15 downto 0);
	signal wrAAXI_awvalid_sig: std_logic;
	signal wrAAXI_wdata_sig: std_logic_vector(511 downto 0);
	signal wrAAXI_wlast_sig: std_logic;
	signal wrAAXI_wvalid_sig: std_logic;

	signal reqWrA_sig: std_logic;

	signal wrADoneA: boolean;
	signal wrADoneB: boolean;

	-- IP sigs.wrAGearEgr.cust --- INSERT

	---- wrA geared ingress operation (wrAGearIgr)
	type stateWrAGearIgr_t is (
		stateWrAGearIgrIdle,
		stateWrAGearIgrXfer,
		stateWrAGearIgrResp,
		stateWrAGearIgrFull
	);
	signal stateWrAGearIgr: stateWrAGearIgr_t := stateWrAGearIgrIdle;

	signal wrAAXI_awready_oprt: std_logic;
	signal wrAAXI_wready_oprt: std_logic;

	signal wrAFillBNotA: boolean;

	signal wrAFullA: boolean;
	signal wrAFullB: boolean;

	signal wrAAa: std_logic_vector(15 downto 0);
	signal wrAAbuf: burstbuf_t;

	signal wrABa: std_logic_vector(15 downto 0);
	signal wrABbuf: burstbuf_t;

	-- IP sigs.wrAGearIgr.cust --- INSERT

	---- wrB geared egress operation (wrBGearEgr)
	type stateWrBGearEgr_t is (
		stateWrBGearEgrIdle,
		stateWrBGearEgrAddr,
		stateWrBGearEgrXfer,
		stateWrBGearEgrResp
	);
	signal stateWrBGearEgr: stateWrBGearEgr_t := stateWrBGearEgrIdle;

	signal wrBAXI_awaddr_sig: std_logic_vector(15 downto 0);
	signal wrBAXI_awvalid_sig: std_logic;
	signal wrBAXI_wdata_sig: std_logic_vector(511 downto 0);
	signal wrBAXI_wlast_sig: std_logic;
	signal wrBAXI_wvalid_sig: std_logic;

	signal reqWrB_sig: std_logic;

	signal wrBDoneA: boolean;
	signal wrBDoneB: boolean;

	-- IP sigs.wrBGearEgr.cust --- INSERT

	---- wrB geared ingress operation (wrBGearIgr)
	type stateWrBGearIgr_t is (
		stateWrBGearIgrIdle,
		stateWrBGearIgrXfer,
		stateWrBGearIgrResp,
		stateWrBGearIgrFull
	);
	signal stateWrBGearIgr: stateWrBGearIgr_t := stateWrBGearIgrIdle;

	signal wrBAXI_awready_oprt: std_logic;
	signal wrBAXI_wready_oprt: std_logic;

	signal wrBFillBNotA: boolean;

	signal wrBFullA: boolean;
	signal wrBFullB: boolean;

	signal wrBAa: std_logic_vector(15 downto 0);
	signal wrBAbuf: burstbuf_t;

	signal wrBBa: std_logic_vector(15 downto 0);
	signal wrBBbuf: burstbuf_t;

	-- IP sigs.wrBGearIgr.cust --- INSERT

	---- write access negotiation (write)
	type stateWrite_t is (
		stateWriteInit,
		stateWriteIdle,
		stateWriteLocked
	);
	signal stateWrite: stateWrite_t := stateWriteInit;

	constant NWr: natural := 2;
	signal abWr: natural;
	signal ackWr: std_logic;

	signal ackWrA_sig: std_logic;
	signal ackWrB_sig: std_logic;

	signal ddrAXI_awlen_sig: std_logic_vector(7 downto 0);

	signal ddrAXI_wvalid_sig: std_logic;
	signal ddrAXI_wlast_sig: std_logic;

	signal ddrAXI_bready_sig: std_logic;
	signal wrmutex: mutex_t;
	signal strbWrlock: std_logic;

	signal wrid: std_logic_vector(31 downto 0);
	signal ixWrid: natural range 0 to 31;

	signal wrAAXI_awready_sig: std_logic;
	signal wrAAXI_wready_sig: std_logic;

	signal wrBAXI_awready_sig: std_logic;
	signal wrBAXI_wready_sig: std_logic;

	-- IP sigs.write.cust --- INSERT

	---- memclk to mclk CDC sampling (memclkToMclkSample)

	signal strbWrlock_mclk: std_logic;
	signal strbRdlock_mclk: std_logic;

	-- IP sigs.memclkToMclkSample.cust --- INSERT

	---- memclk to mclk CDC stretching (memclkToMclkStretch)

	signal strbWrlock_to_mclk: std_logic;
	signal strbRdlock_to_mclk: std_logic;

	-- IP sigs.memclkToMclkStretch.cust --- INSERT

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- implementation: rdA geared egress operation (rdAGearEgr)
	------------------------------------------------------------------------

	-- IP impl.rdAGearEgr.wiring --- BEGIN
	rdAAXI_arready_oprt <= '1' when stateRdAGearEgr=stateRdAGearEgrIdle else '0';
	rdAAXI_arready <= rdAAXI_arready_oprt;
	rdAAXI_rdata <= rdAAXI_rdata_oprt;
	rdAAXI_rlast <= rdAAXI_rlast_oprt;
	rdAAXI_rvalid_oprt <= '1' when stateRdAGearEgr=stateRdAGearEgrXfer else '0';
	rdAAXI_rvalid <= rdAAXI_rvalid_oprt;
	-- IP impl.rdAGearEgr.wiring --- END

	-- IP impl.rdAGearEgr.rising --- BEGIN
	process (resetMemclk, memclk, stateRdAGearEgr)
		-- IP impl.rdAGearEgr.vars --- BEGIN
		variable i: natural range 0 to NBeat-1;

		constant jmax: natural := 512/32-1;
		variable j: natural range 0 to jmax;
		-- IP impl.rdAGearEgr.vars --- END

	begin
		if resetMemclk='1' then
			-- IP impl.rdAGearEgr.asyncrst --- BEGIN
			stateRdAGearEgr <= stateRdAGearEgrIdle;
			rdAAXI_rdata_oprt <= (others => '0');
			rdAAXI_rlast_oprt <= '0';
			rdAReady <= true;
			rdAA <= (others => '0');

			i := 0;
			j := 0;
			-- IP impl.rdAGearEgr.asyncrst --- END

		elsif rising_edge(memclk) then
			if stateRdAGearEgr=stateRdAGearEgrIdle then
				if rdAAXI_rwvalid then
					rdAA <= rdAAXI_araddr;
					rdAReady <= true;

					stateRdAGearEgr <= stateRdAGearEgrWaitFull;
				end if;

			elsif stateRdAGearEgr=stateRdAGearEgrWaitFull then
				if rdAFull_cross then
					i := 0;
					j := 0;

					rdAAXI_rdata_oprt <= rdABuf(i)(32*(j+1)-1 downto 32*j);
					rdAAXI_rlast_oprt <= '0';

					stateRdAGearEgr <= stateRdAGearEgrXfer;
				end if;

			elsif stateRdAGearEgr=stateRdAGearEgrXfer then
				if rdAAXI_rready_sig='1' then
					if j=jmax then
						j := 0;

						if i=NBeat-1 then
							rdAReady <= false;

							stateRdAGearEgr <= stateRdAGearEgrDone;

						else
							i := i + 1;

							rdAAXI_rdata_oprt <= rdABuf(i)(32*(j+1)-1 downto 32*j);

							stateRdAGearEgr <= stateRdAGearEgrXfer;
						end if;

					else
						j := j + 1;

						rdAAXI_rdata_oprt <= rdABuf(i)(32*(j+1)-1 downto 32*j);

						if i=NBeat-1 and j=jmax then
							rdAAXI_rlast_oprt <= '1';
						end if;

						stateRdAGearEgr <= stateRdAGearEgrXfer;
					end if;
				end if;

			elsif stateRdAGearEgr=stateRdAGearEgrDone then
				if not rdAFull_cross then
					stateRdAGearEgr <= stateRdAGearEgrIdle;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.rdAGearEgr.rising --- END

	------------------------------------------------------------------------
	-- implementation: rdA geared ingress operation (rdAGearIgr)
	------------------------------------------------------------------------

	-- IP impl.rdAGearIgr.wiring --- BEGIN
	rdAAXI_arvalid_sig <= '1' when stateRdAGearIgr=stateRdAGearIgrAddr else '0';
	rdAAXI_rready_sig <= '1' when stateRdAGearIgr=stateRdAGearIgrXfer else '0';

	reqRdA_sig <= '1' when (stateRdAGearIgr=stateRdAGearIgrAddr or stateRdAGearIgr=stateRdAGearIgrXfer) else '0';
	-- IP impl.rdAGearIgr.wiring --- END

	-- IP impl.rdAGearIgr.rising --- BEGIN
	process (resetMemclk, memclk, stateRdAGearIgr)
		-- IP impl.rdAGearIgr.vars --- BEGIN
		variable i: natural range 0 to NBeat-1;
		-- IP impl.rdAGearIgr.vars --- END

	begin
		if resetMemclk='1' then
			rdAAXI_araddr_sig <= (others => '0');

			rdAFull <= false;

			for i in 0 to NBeat-1 loop
				rdABuf(i) <= (others => '0');
			end loop;

		elsif rising_edge(memclk) then
			if not rdAReady_memclk and rdAFull then
				rdAFull <= false;
			end if;

			if stateRdAGearIgr=stateRdAGearIgrIdle then
				if rdAReady_cross and not rdAFull then
					rdAAXI_araddr_sig <= rdAA;

					stateRdAGearIgr <= stateRdAGearIgrAddr;
				end if;

			elsif stateRdAGearIgr=stateRdAGearIgrAddr then
				if rdAAXI_awredy_sig then
					i := 0;

					stateRdAGearIgr <= stateRdAGearIgrXfer;
				end if;

			elsif stateRdAGearIgr=stateRdAGearIgrXfer then
				if rdAAXI_rvalid_sig='1' then
					rdABuf(i) <= rdAAXI_rdata_sig;
				end if;

				if (i=imax-1 or rdAAXI_rlast_sig='1') then
					rdAFull <= true;

					stateRdAGearIgr <= stateRdAGearIgrIdle;

				else
					i := i + 1;

					stateRdAGearIgr <= stateRdAGearIgrXfer;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.rdAGearIgr.rising --- END

	------------------------------------------------------------------------
	-- implementation: read access negotiation (read)
	------------------------------------------------------------------------

	ddrAXI_arid <= (others => '0');

	ddrAXI_araddr <= "000011" & rdAAXI_araddr_sig & "0000000000" when rdmutex=mutexA
				else (others => '0');

	ddrAXI_arburst <= "01"; -- INCR burst type
	ddrAXI_arcache <= "0000"; -- device non-bufferable memory type

	ddrAXI_arlen <= ddrAXI_arlen_sig;
	ddrAXI_arlen_sig <= x"0F"; -- burst length of 16

	ddrAXI_arlock <= "0"; -- normal access as opposed to exclusive access
	ddrAXI_arprot <= "010"; -- unprivileged, non-secure data access
	ddrAXI_arqos <= "1101"; -- not participating in QoS scheme

	rdAAXI_arready_sig <= ddrAXI_arready when rdmutex=mutexA else '0';

	ddrAXI_arregion <= "0000"; -- region feature not used
	ddrAXI_arsize <= "110"; -- 512-bit wide transfers

	ddrAXI_arvalid <= rdAAXI_arvalid_sig when rdmutex=mutexA
				else '0';

	rdAAXI_rdata_sig <= ddrAXI_rdata;

	rdAAXI_rlast_sig <= ddrAXI_rlast;

	ddrAXI_rready <= rdAAXI_rready_sig when rdmutex=mutexA
				else '0';

	rdAAXI_rresp_sig <= ddrAXI_rresp;

	rdAAXI_rvalid_sig <= ddrAXI_rvalid when rdmutex=mutexA else '0';

	ackRd <= '1' when stateRead=stateReadLocked else '0';

	ackRdA <= ackRd when rdmutex=mutexA else '0';

	-- IP impl.read.rising --- BEGIN
	process (resetMemclk, memclk, stateRead)
		-- IP impl.read.vars --- BEGIN
		-- IP impl.read.vars --- END

	begin
		if resetMemclk='1' then
			-- IP impl.read.asyncrst --- BEGIN
			stateRead <= stateReadInit;
			aRd <= 0;
			rdmutex <= mutexIdle;
			strbRdlock <= '0';

			-- IP impl.read.asyncrst --- END

		elsif rising_edge(memclk) then
			if stateRead=stateReadInit then
				-- IP impl.read.syncrst --- BEGIN
				aRd <= 0;
				rdmutex <= mutexIdle;
				strbRdlock <= '0';

				-- IP impl.read.syncrst --- END

				stateRead <= stateReadIdle;

			elsif stateRead=stateReadIdle then
				if reqRdA_sig='1' then
					aRd <= 0;
					rdmutex <= mutexA;

					strbRdlock <= '1';

					stateRead <= stateReadLocked;
				end if;

			elsif stateRead=stateReadLocked then
				strbRdlock <= '0';

				if (ddrAXI_rvalid='1' and ddrAXI_rlast='1') then
					rdmutex <= mutexIdle;

					stateRead <= stateReadIdle;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.read.rising --- END

	------------------------------------------------------------------------
	-- implementation: accumulate statistics (stats)
	------------------------------------------------------------------------

	-- IP impl.stats.wiring --- BEGIN
	getStatsNRdA <= NRdA;
	getStatsNWrA <= NWrA;
	getStatsNWrB <= NWrB;
	-- IP impl.stats.wiring --- END

	-- IP impl.stats.rising --- BEGIN
	process (reset, mclk, stateStats)
		-- IP impl.stats.vars --- BEGIN
		constant imax: natural := 10000; -- 1 s
		variable i: natural range 0 to imax;

		variable NRdA_collect: std_logic_vector(31 downto 0);
		variable NWrA_collect: std_logic_vector(31 downto 0);
		variable NWrB_collect: std_logic_vector(31 downto 0);
		-- IP impl.stats.vars --- END

	begin
		if reset='1' then
			-- IP impl.stats.asyncrst --- BEGIN
			stateStats <= stateStatsCollectA;
			NRdA <= (others => '0');
			NWrA <= (others => '0');
			NWrB <= (others => '0');

			i := 0;
			NRdA_collect := (others => '0');
			NWrA_collect := (others => '0');
			NWrB_collect := (others => '0');
			-- IP impl.stats.asyncrst --- END

		elsif rising_edge(mclk) then
			if strbRdlock_mclk='1' then
				case rdmutex is
					when mutexA =>
						NRdA_collect := std_logic_vector(unsigned(NRdA_collect) + unsigned(ddrAXI_arlen_sig) + 1);
					when others =>
				end case;
			end if;

			if strbWrlock_mclk='1' then
				case wrmutex is
					when mutexA =>
						NWrA_collect := std_logic_vector(unsigned(NWrA_collect) + unsigned(ddrAXI_awlen_sig) + 1);
					when mutexB =>
						NWrB_collect := std_logic_vector(unsigned(NWrB_collect) + unsigned(ddrAXI_awlen_sig) + 1);
					when others =>
				end case;
			end if;

			if stateStats=stateStatsCollectA then
				if tkclk='1' then
					if i=imax then
						i := 0;

						NRdA <= NRdA_collect;
						NRdA_collect := (others => '0');

						NWrA <= NWrA_collect;
						NWrA_collect := (others => '0');

						NWrB <= NWrB_collect;
						NWrB_collect := (others => '0');
					end if;

					stateStats <= stateStatsCollectB;
				end if;

			elsif stateStats=stateStatsCollectB then
				if tkclk='0' then
					i := i + 1;

					stateStats <= stateStatsCollectA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.stats.rising --- END

	------------------------------------------------------------------------
	-- implementation: wrA geared egress operation (wrAGearEgr)
	------------------------------------------------------------------------

	-- IP impl.wrAGearEgr.wiring --- BEGIN
	wrAAXI_awvalid_sig <= '1' when stateWrAGearEgr=stateWrAGearEgrAddr else '0';
	wrAAXI_wvalid_sig <= '1' when stateWrAGearEgr=stateWrAGearEgrXfer else '0';

	reqWrA_sig <= '1' when (stateWrAGearEgr=stateWrAGearEgrAddr or stateWrAGearEgr=stateWrAGearEgrXfer) else '0';
	-- IP impl.wrAGearEgr.wiring --- END

	-- IP impl.wrAGearEgr.rising --- BEGIN
	process (resetMemclk, memclk, stateWrAGearEgr)
		-- IP impl.wrAGearEgr.vars --- BEGIN
		variable i: natural range 0 to NBeat-1;
		-- IP impl.wrAGearEgr.vars --- END

	begin
		if resetMemclk='1' then
			-- IP impl.wrAGearEgr.asyncrst --- BEGIN
			stateWrAGearEgr <= stateWrAGearEgrIdle;
			wrAAXI_awaddr_sig <= (others => '0');
			wrAAXI_wdata_sig <= (others => '0');
			wrAAXI_wlast_sig <= '0';
			wrADoneA <= false;
			wrADoneB <= false;

			i := 0;
			-- IP impl.wrAGearEgr.asyncrst --- END

		elsif rising_edge(memclk) then
			if wrAFillBNotA_memclk and not wrAFullA_memclk and wrADoneA then
				wrADoneA <= false;
			end if;

			if not wrAFillBNotA_memclk and not wrAFullB_memclk and wrADoneB then
				wrADoneB <= false;
			end if;

			if stateWrAGearEgr=stateWrAGearEgrIdle then
				if wrAFillBNotA_cross and wrAFullA_crossnot wrADoneA then
					wrAAXI_awaddr_sig <= wrAAa;

					stateWrAGearEgr <= stateWrAGearEgrAddr;

				elsif not wrAFillBNotA_cross and wrAFullB_cross and not wrADoneB then
					wrAAXI_awaddr_sig <= wrABa;

					stateWrAGearEgr <= stateWrAGearEgrAddr;
				end if;

			elsif stateWrAGearEgr=stateWrAGearEgrAddr then
				if wrAAXI_awready_sig='1' then
					wrAAXI_wlast_sig <= '0';

					if wrAFillBNotA_memclk then
						wrAAXI_wdata_sig <= wrAAbuf(i);
					else
						wrAAXI_wdata_sig <= wrABbuf(i);
					end if;

					i := 0;

					stateWrAGearEgr <= stateWrAGearEgrXfer;
				end if;

			elsif stateWrAGearEgr=stateWrAGearEgrXfer then
				if wrAAXI_wready_sig='1' then
					if i=imax-1 then
						if wrAFillBNotA_memclk then
							wrADoneA <= true;
						else
							wrADoneB <= true;
						end if;

						stateWrAGearEgr <= stateWrAGearEgrResp;

					else
						i := i + 1;

						if wrAFillBNotA_memclk then
							wrAAXI_wdata_sig <= wrAAbuf(i);
						else
							wrAAXI_wdata_sig <= wrABbuf(i);
						end if;

						if i=imax-1 then
							wrAAXI_wlast_sig <= '1';
						end if;

						stateWrAGearEgr <= stateWrAGearEgrXfer;
					end if;
				end if;

			elsif stateWrAGearEgr=stateWrAGearEgrResp then
				stateWrAGearEgr <= stateWrAGearEgrIdle;
			end if;
		end if;
	end process;
	-- IP impl.wrAGearEgr.rising --- END

	------------------------------------------------------------------------
	-- implementation: wrA geared ingress operation (wrAGearIgr)
	------------------------------------------------------------------------

	-- IP impl.wrAGearIgr.wiring --- BEGIN
	wrAAXI_awready_oprt <= '1' when stateWrAGearIgr=stateWrAGearIgrIdle else '0';
	wrAAXI_awready <= wrAAXI_awready_oprt;
	wrAAXI_wready_oprt <= '1' when stateWrAGearIgr=stateWrAGearIgrXfer else '0';
	wrAAXI_wready <= wrAAXI_wready_oprt;
	-- IP impl.wrAGearIgr.wiring --- END

	-- IP impl.wrAGearIgr.rising --- BEGIN
	process (resetMemclk, memclk, stateWrAGearIgr)
		-- IP impl.wrAGearIgr.vars --- BEGIN
		variable i: natural range 0 to NBeat-1;

		constant jmax: natural := 512/32-1;
		variable j: natural range 0 to jmax;
		-- IP impl.wrAGearIgr.vars --- END

	begin
		if resetMemclk='1' then
			wrAFillBNotA <= true;

			wrAFullA <= false;
			wrAFullB <= false;

			wrAAa <= (others => '0');
			for i in 0 to NBeat-1 loop
				wrAAbuf(i) <= (others => '0');
			end loop;

			wrABa <= (others => '0');
			for i in 0 to NBeat-1 loop
				wrABbuf(i) <= (others => '0');
			end loop;

		elsif rising_edge(memclk) then
		-- IP impl.wrAGearIgr.ext --- INSERT

			if stateWrAGearIgr=stateWrAGearIgrIdle then
				if wrAAXI_awvalid='1' then
					if not wrAFillBNotA then
						wrAAa <= wrAAXI_awaddr;
					else
						wrABa <= wrAAXI_awaddr;
					end if;

					i := 0;
					j := 0;

					stateWrAGearIgr <= stateWrAGearIgrXfer;
				end if;

			elsif stateWrAGearIgr=stateWrAGearIgrXfer then
				if wrAAXI_wvalid='1' then
					if not wrAFillBNotA then
						wrAAbuf(i)(32*(j+1)-1 downto 32*j) <= wrAAXI_wdata;
					else
						wrABbuf(i)(32*(j+1)-1 downto 32*j) <= wrAAXI_wdata;
					end if;

					if j=jmax then
						j := 0;

						if i=imax-1 then
							if not wrAFillBNotA then
								wrAFullA <= true;
							else
								wrAFullB <= true;
							end if;

							wrAFillBNotA <= not wrAFillBNotA;

							stateWrAGearIgr <= stateWrAGearIgrResp;

						else
							i := i + 1;

							stateWrAGearIgr <= stateWrAGearIgrXfer;
						end if;

					else
						j := j + 1;

						stateWrAGearIgr <= stateWrAGearIgrXfer;
					end if;
				end if;

			elsif stateWrAGearIgr=stateWrAGearIgrResp then
				stateWrAGearIgr <= stateWrAGearIgrFull;

			elsif stateWrAGearIgr=stateWrAGearIgrFull then
				if (not wrAFillBNotA and not wrAFullA) or (wrAFillBNotA and not wrAFullB) then
					stateWrAGearIgr <= stateWrAGearIgrIdle;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.wrAGearIgr.rising --- END

	------------------------------------------------------------------------
	-- implementation: wrB geared egress operation (wrBGearEgr)
	------------------------------------------------------------------------

	-- IP impl.wrBGearEgr.wiring --- BEGIN
	wrBAXI_awvalid_sig <= '1' when stateWrBGearEgr=stateWrBGearEgrAddr else '0';
	wrBAXI_wvalid_sig <= '1' when stateWrBGearEgr=stateWrBGearEgrXfer else '0';

	reqWrB_sig <= '1' when (stateWrBGearEgr=stateWrBGearEgrAddr or stateWrBGearEgr=stateWrBGearEgrXfer) else '0';
	-- IP impl.wrBGearEgr.wiring --- END

	-- IP impl.wrBGearEgr.rising --- BEGIN
	process (resetMemclk, memclk, stateWrBGearEgr)
		-- IP impl.wrBGearEgr.vars --- BEGIN
		variable i: natural range 0 to NBeat-1;
		-- IP impl.wrBGearEgr.vars --- END

	begin
		if resetMemclk='1' then
			-- IP impl.wrBGearEgr.asyncrst --- BEGIN
			stateWrBGearEgr <= stateWrBGearEgrIdle;
			wrBAXI_awaddr_sig <= (others => '0');
			wrBAXI_wdata_sig <= (others => '0');
			wrBAXI_wlast_sig <= '0';
			wrBDoneA <= false;
			wrBDoneB <= false;

			i := 0;
			-- IP impl.wrBGearEgr.asyncrst --- END

		elsif rising_edge(memclk) then
			if wrBFillBNotA_memclk and not wrBFullA_memclk and wrBDoneA then
				wrBDoneA <= false;
			end if;

			if not wrBFillBNotA_memclk and not wrBFullB_memclk and wrBDoneB then
				wrBDoneB <= false;
			end if;

			if stateWrBGearEgr=stateWrBGearEgrIdle then
				if wrAFillBNotA_cross and wrAFullA_crossnot wrADoneA then
					wrBAXI_awaddr_sig <= wrBAa;

					stateWrBGearEgr <= stateWrBGearEgrAddr;

				elsif not wrAFillBNotA_cross and wrAFullB_cross and not wrADoneB then
					wrBAXI_awaddr_sig <= wrBBa;

					stateWrBGearEgr <= stateWrBGearEgrAddr;
				end if;

			elsif stateWrBGearEgr=stateWrBGearEgrAddr then
				if wrAAXI_awready_sig='1' then
					wrBAXI_wlast_sig <= '0';

					if wrBFillBNotA_memclk then
						wrBAXI_wdata_sig <= wrBAbuf(i);
					else
						wrBAXI_wdata_sig <= wrBBbuf(i);
					end if;

					i := 0;

					stateWrBGearEgr <= stateWrBGearEgrXfer;
				end if;

			elsif stateWrBGearEgr=stateWrBGearEgrXfer then
				if wrAAXI_wready_sig='1' then
					if i=imax-1 then
						if wrBFillBNotA_memclk then
							wrBDoneA <= true;
						else
							wrBDoneB <= true;
						end if;

						stateWrBGearEgr <= stateWrBGearEgrResp;

					else
						i := i + 1;

						if wrBFillBNotA_memclk then
							wrBAXI_wdata_sig <= wrBAbuf(i);
						else
							wrBAXI_wdata_sig <= wrBBbuf(i);
						end if;

						if i=imax-1 then
							wrBAXI_wlast_sig <= '1';
						end if;

						stateWrBGearEgr <= stateWrBGearEgrXfer;
					end if;
				end if;

			elsif stateWrBGearEgr=stateWrBGearEgrResp then
				stateWrBGearEgr <= stateWrBGearEgrIdle;
			end if;
		end if;
	end process;
	-- IP impl.wrBGearEgr.rising --- END

	------------------------------------------------------------------------
	-- implementation: wrB geared ingress operation (wrBGearIgr)
	------------------------------------------------------------------------

	-- IP impl.wrBGearIgr.wiring --- BEGIN
	wrBAXI_awready_oprt <= '1' when stateWrBGearIgr=stateWrBGearIgrIdle else '0';
	wrBAXI_awready <= wrBAXI_awready_oprt;
	wrBAXI_wready_oprt <= '1' when stateWrBGearIgr=stateWrBGearIgrXfer else '0';
	wrBAXI_wready <= wrBAXI_wready_oprt;
	-- IP impl.wrBGearIgr.wiring --- END

	-- IP impl.wrBGearIgr.rising --- BEGIN
	process (resetMemclk, memclk, stateWrBGearIgr)
		-- IP impl.wrBGearIgr.vars --- BEGIN
		variable i: natural range 0 to NBeat-1;

		constant jmax: natural := 512/32-1;
		variable j: natural range 0 to jmax;
		-- IP impl.wrBGearIgr.vars --- END

	begin
		if resetMemclk='1' then
			wrBFillBNotA <= true;

			wrBFullA <= false;
			wrBFullB <= false;

			wrBAa <= (others => '0');
			for i in 0 to NBeat-1 loop
				wrBAbuf(i) <= (others => '0');
			end loop;

			wrBBa <= (others => '0');
			for i in 0 to NBeat-1 loop
				wrBBbuf(i) <= (others => '0');
			end loop;

		elsif rising_edge(memclk) then
		-- IP impl.wrBGearIgr.ext --- INSERT

			if stateWrBGearIgr=stateWrBGearIgrIdle then
				if wrAAXI_awvalid='1' then
					if not wrBFillBNotA then
						wrBAa <= wrBAXI_awaddr;
					else
						wrBBa <= wrBAXI_awaddr;
					end if;

					i := 0;
					j := 0;

					stateWrBGearIgr <= stateWrBGearIgrXfer;
				end if;

			elsif stateWrBGearIgr=stateWrBGearIgrXfer then
				if wrAAXI_wvalid='1' then
					if not wrBFillBNotA then
						wrBAbuf(i)(32*(j+1)-1 downto 32*j) <= wrBAXI_wdata;
					else
						wrBBbuf(i)(32*(j+1)-1 downto 32*j) <= wrBAXI_wdata;
					end if;

					if j=jmax then
						j := 0;

						if i=imax-1 then
							if not wrBFillBNotA then
								wrBFullA <= true;
							else
								wrBFullB <= true;
							end if;

							wrBFillBNotA <= not wrBFillBNotA;

							stateWrBGearIgr <= stateWrBGearIgrResp;

						else
							i := i + 1;

							stateWrBGearIgr <= stateWrBGearIgrXfer;
						end if;

					else
						j := j + 1;

						stateWrBGearIgr <= stateWrBGearIgrXfer;
					end if;
				end if;

			elsif stateWrBGearIgr=stateWrBGearIgrResp then
				stateWrBGearIgr <= stateWrBGearIgrFull;

			elsif stateWrBGearIgr=stateWrBGearIgrFull then
				if (not wrAFillBNotA and not wrAFullA) or (wrAFillBNotA and not wrAFullB) then
					stateWrBGearIgr <= stateWrBGearIgrIdle;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.wrBGearIgr.rising --- END

	------------------------------------------------------------------------
	-- implementation: write access negotiation (write)
	------------------------------------------------------------------------

	ddrAXI_awid <= std_logic_vector(to_unsigned(ixWrid, 6));

	ddrAXI_awaddr <= "000011" & wrAAXI_awaddr_sig & "0000000000" when wrmutex=mutexA
				else "000011" & wrBAXI_awaddr_sig & "0000000000" when wrmutex=mutexB
				else (others => '0');

	ddrAXI_awburst <= "01"; -- INCR burst type
	ddrAXI_awcache <= "0000"; -- device non-bufferable memory type

	ddrAXI_awlen <= ddrAXI_awlen_sig;
	ddrAXI_awlen_sig <= x"0F"; -- burst length of 16

	ddrAXI_awlock <= "0"; -- normal access as opposed to exclusive access
	ddrAXI_awprot <= "010"; -- unprivileged, non-secure data access
	ddrAXI_awqos <= "1101"; -- not participating in QoS scheme

	wrAAXI_awready_sig <= ddrAXI_awready when wrmutex=mutexA else '0';
	wrBAXI_awready_sig <= ddrAXI_awready when wrmutex=mutexB else '0';

	ddrAXI_awregion <= "0000"; -- region feature not used
	ddrAXI_awsize <= "110"; -- 512-bit wide transfers

	ddrAXI_awvalid <= wrAAXI_awvalid_sig when wrmutex=mutexA
				else wrBAXI_awvalid_sig when wrmutex=mutexB
				else '0';

	ddrAXI_wdata <= wrAAXI_wdata_sig when wrmutex=mutexA
				else wrBAXI_wdata_sig when wrmutex=mutexB
				else (others => '0');

	ddrAXI_wlast <= ddrAXI_wlast_sig;
	ddrAXI_wlast_sig <= wrAAXI_wlast_sig when wrmutex=mutexA
				else wrBAXI_wlast_sig when wrmutex=mutexB
				else '1';

	wrAAXI_wready_sig <= ddrAXI_wready when wrmutex=mutexA else '0';
	wrBAXI_wready_sig <= ddrAXI_wready when wrmutex=mutexB else '0';

	ddrAXI_wstrb <= (others => '1'); -- all bytes for each transfer

	ddrAXI_wvalid <= ddrAXI_wvalid_sig;
	ddrAXI_wvalid_sig <= wrAAXI_wvalid_sig when wrmutex=mutexA
				else wrBAXI_wvalid_sig when wrmutex=mutexB
				else '0';

	ddrAXI_bready <= ddrAXI_bready_sig;

	ackWr <= '1' when stateWrite=stateWriteLocked else '0';

	ackWrA <= ackWr when wrmutex=mutexA else '0';
	ackWrB <= ackWr when wrmutex=mutexB else '0';

	-- IP impl.write.rising --- BEGIN
	process (resetMemclk, memclk, stateWrite)
		-- IP impl.write.vars --- BEGIN
		-- IP impl.write.vars --- END

	begin
		if resetMemclk='1' then
			-- IP impl.write.asyncrst --- BEGIN
			stateWrite <= stateWriteInit;
			abWr <= 0;
			wrmutex <= mutexIdle;
			strbWrlock <= '0';
			wrid <= (others => '0');
			ixWrid <= 0;

			-- IP impl.write.asyncrst --- END

		elsif rising_edge(memclk) then
			if ddrAXI_bvalid='1' then
				wrid(to_integer(unsigned(ddrAXI_bid))) <= '0';
			end if;

			if unsigned(wrid)=0 then -- one clock late
				ddrAXI_bready_sig <= '0';
			else
				ddrAXI_bready_sig <= '1';
			end if;

			if stateWrite=stateWriteInit then
				-- IP impl.write.syncrst --- BEGIN
				abWr <= 0;
				wrmutex <= mutexIdle;
				strbWrlock <= '0';
				wrid <= (others => '0');
				ixWrid <= 0;

				-- IP impl.write.syncrst --- END

				stateWrite <= stateWriteIdle;

			elsif stateWrite=stateWriteIdle then
				if (reqWrA_sig='1' and ((abWr=0 and reqWrB_sig='0') or abWr=1) and wrid(ixWrid)='0') then
					abWr <= 0;
					wrmutex <= mutexA;

					strbWrlock <= '1';

					wrid(ixWrid) <= '1';

					stateWrite <= stateWriteLocked;

				elsif (reqWrB_sig='1' and ((abWr=1 and reqWrA_sig='0') or abWr=0) and wrid(ixWrid)='0') then
					abWr <= 1;
					wrmutex <= mutexB;

					strbWrlock <= '1';

					wrid(ixWrid) <= '1';

					stateWrite <= stateWriteLocked;
				end if;

			elsif stateWrite=stateWriteLocked then
				strbWrlock <= '0';

				if (ddrAXI_wready='1' and ddrAXI_wvalid_sig='1' and ddrAXI_wlast_sig='1') then
					wrmutex <= mutexIdle;

					if ixWrid=31 then
						ixWrid <= 0;
					else
						ixWrid <= ixWrid + 1;
					end if;

					stateWrite <= stateWriteIdle;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.write.rising --- END

	------------------------------------------------------------------------
	-- implementation: memclk to mclk CDC sampling (memclkToMclkSample)
	------------------------------------------------------------------------

	-- IP impl.memclkToMclkSample.wiring --- BEGIN
	-- IP impl.memclkToMclkSample.wiring --- END

	-- IP impl.memclkToMclkSample.rising --- BEGIN
	process (reset, mclk)
		-- IP impl.memclkToMclkSample.vars --- BEGIN
		variable strbWrlock_wait: boolean;
		variable strbRdlock_wait: boolean;
		-- IP impl.memclkToMclkSample.vars --- END

	begin
		if reset='1' then
			-- IP impl.memclkToMclkSample.asyncrst --- BEGIN
			strbWrlock_mclk <= '0';
			strbRdlock_mclk <= '0';

			strbWrlock_wait := false;
			strbRdlock_wait := false;
			-- IP impl.memclkToMclkSample.asyncrst --- END

		elsif rising_edge(mclk) then
			if strbWrlock_mclk='1' then
				strbWrlock_mclk <= '0';
			elsif strbWrlock_to_mclk='1' and not strbWrlock_wait then
				strbWrlock_mclk <= '1';
				strbWrlock_wait := true;
			end if;
			if strbWrlock_to_mclk='0' and strbWrlock_wait then
				strbWrlock_wait := false;
			end if;

			if strbRdlock_mclk='1' then
				strbRdlock_mclk <= '0';
			elsif strbRdlock_to_mclk='1' and not strbRdlock_wait then
				strbRdlock_mclk <= '1';
				strbRdlock_wait := true;
			end if;
			if strbRdlock_to_mclk='0' and strbRdlock_wait then
				strbRdlock_wait := false;
			end if;

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
		constant imax: natural := 5;

		variable strbWrlock_i: natural range 0 to imax;
		variable strbRdlock_i: natural range 0 to imax;
		-- IP impl.memclkToMclkStretch.vars --- END

	begin
		if resetMemclk='1' then
			-- IP impl.memclkToMclkStretch.asyncrst --- BEGIN
			strbWrlock_to_mclk <= '0';
			strbRdlock_to_mclk <= '0';

			strbWrlock_i := 0;
			strbRdlock_i := 0;
			-- IP impl.memclkToMclkStretch.asyncrst --- END

		elsif rising_edge(memclk) then
			if strbWrlock='1' then
				strbWrlock_to_mclk <= '1';
				strbWrlock_i := 0;
			elsif strbWrlock_i=imax then
				strbWrlock_to_mclk <= '0';
			else
				strbWrlock_i := strbWrlock_i + 1;
			end if;

			if strbRdlock='1' then
				strbRdlock_to_mclk <= '1';
				strbRdlock_i := 0;
			elsif strbRdlock_i=imax then
				strbRdlock_to_mclk <= '0';
			else
				strbRdlock_i := strbRdlock_i + 1;
			end if;

		end if;
	end process;
	-- IP impl.memclkToMclkStretch.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Rtl;
