-- file Hostif.vhd
-- Hostif hostif_Easy_v1_0 easy model host interface implementation
-- copyright: (C) 2017-2024 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 30 Jun 2024
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Cleb.all;

entity Hostif is
	generic (
		fSclk: natural range 100 to 50000000 := 115200;
		fMclk: natural := 50000
	);
	port (
		reset: in std_logic;
		mclk: in std_logic;
		tkclk: in std_logic;
		commok: out std_logic;
		reqReset: out std_logic;

		mgptrackGetInfoTixVState: in std_logic_vector(7 downto 0);

		reqInvMgptrackSelect: out std_logic;
		ackInvMgptrackSelect: in std_logic;

		mgptrackSelectStaTixVTrigger: out std_logic_vector(7 downto 0);
		mgptrackSelectStaFallingNotRising: out std_logic_vector(7 downto 0);
		mgptrackSelectStoTixVTrigger: out std_logic_vector(7 downto 0);
		mgptrackSelectStoFallingNotRising: out std_logic_vector(7 downto 0);

		reqInvMgptrackSet: out std_logic;
		ackInvMgptrackSet: in std_logic;

		mgptrackSetRng: out std_logic_vector(7 downto 0);
		mgptrackSetTCapt: out std_logic_vector(31 downto 0);

		mfsmtrack1GetInfoTixVState: in std_logic_vector(7 downto 0);
		mfsmtrack1GetInfoCoverage: in std_logic_vector(255 downto 0);

		reqInvMfsmtrack1Select: out std_logic;
		ackInvMfsmtrack1Select: in std_logic;

		mfsmtrack1SelectTixVCapture: out std_logic_vector(7 downto 0);
		mfsmtrack1SelectStaTixVTrigger: out std_logic_vector(7 downto 0);
		mfsmtrack1SelectStaFallingNotRising: out std_logic_vector(7 downto 0);
		mfsmtrack1SelectStoTixVTrigger: out std_logic_vector(7 downto 0);
		mfsmtrack1SelectStoFallingNotRising: out std_logic_vector(7 downto 0);

		reqInvMfsmtrack1Set: out std_logic;
		ackInvMfsmtrack1Set: in std_logic;

		mfsmtrack1SetRng: out std_logic_vector(7 downto 0);
		mfsmtrack1SetTCapt: out std_logic_vector(31 downto 0);

		stateGetTixVClebState: in std_logic_vector(7 downto 0);

		tkclksrcGetTkstTkst: in std_logic_vector(31 downto 0);

		reqInvTkclksrcSetTkst: out std_logic;
		ackInvTkclksrcSetTkst: in std_logic;

		tkclksrcSetTkstTkst: out std_logic_vector(31 downto 0);

		mfsmtrack0GetInfoTixVState: in std_logic_vector(7 downto 0);
		mfsmtrack0GetInfoCoverage: in std_logic_vector(255 downto 0);

		reqInvMfsmtrack0Select: out std_logic;
		ackInvMfsmtrack0Select: in std_logic;

		mfsmtrack0SelectTixVCapture: out std_logic_vector(7 downto 0);
		mfsmtrack0SelectStaTixVTrigger: out std_logic_vector(7 downto 0);
		mfsmtrack0SelectStaFallingNotRising: out std_logic_vector(7 downto 0);
		mfsmtrack0SelectStoTixVTrigger: out std_logic_vector(7 downto 0);
		mfsmtrack0SelectStoFallingNotRising: out std_logic_vector(7 downto 0);

		reqInvMfsmtrack0Set: out std_logic;
		ackInvMfsmtrack0Set: in std_logic;

		mfsmtrack0SetRng: out std_logic_vector(7 downto 0);
		mfsmtrack0SetTCapt: out std_logic_vector(31 downto 0);

		identGetVer: in std_logic_vector(63 downto 0);
		identGetHash: in std_logic_vector(63 downto 0);
		identGetWho: in std_logic_vector(63 downto 0);

		identGetCfgFMclk: in std_logic_vector(31 downto 0);

		reqCntbufFromMfsmtrack0: out std_logic;
		ackCntbufFromMfsmtrack0: in std_logic;
		dneCntbufFromMfsmtrack0: out std_logic;
		avllenCntbufFromMfsmtrack0: in std_logic_vector(31 downto 0);

		cntbufFromMfsmtrack0AXIS_tready: out std_logic;
		cntbufFromMfsmtrack0AXIS_tvalid: in std_logic;
		cntbufFromMfsmtrack0AXIS_tdata: in std_logic_vector(7 downto 0);
		cntbufFromMfsmtrack0AXIS_tlast: in std_logic;

		reqFstoccbufFromMfsmtrack0: out std_logic;
		ackFstoccbufFromMfsmtrack0: in std_logic;
		dneFstoccbufFromMfsmtrack0: out std_logic;
		avllenFstoccbufFromMfsmtrack0: in std_logic_vector(31 downto 0);

		fstoccbufFromMfsmtrack0AXIS_tready: out std_logic;
		fstoccbufFromMfsmtrack0AXIS_tvalid: in std_logic;
		fstoccbufFromMfsmtrack0AXIS_tdata: in std_logic_vector(7 downto 0);
		fstoccbufFromMfsmtrack0AXIS_tlast: in std_logic;

		reqSeqbufFromMfsmtrack0: out std_logic;
		ackSeqbufFromMfsmtrack0: in std_logic;
		dneSeqbufFromMfsmtrack0: out std_logic;
		avllenSeqbufFromMfsmtrack0: in std_logic_vector(31 downto 0);

		seqbufFromMfsmtrack0AXIS_tready: out std_logic;
		seqbufFromMfsmtrack0AXIS_tvalid: in std_logic;
		seqbufFromMfsmtrack0AXIS_tdata: in std_logic_vector(7 downto 0);
		seqbufFromMfsmtrack0AXIS_tlast: in std_logic;

		reqCntbufFromMfsmtrack1: out std_logic;
		ackCntbufFromMfsmtrack1: in std_logic;
		dneCntbufFromMfsmtrack1: out std_logic;
		avllenCntbufFromMfsmtrack1: in std_logic_vector(31 downto 0);

		cntbufFromMfsmtrack1AXIS_tready: out std_logic;
		cntbufFromMfsmtrack1AXIS_tvalid: in std_logic;
		cntbufFromMfsmtrack1AXIS_tdata: in std_logic_vector(7 downto 0);
		cntbufFromMfsmtrack1AXIS_tlast: in std_logic;

		reqFstoccbufFromMfsmtrack1: out std_logic;
		ackFstoccbufFromMfsmtrack1: in std_logic;
		dneFstoccbufFromMfsmtrack1: out std_logic;
		avllenFstoccbufFromMfsmtrack1: in std_logic_vector(31 downto 0);

		fstoccbufFromMfsmtrack1AXIS_tready: out std_logic;
		fstoccbufFromMfsmtrack1AXIS_tvalid: in std_logic;
		fstoccbufFromMfsmtrack1AXIS_tdata: in std_logic_vector(7 downto 0);
		fstoccbufFromMfsmtrack1AXIS_tlast: in std_logic;

		reqSeqbufFromMfsmtrack1: out std_logic;
		ackSeqbufFromMfsmtrack1: in std_logic;
		dneSeqbufFromMfsmtrack1: out std_logic;
		avllenSeqbufFromMfsmtrack1: in std_logic_vector(31 downto 0);

		seqbufFromMfsmtrack1AXIS_tready: out std_logic;
		seqbufFromMfsmtrack1AXIS_tvalid: in std_logic;
		seqbufFromMfsmtrack1AXIS_tdata: in std_logic_vector(7 downto 0);
		seqbufFromMfsmtrack1AXIS_tlast: in std_logic;

		reqSeqbufFromMgptrack: out std_logic;
		ackSeqbufFromMgptrack: in std_logic;
		dneSeqbufFromMgptrack: out std_logic;
		avllenSeqbufFromMgptrack: in std_logic_vector(31 downto 0);

		seqbufFromMgptrackAXIS_tready: out std_logic;
		seqbufFromMgptrackAXIS_tvalid: in std_logic;
		seqbufFromMgptrackAXIS_tdata: in std_logic_vector(7 downto 0);
		seqbufFromMgptrackAXIS_tlast: in std_logic;

		rxAXIS_tvalid_sig: out std_logic;

		rxd: in std_logic;
		txd: out std_logic;

		stateOp_dbg: out std_logic_vector(7 downto 0)
	);
end Hostif;

architecture Rtl of Hostif is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Crc8005_8 is
		generic (
			initOneNotZero: boolean := false
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;

			AXIS_tready: out std_logic;
			AXIS_tvalid: in std_logic;
			AXIS_tdata: in std_logic_vector(7 downto 0);
			AXIS_tlast: in std_logic;

			crc: out std_logic_vector(15 downto 0);
			validCrc: out std_logic
		);
	end component;

	component Uartrx_v2_0 is
		generic (
			fMclk: natural := 50000;
			fSclk: natural range 100 to 50000000 := 115200
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;

			req: in std_logic;
			ack: out std_logic;
			len: in std_logic_vector(31 downto 0);
			burst: in std_logic;

			AXIS_tready: in std_logic;
			AXIS_tvalid: out std_logic;
			AXIS_tdata: out std_logic_vector(7 downto 0);
			AXIS_tlast: out std_logic;

			rxd: in std_logic
		);
	end component;

	component Timeout_v1_0 is
		generic (
			twait: natural range 1 to 10000 := 100
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;

			restart: in std_logic;
			timeout: out std_logic
		);
	end component;

	component Uarttx_v2_0 is
		generic (
			fMclk: natural := 50000;

			fSclk: natural range 100 to 50000000 := 115200;
			NStop: natural range 1 to 8 := 1
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;

			req: in std_logic;
			ack: out std_logic;
			len: in std_logic_vector(31 downto 0);

			AXIS_tready: out std_logic;
			AXIS_tvalid: in std_logic;
			AXIS_tdata: in std_logic_vector(7 downto 0);
			AXIS_tlast: in std_logic;

			txd: out std_logic
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	constant wD: natural := 8;

	--- main operation
	type stateOp_t is (
		stateOpInit,
		stateOpIdle,
		stateOpRxopA, stateOpRxopB, stateOpRxopC, stateOpRxopD, stateOpRxopE,
		stateOpTxpollA, stateOpTxpollB, stateOpTxpollC, stateOpTxpollD, stateOpTxpollE, stateOpTxpollF, stateOpTxpollG,
		stateOpTxA, stateOpTxE, stateOpTxB, stateOpTxC, stateOpTxD, stateOpTxF, stateOpTxG,
		stateOpTxbufA, stateOpTxbufB, stateOpTxbufC, stateOpTxbufD, stateOpTxbufE, stateOpTxbufF, stateOpTxbufG, stateOpTxbufH,
		stateOpRxA, stateOpRxB, stateOpRxC, stateOpRxD,
		stateOpRxbufA, stateOpRxbufB, stateOpRxbufC, stateOpRxbufD, stateOpRxbufE, stateOpRxbufF,
		stateOpInv
	);
	signal stateOp: stateOp_t := stateOpInit;

	constant sizeOpbuf: natural := 9;
	constant opbufLastAXIS_tkeep: std_logic_vector(wD/8-1 downto 0) := "0";
	type opbuf_t is array (0 to sizeOpbuf-1) of std_logic_vector(7 downto 0);
	signal opbuf: opbuf_t;

	signal tixVBuffer: std_logic_vector(7 downto 0);
	signal tixVController: std_logic_vector(7 downto 0); -- cmd
	signal tixVCommand: std_logic_vector(7 downto 0); -- cmd
	signal tixVBufxfop: std_logic_vector(7 downto 0); -- bufxf

	constant sizePollbuf: natural := 6;
	constant pollbufLastAXIS_tkeep: std_logic_vector(wD/8-1 downto 0) := "0";
	type pollbuf_t is array (0 to sizePollbuf-1) of std_logic_vector(7 downto 0);
	signal pollbuf: pollbuf_t;

	constant sizeInvbuf: natural := 7; -- should include CRC
	type invbuf_t is array (0 to sizeInvbuf-1) of std_logic_vector(7 downto 0);
	signal invbuf: invbuf_t;

	constant sizeRetbuf: natural := 35; -- should include CRC
	type retbuf_t is array (0 to sizeRetbuf-1) of std_logic_vector(7 downto 0);
	signal retbuf: retbuf_t;

	signal commok_sig: std_logic;
	signal reqReset_sig: std_logic := '0';

	signal cmdvalid: std_logic;

	signal lenRet: std_logic_vector(15 downto 0);

	signal lenInv: std_logic_vector(15 downto 0);

	signal reqInv: std_logic;
	signal ackInv: std_logic;

	signal txbufvalid: std_logic;

	signal reqTxbuf: std_logic;
	signal ackTxbuf: std_logic;
	signal dneTxbuf: std_logic;

	signal avllenTxbuf: std_logic_vector(31 downto 0);

	signal txbufAXIS_tready: std_logic;
	signal txbufAXIS_tvalid: std_logic;
	signal txbufAXIS_tdata: std_logic_vector(wD-1 downto 0);
	signal txbufAXIS_tlast: std_logic;

	signal rxbufvalid: std_logic;

	signal reqRxbuf: std_logic;
	signal ackRxbuf: std_logic;
	signal dneRxbuf: std_logic;

	signal avllenRxbuf: std_logic_vector(31 downto 0);

	signal rxbufAXIS_tready: std_logic;
	signal rxbufAXIS_tvalid: std_logic;
	signal rxbufAXIS_tdata: std_logic_vector(wD-1 downto 0);
	signal rxbufAXIS_tlast: std_logic;

	signal rxbuflast: std_logic;

	signal crcAXIS_tdata: std_logic_vector(wD-1 downto 0);
	signal crcAXIS_tkeep: std_logic_vector(wD/8-1 downto 0);
	signal crcAXIS_tlast: std_logic;

	signal crclast: std_logic;
	signal crcdone: std_logic;

	signal rxlen: std_logic_vector(31 downto 0);

	signal txlen: std_logic_vector(31 downto 0);

	signal txAXIS_tdata: std_logic_vector(wD-1 downto 0);
	signal txAXIS_tlast: std_logic;

	signal txlast: std_logic;

	signal restartWordto: std_logic;
	signal restartXferto: std_logic;

	---- myCrc
	signal crc: std_logic_vector(15 downto 0);
	signal validCrc: std_logic;

	---- myRx
	signal rxAXIS_tdata: std_logic_vector(wD-1 downto 0);
	signal rxAXIS_tlast: std_logic;

	---- myWordto
	signal wordto: std_logic;

	---- myXferto
	signal xferto: std_logic;

	---- handshake
	-- op to myCrc
	signal crcAXIS_tready: std_logic;
	signal crcAXIS_tvalid: std_logic;

	-- op to myRx
	signal reqRx: std_logic;
	signal ackRx: std_logic;
	signal dneRx: std_logic;

	signal rxAXIS_tready: std_logic;
	signal rxAXIS_tvalid: std_logic;

	-- op to myTx
	signal reqTx: std_logic;
	signal ackTx: std_logic;
	signal dneTx: std_logic;

	signal txAXIS_tready: std_logic;
	signal txAXIS_tvalid: std_logic;

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myCrc : Crc8005_8
		port map (
			reset => reset,
			mclk => mclk,

			AXIS_tready => crcAXIS_tready,
			AXIS_tvalid => crcAXIS_tvalid,
			AXIS_tdata => crcAXIS_tdata,
			AXIS_tlast => crcAXIS_tlast,

			crc => crc,
			validCrc => validCrc
		);

	myRx : Uartrx_v2_0
		generic map (
			fMclk => fMclk,
			fSclk => fSclk
		)
		port map (
			reset => reset,
			mclk => mclk,

			req => reqRx,
			ack => ackRx,
			len => rxlen, -- minus one
			burst => '0', --

			AXIS_tready => rxAXIS_tready,
			AXIS_tvalid => rxAXIS_tvalid,
			AXIS_tdata => rxAXIS_tdata,
			AXIS_tlast => rxAXIS_tlast,

			rxd => rxd
		);

	myTx : Uarttx_v2_0
		generic map (
			fMclk => fMclk,

			fSclk => fSclk,
			NStop => 1
		)
		port map (
			reset => reset,
			mclk => mclk,

			req => reqTx,
			ack => ackTx,
			len => txlen, -- minus one

			AXIS_tready => txAXIS_tready,
			AXIS_tvalid => txAXIS_tvalid,
			AXIS_tdata => txAXIS_tdata,
			AXIS_tlast => txAXIS_tlast,

			txd => txd
		);

	myWordto : Timeout_v1_0
		generic map (
			twait => 100
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			restart => restartWordto,
			timeout => wordto
		);

	myXferto : Timeout_v1_0
		generic map (
			twait => 1000
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			restart => restartXferto,
			timeout => xferto
		);

	------------------------------------------------------------------------
	-- implementation: main operation 
	------------------------------------------------------------------------

	commok <= commok_sig;
	reqReset <= reqReset_sig;

	-- command
	cmdvalid <= '1' when ( (tixVController=tixVClebControllerHostif and tixVCommand=x"00")
				or (tixVController=tixVClebControllerIdent and (tixVCommand=tixVIdentCommandGet or tixVCommand=tixVIdentCommandGetCfg))
				or (tixVController=tixVClebControllerMfsmtrack0 and (tixVCommand=tixVMfsmtrack0CommandGetInfo or tixVCommand=tixVMfsmtrack0CommandSelect or tixVCommand=tixVMfsmtrack0CommandSet))
				or (tixVController=tixVClebControllerMfsmtrack1 and (tixVCommand=tixVMfsmtrack1CommandGetInfo or tixVCommand=tixVMfsmtrack1CommandSelect or tixVCommand=tixVMfsmtrack1CommandSet))
				or (tixVController=tixVClebControllerMgptrack and (tixVCommand=tixVMgptrackCommandGetInfo or tixVCommand=tixVMgptrackCommandSelect or tixVCommand=tixVMgptrackCommandSet))
				or (tixVController=tixVClebControllerState and tixVCommand=tixVStateCommandGet)
				or (tixVController=tixVClebControllerTkclksrc and (tixVCommand=tixVTkclksrcCommandGetTkst or tixVCommand=tixVTkclksrcCommandSetTkst))
				) else '0';

	-- tx/ret command
	lenRet <= x"0018" when (tixVController=tixVClebControllerIdent and tixVCommand=tixVIdentCommandGet)
				else x"0004" when (tixVController=tixVClebControllerIdent and tixVCommand=tixVIdentCommandGetCfg)
				else x"0021" when (tixVController=tixVClebControllerMfsmtrack0 and tixVCommand=tixVMfsmtrack0CommandGetInfo)
				else x"0021" when (tixVController=tixVClebControllerMfsmtrack1 and tixVCommand=tixVMfsmtrack1CommandGetInfo)
				else x"0001" when (tixVController=tixVClebControllerMgptrack and tixVCommand=tixVMgptrackCommandGetInfo)
				else x"0001" when (tixVController=tixVClebControllerState and tixVCommand=tixVStateCommandGet)
				else x"0004" when (tixVController=tixVClebControllerTkclksrc and tixVCommand=tixVTkclksrcCommandGetTkst)
				else (others => '0');

	-- rx/inv command
	lenInv <= x"0005" when (tixVController=tixVClebControllerMfsmtrack0 and tixVCommand=tixVMfsmtrack0CommandSelect)
				else x"0005" when (tixVController=tixVClebControllerMfsmtrack0 and tixVCommand=tixVMfsmtrack0CommandSet)
				else x"0005" when (tixVController=tixVClebControllerMfsmtrack1 and tixVCommand=tixVMfsmtrack1CommandSelect)
				else x"0005" when (tixVController=tixVClebControllerMfsmtrack1 and tixVCommand=tixVMfsmtrack1CommandSet)
				else x"0004" when (tixVController=tixVClebControllerMgptrack and tixVCommand=tixVMgptrackCommandSelect)
				else x"0005" when (tixVController=tixVClebControllerMgptrack and tixVCommand=tixVMgptrackCommandSet)
				else x"0004" when (tixVController=tixVClebControllerTkclksrc and tixVCommand=tixVTkclksrcCommandSetTkst)
				else (others => '0');

	reqInv <= '1' when stateOp=stateOpInv else '0';

	reqInvMfsmtrack0Select <= reqInv when (tixVController=tixVClebControllerMfsmtrack0 and tixVCommand=tixVMfsmtrack0CommandSelect) else '0';
	mfsmtrack0SelectTixVCapture <= invbuf(0);
	mfsmtrack0SelectStaTixVTrigger <= invbuf(1);
	mfsmtrack0SelectStaFallingNotRising <= invbuf(2);
	mfsmtrack0SelectStoTixVTrigger <= invbuf(3);
	mfsmtrack0SelectStoFallingNotRising <= invbuf(4);

	reqInvMfsmtrack0Set <= reqInv when (tixVController=tixVClebControllerMfsmtrack0 and tixVCommand=tixVMfsmtrack0CommandSet) else '0';
	mfsmtrack0SetRng <= invbuf(0);
	mfsmtrack0SetTCapt <= invbuf(1) & invbuf(2) & invbuf(3) & invbuf(4);

	reqInvMfsmtrack1Select <= reqInv when (tixVController=tixVClebControllerMfsmtrack1 and tixVCommand=tixVMfsmtrack1CommandSelect) else '0';
	mfsmtrack1SelectTixVCapture <= invbuf(0);
	mfsmtrack1SelectStaTixVTrigger <= invbuf(1);
	mfsmtrack1SelectStaFallingNotRising <= invbuf(2);
	mfsmtrack1SelectStoTixVTrigger <= invbuf(3);
	mfsmtrack1SelectStoFallingNotRising <= invbuf(4);

	reqInvMfsmtrack1Set <= reqInv when (tixVController=tixVClebControllerMfsmtrack1 and tixVCommand=tixVMfsmtrack1CommandSet) else '0';
	mfsmtrack1SetRng <= invbuf(0);
	mfsmtrack1SetTCapt <= invbuf(1) & invbuf(2) & invbuf(3) & invbuf(4);

	reqInvMgptrackSelect <= reqInv when (tixVController=tixVClebControllerMgptrack and tixVCommand=tixVMgptrackCommandSelect) else '0';
	mgptrackSelectStaTixVTrigger <= invbuf(0);
	mgptrackSelectStaFallingNotRising <= invbuf(1);
	mgptrackSelectStoTixVTrigger <= invbuf(2);
	mgptrackSelectStoFallingNotRising <= invbuf(3);

	reqInvMgptrackSet <= reqInv when (tixVController=tixVClebControllerMgptrack and tixVCommand=tixVMgptrackCommandSet) else '0';
	mgptrackSetRng <= invbuf(0);
	mgptrackSetTCapt <= invbuf(1) & invbuf(2) & invbuf(3) & invbuf(4);

	reqInvTkclksrcSetTkst <= reqInv when (tixVController=tixVClebControllerTkclksrc and tixVCommand=tixVTkclksrcCommandSetTkst) else '0';
	tkclksrcSetTkstTkst <= invbuf(0) & invbuf(1) & invbuf(2) & invbuf(3);

	ackInv <= ackInvMfsmtrack0Select when (tixVController=tixVClebControllerMfsmtrack0 and tixVCommand=tixVMfsmtrack0CommandSelect)
				else ackInvMfsmtrack0Set when (tixVController=tixVClebControllerMfsmtrack0 and tixVCommand=tixVMfsmtrack0CommandSet)
				else ackInvMfsmtrack1Select when (tixVController=tixVClebControllerMfsmtrack1 and tixVCommand=tixVMfsmtrack1CommandSelect)
				else ackInvMfsmtrack1Set when (tixVController=tixVClebControllerMfsmtrack1 and tixVCommand=tixVMfsmtrack1CommandSet)
				else ackInvMgptrackSelect when (tixVController=tixVClebControllerMgptrack and tixVCommand=tixVMgptrackCommandSelect)
				else ackInvMgptrackSet when (tixVController=tixVClebControllerMgptrack and tixVCommand=tixVMgptrackCommandSet)
				else ackInvTkclksrcSetTkst when (tixVController=tixVClebControllerTkclksrc and tixVCommand=tixVTkclksrcCommandSetTkst)
				else '1';

	-- tx buffer
	txbufvalid <= '1' when tixVBuffer=tixVClebBufferCntbufMfsmtrack1ToHostif or tixVBuffer=tixVClebBufferCntbufMfsmtrack0ToHostif or tixVBuffer=tixVClebBufferFstoccbufMfsmtrack1ToHostif or tixVBuffer=tixVClebBufferFstoccbufMfsmtrack0ToHostif or tixVBuffer=tixVClebBufferSeqbufMfsmtrack1ToHostif or tixVBuffer=tixVClebBufferSeqbufMfsmtrack0ToHostif or tixVBuffer=tixVClebBufferSeqbufMgptrackToHostif else '0';

	reqTxbuf <= '1' when stateOp=stateOpTxbufA or stateOp=stateOpTxbufB or stateOp=stateOpTxbufC or stateOp=stateOpTxbufD or stateOp=stateOpTxbufE or stateOp=stateOpTxbufF or stateOp=stateOpTxbufG or stateOp=stateOpTxbufH else '0';

	reqCntbufFromMfsmtrack1 <= reqTxbuf when tixVBuffer=tixVClebBufferCntbufMfsmtrack1ToHostif else '0';
	reqCntbufFromMfsmtrack0 <= reqTxbuf when tixVBuffer=tixVClebBufferCntbufMfsmtrack0ToHostif else '0';
	reqFstoccbufFromMfsmtrack1 <= reqTxbuf when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack1ToHostif else '0';
	reqFstoccbufFromMfsmtrack0 <= reqTxbuf when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack0ToHostif else '0';
	reqSeqbufFromMfsmtrack1 <= reqTxbuf when tixVBuffer=tixVClebBufferSeqbufMfsmtrack1ToHostif else '0';
	reqSeqbufFromMfsmtrack0 <= reqTxbuf when tixVBuffer=tixVClebBufferSeqbufMfsmtrack0ToHostif else '0';
	reqSeqbufFromMgptrack <= reqTxbuf when tixVBuffer=tixVClebBufferSeqbufMgptrackToHostif else '0';

	ackTxbuf <= ackCntbufFromMfsmtrack1 when tixVBuffer=tixVClebBufferCntbufMfsmtrack1ToHostif
				else ackCntbufFromMfsmtrack0 when tixVBuffer=tixVClebBufferCntbufMfsmtrack0ToHostif
				else ackFstoccbufFromMfsmtrack1 when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack1ToHostif
				else ackFstoccbufFromMfsmtrack0 when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack0ToHostif
				else ackSeqbufFromMfsmtrack1 when tixVBuffer=tixVClebBufferSeqbufMfsmtrack1ToHostif
				else ackSeqbufFromMfsmtrack0 when tixVBuffer=tixVClebBufferSeqbufMfsmtrack0ToHostif
				else ackSeqbufFromMgptrack when tixVBuffer=tixVClebBufferSeqbufMgptrackToHostif
				else '0';

	dneTxbuf <= '1' when stateOp=stateOpTxbufE else '0';

	dneCntbufFromMfsmtrack1 <= dneTxbuf when tixVBuffer=tixVClebBufferCntbufMfsmtrack1ToHostif else '0';
	dneCntbufFromMfsmtrack0 <= dneTxbuf when tixVBuffer=tixVClebBufferCntbufMfsmtrack0ToHostif else '0';
	dneFstoccbufFromMfsmtrack1 <= dneTxbuf when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack1ToHostif else '0';
	dneFstoccbufFromMfsmtrack0 <= dneTxbuf when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack0ToHostif else '0';
	dneSeqbufFromMfsmtrack1 <= dneTxbuf when tixVBuffer=tixVClebBufferSeqbufMfsmtrack1ToHostif else '0';
	dneSeqbufFromMfsmtrack0 <= dneTxbuf when tixVBuffer=tixVClebBufferSeqbufMfsmtrack0ToHostif else '0';
	dneSeqbufFromMgptrack <= dneTxbuf when tixVBuffer=tixVClebBufferSeqbufMgptrackToHostif else '0';

	avllenTxbuf <= avllenCntbufFromMfsmtrack1 when tixVBuffer=tixVClebBufferCntbufMfsmtrack1ToHostif
				else avllenCntbufFromMfsmtrack0 when tixVBuffer=tixVClebBufferCntbufMfsmtrack0ToHostif
				else avllenFstoccbufFromMfsmtrack1 when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack1ToHostif
				else avllenFstoccbufFromMfsmtrack0 when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack0ToHostif
				else avllenSeqbufFromMfsmtrack1 when tixVBuffer=tixVClebBufferSeqbufMfsmtrack1ToHostif
				else avllenSeqbufFromMfsmtrack0 when tixVBuffer=tixVClebBufferSeqbufMfsmtrack0ToHostif
				else avllenSeqbufFromMgptrack when tixVBuffer=tixVClebBufferSeqbufMgptrackToHostif
				else (others => '0');

	txbufAXIS_tready <= '1' when stateOp=stateOpTxbufB else '0';

	cntbufFromMfsmtrack1AXIS_tready <= txbufAXIS_tready when tixVBuffer=tixVClebBufferCntbufMfsmtrack1ToHostif else '0';
	cntbufFromMfsmtrack0AXIS_tready <= txbufAXIS_tready when tixVBuffer=tixVClebBufferCntbufMfsmtrack0ToHostif else '0';
	fstoccbufFromMfsmtrack1AXIS_tready <= txbufAXIS_tready when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack1ToHostif else '0';
	fstoccbufFromMfsmtrack0AXIS_tready <= txbufAXIS_tready when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack0ToHostif else '0';
	seqbufFromMfsmtrack1AXIS_tready <= txbufAXIS_tready when tixVBuffer=tixVClebBufferSeqbufMfsmtrack1ToHostif else '0';
	seqbufFromMfsmtrack0AXIS_tready <= txbufAXIS_tready when tixVBuffer=tixVClebBufferSeqbufMfsmtrack0ToHostif else '0';
	seqbufFromMgptrackAXIS_tready <= txbufAXIS_tready when tixVBuffer=tixVClebBufferSeqbufMgptrackToHostif else '0';

	txbufAXIS_tvalid <= cntbufFromMfsmtrack1AXIS_tvalid when tixVBuffer=tixVClebBufferCntbufMfsmtrack1ToHostif
				else cntbufFromMfsmtrack0AXIS_tvalid when tixVBuffer=tixVClebBufferCntbufMfsmtrack0ToHostif
				else fstoccbufFromMfsmtrack1AXIS_tvalid when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack1ToHostif
				else fstoccbufFromMfsmtrack0AXIS_tvalid when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack0ToHostif
				else seqbufFromMfsmtrack1AXIS_tvalid when tixVBuffer=tixVClebBufferSeqbufMfsmtrack1ToHostif
				else seqbufFromMfsmtrack0AXIS_tvalid when tixVBuffer=tixVClebBufferSeqbufMfsmtrack0ToHostif
				else seqbufFromMgptrackAXIS_tvalid when tixVBuffer=tixVClebBufferSeqbufMgptrackToHostif
				else '0';

	txbufAXIS_tdata <= cntbufFromMfsmtrack1AXIS_tdata when tixVBuffer=tixVClebBufferCntbufMfsmtrack1ToHostif
				else cntbufFromMfsmtrack0AXIS_tdata when tixVBuffer=tixVClebBufferCntbufMfsmtrack0ToHostif
				else fstoccbufFromMfsmtrack1AXIS_tdata when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack1ToHostif
				else fstoccbufFromMfsmtrack0AXIS_tdata when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack0ToHostif
				else seqbufFromMfsmtrack1AXIS_tdata when tixVBuffer=tixVClebBufferSeqbufMfsmtrack1ToHostif
				else seqbufFromMfsmtrack0AXIS_tdata when tixVBuffer=tixVClebBufferSeqbufMfsmtrack0ToHostif
				else seqbufFromMgptrackAXIS_tdata when tixVBuffer=tixVClebBufferSeqbufMgptrackToHostif
				else (others => '0');

	txbufAXIS_tlast <= cntbufFromMfsmtrack1AXIS_tlast when tixVBuffer=tixVClebBufferCntbufMfsmtrack1ToHostif
				else cntbufFromMfsmtrack0AXIS_tlast when tixVBuffer=tixVClebBufferCntbufMfsmtrack0ToHostif
				else fstoccbufFromMfsmtrack1AXIS_tlast when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack1ToHostif
				else fstoccbufFromMfsmtrack0AXIS_tlast when tixVBuffer=tixVClebBufferFstoccbufMfsmtrack0ToHostif
				else seqbufFromMfsmtrack1AXIS_tlast when tixVBuffer=tixVClebBufferSeqbufMfsmtrack1ToHostif
				else seqbufFromMfsmtrack0AXIS_tlast when tixVBuffer=tixVClebBufferSeqbufMfsmtrack0ToHostif
				else seqbufFromMgptrackAXIS_tlast when tixVBuffer=tixVClebBufferSeqbufMgptrackToHostif
				else '0';

	-- rx buffer
	rxbufvalid <=  '0';

	reqRxbuf <= '1' when stateOp=stateOpRxbufA or stateOp=stateOpRxbufB or stateOp=stateOpRxbufC or stateOp=stateOpRxbufD or stateOp=stateOpRxbufE or stateOp=stateOpRxbufF else '0';

	ackRxbuf <= '0';

	dneRxbuf <= '1' when stateOp=stateOpRxbufF else '0';

	avllenRxbuf <= (others => '0');

	rxbufAXIS_tvalid <= '1' when stateOp=stateOpRxbufC else '0';

	rxbufAXIS_tlast <= '1' when (stateOp=stateOpRxbufC and rxbuflast='1') else '0';

	rxbufAXIS_tready <= '0';

	crcAXIS_tvalid <= '1' when ((stateOp=stateOpRxopB or stateOp=stateOpRxB or stateOp=stateOpRxbufB) and rxAXIS_tvalid='1')
				or ((stateOp=stateOpTxpollC or stateOp=stateOpTxC or stateOp=stateOpTxbufC) and crcdone='0')
				else '0';

	crcAXIS_tdata <= rxAXIS_tdata when (stateOp=stateOpRxopB or stateOp=stateOpRxB or stateOp=stateOpRxbufB)
				else txAXIS_tdata when (stateOp=stateOpTxpollC or stateOp=stateOpTxC or stateOp=stateOpTxbufC)
				else (others => '0');

	crcAXIS_tlast <= '1' when ((stateOp=stateOpRxopB or stateOp=stateOpRxB or stateOp=stateOpRxbufB) and rxAXIS_tlast='1')
				or crclast='1' -- covers txpoll, tx, txbuf; _tlast has to stay on until crc is evaluated / copied
				else '0';

	reqRx <= '1' when stateOp=stateOpRxopB
				or stateOp=stateOpTxpollG
				or stateOp=stateOpTxG
				or stateOp=stateOpTxbufG
				or stateOp=stateOpRxB
				or stateOp=stateOpRxbufB or stateOp=stateOpRxbufC
				else '0';

	rxAXIS_tready <= '1' when stateOp=stateOpRxopB
				or stateOp=stateOpTxpollG
				or stateOp=stateOpTxG
				or stateOp=stateOpTxbufG
				or stateOp=stateOpRxB
				or stateOp=stateOpRxbufB
				else '0';

	restartWordto <= '0' when ((ackRx='1' and rxAXIS_tvalid='0' and (stateOp=stateOpRxopB or stateOp=stateOpRxB or stateOp=stateOpRxbufB))
				or (ackTx='1' and txAXIS_tready='0' and (stateOp=stateOpTxpollE or stateOp=stateOpTxE or stateOp=stateOpTxbufE)))
				else '1';

	restartXferto <= '0' when ((ackRx='0' and (stateOp=stateOpRxB or stateOp=stateOpRxbufB))
					or ((ackTx='0' and (stateOp=stateOpTxpollE or stateOp=stateOpTxE or stateOp=stateOpTxbufE)))
					or stateOp=stateOpRxopE or stateOp=stateOpTxpollG or stateOp=stateOpTxG or stateOp=stateOpTxbufG or stateOp=stateOpRxD or stateOp=stateOpRxbufE)
					else '1';

	reqTx <= '1' when stateOp=stateOpRxopE
				or stateOp=stateOpTxpollB or stateOp=stateOpTxpollC or stateOp=stateOpTxpollD or stateOp=stateOpTxpollE or stateOp=stateOpTxpollF
				or stateOp=stateOpTxE or stateOp=stateOpTxB or stateOp=stateOpTxC or stateOp=stateOpTxD or stateOp=stateOpTxF
				or stateOp=stateOpTxbufB or stateOp=stateOpTxbufC or stateOp=stateOpTxbufD or stateOp=stateOpTxbufE or stateOp=stateOpTxbufF
				or stateOp=stateOpRxD
				or stateOp=stateOpRxbufE
				else '0';

	txAXIS_tvalid <= '1' when stateOp=stateOpRxopE
				or stateOp=stateOpTxpollE
				or stateOp=stateOpTxE
				or stateOp=stateOpTxbufE
				or stateOp=stateOpRxD
				or stateOp=stateOpRxbufE
				else '0';
	
	txAXIS_tlast <= '1' when stateOp=stateOpRxopE
				or (stateOp=stateOpTxpollE and txlast='1')
				or (stateOp=stateOpTxE and txlast='1')
				or (stateOp=stateOpTxbufE and txlast='1')
				or stateOp=stateOpRxD
				or stateOp=stateOpRxbufE
				else '0';

	-- IP cust --- RBEGIN
	stateOp_dbg <= x"00" when stateOp=stateOpInit
				else x"10" when stateOp=stateOpIdle
				else x"20" when stateOp=stateOpRxopA
				else x"21" when stateOp=stateOpRxopB
				else x"22" when stateOp=stateOpRxopC
				else x"23" when stateOp=stateOpRxopD
				else x"24" when stateOp=stateOpRxopE
				else x"30" when stateOp=stateOpTxpollA
				else x"31" when stateOp=stateOpTxpollB
				else x"32" when stateOp=stateOpTxpollC
				else x"33" when stateOp=stateOpTxpollD
				else x"34" when stateOp=stateOpTxpollE
				else x"35" when stateOp=stateOpTxpollF
				else x"36" when stateOp=stateOpTxpollG
				else x"40" when stateOp=stateOpTxA
				else x"41" when stateOp=stateOpTxB
				else x"42" when stateOp=stateOpTxC
				else x"43" when stateOp=stateOpTxD
				else x"44" when stateOp=stateOpTxE
				else x"45" when stateOp=stateOpTxF
				else x"46" when stateOp=stateOpTxG
				else x"50" when stateOp=stateOpTxbufA
				else x"51" when stateOp=stateOpTxbufB
				else x"52" when stateOp=stateOpTxbufC
				else x"53" when stateOp=stateOpTxbufD
				else x"54" when stateOp=stateOpTxbufE
				else x"55" when stateOp=stateOpTxbufF
				else x"56" when stateOp=stateOpTxbufG
				else x"57" when stateOp=stateOpTxbufH
				else x"60" when stateOp=stateOpRxA
				else x"61" when stateOp=stateOpRxB
				else x"62" when stateOp=stateOpRxC
				else x"63" when stateOp=stateOpRxD
				else x"70" when stateOp=stateOpRxbufA
				else x"71" when stateOp=stateOpRxbufB
				else x"72" when stateOp=stateOpRxbufC
				else x"73" when stateOp=stateOpRxbufD
				else x"74" when stateOp=stateOpRxbufE
				else x"75" when stateOp=stateOpRxbufF
				else x"80" when stateOp=stateOpInv
				else (others => '1');
	
	rxAXIS_tvalid_sig <= rxAXIS_tvalid;
	-- IP cust --- REND

	process (reset, mclk, stateOp)
		variable len: std_logic_vector(31 downto 0);

		variable full_vec: unsigned(31 downto 0);
		variable quot: natural;

		variable resid: natural range 0 to wD/8-1;
		variable residCrc: natural range 0 to wD/8-1;

		variable lastAXIS_tkeep: std_logic_vector(wD/8-1 downto 0);

		variable txAXIS_tdata_lcl: std_logic_vector(wD-1 downto 0);

		variable stateOp_next: stateOp_t;

		variable wordcnt: natural;
		variable wordcntLast: natural;
		variable wordcntCrcLast: natural range 0 to 16777216;

		variable ixRetbufCrc: natural range 0 to sizeRetbuf-2;

	begin
		if reset='1' then
			stateOp <= stateOpInit;
			opbuf <= (others => (others => '0'));
			tixVBuffer <= (others => '0');
			tixVController <= (others => '0');
			tixVCommand <= (others => '0');
			tixVBufxfop <= (others => '0');
			pollbuf <= (others => (others => '0'));
			invbuf <= (others => (others => '0'));
			retbuf <= (others => (others => '0'));
			commok_sig <= '1';
			reqReset_sig <= '0';
			rxbuflast <= '0';
			crcAXIS_tkeep <= (others => '1');
			crclast <= '0';
			crcdone <= '0';
			rxlen <= (others => '0');
			txlen <= (others => '0');
			txAXIS_tdata <= (others => '0');
			txlast <= '0';

			len := (others => '0');
			full_vec := (others => '0');
			quot := 0;
			resid := 0;
			residCrc := 0;
			lastAXIS_tkeep := (others => '1');
			txAXIS_tdata_lcl := (others => '0');
			stateOp_next := stateOpInit;
			wordcnt := 0;
			wordcntLast := 0;
			wordcntCrcLast := 0;
			ixRetbufCrc := 0;

		elsif rising_edge(mclk) then
			if stateOp=stateOpInit or wordto='1' or xferto='1' then
				opbuf <= (others => (others => '0'));
				tixVBuffer <= (others => '0');
				tixVController <= (others => '0');
				tixVCommand <= (others => '0');
				tixVBufxfop <= (others => '0');
				pollbuf <= (others => (others => '0'));
				invbuf <= (others => (others => '0'));
				retbuf <= (others => (others => '0'));
				reqReset_sig <= '0';
				rxbuflast <= '0';
				crcAXIS_tkeep <= (others => '1');
				crclast <= '0';
				crcdone <= '0';
				rxlen <= (others => '0');
				txlen <= (others => '0');
				txAXIS_tdata <= (others => '0');
				txlast <= '0';

				len := (others => '0');
				full_vec := (others => '0');
				quot := 0;
				resid := 0;
				residCrc := 0;
				lastAXIS_tkeep := (others => '1');
				txAXIS_tdata_lcl := (others => '0');
				stateOp_next := stateOpInit;
				wordcnt := 0;
				wordcntLast := 0;
				wordcntCrcLast := 0;
				ixRetbufCrc := 0;

				if wordto='1' or xferto='1' then
					commok_sig <= '0';

					stateOp <= stateOpInit;
				else
					stateOp <= stateOpIdle;
				end if;

			elsif stateOp=stateOpIdle then
				stateOp <= stateOpRxopA;

-- RX OP BEGIN
			elsif stateOp=stateOpRxopA then
				if wD=128 then
					rxlen <= (others => '0');
					wordcntLast := 0;
				else
					rxlen <= std_logic_vector(to_unsigned(sizeOpbuf/(wD/8)-1, 32));
					wordcntLast := sizeOpbuf/(wD/8) - 1;
				end if;

				crcAXIS_tkeep <= (others => '1');

				wordcnt := 0;

				stateOp <= stateOpRxopB;

			elsif stateOp=stateOpRxopB then -- reqRx='1', rxAXIS_tready='1'
				if rxAXIS_tvalid='1' then
					commok_sig <= '1';

					for i in 0 to wD/8-1 loop
						opbuf(wordcnt*wD/8+i) <= rxAXIS_tdata(8*(i+1)-1 downto 8*i);
					end loop;

					if wordcnt=wordcntLast-1 then
						crcAXIS_tkeep <= opbufLastAXIS_tkeep;
						crclast <= '1';
						
						wordcnt := wordcnt + 1;

					elsif wordcnt=wordcntLast then
						stateOp <= stateOpRxopC;

					else
						wordcnt := wordcnt + 1;
					end if;
				end if;

			elsif stateOp=stateOpRxopC then
				crcAXIS_tkeep <= (others => '1');
				crclast <= '0';

				if crc=x"0000" then
					tixVBuffer <= opbuf(ixOpbufBuffer);
					if opbuf(ixOpbufBuffer)/=tixVClebBufferCmdretToHostif or opbuf(ixOpbufBufxfBufxfop)/=tixVBufxfopPoll then
						tixVController <= opbuf(ixOpbufController);
						tixVCommand <= opbuf(ixOpbufCmdCommand);
					end if;
					tixVBufxfop <= opbuf(ixOpbufBufxfBufxfop);

					len := opbuf(ixOpbufLen) & opbuf(ixOpbufLen+1) & opbuf(ixOpbufLen+2) & opbuf(ixOpbufLen+3);

					stateOp <= stateOpRxopD;
				
				else
					commok_sig <= '0';

					stateOp <= stateOpInit;
				end if;

			elsif stateOp=stateOpRxopD then
				stateOp_next := stateOpInit;

				if tixVBuffer=tixVClebBufferCmdretToHostif and tixVBufxfop=tixVBufxfopPoll and len(7 downto 0)=x"04" then
					stateOp_next := stateOpTxpollA;

				elsif tixVBuffer=tixVClebBufferHostifToCmdinv and cmdvalid='1' and len(15 downto 0)=lenInv then
					if unsigned(lenInv)=0 then
						stateOp_next := stateOpInv;
					else
						stateOp_next := stateOpRxA;
					end if;

				elsif (txbufvalid='1' or rxbufvalid='1') and tixVBufxfop=tixVBufxfopPoll then
					stateOp_next := stateOpTxpollA;

				elsif txbufvalid='1' and tixVBufxfop=tixVBufxfopXfer and len=avllenTxbuf and unsigned(len)/=0 then
					if wD=8 or (wD=16 and len(0)='0') or (wD=32 and len(1 downto 0)="00") or (wD=64 and len(2 downto 0)="000") or (wD=128 and len(3 downto 0)="0000") then
						stateOp_next := stateOpTxbufA;
					end if;

				elsif rxbufvalid='1' and tixVBufxfop=tixVBufxfopXfer and unsigned(len)<=unsigned(avllenRxbuf) and unsigned(len)/=0 then
					if wD=8 or (wD=16 and len(0)='0') or (wD=32 and len(1 downto 0)="00") or (wD=64 and len(2 downto 0)="000") or (wD=128 and len(3 downto 0)="0000") then
						stateOp_next := stateOpRxbufA;
					end if;
				end if;

				txlen <= (others => '0');
				txlast <= '1';

				if stateOp_next=stateOpInit then
					txAXIS_tdata(7 downto 0) <= fls8;
				else
					txAXIS_tdata(7 downto 0) <= tru8;
				end if;

				stateOp <= stateOpRxopE;

			elsif stateOp=stateOpRxopE then -- reqTx='1', txAXIS_tvalid='1', txAXIS_tlast='1'
				if dneTx='1' then
					stateOp <= stateOp_next;
				end if;

-- RX OP END, TX POLL BEGIN
			elsif stateOp=stateOpTxpollA then
				if tixVBuffer=tixVClebBufferCmdretToHostif then
					pollbuf(ixPollbufCmdController) <= tixVController;
					pollbuf(ixPollbufCmdCommand) <= tixVCommand;
					pollbuf(ixPollbufCmdLen) <= lenRet(15 downto 8);
					pollbuf(ixPollbufCmdLen+1) <= lenRet(7 downto 0);
				elsif txbufvalid='1' then
					pollbuf(ixPollbufBufxfAvllen) <= avllenTxbuf(31 downto 24);
					pollbuf(ixPollbufBufxfAvllen+1) <= avllenTxbuf(23 downto 16);
					pollbuf(ixPollbufBufxfAvllen+2) <= avllenTxbuf(15 downto 8);
					pollbuf(ixPollbufBufxfAvllen+3) <= avllenTxbuf(7 downto 0);
				elsif rxbufvalid='1' then
					pollbuf(ixPollbufBufxfAvllen) <= avllenRxbuf(31 downto 24);
					pollbuf(ixPollbufBufxfAvllen+1) <= avllenRxbuf(23 downto 16);
					pollbuf(ixPollbufBufxfAvllen+2) <= avllenRxbuf(15 downto 8);
					pollbuf(ixPollbufBufxfAvllen+3) <= avllenRxbuf(7 downto 0);
				end if;

				if wD=64 or wD=128 then
					txlen <= (others => '0');
					wordcntLast := 0;
				else
					txlen <= std_logic_vector(to_unsigned(sizePollbuf/(wD/8)-1, 32));
					wordcntLast := sizePollbuf/(wD/8)-1;
				end if;

				if wD=64 or wD=128 then
					crcAXIS_tkeep <= pollbufLastAXIS_tkeep;
					crclast <= '1';
					txlast <= '1';
				else
					crcAXIS_tkeep <= (others => '1');
					crclast <= '0';
					txlast <= '0';
				end if;

				wordcnt := 0;

				crcdone <= '0';

				stateOp <= stateOpTxpollB;

			elsif stateOp=stateOpTxpollB then -- load into txAXIS_tdata
				for i in 0 to wD/8-1 loop
					txAXIS_tdata(8*(i+1)-1 downto 8*i) <= pollbuf(wordcnt*wD/8+i);
				end loop;

				stateOp <= stateOpTxpollC;

			elsif stateOp=stateOpTxpollC then -- calc CRC on txAXIS_tdata
				if (wD=64 or wD=128) or ((wD=8 or wD=16 or wD=32) and wordcnt=ixPollbufCrc/(wD/8)-1) then
					crcdone <= '1';

					stateOp <= stateOpTxpollD;

				else
					stateOp <= stateOpTxpollE;
				end if;

			elsif stateOp=stateOpTxpollD then -- update pollbuf or txAXIS_tdata
				if wD=64 or wD=128 then
					txAXIS_tdata(5*8-1 downto 4*8) <= crc(15 downto 8);
					txAXIS_tdata(6*8-1 downto 5*8) <= crc(7 downto 0);

				else
					pollbuf(ixPollbufCrc) <= crc(15 downto 8);
					pollbuf(ixPollbufCrc + 1) <= crc(7 downto 0);
				end if;

				stateOp <= stateOpTxpollE;

			elsif stateOp=stateOpTxpollE then
				if txAXIS_tready='1' then
					if wordcnt=wordcntLast then
						crcAXIS_tkeep <= (others => '1');
						crclast <= '0';
						crcdone <= '0';

						stateOp <= stateOpTxpollF;
					
					else
						wordcnt := wordcnt + 1;

						if wordcnt=wordcntLast then
							txlast <= '1';
						end if;

						if (wD=8 or wD=16 or wD=32) and wordcnt=ixPollbufCrc/(wD/8)-1 then
							--crcAXIS_tkeep <= pollbufLastAXIS_tkeep; -- irrelevant as only applicable for wD=64 and wD=128
							crclast <= '1';
						end if;

						stateOp <= stateOpTxpollB;
					end if;
				end if;

			elsif stateOp=stateOpTxpollF then
				if dneTx='1' then
					rxlen <= (others => '0');

					stateOp <= stateOpTxpollG;
				end if;

			elsif stateOp=stateOpTxpollG then -- reqRx='1', rxAXIS_tready'1'
				if rxAXIS_tvalid='1' then
					if rxAXIS_tdata(7 downto 0)/=tru8 then
						stateOp <= stateOpInit;

					else
						if tixVBuffer=tixVClebBufferCmdretToHostif then
							stateOp <= stateOpTxA;
						else
							stateOp <= stateOpInit;
						end if;
					end if;
				end if;

-- TX POLL END, TX BEGIN
			elsif stateOp=stateOpTxA then
				ixRetbufCrc := to_integer(unsigned(lenRet));

				full_vec := resize(unsigned(lenRet), 32) + 1; -- +2 (for CRC) -1

				if wD=8 then
					resid := 0;

					txlen <= std_logic_vector(full_vec);
					wordcntLast := to_integer(full_vec);

					wordcntCrcLast := to_integer(unsigned(lenRet) - 1);
					lastAXIS_tkeep := (others => '1');

				else
					if wD=16 then
						quot := to_integer(full_vec(31 downto 1));
						resid := to_integer(unsigned(full_vec(0 downto 0)));
					elsif wD=32 then
						quot := to_integer(full_vec(31 downto 2));
						resid := to_integer(unsigned(full_vec(1 downto 0)));
					elsif wD=64 then
						quot := to_integer(full_vec(31 downto 3));
						resid := to_integer(unsigned(full_vec(2 downto 0)));
					elsif wD=128 then
						quot := to_integer(full_vec(31 downto 4));
						resid := to_integer(unsigned(full_vec(3 downto 0)));
					end if;

					txlen <= std_logic_vector(to_unsigned(quot, 32));
					wordcntLast := quot;

					if resid=0 then
						wordcntCrcLast := quot - 1;
						residCrc := wD/8 - 2;
					elsif resid=1 then
						wordcntCrcLast := quot - 1;
						residCrc := wD/8 - 1;
					else
						wordcntCrcLast := quot;
						residCrc := resid - 2;
					end if;

					for i in 0 to wD/8-1 loop
						if residCrc>=i then
							lastAXIS_tkeep(i) := '1';
						else
							lastAXIS_tkeep(i) := '0';
						end if;
					end loop;
				end if;

				if wordcntCrcLast=0 then
					crcAXIS_tkeep <= lastAXIS_tkeep;
					crclast <= '1';

					if wordcntLast=0 then
						txlast <= '1';
					else
						txlast <= '0';
					end if;

				else
					crcAXIS_tkeep <= (others => '1');
					crclast <= '0';
					txlast <= '0';
				end if;

				wordcnt := 0;

				crcdone <= '0';
				
				stateOp <= stateOpTxB;

			elsif stateOp=stateOpTxB then -- load into txAXIS_tdata
				for i in 0 to wD/8-1 loop
					txAXIS_tdata(8*(i+1)-1 downto 8*i) <= retbuf(wordcnt*wD/8+i);
				end loop;

				stateOp <= stateOpTxC;

			elsif stateOp=stateOpTxC then
				if wordcnt=wordcntCrcLast then
					crcdone <= '1';

					stateOp <= stateOpTxD;
				
				else
					stateOp <= stateOpTxE;
				end if;

			elsif stateOp=stateOpTxD then
				if resid=0 then
					txAXIS_tdata(wD-1 downto wD-8) <= crc(15 downto 8);
					retbuf(ixRetbufCrc + 1) <= crc(7 downto 0);

				elsif resid=1 then
					retbuf(ixRetbufCrc) <= crc(15 downto 8);
					retbuf(ixRetbufCrc + 1) <= crc(7 downto 0);

				else
					-- ex. wD = 32, resid = 2, i.e. -CCX => crc(15..8) into 15..8; crc(7..0) into 23..16
					txAXIS_tdata(resid*8-1 downto (resid-1)*8) <= crc(15 downto 8);
					txAXIS_tdata((resid+1)*8-1 downto resid*8) <= crc(7 downto 0);
				end if;

				stateOp <= stateOpTxE;

			elsif stateOp=stateOpTxE then
				if txAXIS_tready='1' then
					if wordcnt=wordcntLast then
						crcAXIS_tkeep <= (others => '1');
						crclast <= '0';
						crcdone <= '0';
						txlast <= '0';

						stateOp <= stateOpTxF;
					
					else
						wordcnt := wordcnt + 1;

						if wordcnt=wordcntLast then
							txlast <= '1';
						end if;

						if wordcnt=wordcntCrcLast then
							crcAXIS_tkeep <= lastAXIS_tkeep;
							crclast <= '1';
						end if;

						stateOp <= stateOpTxB;
					end if;
				end if;

			elsif stateOp=stateOpTxF then
				if dneTx='1' then
					rxlen <= (others => '0');

					stateOp <= stateOpTxG;
				end if;

			elsif stateOp=stateOpTxG then -- reqRx='1', rxAXIS_tready'1'
				if rxAXIS_tvalid='1' then
					if rxAXIS_tdata(7 downto 0)/=tru8 then
						stateOp <= stateOpIdle; -- offer chance to re-retrieve the return of a command
					else
						stateOp <= stateOpInit;
					end if;
				end if;

-- TX END, TX BUF BEGIN
			elsif stateOp=stateOpTxbufA then -- reqTxbuf='1'
				if ackTxbuf='1' then
					full_vec := resize(unsigned(len), 32) + 1; -- +2 (for CRC) -1

					if wD=8 then
						txlen <= std_logic_vector(full_vec);
						wordcntLast := to_integer(full_vec);
						wordcntCrcLast := to_integer(unsigned(len) - 1);
					elsif wD=16 then
						txlen <= "0" & std_logic_vector(full_vec(31 downto 1));
						wordcntLast := to_integer(full_vec(31 downto 1));
						wordcntCrcLast := to_integer(full_vec(31 downto 1) - 1);
					elsif wD=32 then
						txlen <= "00" & std_logic_vector(full_vec(31 downto 2));
						wordcntLast := to_integer(full_vec(31 downto 2));
						wordcntCrcLast := to_integer(full_vec(31 downto 2) - 1);
					elsif wD=64 then
						txlen <= "000" & std_logic_vector(full_vec(31 downto 3));
						wordcntLast := to_integer(full_vec(31 downto 3));
						wordcntCrcLast := to_integer(full_vec(31 downto 3) - 1);
					elsif wD=128 then
						txlen <= "0000" & std_logic_vector(full_vec(31 downto 4));
						wordcntLast := to_integer(full_vec(31 downto 4));
						wordcntCrcLast := to_integer(full_vec(31 downto 4) - 1);
					end if;

					crcAXIS_tkeep <= (others => '1');

					if wordcntCrcLast=0 then
						crclast <= '1';
					else
						crclast <= '0';
					end if;

					txlast <= '0';

					wordcnt := 0;

					crcdone <= '0';

					stateOp <= stateOpTxbufB;
				end if;

			elsif stateOp=stateOpTxbufB then -- load into txAXIS_tdata
				if txbufAXIS_tvalid='1' then
					txAXIS_tdata <= txbufAXIS_tdata;

					stateOp <= stateOpTxbufC;
				end if;

			elsif stateOp=stateOpTxbufC then -- calc CRC on txAXIS_tdata
				if wordcnt=wordcntCrcLast then
					crcdone <= '1';
				end if;

				stateOp <= stateOpTxbufE;

			elsif stateOp=stateOpTxbufD then
				if wD=8 and wordcnt=wordcntLast-1 then
					txAXIS_tdata <= crc(15 downto 8);
				elsif wD=8 and wordcnt=wordcntLast then
					txAXIS_tdata <= crc(7 downto 0);
				--else
				--	txAXIS_tdata(7 downto 0) <= crc(15 downto 8);
				--	txAXIS_tdata(15 downto 8) <= crc(7 downto 0);
				end if;

				stateOp <= stateOpTxbufE;

			elsif stateOp=stateOpTxbufE then
				if txAXIS_tready='1' then
					if wordcnt=wordcntLast then
						crcAXIS_tkeep <= (others => '1');
						crclast <= '0';
						crcdone <= '0';
						txlast <= '0';

						stateOp <= stateOpTxbufF;
					
					else
						wordcnt := wordcnt + 1;

						if wordcnt=wordcntLast then
							txlast <= '1';
						end if;

						if wordcnt=wordcntCrcLast then
							crclast <= '1';
						end if;

						if wordcnt>wordcntCrcLast then
							stateOp <= stateOpTxbufD;
						else
							stateOp <= stateOpTxbufB;
						end if;
					end if;
				end if;

			elsif stateOp=stateOpTxbufF then
				if dneTx='1' then
					rxlen <= (others => '0');

					stateOp <= stateOpTxbufG;
				end if;

			elsif stateOp=stateOpTxbufG then -- reqRx='1', rxAXIS_tready'1'
				if rxAXIS_tvalid='1' then
					if rxAXIS_tdata(7 downto 0)/=tru8 then
						stateOp <= stateOpInit;
					else
						stateOp <= stateOpTxbufH;
					end if;
				end if;

			elsif stateOp=stateOpTxbufH then -- dneTxbuf='1'
				if ackTxbuf='0' then
					stateOp <= stateOpInit;
				end if;

-- TX BUF END, RX BEGIN
			elsif stateOp=stateOpRxA then
				full_vec := resize(unsigned(lenInv), 32) + 1; -- +2 (for CRC) -1
				if wD=8 then
					rxlen <= std_logic_vector(full_vec);
					wordcntLast := to_integer(full_vec);

				else
					if wD=16 then
						quot := to_integer(full_vec(31 downto 1));
						resid := to_integer(unsigned(full_vec(0 downto 0)));
					elsif wD=32 then
						quot := to_integer(full_vec(31 downto 2));
						resid := to_integer(unsigned(full_vec(1 downto 0)));
					elsif wD=64 then
						quot := to_integer(full_vec(31 downto 3));
						resid := to_integer(unsigned(full_vec(2 downto 0)));
					elsif wD=128 then
						quot := to_integer(full_vec(31 downto 4));
						resid := to_integer(unsigned(full_vec(3 downto 0)));
					end if;

					rxlen <= std_logic_vector(to_unsigned(quot, 32));

					for i in 0 to wD/8-1 loop
						if resid>=i then
							lastAXIS_tkeep(i) := '1';
						else
							lastAXIS_tkeep(i) := '0';
						end if;
					end loop;

					wordcntLast := quot;
				end if;

				wordcnt := 0;

				stateOp <= stateOpRxB;

			elsif stateOp=stateOpRxB then -- reqRx='1', rxAXIS_tready='1'
				if rxAXIS_tvalid='1' then
					for i in 0 to wD/8-1 loop
						invbuf(wordcnt*wD/8+i) <= rxAXIS_tdata(8*(i+1)-1 downto 8*i);
					end loop;

					if wordcnt=wordcntLast-1 then
						crcAXIS_tkeep <= lastAXIS_tkeep;
						crclast <= '1';

						wordcnt := wordcnt + 1;

					elsif wordcnt=wordcntLast then
						stateOp <= stateOpRxC;

					else
						wordcnt := wordcnt + 1;
					end if;
				end if;

			elsif stateOp=stateOpRxC then
				crcAXIS_tkeep <= (others => '1');
				crclast <= '0';

				if crc=x"0000" then
					txlen <= (others => '0');
					txlast <= '1';

					txAXIS_tdata(7 downto 0) <= tru8;

					stateOp <= stateOpRxD;
				
				else
					commok_sig <= '0';

					stateOp <= stateOpInit;
				end if;

			elsif stateOp=stateOpRxD then -- reqTx='1', txAXIS_tvalid='1', txAXIS_tlast='1'
				if dneTx='1' then
					stateOp <= stateOpInv;
				end if;

-- RX END, RX BUF BEGIN
			elsif stateOp=stateOpRxbufA then -- reqRxbuf='1'
				if ackRxbuf='1' then
					full_vec := resize(unsigned(len), 32) + 1; -- +2 (for CRC) -1
					if wD=8 then
						rxlen <= std_logic_vector(full_vec);
						wordcntLast := to_integer(full_vec);

					else
						if wD=16 then
							quot := to_integer(full_vec(31 downto 1));
							resid := to_integer(unsigned(full_vec(0 downto 0)));
						elsif wD=32 then
							quot := to_integer(full_vec(31 downto 2));
							resid := to_integer(unsigned(full_vec(1 downto 0)));
						elsif wD=64 then
							quot := to_integer(full_vec(31 downto 3));
							resid := to_integer(unsigned(full_vec(2 downto 0)));
						elsif wD=128 then
							quot := to_integer(full_vec(31 downto 4));
							resid := to_integer(unsigned(full_vec(3 downto 0)));
						end if;

						rxlen <= std_logic_vector(to_unsigned(quot, 32));

						for i in 0 to wD/8-1 loop
							if resid>=i then
								lastAXIS_tkeep(i) := '1';
							else
								lastAXIS_tkeep(i) := '0';
							end if;
						end loop;

						wordcntLast := quot;
					end if;

					wordcnt := 0;

					stateOp <= stateOpRxbufB;
				end if;

			elsif stateOp=stateOpRxbufB then -- reqRx='1', rxAXIS_tready='1'
				if rxAXIS_tvalid='1' then
					rxbufAXIS_tdata <= rxAXIS_tdata;

					if wordcnt=wordcntLast-2 and (wD=8 or resid<=1) then
						rxbuflast <= '1';

						wordcnt := wordcnt + 1;

						stateOp <= stateOpRxbufC;

					elsif wordcnt=wordcntLast-1 then
						rxbuflast <= '1';

						crcAXIS_tkeep <= lastAXIS_tkeep;
						crclast <= '1';

						wordcnt := wordcnt + 1;

						if wD=8 or resid<=1 then
							stateOp <= stateOpRxbufB;
						else
							stateOp <= stateOpRxbufC;
						end if;

					elsif wordcnt=wordcntLast then
						stateOp <= stateOpRxbufD;

					else
						wordcnt := wordcnt + 1;

						stateOp <= stateOpRxbufC;
					end if;
				end if;

			elsif stateOp=stateOpRxbufC then -- rxbufAXIS_tvalid='1'
				if rxbufAXIS_tready='1' then
					stateOp <= stateOpRxbufB;
				end if;

			elsif stateOp=stateOpRxbufD then
				crcAXIS_tkeep <= (others => '1');
				crclast <= '0';

				if crc=x"0000" then
					txlen <= (others => '0');
					txlast <= '1';

					txAXIS_tdata(7 downto 0) <= tru8;

					stateOp <= stateOpRxbufE;
				
				else
					commok_sig <= '0';

					stateOp <= stateOpInit;
				end if;

			elsif stateOp=stateOpRxbufE then -- reqTx='1', txAXIS_tvalid='1', txAXIS_tlast='1'
				if dneTx='1' then
					stateOp <= stateOpRxbufF;
				end if;

			elsif stateOp=stateOpRxbufF then -- reqRxbuf='1', dneRxbuf='1'
				if ackRxbuf='0' then
					stateOp <= stateOpInit;
				end if;
-- RX BUF END

			elsif stateOp=stateOpInv then -- reqInv='1
				if tixVController=tixVClebControllerHostif and tixVCommand=x"00" then
					reqReset_sig <= '1';

				elsif ackInv='1' then
					if tixVController=tixVClebControllerIdent then
						if tixVCommand=tixVIdentCommandGet then
							for i in 0 to 7 loop
								retbuf(7-i) <= identGetVer((8-i)*8-1 downto (7-i)*8);
							end loop;
							for i in 0 to 7 loop
								retbuf(8+7-i) <= identGetHash((8-i)*8-1 downto (7-i)*8);
							end loop;
							for i in 0 to 7 loop
								retbuf(16+7-i) <= identGetWho((8-i)*8-1 downto (7-i)*8);
							end loop;
						elsif tixVCommand=tixVIdentCommandGetCfg then
							for i in 0 to 3 loop
								retbuf(i) <= identGetCfgFMclk((4-i)*8-1 downto (3-i)*8);
							end loop;
						end if;

					elsif tixVController=tixVClebControllerMfsmtrack0 then
						if tixVCommand=tixVMfsmtrack0CommandGetInfo then
							retbuf(0) <= mfsmtrack0GetInfoTixVState;
							for i in 0 to 31 loop
								retbuf(1+31-i) <= mfsmtrack0GetInfoCoverage((32-i)*8-1 downto (31-i)*8);
							end loop;
						end if;

					elsif tixVController=tixVClebControllerMfsmtrack1 then
						if tixVCommand=tixVMfsmtrack1CommandGetInfo then
							retbuf(0) <= mfsmtrack1GetInfoTixVState;
							for i in 0 to 31 loop
								retbuf(1+31-i) <= mfsmtrack1GetInfoCoverage((32-i)*8-1 downto (31-i)*8);
							end loop;
						end if;

					elsif tixVController=tixVClebControllerMgptrack then
						if tixVCommand=tixVMgptrackCommandGetInfo then
							retbuf(0) <= mgptrackGetInfoTixVState;
						end if;

					elsif tixVController=tixVClebControllerState then
						if tixVCommand=tixVStateCommandGet then
							retbuf(0) <= stateGetTixVClebState;
						end if;

					elsif tixVController=tixVClebControllerTkclksrc then
						if tixVCommand=tixVTkclksrcCommandGetTkst then
							for i in 0 to 3 loop
								retbuf(i) <= tkclksrcGetTkstTkst((4-i)*8-1 downto (3-i)*8);
							end loop;
						end if;

					end if;

					stateOp <= stateOpIdle; -- not init, so cmdretToHostif (maintaining tixVController/tixVCommand) can be run
				end if;
			end if;
		end if;
	end process;

end Rtl;
