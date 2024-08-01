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
use work.Zudk.all;

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
		rdAAXI_rdata: out std_logic_vector(127 downto 0);
		rdAAXI_rlast: out std_logic;
		rdAAXI_rready: in std_logic;
		rdAAXI_rresp: out std_logic_vector(1 downto 0);
		rdAAXI_rvalid: out std_logic;

		reqWrA: in std_logic;
		ackWrA: out std_logic;

		wrAAXI_awaddr: in std_logic_vector(19 downto 0);
		wrAAXI_awready: out std_logic;
		wrAAXI_awvalid: in std_logic;
		wrAAXI_wdata: in std_logic_vector(127 downto 0);
		wrAAXI_wlast: in std_logic;
		wrAAXI_wready: out std_logic;
		wrAAXI_wvalid: in std_logic;

		reqWrB: in std_logic;
		ackWrB: out std_logic;

		wrBAXI_awaddr: in std_logic_vector(19 downto 0);
		wrBAXI_awready: out std_logic;
		wrBAXI_awvalid: in std_logic;
		wrBAXI_wdata: in std_logic_vector(127 downto 0);
		wrBAXI_wlast: in std_logic;
		wrBAXI_wready: out std_logic;
		wrBAXI_wvalid: in std_logic;

		ddrAXI_arid: out std_logic_vector(5 downto 0);
		ddrAXI_araddr: out std_logic_vector(39 downto 0);
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
		ddrAXI_rdata: in std_logic_vector(127 downto 0);
		ddrAXI_rlast: in std_logic;
		ddrAXI_rready: out std_logic;
		ddrAXI_rresp: in std_logic_vector(1 downto 0);
		ddrAXI_rvalid: in std_logic;

		ddrAXI_awid: out std_logic_vector(5 downto 0);
		ddrAXI_awaddr: out std_logic_vector(39 downto 0);
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

		ddrAXI_wdata: out std_logic_vector(127 downto 0);
		ddrAXI_wlast: out std_logic;
		ddrAXI_wready: in std_logic;
		ddrAXI_wstrb: out std_logic_vector(15 downto 0);
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
	-- implementation: read access negotiation (read)
	------------------------------------------------------------------------

	ddrAXI_arid <= (others => '0');

	ddrAXI_araddr <= "000000000111" & rdAAXI_araddr & "00000000" when rdmutex=mutexA
				else (others => '0');

	ddrAXI_arburst <= "01"; -- INCR burst type
	ddrAXI_arcache <= "0000"; -- device non-bufferable memory type

	ddrAXI_arlen <= ddrAXI_arlen_sig;
	ddrAXI_arlen_sig <= x"0F"; -- burst length of 16

	ddrAXI_arlock <= "0"; -- normal access as opposed to exclusive access
	ddrAXI_arprot <= "010"; -- unprivileged, non-secure data access
	ddrAXI_arqos <= "1101"; -- not participating in QoS scheme

	rdAAXI_arready <= ddrAXI_arready when rdmutex=mutexA else '0';

	ddrAXI_arregion <= "0000"; -- region feature not used
	ddrAXI_arsize <= "100"; -- 128-bit wide transfers

	ddrAXI_arvalid <= rdAAXI_arvalid when rdmutex=mutexA
				else '0';

	rdAAXI_rdata <= ddrAXI_rdata;

	rdAAXI_rlast <= ddrAXI_rlast;

	ddrAXI_rready <= rdAAXI_rready when rdmutex=mutexA
				else '0';

	rdAAXI_rresp <= ddrAXI_rresp;

	rdAAXI_rvalid <= ddrAXI_rvalid when rdmutex=mutexA else '0';

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
				if reqRdA='1' then
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
	-- implementation: write access negotiation (write)
	------------------------------------------------------------------------

	ddrAXI_awid <= std_logic_vector(to_unsigned(ixWrid, 6));

	ddrAXI_awaddr <= "000000000111" & wrAAXI_awaddr & "00000000" when wrmutex=mutexA
				else "000000000111" & wrBAXI_awaddr & "00000000" when wrmutex=mutexB
				else (others => '0');

	ddrAXI_awburst <= "01"; -- INCR burst type
	ddrAXI_awcache <= "0000"; -- device non-bufferable memory type

	ddrAXI_awlen <= ddrAXI_awlen_sig;
	ddrAXI_awlen_sig <= x"0F"; -- burst length of 16

	ddrAXI_awlock <= "0"; -- normal access as opposed to exclusive access
	ddrAXI_awprot <= "010"; -- unprivileged, non-secure data access
	ddrAXI_awqos <= "1101"; -- not participating in QoS scheme

	wrAAXI_awready <= ddrAXI_awready when wrmutex=mutexA else '0';
	wrBAXI_awready <= ddrAXI_awready when wrmutex=mutexB else '0';

	ddrAXI_awregion <= "0000"; -- region feature not used
	ddrAXI_awsize <= "100"; -- 128-bit wide transfers

	ddrAXI_awvalid <= wrAAXI_awvalid when wrmutex=mutexA
				else wrBAXI_awvalid when wrmutex=mutexB
				else '0';

	ddrAXI_wdata <= wrAAXI_wdata when wrmutex=mutexA
				else wrBAXI_wdata when wrmutex=mutexB
				else (others => '0');

	ddrAXI_wlast <= ddrAXI_wlast_sig;
	ddrAXI_wlast_sig <= wrAAXI_wlast when wrmutex=mutexA
				else wrBAXI_wlast when wrmutex=mutexB
				else '1';

	wrAAXI_wready <= ddrAXI_wready when wrmutex=mutexA else '0';
	wrBAXI_wready <= ddrAXI_wready when wrmutex=mutexB else '0';

	ddrAXI_wstrb <= (others => '1'); -- all bytes for each transfer

	ddrAXI_wvalid <= ddrAXI_wvalid_sig;
	ddrAXI_wvalid_sig <= wrAAXI_wvalid when wrmutex=mutexA
				else wrBAXI_wvalid when wrmutex=mutexB
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
				if (reqWrA='1' and ((abWr=0 and reqWrB='0') or abWr=1) and wrid(ixWrid)='0') then
					abWr <= 0;
					wrmutex <= mutexA;

					strbWrlock <= '1';

					wrid(ixWrid) <= '1';

					stateWrite <= stateWriteLocked;

				elsif (reqWrB='1' and ((abWr=1 and reqWrA='0') or abWr=0) and wrid(ixWrid)='0') then
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
