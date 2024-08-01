-- file Wted_core.vhd
-- Wted_core top_v1_0 top implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 30 Jun 2024
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Cleb.all;

entity Wted_core is
	generic (
		fAclk: natural := 50000;
		fMclk: natural := 50000
	);
	port (
		--extclk: in std_logic;
		
		aresetn: in std_logic;
		btn0: in std_logic;
		hosi: in std_logic;
		hiso: out std_logic;

		rgb0_r: out std_logic;
		rgb0_g: out std_logic;
		rgb0_b: out std_logic
	);
end Wted_core;

architecture Rtl of Wted_core is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Debounce_v1_0 is
		generic (
			invert: boolean := false;
			tdead: natural range 1 to 10000 := 100
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;

			noisy: in std_logic;
			clean: out std_logic
		);
	end component;

	component Hostif is
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

			reqSeqbufFromMfsmtrack1: out std_logic;

			fstoccbufFromMfsmtrack1AXIS_tready: out std_logic;

			ackSeqbufFromMfsmtrack1: in std_logic;

			fstoccbufFromMfsmtrack1AXIS_tvalid: in std_logic;

			dneSeqbufFromMfsmtrack1: out std_logic;

			fstoccbufFromMfsmtrack1AXIS_tdata: in std_logic_vector(7 downto 0);

			avllenSeqbufFromMfsmtrack1: in std_logic_vector(31 downto 0);

			fstoccbufFromMfsmtrack1AXIS_tlast: in std_logic;

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
	end component;

	component IB is
		port (
			O: out std_logic;
			I: in std_logic
		);
	end component;

	component Ident is
		generic (
			fMclk: natural := 0
		);
		port (
			getVer: out std_logic_vector(63 downto 0);
			getHash: out std_logic_vector(63 downto 0);
			getWho: out std_logic_vector(63 downto 0);

			getCfgFMclk: out std_logic_vector(31 downto 0)
		);
	end component;

	component Mfsmtrack0 is
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
			cntbufToHostifAXIS_tdata: out std_logic_vector(7 downto 0);
			cntbufToHostifAXIS_tlast: out std_logic;

			reqFstoccbufToHostif: in std_logic;
			ackFstoccbufToHostif: out std_logic;
			dneFstoccbufToHostif: in std_logic;
			avllenFstoccbufToHostif: out std_logic_vector(31 downto 0);

			fstoccbufToHostifAXIS_tready: in std_logic;
			fstoccbufToHostifAXIS_tvalid: out std_logic;
			fstoccbufToHostifAXIS_tdata: out std_logic_vector(7 downto 0);
			fstoccbufToHostifAXIS_tlast: out std_logic;

			reqSeqbufToHostif: in std_logic;
			ackSeqbufToHostif: out std_logic;
			dneSeqbufToHostif: in std_logic;
			avllenSeqbufToHostif: out std_logic_vector(31 downto 0);

			seqbufToHostifAXIS_tready: in std_logic;
			seqbufToHostifAXIS_tvalid: out std_logic;
			seqbufToHostifAXIS_tdata: out std_logic_vector(7 downto 0);
			seqbufToHostifAXIS_tlast: out std_logic;

			hostifStateOp: in std_logic_vector(7 downto 0)
		);
	end component;

	component Mfsmtrack1 is
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
			cntbufToHostifAXIS_tdata: out std_logic_vector(7 downto 0);
			cntbufToHostifAXIS_tlast: out std_logic;

			reqFstoccbufToHostif: in std_logic;
			ackFstoccbufToHostif: out std_logic;
			dneFstoccbufToHostif: in std_logic;
			avllenFstoccbufToHostif: out std_logic_vector(31 downto 0);

			fstoccbufToHostifAXIS_tready: in std_logic;
			fstoccbufToHostifAXIS_tvalid: out std_logic;
			fstoccbufToHostifAXIS_tdata: out std_logic_vector(7 downto 0);
			fstoccbufToHostifAXIS_tlast: out std_logic;

			reqSeqbufToHostif: in std_logic;
			ackSeqbufToHostif: out std_logic;
			dneSeqbufToHostif: in std_logic;
			avllenSeqbufToHostif: out std_logic_vector(31 downto 0);

			seqbufToHostifAXIS_tready: in std_logic;
			seqbufToHostifAXIS_tvalid: out std_logic;
			seqbufToHostifAXIS_tdata: out std_logic_vector(7 downto 0);
			seqbufToHostifAXIS_tlast: out std_logic;

			tkclksrcStateOp: in std_logic_vector(7 downto 0)
		);
	end component;

	component Mgptrack is
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
			seqbufToHostifAXIS_tdata: out std_logic_vector(7 downto 0);
			seqbufToHostifAXIS_tlast: out std_logic;

			tkclk: in std_logic;
			rgb0_r: in std_logic;
			rgb0_g: in std_logic;
			rgb0_b: in std_logic;
			btn0: in std_logic;
			btn0_sig: in std_logic;
			tkclksrcGetTkstTkst: in std_logic_vector(7 downto 0)
		);
	end component;

	component Osc_div9 is
		port (
			hf_clk_out_o: out std_logic;
			hf_out_en_i: in std_logic
		);
	end component;

	component Rgbled_v1_0 is
		generic (
			fMclk: natural := 50000
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			rgb: in std_logic_vector(23 downto 0);

			r: out std_logic;
			g: out std_logic;
			b: out std_logic
		);
	end component;

	component State is
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;

			getTixVClebState: out std_logic_vector(7 downto 0);

			commok: in std_logic;
			rgb: out std_logic_vector(23 downto 0)
		);
	end component;

	component Tkclksrc_Easy_v1_0 is
		generic (
			fMclk: natural := 50000
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: out std_logic;

			getTkstTkst: out std_logic_vector(31 downto 0);

			reqInvSetTkst: in std_logic;
			ackInvSetTkst: out std_logic;

			setTkstTkst: in std_logic_vector(31 downto 0);

			stateOp_dbg: out std_logic_vector(7 downto 0)
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- mclk wiring and reset (mclk)

	signal reset: std_logic;
	signal mclk: std_logic;

	-- IP sigs.mclk.cust --- INSERT

	---- myDebounceBtn0
	signal btn0_sig: std_logic;

	---- myHostif
	signal commok: std_logic;
	signal hostifRxAXIS_tvalid: std_logic;

	signal mgptrackSelectStaTixVTrigger: std_logic_vector(7 downto 0);
	signal mgptrackSelectStaFallingNotRising: std_logic_vector(7 downto 0);
	signal mgptrackSelectStoTixVTrigger: std_logic_vector(7 downto 0);
	signal mgptrackSelectStoFallingNotRising: std_logic_vector(7 downto 0);

	signal mgptrackSetRng: std_logic_vector(7 downto 0);
	signal mgptrackSetTCapt: std_logic_vector(31 downto 0);

	signal mfsmtrack1SelectTixVCapture: std_logic_vector(7 downto 0);
	signal mfsmtrack1SelectStaTixVTrigger: std_logic_vector(7 downto 0);
	signal mfsmtrack1SelectStaFallingNotRising: std_logic_vector(7 downto 0);
	signal mfsmtrack1SelectStoTixVTrigger: std_logic_vector(7 downto 0);
	signal mfsmtrack1SelectStoFallingNotRising: std_logic_vector(7 downto 0);

	signal mfsmtrack1SetRng: std_logic_vector(7 downto 0);
	signal mfsmtrack1SetTCapt: std_logic_vector(31 downto 0);

	signal tkclksrcSetTkstTkst: std_logic_vector(31 downto 0);

	signal cntbufMfsmtrack0ToHostifAXIS_tready: std_logic;

	signal mfsmtrack0SelectTixVCapture: std_logic_vector(7 downto 0);
	signal mfsmtrack0SelectStaTixVTrigger: std_logic_vector(7 downto 0);
	signal mfsmtrack0SelectStaFallingNotRising: std_logic_vector(7 downto 0);
	signal mfsmtrack0SelectStoTixVTrigger: std_logic_vector(7 downto 0);

	signal fstoccbufMfsmtrack0ToHostifAXIS_tready: std_logic;

	signal mfsmtrack0SelectStoFallingNotRising: std_logic_vector(7 downto 0);

	signal mfsmtrack0SetRng: std_logic_vector(7 downto 0);
	signal mfsmtrack0SetTCapt: std_logic_vector(31 downto 0);

	signal seqbufMfsmtrack0ToHostifAXIS_tready: std_logic;

	signal cntbufMfsmtrack1ToHostifAXIS_tready: std_logic;

	signal fstoccbufMfsmtrack1ToHostifAXIS_tready: std_logic;

	signal seqbufMfsmtrack1ToHostifAXIS_tready: std_logic;

	signal seqbufMgptrackToHostifAXIS_tready: std_logic;

	signal hostifStateOp_dbg: std_logic_vector(7 downto 0);

	---- myIdent
	signal identGetVer: std_logic_vector(63 downto 0);
	signal identGetHash: std_logic_vector(63 downto 0);
	signal identGetWho: std_logic_vector(63 downto 0);

	signal identGetCfgFMclk: std_logic_vector(31 downto 0);

	---- myMfsmtrack0
	signal avllenCntbufMfsmtrack0ToHostif: std_logic_vector(31 downto 0);

	signal mfsmtrack0GetInfoTixVState: std_logic_vector(7 downto 0);

	signal cntbufMfsmtrack0ToHostifAXIS_tvalid: std_logic;

	signal mfsmtrack0GetInfoCoverage: std_logic_vector(255 downto 0);

	signal cntbufMfsmtrack0ToHostifAXIS_tdata: std_logic_vector(7 downto 0);
	signal cntbufMfsmtrack0ToHostifAXIS_tlast: std_logic;

	signal avllenFstoccbufMfsmtrack0ToHostif: std_logic_vector(31 downto 0);

	signal fstoccbufMfsmtrack0ToHostifAXIS_tvalid: std_logic;
	signal fstoccbufMfsmtrack0ToHostifAXIS_tdata: std_logic_vector(7 downto 0);
	signal fstoccbufMfsmtrack0ToHostifAXIS_tlast: std_logic;

	signal avllenSeqbufMfsmtrack0ToHostif: std_logic_vector(31 downto 0);

	signal seqbufMfsmtrack0ToHostifAXIS_tvalid: std_logic;
	signal seqbufMfsmtrack0ToHostifAXIS_tdata: std_logic_vector(7 downto 0);
	signal seqbufMfsmtrack0ToHostifAXIS_tlast: std_logic;

	---- myMfsmtrack1
	signal mfsmtrack1GetInfoTixVState: std_logic_vector(7 downto 0);
	signal mfsmtrack1GetInfoCoverage: std_logic_vector(255 downto 0);

	signal avllenCntbufMfsmtrack1ToHostif: std_logic_vector(31 downto 0);

	signal cntbufMfsmtrack1ToHostifAXIS_tvalid: std_logic;
	signal cntbufMfsmtrack1ToHostifAXIS_tdata: std_logic_vector(7 downto 0);
	signal cntbufMfsmtrack1ToHostifAXIS_tlast: std_logic;

	signal avllenFstoccbufMfsmtrack1ToHostif: std_logic_vector(31 downto 0);

	signal fstoccbufMfsmtrack1ToHostifAXIS_tvalid: std_logic;
	signal fstoccbufMfsmtrack1ToHostifAXIS_tdata: std_logic_vector(7 downto 0);
	signal fstoccbufMfsmtrack1ToHostifAXIS_tlast: std_logic;

	signal avllenSeqbufMfsmtrack1ToHostif: std_logic_vector(31 downto 0);

	signal seqbufMfsmtrack1ToHostifAXIS_tvalid: std_logic;
	signal seqbufMfsmtrack1ToHostifAXIS_tdata: std_logic_vector(7 downto 0);
	signal seqbufMfsmtrack1ToHostifAXIS_tlast: std_logic;

	---- myMgptrack
	signal mgptrackGetInfoTixVState: std_logic_vector(7 downto 0);

	signal avllenSeqbufMgptrackToHostif: std_logic_vector(31 downto 0);

	signal seqbufMgptrackToHostifAXIS_tvalid: std_logic;
	signal seqbufMgptrackToHostifAXIS_tdata: std_logic_vector(7 downto 0);
	signal seqbufMgptrackToHostifAXIS_tlast: std_logic;

	---- myRgbled0
	signal rgb0_r_sig: std_logic;
	signal rgb0_g_sig: std_logic;
	signal rgb0_b_sig: std_logic;

	---- myState
	signal rgb0: std_logic_vector(23 downto 0);

	signal stateGetTixVClebState: std_logic_vector(7 downto 0);

	---- myTkclksrc
	signal tkclk: std_logic;

	signal tkclksrcGetTkstTkst: std_logic_vector(31 downto 0);

	signal tkclksrcStateOp_dbg: std_logic_vector(7 downto 0);

	---- handshake
	-- myHostif to (many)
	signal reqResetFromHostif: std_logic;

	-- myHostif to myMgptrack
	signal reqInvMgptrackSelect: std_logic;
	signal ackInvMgptrackSelect: std_logic;

	-- myHostif to myMgptrack
	signal reqInvMgptrackSet: std_logic;
	signal ackInvMgptrackSet: std_logic;

	-- myHostif to myMfsmtrack1
	signal reqInvMfsmtrack1Select: std_logic;
	signal ackInvMfsmtrack1Select: std_logic;

	-- myHostif to myMfsmtrack1
	signal reqInvMfsmtrack1Set: std_logic;
	signal ackInvMfsmtrack1Set: std_logic;

	-- myHostif to myMfsmtrack0
	signal reqCntbufMfsmtrack0ToHostif: std_logic;
	signal ackCntbufMfsmtrack0ToHostif: std_logic;
	signal dneCntbufMfsmtrack0ToHostif: std_logic;

	-- myHostif to myTkclksrc
	signal reqInvTkclksrcSetTkst: std_logic;
	signal ackInvTkclksrcSetTkst: std_logic;

	-- myHostif to myMfsmtrack0
	signal reqInvMfsmtrack0Select: std_logic;
	signal ackInvMfsmtrack0Select: std_logic;

	-- myHostif to myMfsmtrack0
	signal reqFstoccbufMfsmtrack0ToHostif: std_logic;
	signal ackFstoccbufMfsmtrack0ToHostif: std_logic;
	signal dneFstoccbufMfsmtrack0ToHostif: std_logic;

	-- myHostif to myMfsmtrack0
	signal reqInvMfsmtrack0Set: std_logic;
	signal ackInvMfsmtrack0Set: std_logic;

	-- myHostif to myMfsmtrack0
	signal reqSeqbufMfsmtrack0ToHostif: std_logic;
	signal ackSeqbufMfsmtrack0ToHostif: std_logic;
	signal dneSeqbufMfsmtrack0ToHostif: std_logic;

	-- myHostif to myMfsmtrack1
	signal reqCntbufMfsmtrack1ToHostif: std_logic;
	signal ackCntbufMfsmtrack1ToHostif: std_logic;
	signal dneCntbufMfsmtrack1ToHostif: std_logic;

	-- myHostif to myMfsmtrack1
	signal reqFstoccbufMfsmtrack1ToHostif: std_logic;
	signal ackFstoccbufMfsmtrack1ToHostif: std_logic;
	signal dneFstoccbufMfsmtrack1ToHostif: std_logic;

	-- myHostif to myMfsmtrack1
	signal reqSeqbufMfsmtrack1ToHostif: std_logic;
	signal ackSeqbufMfsmtrack1ToHostif: std_logic;
	signal dneSeqbufMfsmtrack1ToHostif: std_logic;

	-- myHostif to myMgptrack
	signal reqSeqbufMgptrackToHostif: std_logic;
	signal ackSeqbufMgptrackToHostif: std_logic;
	signal dneSeqbufMgptrackToHostif: std_logic;

	---- other
	signal aclk: std_logic;
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myDebounceBtn0 : Debounce_v1_0
		generic map (
			invert => false,
			tdead => 100
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			noisy => btn0,
			clean => btn0_sig
		);

	myHostif : Hostif
		generic map (
			fSclk => 115200,
			fMclk => fMclk
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,
			commok => commok,
			reqReset => reqResetFromHostif,

			mgptrackGetInfoTixVState => mgptrackGetInfoTixVState,

			reqInvMgptrackSelect => reqInvMgptrackSelect,
			ackInvMgptrackSelect => ackInvMgptrackSelect,

			mgptrackSelectStaTixVTrigger => mgptrackSelectStaTixVTrigger,
			mgptrackSelectStaFallingNotRising => mgptrackSelectStaFallingNotRising,
			mgptrackSelectStoTixVTrigger => mgptrackSelectStoTixVTrigger,
			mgptrackSelectStoFallingNotRising => mgptrackSelectStoFallingNotRising,

			reqInvMgptrackSet => reqInvMgptrackSet,
			ackInvMgptrackSet => ackInvMgptrackSet,

			mgptrackSetRng => mgptrackSetRng,
			mgptrackSetTCapt => mgptrackSetTCapt,

			mfsmtrack1GetInfoTixVState => mfsmtrack1GetInfoTixVState,
			mfsmtrack1GetInfoCoverage => mfsmtrack1GetInfoCoverage,

			reqInvMfsmtrack1Select => reqInvMfsmtrack1Select,
			ackInvMfsmtrack1Select => ackInvMfsmtrack1Select,

			mfsmtrack1SelectTixVCapture => mfsmtrack1SelectTixVCapture,
			mfsmtrack1SelectStaTixVTrigger => mfsmtrack1SelectStaTixVTrigger,
			mfsmtrack1SelectStaFallingNotRising => mfsmtrack1SelectStaFallingNotRising,
			mfsmtrack1SelectStoTixVTrigger => mfsmtrack1SelectStoTixVTrigger,
			mfsmtrack1SelectStoFallingNotRising => mfsmtrack1SelectStoFallingNotRising,

			reqInvMfsmtrack1Set => reqInvMfsmtrack1Set,
			ackInvMfsmtrack1Set => ackInvMfsmtrack1Set,

			mfsmtrack1SetRng => mfsmtrack1SetRng,
			mfsmtrack1SetTCapt => mfsmtrack1SetTCapt,

			stateGetTixVClebState => stateGetTixVClebState,

			tkclksrcGetTkstTkst => tkclksrcGetTkstTkst,

			reqInvTkclksrcSetTkst => reqInvTkclksrcSetTkst,
			ackInvTkclksrcSetTkst => ackInvTkclksrcSetTkst,

			tkclksrcSetTkstTkst => tkclksrcSetTkstTkst,

			mfsmtrack0GetInfoTixVState => mfsmtrack0GetInfoTixVState,
			mfsmtrack0GetInfoCoverage => mfsmtrack0GetInfoCoverage,

			reqInvMfsmtrack0Select => reqInvMfsmtrack0Select,
			ackInvMfsmtrack0Select => ackInvMfsmtrack0Select,

			mfsmtrack0SelectTixVCapture => mfsmtrack0SelectTixVCapture,
			mfsmtrack0SelectStaTixVTrigger => mfsmtrack0SelectStaTixVTrigger,
			mfsmtrack0SelectStaFallingNotRising => mfsmtrack0SelectStaFallingNotRising,
			mfsmtrack0SelectStoTixVTrigger => mfsmtrack0SelectStoTixVTrigger,
			mfsmtrack0SelectStoFallingNotRising => mfsmtrack0SelectStoFallingNotRising,

			reqInvMfsmtrack0Set => reqInvMfsmtrack0Set,
			ackInvMfsmtrack0Set => ackInvMfsmtrack0Set,

			mfsmtrack0SetRng => mfsmtrack0SetRng,
			mfsmtrack0SetTCapt => mfsmtrack0SetTCapt,

			identGetVer => identGetVer,
			identGetHash => identGetHash,
			identGetWho => identGetWho,

			identGetCfgFMclk => identGetCfgFMclk,

			reqCntbufFromMfsmtrack0 => reqCntbufMfsmtrack0ToHostif,
			ackCntbufFromMfsmtrack0 => ackCntbufMfsmtrack0ToHostif,
			dneCntbufFromMfsmtrack0 => dneCntbufMfsmtrack0ToHostif,
			avllenCntbufFromMfsmtrack0 => avllenCntbufMfsmtrack0ToHostif,

			cntbufFromMfsmtrack0AXIS_tready => cntbufMfsmtrack0ToHostifAXIS_tready,
			cntbufFromMfsmtrack0AXIS_tvalid => cntbufMfsmtrack0ToHostifAXIS_tvalid,
			cntbufFromMfsmtrack0AXIS_tdata => cntbufMfsmtrack0ToHostifAXIS_tdata,
			cntbufFromMfsmtrack0AXIS_tlast => cntbufMfsmtrack0ToHostifAXIS_tlast,

			reqFstoccbufFromMfsmtrack0 => reqFstoccbufMfsmtrack0ToHostif,
			ackFstoccbufFromMfsmtrack0 => ackFstoccbufMfsmtrack0ToHostif,
			dneFstoccbufFromMfsmtrack0 => dneFstoccbufMfsmtrack0ToHostif,
			avllenFstoccbufFromMfsmtrack0 => avllenFstoccbufMfsmtrack0ToHostif,

			fstoccbufFromMfsmtrack0AXIS_tready => fstoccbufMfsmtrack0ToHostifAXIS_tready,
			fstoccbufFromMfsmtrack0AXIS_tvalid => fstoccbufMfsmtrack0ToHostifAXIS_tvalid,
			fstoccbufFromMfsmtrack0AXIS_tdata => fstoccbufMfsmtrack0ToHostifAXIS_tdata,
			fstoccbufFromMfsmtrack0AXIS_tlast => fstoccbufMfsmtrack0ToHostifAXIS_tlast,

			reqSeqbufFromMfsmtrack0 => reqSeqbufMfsmtrack0ToHostif,
			ackSeqbufFromMfsmtrack0 => ackSeqbufMfsmtrack0ToHostif,
			dneSeqbufFromMfsmtrack0 => dneSeqbufMfsmtrack0ToHostif,
			avllenSeqbufFromMfsmtrack0 => avllenSeqbufMfsmtrack0ToHostif,

			seqbufFromMfsmtrack0AXIS_tready => seqbufMfsmtrack0ToHostifAXIS_tready,
			seqbufFromMfsmtrack0AXIS_tvalid => seqbufMfsmtrack0ToHostifAXIS_tvalid,
			seqbufFromMfsmtrack0AXIS_tdata => seqbufMfsmtrack0ToHostifAXIS_tdata,
			seqbufFromMfsmtrack0AXIS_tlast => seqbufMfsmtrack0ToHostifAXIS_tlast,

			reqCntbufFromMfsmtrack1 => reqCntbufMfsmtrack1ToHostif,
			ackCntbufFromMfsmtrack1 => ackCntbufMfsmtrack1ToHostif,
			dneCntbufFromMfsmtrack1 => dneCntbufMfsmtrack1ToHostif,
			avllenCntbufFromMfsmtrack1 => avllenCntbufMfsmtrack1ToHostif,

			cntbufFromMfsmtrack1AXIS_tready => cntbufMfsmtrack1ToHostifAXIS_tready,
			cntbufFromMfsmtrack1AXIS_tvalid => cntbufMfsmtrack1ToHostifAXIS_tvalid,
			cntbufFromMfsmtrack1AXIS_tdata => cntbufMfsmtrack1ToHostifAXIS_tdata,
			cntbufFromMfsmtrack1AXIS_tlast => cntbufMfsmtrack1ToHostifAXIS_tlast,

			reqFstoccbufFromMfsmtrack1 => reqFstoccbufMfsmtrack1ToHostif,
			ackFstoccbufFromMfsmtrack1 => ackFstoccbufMfsmtrack1ToHostif,
			dneFstoccbufFromMfsmtrack1 => dneFstoccbufMfsmtrack1ToHostif,
			avllenFstoccbufFromMfsmtrack1 => avllenFstoccbufMfsmtrack1ToHostif,

			reqSeqbufFromMfsmtrack1 => reqSeqbufMfsmtrack1ToHostif,

			fstoccbufFromMfsmtrack1AXIS_tready => fstoccbufMfsmtrack1ToHostifAXIS_tready,

			ackSeqbufFromMfsmtrack1 => ackSeqbufMfsmtrack1ToHostif,

			fstoccbufFromMfsmtrack1AXIS_tvalid => fstoccbufMfsmtrack1ToHostifAXIS_tvalid,

			dneSeqbufFromMfsmtrack1 => dneSeqbufMfsmtrack1ToHostif,

			fstoccbufFromMfsmtrack1AXIS_tdata => fstoccbufMfsmtrack1ToHostifAXIS_tdata,

			avllenSeqbufFromMfsmtrack1 => avllenSeqbufMfsmtrack1ToHostif,

			fstoccbufFromMfsmtrack1AXIS_tlast => fstoccbufMfsmtrack1ToHostifAXIS_tlast,

			seqbufFromMfsmtrack1AXIS_tready => seqbufMfsmtrack1ToHostifAXIS_tready,
			seqbufFromMfsmtrack1AXIS_tvalid => seqbufMfsmtrack1ToHostifAXIS_tvalid,
			seqbufFromMfsmtrack1AXIS_tdata => seqbufMfsmtrack1ToHostifAXIS_tdata,
			seqbufFromMfsmtrack1AXIS_tlast => seqbufMfsmtrack1ToHostifAXIS_tlast,

			reqSeqbufFromMgptrack => reqSeqbufMgptrackToHostif,
			ackSeqbufFromMgptrack => ackSeqbufMgptrackToHostif,
			dneSeqbufFromMgptrack => dneSeqbufMgptrackToHostif,
			avllenSeqbufFromMgptrack => avllenSeqbufMgptrackToHostif,

			seqbufFromMgptrackAXIS_tready => seqbufMgptrackToHostifAXIS_tready,
			seqbufFromMgptrackAXIS_tvalid => seqbufMgptrackToHostifAXIS_tvalid,
			seqbufFromMgptrackAXIS_tdata => seqbufMgptrackToHostifAXIS_tdata,
			seqbufFromMgptrackAXIS_tlast => seqbufMgptrackToHostifAXIS_tlast,

			rxAXIS_tvalid_sig => hostifRxAXIS_tvalid,

			rxd => hosi,
			txd => hiso,

			stateOp_dbg => hostifStateOp_dbg
		);

	myIdent : Ident
		generic map (
			fMclk => fMclk
		)
		port map (
			getVer => identGetVer,
			getHash => identGetHash,
			getWho => identGetWho,

			getCfgFMclk => identGetCfgFMclk
		);

	myMfsmtrack0 : Mfsmtrack0
		port map (
			reset => reset,
			mclk => mclk,

			hostifRxAXIS_tvalid => hostifRxAXIS_tvalid,
			ackInvTkclksrcSetTkst => ackInvTkclksrcSetTkst,

			getInfoTixVState => mfsmtrack0GetInfoTixVState,
			getInfoCoverage => mfsmtrack0GetInfoCoverage,

			reqInvSelect => reqInvMfsmtrack0Select,
			ackInvSelect => ackInvMfsmtrack0Select,

			selectTixVCapture => mfsmtrack0SelectTixVCapture,
			selectStaTixVTrigger => mfsmtrack0SelectStaTixVTrigger,
			selectStaFallingNotRising => mfsmtrack0SelectStaFallingNotRising,
			selectStoTixVTrigger => mfsmtrack0SelectStoTixVTrigger,
			selectStoFallingNotRising => mfsmtrack0SelectStoFallingNotRising,

			reqInvSet => reqInvMfsmtrack0Set,
			ackInvSet => ackInvMfsmtrack0Set,

			setRng => mfsmtrack0SetRng,
			setTCapt => mfsmtrack0SetTCapt,

			reqCntbufToHostif => reqCntbufMfsmtrack0ToHostif,
			ackCntbufToHostif => ackCntbufMfsmtrack0ToHostif,
			dneCntbufToHostif => dneCntbufMfsmtrack0ToHostif,
			avllenCntbufToHostif => avllenCntbufMfsmtrack0ToHostif,

			cntbufToHostifAXIS_tready => cntbufMfsmtrack0ToHostifAXIS_tready,
			cntbufToHostifAXIS_tvalid => cntbufMfsmtrack0ToHostifAXIS_tvalid,
			cntbufToHostifAXIS_tdata => cntbufMfsmtrack0ToHostifAXIS_tdata,
			cntbufToHostifAXIS_tlast => cntbufMfsmtrack0ToHostifAXIS_tlast,

			reqFstoccbufToHostif => reqFstoccbufMfsmtrack0ToHostif,
			ackFstoccbufToHostif => ackFstoccbufMfsmtrack0ToHostif,
			dneFstoccbufToHostif => dneFstoccbufMfsmtrack0ToHostif,
			avllenFstoccbufToHostif => avllenFstoccbufMfsmtrack0ToHostif,

			fstoccbufToHostifAXIS_tready => fstoccbufMfsmtrack0ToHostifAXIS_tready,
			fstoccbufToHostifAXIS_tvalid => fstoccbufMfsmtrack0ToHostifAXIS_tvalid,
			fstoccbufToHostifAXIS_tdata => fstoccbufMfsmtrack0ToHostifAXIS_tdata,
			fstoccbufToHostifAXIS_tlast => fstoccbufMfsmtrack0ToHostifAXIS_tlast,

			reqSeqbufToHostif => reqSeqbufMfsmtrack0ToHostif,
			ackSeqbufToHostif => ackSeqbufMfsmtrack0ToHostif,
			dneSeqbufToHostif => dneSeqbufMfsmtrack0ToHostif,
			avllenSeqbufToHostif => avllenSeqbufMfsmtrack0ToHostif,

			seqbufToHostifAXIS_tready => seqbufMfsmtrack0ToHostifAXIS_tready,
			seqbufToHostifAXIS_tvalid => seqbufMfsmtrack0ToHostifAXIS_tvalid,
			seqbufToHostifAXIS_tdata => seqbufMfsmtrack0ToHostifAXIS_tdata,
			seqbufToHostifAXIS_tlast => seqbufMfsmtrack0ToHostifAXIS_tlast,

			hostifStateOp => hostifStateOp_dbg
		);

	myMfsmtrack1 : Mfsmtrack1
		port map (
			reset => reset,
			mclk => mclk,

			hostifRxAXIS_tvalid => hostifRxAXIS_tvalid,
			ackInvTkclksrcSetTkst => ackInvTkclksrcSetTkst,

			getInfoTixVState => mfsmtrack1GetInfoTixVState,
			getInfoCoverage => mfsmtrack1GetInfoCoverage,

			reqInvSelect => reqInvMfsmtrack1Select,
			ackInvSelect => ackInvMfsmtrack1Select,

			selectTixVCapture => mfsmtrack1SelectTixVCapture,
			selectStaTixVTrigger => mfsmtrack1SelectStaTixVTrigger,
			selectStaFallingNotRising => mfsmtrack1SelectStaFallingNotRising,
			selectStoTixVTrigger => mfsmtrack1SelectStoTixVTrigger,
			selectStoFallingNotRising => mfsmtrack1SelectStoFallingNotRising,

			reqInvSet => reqInvMfsmtrack1Set,
			ackInvSet => ackInvMfsmtrack1Set,

			setRng => mfsmtrack1SetRng,
			setTCapt => mfsmtrack1SetTCapt,

			reqCntbufToHostif => reqCntbufMfsmtrack1ToHostif,
			ackCntbufToHostif => ackCntbufMfsmtrack1ToHostif,
			dneCntbufToHostif => dneCntbufMfsmtrack1ToHostif,
			avllenCntbufToHostif => avllenCntbufMfsmtrack1ToHostif,

			cntbufToHostifAXIS_tready => cntbufMfsmtrack1ToHostifAXIS_tready,
			cntbufToHostifAXIS_tvalid => cntbufMfsmtrack1ToHostifAXIS_tvalid,
			cntbufToHostifAXIS_tdata => cntbufMfsmtrack1ToHostifAXIS_tdata,
			cntbufToHostifAXIS_tlast => cntbufMfsmtrack1ToHostifAXIS_tlast,

			reqFstoccbufToHostif => reqFstoccbufMfsmtrack1ToHostif,
			ackFstoccbufToHostif => ackFstoccbufMfsmtrack1ToHostif,
			dneFstoccbufToHostif => dneFstoccbufMfsmtrack1ToHostif,
			avllenFstoccbufToHostif => avllenFstoccbufMfsmtrack1ToHostif,

			fstoccbufToHostifAXIS_tready => fstoccbufMfsmtrack1ToHostifAXIS_tready,
			fstoccbufToHostifAXIS_tvalid => fstoccbufMfsmtrack1ToHostifAXIS_tvalid,
			fstoccbufToHostifAXIS_tdata => fstoccbufMfsmtrack1ToHostifAXIS_tdata,
			fstoccbufToHostifAXIS_tlast => fstoccbufMfsmtrack1ToHostifAXIS_tlast,

			reqSeqbufToHostif => reqSeqbufMfsmtrack1ToHostif,
			ackSeqbufToHostif => ackSeqbufMfsmtrack1ToHostif,
			dneSeqbufToHostif => dneSeqbufMfsmtrack1ToHostif,
			avllenSeqbufToHostif => avllenSeqbufMfsmtrack1ToHostif,

			seqbufToHostifAXIS_tready => seqbufMfsmtrack1ToHostifAXIS_tready,
			seqbufToHostifAXIS_tvalid => seqbufMfsmtrack1ToHostifAXIS_tvalid,
			seqbufToHostifAXIS_tdata => seqbufMfsmtrack1ToHostifAXIS_tdata,
			seqbufToHostifAXIS_tlast => seqbufMfsmtrack1ToHostifAXIS_tlast,

			tkclksrcStateOp => tkclksrcStateOp_dbg
		);

	myMgptrack : Mgptrack
		port map (
			reset => reset,
			mclk => mclk,

			hostifRxAXIS_tvalid => hostifRxAXIS_tvalid,
			ackInvTkclksrcSetTkst => ackInvTkclksrcSetTkst,

			getInfoTixVState => mgptrackGetInfoTixVState,

			reqInvSelect => reqInvMgptrackSelect,
			ackInvSelect => ackInvMgptrackSelect,

			selectStaTixVTrigger => mgptrackSelectStaTixVTrigger,
			selectStaFallingNotRising => mgptrackSelectStaFallingNotRising,
			selectStoTixVTrigger => mgptrackSelectStoTixVTrigger,
			selectStoFallingNotRising => mgptrackSelectStoFallingNotRising,

			reqInvSet => reqInvMgptrackSet,
			ackInvSet => ackInvMgptrackSet,

			setRng => mgptrackSetRng,
			setTCapt => mgptrackSetTCapt,

			reqSeqbufToHostif => reqSeqbufMgptrackToHostif,
			ackSeqbufToHostif => ackSeqbufMgptrackToHostif,
			dneSeqbufToHostif => dneSeqbufMgptrackToHostif,
			avllenSeqbufToHostif => avllenSeqbufMgptrackToHostif,

			seqbufToHostifAXIS_tready => seqbufMgptrackToHostifAXIS_tready,
			seqbufToHostifAXIS_tvalid => seqbufMgptrackToHostifAXIS_tvalid,
			seqbufToHostifAXIS_tdata => seqbufMgptrackToHostifAXIS_tdata,
			seqbufToHostifAXIS_tlast => seqbufMgptrackToHostifAXIS_tlast,

			tkclk => tkclk,
			rgb0_r => rgb0_r_sig,
			rgb0_g => rgb0_g_sig,
			rgb0_b => rgb0_b_sig,
			btn0 => btn0,
			btn0_sig => btn0_sig,
			tkclksrcGetTkstTkst => tkclksrcGetTkstTkst(7 downto 0)
		);

	myOscAclk : Osc_div9
		port map (
			hf_clk_out_o => aclk,
			hf_out_en_i => '1'
		);

	--myIbAclk : IB
		--port map (
			--O => mclk,--aclk,
			--I => extclk
		--);

	myRgbled0 : Rgbled_v1_0
		generic map (
			fMclk => fMclk
		)
		port map (
			reset => reset,
			mclk => mclk,
			rgb => rgb0,

			r => rgb0_r_sig,
			g => rgb0_g_sig,
			b => rgb0_b_sig
		);

	myState : State
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			getTixVClebState => stateGetTixVClebState,

			commok => commok,
			rgb => rgb0
		);

	myTkclksrc : Tkclksrc_Easy_v1_0
		generic map (
			fMclk => fMclk
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			getTkstTkst => tkclksrcGetTkstTkst,

			reqInvSetTkst => reqInvTkclksrcSetTkst,
			ackInvSetTkst => ackInvTkclksrcSetTkst,

			setTkstTkst => tkclksrcSetTkstTkst,

			stateOp_dbg => tkclksrcStateOp_dbg
		);

	------------------------------------------------------------------------
	-- implementation: mclk wiring and reset (mclk)
	------------------------------------------------------------------------

	-- IP impl.mclk.wiring --- BEGIN
	mclk <= aclk;
	-- IP impl.mclk.wiring --- END

	-- IP impl.mclk.rising --- BEGIN
	process (aresetn, mclk)
		-- IP impl.mclk.vars --- BEGIN
		constant imax: natural := 16;
		variable i: natural range 0 to imax;

		constant jmax: natural := 1;
		variable j: natural range 0 to jmax;
		-- IP impl.mclk.vars --- END

	begin
		if aresetn='0' then
			-- IP impl.mclk.asyncrst --- BEGIN
			reset <= '1';

			i := 0;
			j := 0;
			-- IP impl.mclk.asyncrst --- END

		elsif rising_edge(mclk) then
			if reqResetFromHostif='1' then
				if i=imax then
					i := 0;
					j := 0;

				else
					if j=jmax then
						reset <= '1';
						j := 0;

					else
						j := j + 1;
					end if;
				end if;

			elsif i=imax then
				reset <= '0';
			else
				i := i + 1;
			end if;
		end if;
	end process;
	-- IP impl.mclk.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- IBEGIN
	rgb0_r <= rgb0_r_sig;
	rgb0_g <= rgb0_g_sig;
	rgb0_b <= rgb0_b_sig;
	-- IP impl.oth.cust --- IEND

end Rtl;
