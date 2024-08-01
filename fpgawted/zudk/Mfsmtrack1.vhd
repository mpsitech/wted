-- file Mfsmtrack1.vhd
-- Mfsmtrack1 fsmtrack_Easy_v1_0 easy model debug controller implementation
-- copyright: (C) 2023 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 30 Jun 2024
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Zudk.all;

entity Mfsmtrack1 is
	port (
		reset: in std_logic;
		mclk: in std_logic;

		hostifRxAXIS_tvalid: in std_logic;
		ackInvTkclksrcSetTkst: in std_logic;

		getInfoTixVState: out std_logic_vector(7 downto 0);
		getInfoCoverage: out std_logic_vector(255 downto 0);

		reqInvSelect: in std_logic;
		ackInvSelect: out std_logic;

		selectTixVCapture: in std_logic_vector(7 downto 0);
		selectStaTixVTrigger: in std_logic_vector(7 downto 0);
		selectStaFallingNotRising: in std_logic_vector(7 downto 0);
		selectStoTixVTrigger: in std_logic_vector(7 downto 0);
		selectStoFallingNotRising: in std_logic_vector(7 downto 0);

		reqInvSet: in std_logic;
		ackInvSet: out std_logic;

		setRng: in std_logic_vector(7 downto 0);
		setTCapt: in std_logic_vector(31 downto 0);

		reqCntbufToHostif: in std_logic;
		ackCntbufToHostif: out std_logic;
		dneCntbufToHostif: in std_logic;
		avllenCntbufToHostif: out std_logic_vector(31 downto 0);

		cntbufToHostifAXIS_tready: in std_logic;
		cntbufToHostifAXIS_tvalid: out std_logic;
		cntbufToHostifAXIS_tdata: out std_logic_vector(63 downto 0);
		cntbufToHostifAXIS_tlast: out std_logic;

		reqFstoccbufToHostif: in std_logic;
		ackFstoccbufToHostif: out std_logic;
		dneFstoccbufToHostif: in std_logic;
		avllenFstoccbufToHostif: out std_logic_vector(31 downto 0);

		fstoccbufToHostifAXIS_tready: in std_logic;
		fstoccbufToHostifAXIS_tvalid: out std_logic;
		fstoccbufToHostifAXIS_tdata: out std_logic_vector(63 downto 0);
		fstoccbufToHostifAXIS_tlast: out std_logic;

		reqSeqbufToHostif: in std_logic;
		ackSeqbufToHostif: out std_logic;
		dneSeqbufToHostif: in std_logic;
		avllenSeqbufToHostif: out std_logic_vector(31 downto 0);

		seqbufToHostifAXIS_tready: in std_logic;
		seqbufToHostifAXIS_tvalid: out std_logic;
		seqbufToHostifAXIS_tdata: out std_logic_vector(63 downto 0);
		seqbufToHostifAXIS_tlast: out std_logic;

		clientStateGetbufB: in std_logic_vector(7 downto 0);
		clientStateSetbufB: in std_logic_vector(7 downto 0);
		tkclksrcStateOp: in std_logic_vector(7 downto 0)
	);
end Mfsmtrack1;

architecture Rtl of Mfsmtrack1 is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Dpbram_size2kB_a32b32 is
		port (
			clkA: in std_logic;

			enA: in std_logic;
			weA: in std_logic_vector(0 downto 0);

			addrA: in std_logic_vector(8 downto 0);
			doutA: out std_logic_vector(31 downto 0);
			dinA: in std_logic_vector(31 downto 0);

			clkB: in std_logic;

			enB: in std_logic;
			weB: in std_logic_vector(0 downto 0);

			addrB: in std_logic_vector(8 downto 0);
			doutB: out std_logic_vector(31 downto 0);
			dinB: in std_logic_vector(31 downto 0)
		);
	end component;

	component Dpbram_size2kB_a32b64 is
		port (
			clkA: in std_logic;

			enA: in std_logic;
			weA: in std_logic_vector(0 downto 0);

			addrA: in std_logic_vector(8 downto 0);
			doutA: out std_logic_vector(31 downto 0);
			dinA: in std_logic_vector(31 downto 0);

			clkB: in std_logic;

			enB: in std_logic;
			weB: in std_logic_vector(0 downto 0);

			addrB: in std_logic_vector(7 downto 0);
			doutB: out std_logic_vector(63 downto 0);
			dinB: in std_logic_vector(63 downto 0)
		);
	end component;

	component Dpbram_size4kB_a32b64 is
		port (
			clkA: in std_logic;

			enA: in std_logic;
			weA: in std_logic_vector(0 downto 0);

			addrA: in std_logic_vector(9 downto 0);
			doutA: out std_logic_vector(31 downto 0);
			dinA: in std_logic_vector(31 downto 0);

			clkB: in std_logic;

			enB: in std_logic;
			weB: in std_logic_vector(0 downto 0);

			addrB: in std_logic_vector(8 downto 0);
			doutB: out std_logic_vector(63 downto 0);
			dinB: in std_logic_vector(63 downto 0)
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	constant wD: natural := 64;
	constant logWD: natural := 3;

	constant sizeSeqbuf: natural := 4096;
	constant logSizeSeqbuf: natural := 12;

	constant tixVCaptureClientGetbufB: std_logic_vector(7 downto 0) := x"01";
	constant tixVCaptureClientSetbufB: std_logic_vector(7 downto 0) := x"02";
	constant tixVCaptureTkclksrcOp: std_logic_vector(7 downto 0) := x"03";

	constant tixVStateIdle: std_logic_vector(7 downto 0) := x"00";
	constant tixVStateArm: std_logic_vector(7 downto 0) := x"01";
	constant tixVStateAcq: std_logic_vector(7 downto 0) := x"02";
	constant tixVStateDone: std_logic_vector(7 downto 0) := x"03";

	constant tixVTriggerVoid: std_logic_vector(7 downto 0) := x"00";
	constant tixVTriggerHostifRxAXIS_tvalid: std_logic_vector(7 downto 0) := x"02";
	constant tixVTriggerAckInvTkclksrcSetTkst: std_logic_vector(7 downto 0) := x"03";

	---- counter buffer B/hostif-facing operation (cntbufB)
	type stateCntbufB_t is (
		stateCntbufBInit,
		stateCntbufBIdle,
		stateCntbufBXferA, stateCntbufBXferB, stateCntbufBXferC,
		stateCntbufBDone,
		stateCntbufBClear
	);
	signal stateCntbufB: stateCntbufB_t := stateCntbufBInit;

	signal cntbufToHostifAXIS_tdata_sig: std_logic_vector(wD-1 downto 0);

	signal enCntbufB_sig: std_logic;

	signal aCntbufB: natural range 0 to 255;

	---- count operation (count)
	type stateCount_t is (
		stateCountInit,
		stateCountIdle,
		stateCountRun,
		stateCountDone,
		stateCountClear,
		stateCountAckClear
	);
	signal stateCount: stateCount_t := stateCountInit;

	signal rdyCount: std_logic;
	signal dneCount: std_logic;

	signal enCntbuf: std_logic;

	signal aCntbuf: natural range 0 to 511;
	signal aCntbuf_vec: std_logic_vector(8 downto 0);

	signal dwrCntbuf: std_logic_vector(31 downto 0);

	signal enCntbufB: std_logic;
	signal enCntbuf_B: std_logic;

	signal aCntbufB_vec: std_logic_vector(8 downto 0);

	---- first occurrence operation (first)
	type stateFirst_t is (
		stateFirstInit,
		stateFirstIdle,
		stateFirstRun,
		stateFirstDone,
		stateFirstClear,
		stateFirstAckClear
	);
	signal stateFirst: stateFirst_t := stateFirstInit;

	signal rdyFirst: std_logic;
	signal dneFirst: std_logic;

	signal enFstoccbuf: std_logic;

	signal aFstoccbuf: natural range 0 to 511;
	signal aFstoccbuf_vec: std_logic_vector(8 downto 0);

	signal dwrFstoccbuf: std_logic_vector(31 downto 0);

	signal coverage: std_logic_vector(255 downto 0);

	---- first occurrence buffer B/hostif-facing operation (fstoccbufB)
	type stateFstoccbufB_t is (
		stateFstoccbufBInit,
		stateFstoccbufBIdle,
		stateFstoccbufBXferA, stateFstoccbufBXferB,
		stateFstoccbufBDone,
		stateFstoccbufBClear
	);
	signal stateFstoccbufB: stateFstoccbufB_t := stateFstoccbufBInit;

	signal enFstoccbufB: std_logic;

	signal aFstoccbufB: natural range 0 to 2048/(wD/8) - 1;
	signal aFstoccbufB_vec: std_logic_vector(11-logWD-1 downto 0);

	---- main operation (op)
	type stateOp_t is (
		stateOpInit,
		stateOpInv,
		stateOpIdle,
		stateOpStart,
		stateOpRun,
		stateOpStop,
		stateOpClear
	);
	signal stateOp: stateOp_t := stateOpInit;

	signal ackInvSelect_sig: std_logic;
	signal ackInvSet_sig: std_logic;

	signal tixVCapture: std_logic_vector(7 downto 0);

	signal staTixVTrigger: std_logic_vector(7 downto 0);
	signal staFallingNotRising: boolean;

	signal stoTixVTrigger: std_logic_vector(7 downto 0);
	signal stoFallingNotRising: boolean;

	signal strbStart: std_logic;
	signal strbStop: std_logic;

	signal tick: std_logic_vector(31 downto 0);

	---- sequence operation (seq)
	type stateSeq_t is (
		stateSeqInit,
		stateSeqIdle,
		stateSeqRun,
		stateSeqDone,
		stateSeqClear,
		stateSeqAckClear
	);
	signal stateSeq: stateSeq_t := stateSeqInit;

	signal rdySeq: std_logic;
	signal dneSeq: std_logic;

	signal enSeqbuf: std_logic;

	signal aSeqbuf: natural range 0 to sizeSeqbuf/4-1;
	signal aSeqbuf_vec: std_logic_vector(logSizeSeqbuf-2-1 downto 0);

	signal dwrSeqbuf: std_logic_vector(31 downto 0);

	---- sequence buffer B/hostif-facing operation (seqbufB)
	type stateSeqbufB_t is (
		stateSeqbufBInit,
		stateSeqbufBIdle,
		stateSeqbufBXferA, stateSeqbufBXferB,
		stateSeqbufBDone,
		stateSeqbufBClear
	);
	signal stateSeqbufB: stateSeqbufB_t := stateSeqbufBInit;

	signal enSeqbufB: std_logic;

	signal aSeqbufB: natural range 0 to sizeSeqbuf/(wD/8)-1;
	signal aSeqbufB_vec: std_logic_vector(logSizeSeqbuf-logWD-1 downto 0);

	---- sampling operation (sample)
	signal state: std_logic_vector(7 downto 0);

	signal start: std_logic;
	signal stop: std_logic;

	---- myCntbuf
	signal drdCntbufB: std_logic_vector(31 downto 0);

	---- handshake

	-- cntbufB to count
	signal reqCntbufBToCountClear: std_logic;
	signal ackCntbufBToCountClear: std_logic;

	-- fstoccbufB to first
	signal reqFstoccbufBToFirstClear: std_logic;
	signal ackFstoccbufBToFirstClear: std_logic;

	-- op to (many)
	signal reqOpClear: std_logic;

	-- seqbufB to seq
	signal reqSeqbufBToSeqClear: std_logic;
	signal ackSeqbufBToSeqClear: std_logic;

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myCntbuf : Dpbram_size2kB_a32b32
		port map (
			clkA => mclk,

			enA => enCntbuf,
			weA => (others => '1'),

			addrA => aCntbuf_vec,
			doutA => open,
			dinA => dwrCntbuf,

			clkB => mclk,

			enB => enCntbufB,
			weB => (others => '0'),

			addrB => aCntbufB_vec,
			doutB => drdCntbufB,
			dinB => (others => '0')
		);

	myFstoccbuf : Dpbram_size2kB_a32b64
		port map (
			clkA => mclk,

			enA => enFstoccbuf,
			weA => (others => '1'),

			addrA => aFstoccbuf_vec,
			doutA => open,
			dinA => dwrFstoccbuf,

			clkB => mclk,

			enB => enFstoccbufB,
			weB => (others => '0'),

			addrB => aFstoccbufB_vec,
			doutB => fstoccbufToHostifAXIS_tdata,
			dinB => (others => '0')
		);

	mySeqbuf : Dpbram_size4kB_a32b64
		port map (
			clkA => mclk,

			enA => enSeqbuf,
			weA => (others => '1'),

			addrA => aSeqbuf_vec,
			doutA => open,
			dinA => dwrSeqbuf,

			clkB => mclk,

			enB => enSeqbufB,
			weB => (others => '0'),

			addrB => aSeqbufB_vec,
			doutB => seqbufToHostifAXIS_tdata,
			dinB => (others => '0')
		);

	------------------------------------------------------------------------
	-- implementation: counter buffer B/hostif-facing operation (cntbufB)
	------------------------------------------------------------------------

	ackCntbufToHostif <= '1' when stateCntbufB=stateCntbufBXferA or stateCntbufB=stateCntbufBXferB or stateCntbufB=stateCntbufBXferC or stateCntbufB=stateCntbufBDone else '0';

	avllenCntbufToHostif <= std_logic_vector(to_unsigned(1024, 32)) when dneCount='1'
				else (others => '0');

	cntbufToHostifAXIS_tvalid <= '1' when stateCntbufB=stateCntbufBXferC else '0';

	cntbufToHostifAXIS_tdata <= cntbufToHostifAXIS_tdata_sig;

	cntbufToHostifAXIS_tlast <= '1' when stateCntbufB=stateCntbufBXferC and aCntbufB=(1024/(32/8))-1 else '0';

	enCntbufB_sig <= '1' when stateCntbufB=stateCntbufBXferA else '0';

	reqCntbufBToCountClear <= '1' when stateCntbufB=stateCntbufBClear else '0';

	process (reset, mclk, stateCntbufB)
		variable i: natural range 0 to 4; -- for up-gearing 0 to wD/32 (max. 4)
		variable j: natural range 0 to 4; -- for down-gearing 0 to 32/wD (max. 4)

		constant waitcdc: boolean := false;

		constant kmax: natural := 1;
		variable k: natural range 0 to kmax; -- for CDC latency

	begin
		if reset='1' then
			stateCntbufB <= stateCntbufBInit;
			aCntbufB <= 0;
			cntbufToHostifAXIS_tdata_sig <= (others => '0');

			i := 0;
			k := 0;

		elsif rising_edge(mclk) then
			if stateCntbufB=stateCntbufBInit then
				aCntbufB <= 0;
				cntbufToHostifAXIS_tdata_sig <= (others => '0');

				i := 0;
				k := 0;

				stateCntbufB <= stateCntbufBIdle;

			elsif stateCntbufB=stateCntbufBIdle then
				if reqCntbufToHostif='1' then
					i := 0;
					k := 0;

					stateCntbufB <= stateCntbufBXferA;
				end if;

			elsif stateCntbufB=stateCntbufBXferA then -- enCntbufB_sig='1'
				if not waitcdc then
					stateCntbufB <= stateCntbufBXferB;

				else
					k := k + 1;

					if k=kmax then
						stateCntbufB <= stateCntbufBXferB;
					end if;
				end if;

			elsif stateCntbufB=stateCntbufBXferB then
				if wD>=32 then
					-- up-gearing: one AXIS xfer requires multiple memory accesses
					cntbufToHostifAXIS_tdata_sig((i+1)*32-1 downto (i*32)) <= drdCntbufB;

					i := i + 1;

					if i=wD/32 then
						stateCntbufB <= stateCntbufBXferC;

					else
						aCntbufB <= aCntbufB + 1;

						k := 0;

						stateCntbufB <= stateCntbufBXferA;
					end if;

				else
					-- down-gearing: one memory access can support multiple AXIS xfer's
					cntbufToHostifAXIS_tdata_sig <= drdCntbufB((32/wD-i)*wD-1 downto (wD/32-i-1)*wD);

					i := i + 1;

					stateCntbufB <= stateCntbufBXferC;
				end if;

			elsif stateCntbufB=stateCntbufBXferC then -- cntbufToHostifAXIS_tvalid='1'
				if cntbufToHostifAXIS_tready='1' then
					if wD>=32 then
						if aCntbufB=(1024/(32/8))-1 then
							stateCntbufB <= stateCntbufBDone;

						else
							aCntbufB <= aCntbufB + 1;

							i := 0;
							k := 0;

							stateCntbufB <= stateCntbufBXferA;
						end if;

					else
						if i=32/wD then
							if aCntbufB=(1024/(32/8))-1 then
								stateCntbufB <= stateCntbufBDone;

							else
								aCntbufB <= aCntbufB + 1;

								i := 0;
								k := 0;

								stateCntbufB <= stateCntbufBXferA;
							end if;
						
						else
							stateCntbufB <= stateCntbufBXferB;
						end if;
					end if;

				elsif reqCntbufToHostif='0' then
					stateCntbufB <= stateCntbufBInit;
				end if;

			elsif stateCntbufB=stateCntbufBDone then
				if dneCntbufToHostif='1' then
					stateCntbufB <= stateCntbufBClear;

				elsif reqCntbufToHostif='0' then
					stateCntbufB <= stateCntbufBInit;
				end if;

			elsif stateCntbufB=stateCntbufBClear then -- reqCntbufBToCountClear='1'
				if reqCntbufToHostif='0' and ackCntbufBToCountClear='1' then
					stateCntbufB <= stateCntbufBInit;
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: count operation (count)
	------------------------------------------------------------------------

	rdyCount <= '1' when stateCount=stateCountIdle else '0';
	dneCount <= '1' when stateCount=stateCountDone else '0';

	enCntbuf <= '1' when stateCount=stateCountRun else '0';
	aCntbuf_vec <= std_logic_vector(to_unsigned(aCntbuf, 9));

	enCntbufB <= '1' when stateCount=stateCountRun else enCntbufB_sig;
	aCntbufB_vec <= '0' & state when stateCount=stateCountRun else std_logic_vector(to_unsigned(aCntbufB, 9));

	ackCntbufBToCountClear <= '1' when stateCount=stateCountAckClear else '0';

	process (reset, mclk, stateCount)
		variable statem1: std_logic_vector(7 downto 0);

		variable cnt: std_logic_vector(31 downto 0);

	begin
		if reset='1' then
			stateCount <= stateCountInit;
			aCntbuf <= 0;
			dwrCntbuf <= (others => '0');

			statem1 := (others => '0');
			cnt := (others => '0');

		elsif rising_edge(mclk) then
			if stateCount=stateCountInit then
				aCntbuf <= 0;
				dwrCntbuf <= (others => '0');

				statem1 := (others => '1');
				cnt := (others => '0');

				stateCount <= stateCountIdle;

			elsif stateCount=stateCountIdle then
				if strbStart='1' then
					stateCount <= stateCountRun;
				end if;

			elsif stateCount=stateCountRun then
				if state=statem1 then
					cnt := std_logic_vector(unsigned(cnt) + 1);
				else
					cnt := std_logic_vector(unsigned(drdCntbufB) + 1);
				end if;

				aCntbuf <= to_integer(unsigned(state));
				dwrCntbuf <= cnt;

				statem1 := state;

				if strbStop='1' or cnt=x"FFFFFFFF" then
					stateCount <= stateCountDone;
				end if;

			elsif stateCount=stateCountDone then
				if reqOpClear='1' or reqCntbufBToCountClear='1' then
					aCntbuf <= 0;
					dwrCntbuf <= (others => '0');

					stateCount <= stateCountClear;
				end if;

			elsif stateCount=stateCountClear then
				if aCntbuf=511 then
					if reqCntbufBToCountClear='1' then
						stateCount <= stateCountAckClear;
					else
						stateCount <= stateCountInit;
					end if;

				else
					aCntbuf <= aCntbuf + 1;
				end if; 

			elsif stateCount=stateCountAckClear then
				if reqCntbufBToCountClear='0' then
					stateCount <= stateCountInit;
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: first occurrence operation (first)
	------------------------------------------------------------------------

	rdyFirst <= '1' when stateFirst=stateFirstIdle else '0';
	dneFirst <= '1' when stateFirst=stateFirstDone else '0';

	enFstoccbuf <= '1' when (stateFirst=stateFirstRun and coverage(to_integer(unsigned(state)))='0') or stateFirst=stateFirstClear else '0';

	aFstoccbuf_vec <= '0' & state when stateFirst=stateFirstRun
				else std_logic_vector(to_unsigned(aFstoccbuf, 9));

	dwrFstoccbuf <= tick when stateFirst=stateFirstRun else (others => '1');

	ackFstoccbufBToFirstClear <= '1' when stateFirst=stateFirstAckClear else '0';

	process (reset, mclk, stateFirst)

	begin
		if reset='1' then
			stateFirst <= stateFirstInit;
			aFstoccbuf <= 0;
			coverage <= (others => '0');

		elsif rising_edge(mclk) then
			if stateFirst=stateFirstInit then
				aFstoccbuf <= 0;
				coverage <= (others => '0');

				stateFirst <= stateFirstIdle;

			elsif stateFirst=stateFirstIdle then
				if strbStart='1' then
					stateFirst <= stateFirstRun;
				end if;

			elsif stateFirst=stateFirstRun then
				if strbStop='1' then
					stateFirst <= stateFirstDone;

				else
					coverage(to_integer(unsigned(state))) <= '1';
				end if;

			elsif stateFirst=stateFirstDone then
				if reqOpClear='1' or reqFstoccbufBToFirstClear='1' then
					aFstoccbuf <= 0;

					stateFirst <= stateFirstClear;
				end if;

			elsif stateFirst=stateFirstClear then
				if aFstoccbuf=511 then
					if reqFstoccbufBToFirstClear='1' then
						stateFirst <= stateFirstAckClear;
					else
						stateFirst <= stateFirstInit;
					end if;

				else
					aFstoccbuf <= aFstoccbuf + 1;
				end if; 

			elsif stateFirst=stateFirstAckClear then
				if reqFstoccbufBToFirstClear='0' then
					stateFirst <= stateFirstInit;
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: first occurrence buffer B/hostif-facing operation (fstoccbufB)
	------------------------------------------------------------------------

	ackFstoccbufToHostif <= '1' when stateFstoccbufB=stateFstoccbufBXferA or stateFstoccbufB=stateFstoccbufBXferB or stateFstoccbufB=stateFstoccbufBDone else '0';

	avllenFstoccbufToHostif <= std_logic_vector(to_unsigned(1024, 32)) when dneFirst='1'
				else (others => '0');

	fstoccbufToHostifAXIS_tvalid <= '1' when stateFstoccbufB=stateFstoccbufBXferB else '0';

	fstoccbufToHostifAXIS_tlast <= '1' when stateFstoccbufB=stateFstoccbufBXferB and aFstoccbufB=(1024/(wD/8))-1 else '0';

	enFstoccbufB <= '1' when stateFstoccbufB=stateFstoccbufBXferA else '0';

	aFstoccbufB_vec <= std_logic_vector(to_unsigned(aFstoccbufB, 11-logWD));

	reqFstoccbufBToFirstClear <= '1' when stateFstoccbufB=stateFstoccbufBClear else '0';

	process (reset, mclk, stateFstoccbufB)

	begin
		if reset='1' then
			stateFstoccbufB <= stateFstoccbufBInit;
			aFstoccbufB <= 0;

		elsif rising_edge(mclk) then
			if stateFstoccbufB=stateFstoccbufBInit then
				aFstoccbufB <= 0;

				stateFstoccbufB <= stateFstoccbufBIdle;

			elsif stateFstoccbufB=stateFstoccbufBIdle then
				if reqFstoccbufToHostif='1' then
					stateFstoccbufB <= stateFstoccbufBXferA;
				end if;

			elsif stateFstoccbufB=stateFstoccbufBXferA then -- enFstoccbufB='1'
				stateFstoccbufB <= stateFstoccbufBXferB;
				
			elsif stateFstoccbufB=stateFstoccbufBXferB then -- fstoccbufToHostifAXIS_tvalid='1'
				if fstoccbufToHostifAXIS_tready='1' then
					if aFstoccbufB=(1024/(wD/8))-1 then
						stateFstoccbufB <= stateFstoccbufBDone;

					else
						aFstoccbufB <= aFstoccbufB + 1;

						stateFstoccbufB <= stateFstoccbufBXferA;
					end if;

				elsif reqFstoccbufToHostif='0' then
					stateFstoccbufB <= stateFstoccbufBInit;
				end if;

			elsif stateFstoccbufB=stateFstoccbufBDone then
				if dneFstoccbufToHostif='1' then
					stateFstoccbufB <= stateFstoccbufBClear;

				elsif reqFstoccbufToHostif='0' then
					stateFstoccbufB <= stateFstoccbufBInit;
				end if ;

			elsif stateFstoccbufB=stateFstoccbufBClear then -- reqFstoccbufBToFirstClear='1'
				if reqFstoccbufToHostif='0' and ackFstoccbufBToFirstClear='1' then
					stateFstoccbufB <= stateFstoccbufBInit;
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	ackInvSelect <= ackInvSelect_sig;
	ackInvSet <= ackInvSet_sig;

	getInfoTixVState <= tixVStateArm when stateOp=stateOpIdle
				else tixVStateAcq when stateOp=stateOpRun
				else tixVStateDone when stateOp=stateOpStop
				else tixVStateIdle;
	getInfoCoverage <= coverage;

	strbStart <= '1' when stateOp=stateOpStart else '0';

	reqOpClear <= '1' when stateOp=stateOpClear else '0';

	process (reset, mclk, stateOp)
		variable rng: boolean;
		variable restart: boolean;

		variable TCapt: std_logic_vector(31 downto 0);

		variable strb_last: std_logic;

	begin
		if reset='1' then
			stateOp <= stateOpInit;
			ackInvSelect_sig <= '0';
			ackInvSet_sig <= '0';
			tixVCapture <= x"01";
			staTixVTrigger <= tixVTriggerVoid;
			staFallingNotRising <= false;
			stoTixVTrigger <= tixVTriggerVoid;
			stoFallingNotRising <= false;
			strbStop <= '0';
			tick <= (others => '0');

			rng := false;
			restart := false;
			TCapt := (others => '0');
			strb_last := '0';

		elsif rising_edge(mclk) then
			if stateOp=stateOpInit or (stateOp/=stateOpInv and (reqInvSelect='1' or reqInvSet='1'))  then
				strbStop <= '0';
				tick <= (others => '0');

				if reqInvSelect='1' then
					tixVCapture <= selectTixVCapture;
					staTixVTrigger <= selectStaTixVTrigger;
					staFallingNotRising <= (selectStaFallingNotRising=tru8);
					stoTixVTrigger <= selectStoTixVTrigger;
					stoFallingNotRising <= (selectStoFallingNotRising=tru8);

					ackInvSelect_sig <= '1';
					stateOp <= stateOpInv;

				elsif reqInvSet='1' then
					if setRng=tru8 then
						rng := true;
					else
						rng := false;
					end if;
					TCapt := setTCapt;

					ackInvSet_sig <= '1';
					stateOp <= stateOpInv;

				else
					restart := false;

					if rng then
						strb_last := start;

						stateOp <= stateOpIdle;

					else
						tick <= (others => '0');

						stateOp <= stateOpInit;
					end if;
				end if;

			elsif stateOp=stateOpInv then
				if (reqInvSet='0' and ackInvSet_sig='1') or (reqInvSelect='0' and ackInvSelect_sig='1') then
					ackInvSet_sig <= '0';
					ackInvSelect_sig <= '0';

					strbStop <= '1';

					restart := true;

					stateOp <= stateOpStop;
				end if;

			elsif stateOp=stateOpIdle then
				if staTixVTrigger=tixVTriggerVoid or (not staFallingNotRising and strb_last='0' and start='1') or (staFallingNotRising and strb_last='1' and start='0') then
					stateOp <= stateOpStart;
				else
					strb_last := start;
				end if;

			elsif stateOp=stateOpStart then -- strbStart='1'
				strb_last := stop;

				stateOp <= stateOpRun;

			elsif stateOp=stateOpRun then
				tick <= std_logic_vector(unsigned(tick) + 1);

				if (stoTixVTrigger=tixVTriggerVoid and tick>=TCapt) or tick=x"FFFFFFF0" or (not staFallingNotRising and strb_last='0' and stop='1') or (staFallingNotRising and strb_last='1' and stop='0') or dneCount='1' or dneSeq='1' then
					strbStop <= '1';

					stateOp <= stateOpStop;

				else
					strb_last := stop;
				end if;

			elsif stateOp=stateOpStop then
				strbStop <= '0';

				tick <= std_logic_vector(unsigned(tick) + 1);

				if restart then
					stateOp <= stateOpClear;

				else
					if rdyCount='1' and rdyFirst='1' and rdySeq='1' then
						stateOp <= stateOpInit;
					end if;
				end if;

			elsif stateOp=stateOpClear then -- reqOpClear='1'
				if rdyCount='1' and rdyFirst='1' and rdySeq='1' then
					stateOp <= stateOpInit;
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: sampling operation (sample)
	------------------------------------------------------------------------

	process (reset, mclk)

	begin
		if reset='1' then
			state <= (others => '1');
			start <= '0';
			stop <= '0';

		elsif rising_edge(mclk) then
			case tixVCapture is
				when tixVCaptureClientGetbufB =>
					state <= clientStateGetbufB;
				when tixVCaptureClientSetbufB =>
					state <= clientStateSetbufB;
				when tixVCaptureTkclksrcOp =>
					state <= tkclksrcStateOp;
				when others =>
					state <= (others => '1');
			end case;

			case staTixVTrigger is
				when tixVTriggerHostifRxAXIS_tvalid =>
					start <= hostifRxAXIS_tvalid;
				when tixVTriggerAckInvTkclksrcSetTkst =>
					start <= ackInvTkclksrcSetTkst;
				when others =>
					start <= '0';
			end case;

			case stoTixVTrigger is
				when tixVTriggerHostifRxAXIS_tvalid =>
					stop <= hostifRxAXIS_tvalid;
				when tixVTriggerAckInvTkclksrcSetTkst =>
					stop <= ackInvTkclksrcSetTkst;
				when others =>
					stop <= '0';
			end case;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: sequence operation (seq)
	------------------------------------------------------------------------

	rdySeq <= '1' when stateSeq=stateSeqIdle else '0';
	dneSeq <= '1' when stateSeq=stateSeqDone else '0';

	aSeqbuf_vec <= std_logic_vector(to_unsigned(aSeqbuf, logSizeSeqbuf-2));

	ackSeqbufBToSeqClear <= '1' when stateSeq=stateSeqAckClear else '0';

	process (reset, mclk, stateSeq)
		variable quad: std_logic_vector(31 downto 0);

		variable i: natural range 0 to 3;

		variable first: boolean;
		variable stop_lcl: boolean;

		variable burstState: std_logic_vector(7 downto 0);
		variable burstCnt: natural range 0 to 65535;

	begin
		if reset='1' then
			stateSeq <= stateSeqInit;
			enSeqbuf <= '0';
			aSeqbuf <= 0;
			dwrSeqbuf <= (others => '0');

			quad := (others => '0');
			i := 0;
			first := true;
			stop_lcl := false;
			burstState := (others => '1');
			burstCnt := 0;

		elsif rising_edge(mclk) then
			if stateSeq=stateSeqInit then
				enSeqbuf <= '0';
				aSeqbuf <= 0;
				dwrSeqbuf <= (others => '0');

				quad := (others => '0');
				i := 0;
				first := true;
				stop_lcl := false;
				burstState := (others => '1');
				burstCnt := 0;

				stateSeq <= stateSeqIdle;

			elsif stateSeq=stateSeqIdle then -- rdySeq='1'
				if strbStart='1' then
					stateSeq <= stateSeqRun;
				end if;

			elsif stateSeq=stateSeqRun then
				if strbStop='1' then
					stop_lcl := true;
				end if;

				quad((i+1)*8-1 downto i*8) := state;

				if i=3 then
					if quad(23 downto 16)=state and quad(15 downto 8)=state and quad(7 downto 0)=state then
						if state/=burstState or burstCnt=65535 then
							if not first then
								aSeqbuf <= aSeqbuf + 1;
							end if;

							burstCnt := 0;
						end if;

						burstState := state;
						burstCnt := burstCnt + 1;

						dwrSeqbuf <= x"FF" & burstState & std_logic_vector(to_unsigned(burstCnt, 16));

					else
						burstState := (others => '1');
						burstCnt := 0;

						if not first then
							aSeqbuf <= aSeqbuf + 1;
						end if;

						dwrSeqbuf <= quad;
					end if;

					enSeqbuf <= '1';

					i := 0;
					first := false;

					stateSeq <= stateSeqRun;

				else
					enSeqbuf <= '0';

					if stop_lcl or aSeqbuf=sizeSeqbuf/4-1 then
						stateSeq <= stateSeqDone;

					else
						i := i + 1;

						stateSeq <= stateSeqRun;
					end if;
				end if;

			elsif stateSeq=stateSeqDone then -- dneSeq='1'
				if reqOpClear='1' or reqSeqbufBToSeqClear='1' then
					aSeqbuf <= 0;
					dwrSeqbuf <= (others => '1');

					stateSeq <= stateSeqClear;
				end if;

			elsif stateSeq=stateSeqClear then
				if aSeqbuf=sizeSeqbuf/4-1 then
					if reqSeqbufBToSeqClear='1' then
						stateSeq <= stateSeqAckClear;
					else
						stateSeq <= stateSeqInit;
					end if;

				else
					aSeqbuf <= aSeqbuf + 1;
				end if;

			elsif stateSeq=stateSeqAckClear then -- ackSeqbufBToSeqClear='1'
				if reqSeqbufBToSeqClear='0' then
					stateSeq <= stateSeqInit;
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: sequence buffer B/hostif-facing operation (seqbufB)
	------------------------------------------------------------------------

	ackSeqbufToHostif <= '1' when stateSeqbufB=stateSeqbufBXferA or stateSeqbufB=stateSeqbufBXferB or stateSeqbufB=stateSeqbufBDone else '0';

	avllenSeqbufToHostif <= std_logic_vector(to_unsigned(sizeSeqbuf, 32)) when dneSeq='1'
				else (others => '0');

	seqbufToHostifAXIS_tvalid <= '1' when stateSeqbufB=stateSeqbufBXferB else '0';

	seqbufToHostifAXIS_tlast <= '1' when stateSeqbufB=stateSeqbufBXferB and aSeqbufB=(sizeSeqbuf/(wD/8))-1 else '0';

	enSeqbufB <= '1' when stateSeqbufB=stateSeqbufBXferA else '0';

	aSeqbufB_vec <= std_logic_vector(to_unsigned(aSeqbufB, logSizeSeqbuf-logWD));

	reqSeqbufBToSeqClear <= '1' when stateSeqbufB=stateSeqbufBClear else '0';

	process (reset, mclk, stateSeqbufB)

	begin
		if reset='1' then
			stateSeqbufB <= stateSeqbufBInit;
			aSeqbufB <= 0;

		elsif rising_edge(mclk) then
			if stateSeqbufB=stateSeqbufBInit then
				aSeqbufB <= 0;

				stateSeqbufB <= stateSeqbufBIdle;

			elsif stateSeqbufB=stateSeqbufBIdle then
				if reqSeqbufToHostif='1' then
					stateSeqbufB <= stateSeqbufBXferA;
				end if;

			elsif stateSeqbufB=stateSeqbufBXferA then -- enSeqbufB='1'
				stateSeqbufB <= stateSeqbufBXferB;
				
			elsif stateSeqbufB=stateSeqbufBXferB then -- seqbufToHostifAXIS_tvalid='1'
				if seqbufToHostifAXIS_tready='1' then
					if aSeqbufB=(sizeSeqbuf/(wD/8))-1 then
						stateSeqbufB <= stateSeqbufBDone;

					else
						aSeqbufB <= aSeqbufB + 1;

						stateSeqbufB <= stateSeqbufBXferA;
					end if;

				elsif reqSeqbufToHostif='0' then
					stateSeqbufB <= stateSeqbufBInit;
				end if;

			elsif stateSeqbufB=stateSeqbufBDone then
				if dneSeqbufToHostif='1' then
					stateSeqbufB <= stateSeqbufBClear;

				elsif reqSeqbufToHostif='0' then
					stateSeqbufB <= stateSeqbufBInit;
				end if ;

			elsif stateSeqbufB=stateSeqbufBClear then -- reqSeqbufBToSeqClear='1'
				if reqSeqbufToHostif='0' and ackSeqbufBToSeqClear='1' then
					stateSeqbufB <= stateSeqbufBInit;
				end if;
			end if;
		end if;
	end process;

end Rtl;
