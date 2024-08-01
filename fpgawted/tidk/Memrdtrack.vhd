-- file Memrdtrack.vhd
-- Memrdtrack gptrack_Easy_v1_0 easy model debug controller implementation
-- copyright: (C) 2023 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 24 Jul 2024
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Tidk.all;

entity Memrdtrack is
	port (
		reset: in std_logic;
		mclk: in std_logic;

		resetMemclk: in std_logic;
		memclk: in std_logic;

		ackInvClientLoadGetbuf: in std_logic;
		ackInvClientStoreSetbuf: in std_logic;

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
		seqbufToHostifAXIS_tdata: out std_logic_vector(31 downto 0);
		seqbufToHostifAXIS_tlast: out std_logic;

		reqClientToDdrifRd: in std_logic;
		ackClientToDdrifRd: in std_logic;
		memCRdAXI_rvalid: in std_logic;
		ddrAXI_araddr_sig: in std_logic_vector(1 downto 0);
		ddrAXI_arready: in std_logic;
		ddrAXI_arvalid_sig: in std_logic;
		ddrAXI_rready_sig: in std_logic;
		ddrAXI_rdata: in std_logic_vector(3 downto 0);
		ddrAXI_rlast: in std_logic
	);
end Memrdtrack;

architecture Rtl of Memrdtrack is

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

	constant wD: natural := 32;
	constant logWD: natural := 2;

	constant sizeSeqbuf: natural := 4096;
	constant logSizeSeqbuf: natural := 12;

	constant tixVCaptureReqClientToDdrifRd: std_logic_vector(7 downto 0) := x"00";
	constant tixVCaptureAckClientToDdrifRd: std_logic_vector(7 downto 0) := x"01";
	constant tixVCaptureMemCRdAXI_rvalid: std_logic_vector(7 downto 0) := x"02";
	constant tixVCaptureDdrAXI_araddr_sig0: std_logic_vector(7 downto 0) := x"03";
	constant tixVCaptureDdrAXI_araddr_sig1: std_logic_vector(7 downto 0) := x"04";
	constant tixVCaptureDdrAXI_arready: std_logic_vector(7 downto 0) := x"05";
	constant tixVCaptureDdrAXI_arvalid_sig: std_logic_vector(7 downto 0) := x"06";
	constant tixVCaptureDdrAXI_rready_sig: std_logic_vector(7 downto 0) := x"07";
	constant tixVCaptureDdrAXI_rdata0: std_logic_vector(7 downto 0) := x"08";
	constant tixVCaptureDdrAXI_rdata1: std_logic_vector(7 downto 0) := x"09";
	constant tixVCaptureDdrAXI_rdata2: std_logic_vector(7 downto 0) := x"0A";
	constant tixVCaptureDdrAXI_rdata3: std_logic_vector(7 downto 0) := x"0B";
	constant tixVCaptureDdrAXI_rlast: std_logic_vector(7 downto 0) := x"0C";

	constant tixVStateIdle: std_logic_vector(7 downto 0) := x"00";
	constant tixVStateArm: std_logic_vector(7 downto 0) := x"01";
	constant tixVStateAcq: std_logic_vector(7 downto 0) := x"02";
	constant tixVStateDone: std_logic_vector(7 downto 0) := x"03";

	constant tixVTriggerVoid: std_logic_vector(7 downto 0) := x"00";
	constant tixVTriggerAckInvClientLoadGetbuf: std_logic_vector(7 downto 0) := x"02";
	constant tixVTriggerAckInvClientStoreSetbuf: std_logic_vector(7 downto 0) := x"03";

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

	---- mclk to memclk CDC sampling (mclkToMemclkSample)

	signal reqSeqbufBToSeqClear_memclk: std_logic;
	signal reqOpToSeqClear_memclk: std_logic;
	signal strbStop_memclk: std_logic;
	signal strbStart_memclk: std_logic;
	signal stoTixVTrigger_memclk: std_logic_vector(7 downto 0);
	signal staTixVTrigger_memclk: std_logic_vector(7 downto 0);
	signal capt_memclk: std_logic_vector(14 downto 0);

	---- mclk to memclk CDC stretching (mclkToMemclkStretch)

	-- IP sigs.mclkToMemclkStretch --- INSERT

	---- memclk to mclk CDC sampling (memclkToMclkSample)

	signal ackSeqbufBToSeqClear_mclk: std_logic;
	signal dneSeq_mclk: std_logic;
	signal rdySeq_mclk: std_logic;
	signal stop_mclk: std_logic;
	signal start_mclk: std_logic;

	---- memclk to mclk CDC stretching (memclkToMclkStretch)

	signal ackSeqbufBToSeqClear_to_mclk: std_logic;
	signal dneSeq_to_mclk: std_logic;
	signal rdySeq_to_mclk: std_logic;
	signal stop_to_mclk: std_logic;
	signal start_to_mclk: std_logic;

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

	mySeqbuf : Dpram_size4kB_a32b32
		port map (
			resetA => resetMemclk,
			clkA => memclk,

			enA => enSeqbuf,
			weA => '1',

			aA => aSeqbuf_vec,
			drdA => open,
			dwrA => dwrSeqbuf,

			resetB => reset,
			clkB => mclk,

			enB => enSeqbufB,
			weB => '0',

			aB => aSeqbufB_vec,
			drdB => seqbufToHostifAXIS_tdata,
			dwrB => (others => '0')
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
						strb_last := start_mclk;

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
				if staTixVTrigger=tixVTriggerVoid or (not staFallingNotRising and strb_last='0' and start_mclk='1') or (staFallingNotRising and strb_last='1' and start_mclk='0') then
					stateOp <= stateOpStart;
				else
					strb_last := start_mclk;
				end if;

			elsif stateOp=stateOpStart then -- strbStart='1'
				strb_last := stop_mclk;

				stateOp <= stateOpRun;

			elsif stateOp=stateOpRun then
				tick <= std_logic_vector(unsigned(tick) + 1);

				if (stoTixVTrigger=tixVTriggerVoid and tick>=TCapt) or tick=x"FFFFFFF0" or (not staFallingNotRising and strb_last='0' and stop_mclk='1') or (staFallingNotRising and strb_last='1' and stop_mclk='0') or dneSeq_mclk='1' then
					strbStop <= '1';

					stateOp <= stateOpStop;

				else
					strb_last := stop_mclk;
				end if;

			elsif stateOp=stateOpStop then
				strbStop <= '0';

				tick <= std_logic_vector(unsigned(tick) + 1);

				if restart then
					stateOp <= stateOpClear;

				else
					if rdySeq_mclk='1' then
						stateOp <= stateOpInit;
					end if;
				end if;

			elsif stateOp=stateOpClear then -- reqOpToSeqClear='1'
				if rdySeq_mclk='1' then
					stateOp <= stateOpInit;
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: sampling operation (sample)
	------------------------------------------------------------------------

	process (resetMemclk, memclk)

	begin
		if resetMemclk='1' then
			capt <= (others => '0');
			start <= '0';
			stop <= '0';

		elsif rising_edge(memclk) then
			capt <= "00" & ddrAXI_rlast & ddrAXI_rdata & ddrAXI_rready_sig & ddrAXI_arvalid_sig & ddrAXI_arready & ddrAXI_araddr_sig & memCRdAXI_rvalid & ackClientToDdrifRd & reqClientToDdrifRd;

			case staTixVTrigger_memclk is
				when tixVTriggerAckInvClientLoadGetbuf =>
					start <= ackInvClientLoadGetbuf;
				when tixVTriggerAckInvClientStoreSetbuf =>
					start <= ackInvClientStoreSetbuf;
				when others =>
					start <= '0';
			end case;

			case stoTixVTrigger_memclk is
				when tixVTriggerAckInvClientLoadGetbuf =>
					stop <= ackInvClientLoadGetbuf;
				when tixVTriggerAckInvClientStoreSetbuf =>
					stop <= ackInvClientStoreSetbuf;
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

	process (resetMemclk, memclk, stateSeq)
		variable quad: std_logic_vector(31 downto 0);

		variable i: natural range 0 to 3;

		variable first: boolean;
		variable stop_lcl: boolean;

		variable burstCapt: std_logic_vector(14 downto 0);
		variable burstCnt: natural range 0 to 65535;

	begin
		if resetMemclk='1' then
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

		elsif rising_edge(memclk) then
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
				if strbStart_memclk='1' then
					stateSeq <= stateSeqRun;
				end if;

			elsif stateSeq=stateSeqRun then
				if strbStop_memclk='1' then
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
				if reqOpToSeqClear_memclk='1' or reqSeqbufBToSeqClear_memclk='1' then
					aSeqbuf <= 0;
					dwrSeqbuf <= (others => '1');

					stateSeq <= stateSeqClear;
				end if;

			elsif stateSeq=stateSeqClear then
				if aSeqbuf=sizeSeqbuf/4-1 then
					if reqSeqbufBToSeqClear_memclk='1' then
						stateSeq <= stateSeqAckClear;
					else
						stateSeq <= stateSeqInit;
					end if;

				else
					aSeqbuf <= aSeqbuf + 1;
				end if;

			elsif stateSeq=stateSeqAckClear then -- ackSeqbufBToSeqClear='1'
				if reqSeqbufBToSeqClear_memclk='0' then
					stateSeq <= stateSeqInit;
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: sequence buffer B/hostif-facing operation (seqbufB)
	------------------------------------------------------------------------

	ackSeqbufToHostif <= '1' when stateSeqbufB=stateSeqbufBXferA or stateSeqbufB=stateSeqbufBXferB or stateSeqbufB=stateSeqbufBDone else '0';

	avllenSeqbufToHostif <= std_logic_vector(to_unsigned(sizeSeqbuf, 32)) when dneSeq_mclk='1'
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

	------------------------------------------------------------------------
	-- implementation: mclk to memclk CDC sampling (mclkToMemclkSample)
	------------------------------------------------------------------------

	-- IP impl.mclkToMemclkSample.wiring --- BEGIN
	-- IP impl.mclkToMemclkSample.wiring --- END

	-- IP impl.mclkToMemclkSample.rising --- BEGIN
	process (resetMemclk, memclk)
		-- IP impl.mclkToMemclkSample.vars --- BEGIN
		variable reqSeqbufBToSeqClear_last: std_logic;
		variable reqOpToSeqClear_last: std_logic;
		variable strbStop_wait: boolean;
		variable strbStart_wait: boolean;
		variable stoTixVTrigger_last: std_logic_vector(7 downto 0);
		variable staTixVTrigger_last: std_logic_vector(7 downto 0);
		variable capt_last: std_logic_vector(14 downto 0);
		-- IP impl.mclkToMemclkSample.vars --- END

	begin
		if resetMemclk='1' then
			-- IP impl.mclkToMemclkSample.asyncrst --- BEGIN
			reqSeqbufBToSeqClear_memclk <= '0';
			reqOpToSeqClear_memclk <= '0';
			strbStop_memclk <= '0';
			strbStart_memclk <= '0';
			stoTixVTrigger_memclk <= (others => '0');
			staTixVTrigger_memclk <= (others => '0');
			capt_memclk <= (others => '0');

			reqSeqbufBToSeqClear_last := '0';
			reqOpToSeqClear_last := '0';
			strbStop_wait := false;
			strbStart_wait := false;
			stoTixVTrigger_last := (others => '0');
			staTixVTrigger_last := (others => '0');
			capt_last := (others => '0');
			-- IP impl.mclkToMemclkSample.asyncrst --- END

		elsif rising_edge(memclk) then
			if reqSeqbufBToSeqClear=reqSeqbufBToSeqClear_last then
				reqSeqbufBToSeqClear_memclk <= reqSeqbufBToSeqClear;
			end if;
			reqSeqbufBToSeqClear_last := reqSeqbufBToSeqClear;

			if reqOpToSeqClear=reqOpToSeqClear_last then
				reqOpToSeqClear_memclk <= reqOpToSeqClear;
			end if;
			reqOpToSeqClear_last := reqOpToSeqClear;

			if strbStop_memclk='1' then
				strbStop_memclk <= '0';
			elsif strbStop='1' and not strbStop_wait then
				strbStop_memclk <= '1';
				strbStop_wait := true;
			end if;
			if strbStop='0' and strbStop_wait then
				strbStop_wait := false;
			end if;

			if strbStart_memclk='1' then
				strbStart_memclk <= '0';
			elsif strbStart='1' and not strbStart_wait then
				strbStart_memclk <= '1';
				strbStart_wait := true;
			end if;
			if strbStart='0' and strbStart_wait then
				strbStart_wait := false;
			end if;

			if stoTixVTrigger=stoTixVTrigger_last then
				stoTixVTrigger_memclk <= stoTixVTrigger;
			end if;
			stoTixVTrigger_last := stoTixVTrigger;

			if staTixVTrigger=staTixVTrigger_last then
				staTixVTrigger_memclk <= staTixVTrigger;
			end if;
			staTixVTrigger_last := staTixVTrigger;

			if capt=capt_last then
				capt_memclk <= capt;
			end if;
			capt_last := capt;

		end if;
	end process;
	-- IP impl.mclkToMemclkSample.rising --- END

	------------------------------------------------------------------------
	-- implementation: mclk to memclk CDC stretching (mclkToMemclkStretch)
	------------------------------------------------------------------------

	-- IP impl.mclkToMemclkStretch.wiring --- INSERT

	-- IP impl.mclkToMemclkStretch.rising --- INSERT

	------------------------------------------------------------------------
	-- implementation: memclk to mclk CDC sampling (memclkToMclkSample)
	------------------------------------------------------------------------

	-- IP impl.memclkToMclkSample.wiring --- BEGIN
	-- IP impl.memclkToMclkSample.wiring --- END

	-- IP impl.memclkToMclkSample.rising --- BEGIN
	process (reset, mclk)
		-- IP impl.memclkToMclkSample.vars --- BEGIN
		variable ackSeqbufBToSeqClear_last: std_logic;
		variable dneSeq_last: std_logic;
		variable rdySeq_last: std_logic;
		variable stop_last: std_logic;
		variable start_last: std_logic;
		-- IP impl.memclkToMclkSample.vars --- END

	begin
		if reset='1' then
			-- IP impl.memclkToMclkSample.asyncrst --- BEGIN
			ackSeqbufBToSeqClear_mclk <= '0';
			dneSeq_mclk <= '0';
			rdySeq_mclk <= '0';
			stop_mclk <= '0';
			start_mclk <= '0';

			ackSeqbufBToSeqClear_last := '0';
			dneSeq_last := '0';
			rdySeq_last := '0';
			stop_last := '0';
			start_last := '0';
			-- IP impl.memclkToMclkSample.asyncrst --- END

		elsif rising_edge(mclk) then
			if ackSeqbufBToSeqClear_to_mclk=ackSeqbufBToSeqClear_last then
				ackSeqbufBToSeqClear_mclk <= ackSeqbufBToSeqClear_to_mclk;
			end if;
			ackSeqbufBToSeqClear_last := ackSeqbufBToSeqClear_to_mclk;

			if dneSeq_to_mclk=dneSeq_last then
				dneSeq_mclk <= dneSeq_to_mclk;
			end if;
			dneSeq_last := dneSeq_to_mclk;

			if rdySeq_to_mclk=rdySeq_last then
				rdySeq_mclk <= rdySeq_to_mclk;
			end if;
			rdySeq_last := rdySeq_to_mclk;

			if stop_to_mclk=stop_last then
				stop_mclk <= stop_to_mclk;
			end if;
			stop_last := stop_to_mclk;

			if start_to_mclk=start_last then
				start_mclk <= start_to_mclk;
			end if;
			start_last := start_to_mclk;

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

		variable ackSeqbufBToSeqClear_i: natural range 0 to imax;
		variable dneSeq_i: natural range 0 to imax;
		variable rdySeq_i: natural range 0 to imax;
		variable stop_i: natural range 0 to imax;
		variable start_i: natural range 0 to imax;
		-- IP impl.memclkToMclkStretch.vars --- END

	begin
		if resetMemclk='1' then
			-- IP impl.memclkToMclkStretch.asyncrst --- BEGIN
			ackSeqbufBToSeqClear_to_mclk <= '0';
			dneSeq_to_mclk <= '0';
			rdySeq_to_mclk <= '0';
			stop_to_mclk <= '0';
			start_to_mclk <= '0';

			ackSeqbufBToSeqClear_i := 0;
			dneSeq_i := 0;
			rdySeq_i := 0;
			stop_i := 0;
			start_i := 0;
			-- IP impl.memclkToMclkStretch.asyncrst --- END

		elsif rising_edge(memclk) then
			if ackSeqbufBToSeqClear_i=imax then
				if ackSeqbufBToSeqClear/=ackSeqbufBToSeqClear_to_mclk then
					ackSeqbufBToSeqClear_to_mclk <= ackSeqbufBToSeqClear;
					ackSeqbufBToSeqClear_i := 0;
				end if;
			else
				ackSeqbufBToSeqClear_i := ackSeqbufBToSeqClear_i + 1;
			end if;

			if dneSeq_i=imax then
				if dneSeq/=dneSeq_to_mclk then
					dneSeq_to_mclk <= dneSeq;
					dneSeq_i := 0;
				end if;
			else
				dneSeq_i := dneSeq_i + 1;
			end if;

			if rdySeq_i=imax then
				if rdySeq/=rdySeq_to_mclk then
					rdySeq_to_mclk <= rdySeq;
					rdySeq_i := 0;
				end if;
			else
				rdySeq_i := rdySeq_i + 1;
			end if;

			if stop_i=imax then
				if stop/=stop_to_mclk then
					stop_to_mclk <= stop;
					stop_i := 0;
				end if;
			else
				stop_i := stop_i + 1;
			end if;

			if start_i=imax then
				if start/=start_to_mclk then
					start_to_mclk <= start;
					start_i := 0;
				end if;
			else
				start_i := start_i + 1;
			end if;

		end if;
	end process;
	-- IP impl.memclkToMclkStretch.rising --- END

end Rtl;
