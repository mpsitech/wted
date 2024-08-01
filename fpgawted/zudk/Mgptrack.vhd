-- file Mgptrack.vhd
-- Mgptrack gptrack_Easy_v1_0 easy model debug controller implementation
-- copyright: (C) 2023 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 5 Jul 2024
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Zudk.all;

entity Mgptrack is
	port (
		reset: in std_logic;
		mclk: in std_logic;

		hostifRxAXIS_tvalid: in std_logic;
		ackInvTkclksrcSetTkst: in std_logic;

		getInfoTixVState: out std_logic_vector(7 downto 0);

		reqInvSelect: in std_logic;
		ackInvSelect: out std_logic;

		selectStaTixVTrigger: in std_logic_vector(7 downto 0);
		selectStaFallingNotRising: in std_logic_vector(7 downto 0);
		selectStoTixVTrigger: in std_logic_vector(7 downto 0);
		selectStoFallingNotRising: in std_logic_vector(7 downto 0);

		reqInvSet: in std_logic;
		ackInvSet: out std_logic;

		setRng: in std_logic_vector(7 downto 0);
		setTCapt: in std_logic_vector(31 downto 0);

		reqSeqbufToHostif: in std_logic;
		ackSeqbufToHostif: out std_logic;
		dneSeqbufToHostif: in std_logic;
		avllenSeqbufToHostif: out std_logic_vector(31 downto 0);

		seqbufToHostifAXIS_tready: in std_logic;
		seqbufToHostifAXIS_tvalid: out std_logic;
		seqbufToHostifAXIS_tdata: out std_logic_vector(63 downto 0);
		seqbufToHostifAXIS_tlast: out std_logic;

		tkclk: in std_logic;
		rgb0_r: in std_logic;
		rgb0_g: in std_logic;
		rgb0_b: in std_logic;
		btn0: in std_logic;
		btn0_sig: in std_logic;
		tkclksrcGetTkstTkst: in std_logic_vector(7 downto 0)
	);
end Mgptrack;

architecture Rtl of Mgptrack is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

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

	constant tixVCaptureTkclk: std_logic_vector(7 downto 0) := x"00";
	constant tixVCaptureRgb0_r: std_logic_vector(7 downto 0) := x"01";
	constant tixVCaptureRgb0_g: std_logic_vector(7 downto 0) := x"02";
	constant tixVCaptureRgb0_b: std_logic_vector(7 downto 0) := x"03";
	constant tixVCaptureBtn0: std_logic_vector(7 downto 0) := x"04";
	constant tixVCaptureBtn0_sig: std_logic_vector(7 downto 0) := x"05";
	constant tixVCaptureTkclksrcGetTkstTkst0: std_logic_vector(7 downto 0) := x"06";
	constant tixVCaptureTkclksrcGetTkstTkst1: std_logic_vector(7 downto 0) := x"07";
	constant tixVCaptureTkclksrcGetTkstTkst2: std_logic_vector(7 downto 0) := x"08";
	constant tixVCaptureTkclksrcGetTkstTkst3: std_logic_vector(7 downto 0) := x"09";
	constant tixVCaptureTkclksrcGetTkstTkst4: std_logic_vector(7 downto 0) := x"0A";
	constant tixVCaptureTkclksrcGetTkstTkst5: std_logic_vector(7 downto 0) := x"0B";
	constant tixVCaptureTkclksrcGetTkstTkst6: std_logic_vector(7 downto 0) := x"0C";
	constant tixVCaptureTkclksrcGetTkstTkst7: std_logic_vector(7 downto 0) := x"0D";

	constant tixVStateIdle: std_logic_vector(7 downto 0) := x"00";
	constant tixVStateArm: std_logic_vector(7 downto 0) := x"01";
	constant tixVStateAcq: std_logic_vector(7 downto 0) := x"02";
	constant tixVStateDone: std_logic_vector(7 downto 0) := x"03";

	constant tixVTriggerVoid: std_logic_vector(7 downto 0) := x"00";
	constant tixVTriggerBtn0: std_logic_vector(7 downto 0) := x"02";
	constant tixVTriggerHostifRxAXIS_tvalid: std_logic_vector(7 downto 0) := x"03";
	constant tixVTriggerAckInvTkclksrcSetTkst: std_logic_vector(7 downto 0) := x"04";

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
	signal capt: std_logic_vector(14 downto 0);

	signal start: std_logic;
	signal stop: std_logic;

	---- handshake

	-- op to seq
	signal reqOpToSeqClear: std_logic;

	-- seqbufB to seq
	signal reqSeqbufBToSeqClear: std_logic;
	signal ackSeqbufBToSeqClear: std_logic;

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

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
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	ackInvSelect <= ackInvSelect_sig;
	ackInvSet <= ackInvSet_sig;

	getInfoTixVState <= tixVStateArm when stateOp=stateOpIdle
				else tixVStateAcq when stateOp=stateOpRun
				else tixVStateDone when stateOp=stateOpStop
				else tixVStateIdle;

	strbStart <= '1' when stateOp=stateOpStart else '0';

	reqOpToSeqClear <= '1' when stateOp=stateOpClear else '0';

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

				if (stoTixVTrigger=tixVTriggerVoid and tick>=TCapt) or tick=x"FFFFFFF0" or (not staFallingNotRising and strb_last='0' and stop='1') or (staFallingNotRising and strb_last='1' and stop='0') or dneSeq='1' then
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
					if rdySeq='1' then
						stateOp <= stateOpInit;
					end if;
				end if;

			elsif stateOp=stateOpClear then -- reqOpToSeqClear='1'
				if rdySeq='1' then
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
			capt <= (others => '0');
			start <= '0';
			stop <= '0';

		elsif rising_edge(mclk) then
			capt <= "0" & tkclksrcGetTkstTkst & btn0_sig & btn0 & rgb0_b & rgb0_g & rgb0_r & tkclk;

			case staTixVTrigger is
				when tixVTriggerBtn0 =>
					start <= btn0;
				when tixVTriggerHostifRxAXIS_tvalid =>
					start <= hostifRxAXIS_tvalid;
				when tixVTriggerAckInvTkclksrcSetTkst =>
					start <= ackInvTkclksrcSetTkst;
				when others =>
					start <= '0';
			end case;

			case stoTixVTrigger is
				when tixVTriggerBtn0 =>
					stop <= btn0;
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

		variable burstCapt: std_logic_vector(14 downto 0);
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
			burstCapt := (others => '0');
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
				burstCapt := (others => '0');
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

				quad((i+1)*16-1) := '0';
				quad((i+1)*16-2 downto i*16) := capt;

				if i=1 then
					if quad(14 downto 0)=capt then
						if capt/=burstCapt or burstCnt=65535 then
							if not first then
								aSeqbuf <= aSeqbuf + 1;
							end if;

							burstCnt := 0;
						end if;

						burstCapt := capt;
						burstCnt := burstCnt + 1;

						dwrSeqbuf <= "1" & burstCapt & std_logic_vector(to_unsigned(burstCnt, 16));

					else
						burstCapt := (others => '0');
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
				if reqOpToSeqClear='1' or reqSeqbufBToSeqClear='1' then
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
