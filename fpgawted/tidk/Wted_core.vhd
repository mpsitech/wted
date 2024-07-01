-- file Wted_core.vhd
-- Wted_core top_v1_0 top implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 30 Jun 2024
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library efxphysicallib;
use efxphysicallib.efxcomponents.all;

use work.Dbecore.all;
use work.Tidk.all;

entity Wted_core is
	generic (
		fAclk: natural := 100000;
		fMclk: natural := 100000;
		fMemclk: natural := 250000
	);
	port (
		areset: in std_logic;
		aclk: in std_logic;
		memclk: in std_logic;

		apuAXIL_araddr: in std_logic_vector(39 downto 0);
		apuAXIL_arprot: in std_logic_vector(2 downto 0);
		apuAXIL_arready: out std_logic;
		apuAXIL_arvalid: in std_logic;

		apuAXIL_rdata: out std_logic_vector(63 downto 0);
		apuAXIL_rready: in std_logic;
		apuAXIL_rresp: out std_logic_vector(1 downto 0);
		apuAXIL_rvalid: out std_logic;
		apuAXIL_rlast: out std_logic;

		apuAXIL_awaddr: in std_logic_vector(39 downto 0);
		apuAXIL_awprot: in std_logic_vector(2 downto 0);
		apuAXIL_awready: out std_logic;
		apuAXIL_awvalid: in std_logic;

		apuAXIL_wdata: in std_logic_vector(63 downto 0);
		apuAXIL_wready: out std_logic;
		apuAXIL_wstrb: in std_logic_vector(7 downto 0);
		apuAXIL_wvalid: in std_logic;

		apuAXIL_bready: in std_logic;
		apuAXIL_bresp: out std_logic_vector(1 downto 0);
		apuAXIL_bvalid: out std_logic;

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

		ddrAXI_rdata: in std_logic_vector(31 downto 0);
		ddrAXI_rlast: in std_logic;
		ddrAXI_rready: out std_logic;
		ddrAXI_rresp: in std_logic_vector(1 downto 0);
		ddrAXI_rvalid: in std_logic;

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

		ddrAXI_wdata: out std_logic_vector(31 downto 0);
		ddrAXI_wlast: out std_logic;
		ddrAXI_wready: in std_logic;
		ddrAXI_wstrb: out std_logic_vector(3 downto 0);
		ddrAXI_wvalid: out std_logic;

		ddrAXI_bready: out std_logic;
		ddrAXI_bresp: in std_logic_vector(1 downto 0);
		ddrAXI_bvalid: in std_logic;

		btn0: in std_logic;
		rgb0_r: out std_logic;
		rgb0_g: out std_logic;

		b: out std_logic
	);
end Wted_core;

architecture Rtl of Wted_core is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Client is
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

			reqSetbufFromHostif: in std_logic;

			dneGetbufToHostif: in std_logic;

			ackSetbufFromHostif: out std_logic;

			avllenGetbufToHostif: out std_logic_vector(31 downto 0);

			dneSetbufFromHostif: in std_logic;
			avllenSetbufFromHostif: out std_logic_vector(31 downto 0);

			getbufToHostifAXIS_tready: in std_logic;

			setbufFromHostifAXIS_tready: out std_logic;

			getbufToHostifAXIS_tvalid: out std_logic;
			getbufToHostifAXIS_tdata: out std_logic_vector(31 downto 0);

			setbufFromHostifAXIS_tvalid: in std_logic;

			getbufToHostifAXIS_tlast: out std_logic;

			setbufFromHostifAXIS_tdata: in std_logic_vector(31 downto 0);
			setbufFromHostifAXIS_tlast: in std_logic;

			stateGetbufB_dbg: out std_logic_vector(7 downto 0);
			stateSetbufB_dbg: out std_logic_vector(7 downto 0)
		);
	end component;

	component Ddrif is
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
			wrAAXI_bready: in std_logic;
			wrAAXI_bresp: out std_logic_vector(1 downto 0);
			wrAAXI_bvalid: out std_logic;

			reqWrB: in std_logic;
			ackWrB: out std_logic;

			wrBAXI_awaddr: in std_logic_vector(19 downto 0);
			wrBAXI_awready: out std_logic;
			wrBAXI_awvalid: in std_logic;
			wrBAXI_wdata: in std_logic_vector(31 downto 0);
			wrBAXI_wlast: in std_logic;
			wrBAXI_wready: out std_logic;
			wrBAXI_wvalid: in std_logic;
			wrBAXI_bready: in std_logic;
			wrBAXI_bresp: out std_logic_vector(1 downto 0);
			wrBAXI_bvalid: out std_logic;

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

			ddrAXI_rdata: in std_logic_vector(31 downto 0);
			ddrAXI_rlast: in std_logic;
			ddrAXI_rready: out std_logic;
			ddrAXI_rresp: in std_logic_vector(1 downto 0);
			ddrAXI_rvalid: in std_logic;

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

			ddrAXI_wdata: out std_logic_vector(31 downto 0);
			ddrAXI_wlast: out std_logic;
			ddrAXI_wready: in std_logic;
			ddrAXI_wstrb: out std_logic_vector(3 downto 0);
			ddrAXI_wvalid: out std_logic;

			ddrAXI_bready: out std_logic;
			ddrAXI_bresp: in std_logic_vector(1 downto 0);
			ddrAXI_bvalid: in std_logic
		);
	end component;

	component Debounce_v1_0 is
		generic (
			invert: boolean := true;
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
			fMclk: natural := 50000
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;
			commok: out std_logic;
			reqReset: out std_logic;

			ackInvMfsmtrack0Select: in std_logic;

			mfsmtrack0SelectTixVSource: out std_logic_vector(7 downto 0);
			mfsmtrack0SelectStaTixVTrigger: out std_logic_vector(7 downto 0);

			mgptrackGetInfoTixVState: in std_logic_vector(7 downto 0);

			mfsmtrack0SelectStoTixVTrigger: out std_logic_vector(7 downto 0);

			reqInvMgptrackSelect: out std_logic;

			reqInvMfsmtrack0Set: out std_logic;

			ackInvMgptrackSelect: in std_logic;

			ackInvMfsmtrack0Set: in std_logic;

			mgptrackSelectStaTixVTrigger: out std_logic_vector(7 downto 0);

			mfsmtrack0SetRng: out std_logic_vector(7 downto 0);
			mfsmtrack0SetTCapt: out std_logic_vector(31 downto 0);

			mgptrackSelectStoTixVTrigger: out std_logic_vector(7 downto 0);

			mfsmtrack1GetInfoTixVState: in std_logic_vector(7 downto 0);
			mfsmtrack1GetInfoCoverage: in std_logic_vector(255 downto 0);

			reqInvMfsmtrack1Select: out std_logic;
			ackInvMfsmtrack1Select: in std_logic;

			mfsmtrack1SelectTixVSource: out std_logic_vector(7 downto 0);

			reqInvMgptrackSet: out std_logic;
			ackInvMgptrackSet: in std_logic;

			mfsmtrack1SelectStaTixVTrigger: out std_logic_vector(7 downto 0);
			mfsmtrack1SelectStoTixVTrigger: out std_logic_vector(7 downto 0);

			reqInvMfsmtrack1Set: out std_logic;
			ackInvMfsmtrack1Set: in std_logic;

			mfsmtrack1SetRng: out std_logic_vector(7 downto 0);
			mfsmtrack1SetTCapt: out std_logic_vector(31 downto 0);

			mgptrackSetRng: out std_logic_vector(7 downto 0);

			identGetVer: in std_logic_vector(63 downto 0);

			mgptrackSetTCapt: out std_logic_vector(31 downto 0);

			mfsmtrack0GetInfoTixVState: in std_logic_vector(7 downto 0);

			identGetHash: in std_logic_vector(63 downto 0);

			mfsmtrack0GetInfoCoverage: in std_logic_vector(255 downto 0);

			identGetWho: in std_logic_vector(63 downto 0);

			identGetCfgFMclk: in std_logic_vector(31 downto 0);
			identGetCfgFMemclk: in std_logic_vector(31 downto 0);

			reqInvTrafgenSet: out std_logic;
			ackInvTrafgenSet: in std_logic;

			trafgenSetRng: out std_logic_vector(7 downto 0);

			reqInvMfsmtrack0Select: out std_logic;

			tkclksrcGetTkstTkst: in std_logic_vector(31 downto 0);

			reqInvTkclksrcSetTkst: out std_logic;
			ackInvTkclksrcSetTkst: in std_logic;

			tkclksrcSetTkstTkst: out std_logic_vector(31 downto 0);

			stateGetTixVTidkState: in std_logic_vector(7 downto 0);

			memgptrackGetInfoTixVState: in std_logic_vector(7 downto 0);

			reqInvMemgptrackSelect: out std_logic;
			ackInvMemgptrackSelect: in std_logic;

			memgptrackSelectStaTixVTrigger: out std_logic_vector(7 downto 0);
			memgptrackSelectStoTixVTrigger: out std_logic_vector(7 downto 0);

			reqInvMemgptrackSet: out std_logic;
			ackInvMemgptrackSet: in std_logic;

			memgptrackSetRng: out std_logic_vector(7 downto 0);
			memgptrackSetTCapt: out std_logic_vector(31 downto 0);

			reqInvClientLoadGetbuf: out std_logic;
			ackInvClientLoadGetbuf: in std_logic;

			reqInvClientStoreSetbuf: out std_logic;
			ackInvClientStoreSetbuf: in std_logic;

			ddrifGetStatsNRdA: in std_logic_vector(31 downto 0);
			ddrifGetStatsNWrA: in std_logic_vector(31 downto 0);
			ddrifGetStatsNWrB: in std_logic_vector(31 downto 0);

			reqGetbufFromClient: out std_logic;
			ackGetbufFromClient: in std_logic;
			dneGetbufFromClient: out std_logic;
			avllenGetbufFromClient: in std_logic_vector(31 downto 0);

			reqSetbufToClient: out std_logic;
			ackSetbufToClient: in std_logic;
			dneSetbufToClient: out std_logic;
			avllenSetbufToClient: in std_logic_vector(31 downto 0);

			getbufFromClientAXIS_tready: out std_logic;
			getbufFromClientAXIS_tvalid: in std_logic;
			getbufFromClientAXIS_tdata: in std_logic_vector(31 downto 0);
			getbufFromClientAXIS_tlast: in std_logic;

			setbufToClientAXIS_tready: in std_logic;
			setbufToClientAXIS_tvalid: out std_logic;

			ackFstoccbufFromMfsmtrack0: in std_logic;

			setbufToClientAXIS_tdata: out std_logic_vector(31 downto 0);

			dneFstoccbufFromMfsmtrack0: out std_logic;

			setbufToClientAXIS_tlast: out std_logic;

			avllenFstoccbufFromMfsmtrack0: in std_logic_vector(31 downto 0);

			fstoccbufFromMfsmtrack0AXIS_tready: out std_logic;
			fstoccbufFromMfsmtrack0AXIS_tvalid: in std_logic;
			fstoccbufFromMfsmtrack0AXIS_tdata: in std_logic_vector(31 downto 0);
			fstoccbufFromMfsmtrack0AXIS_tlast: in std_logic;

			reqCntbufFromMfsmtrack1: out std_logic;

			reqCntbufFromMfsmtrack0: out std_logic;

			ackCntbufFromMfsmtrack1: in std_logic;

			ackCntbufFromMfsmtrack0: in std_logic;

			dneCntbufFromMfsmtrack1: out std_logic;

			dneCntbufFromMfsmtrack0: out std_logic;

			avllenCntbufFromMfsmtrack1: in std_logic_vector(31 downto 0);

			avllenCntbufFromMfsmtrack0: in std_logic_vector(31 downto 0);

			cntbufFromMfsmtrack1AXIS_tready: out std_logic;
			cntbufFromMfsmtrack1AXIS_tvalid: in std_logic;
			cntbufFromMfsmtrack1AXIS_tdata: in std_logic_vector(31 downto 0);

			cntbufFromMfsmtrack0AXIS_tready: out std_logic;

			cntbufFromMfsmtrack1AXIS_tlast: in std_logic;

			reqSeqbufFromMfsmtrack0: out std_logic;

			cntbufFromMfsmtrack0AXIS_tvalid: in std_logic;

			ackSeqbufFromMfsmtrack0: in std_logic;

			cntbufFromMfsmtrack0AXIS_tdata: in std_logic_vector(31 downto 0);

			dneSeqbufFromMfsmtrack0: out std_logic;

			cntbufFromMfsmtrack0AXIS_tlast: in std_logic;

			avllenSeqbufFromMfsmtrack0: in std_logic_vector(31 downto 0);

			seqbufFromMfsmtrack0AXIS_tready: out std_logic;
			seqbufFromMfsmtrack0AXIS_tvalid: in std_logic;
			seqbufFromMfsmtrack0AXIS_tdata: in std_logic_vector(31 downto 0);

			reqFstoccbufFromMfsmtrack0: out std_logic;

			seqbufFromMfsmtrack0AXIS_tlast: in std_logic;

			reqFstoccbufFromMfsmtrack1: out std_logic;
			ackFstoccbufFromMfsmtrack1: in std_logic;
			dneFstoccbufFromMfsmtrack1: out std_logic;
			avllenFstoccbufFromMfsmtrack1: in std_logic_vector(31 downto 0);

			fstoccbufFromMfsmtrack1AXIS_tready: out std_logic;
			fstoccbufFromMfsmtrack1AXIS_tvalid: in std_logic;
			fstoccbufFromMfsmtrack1AXIS_tdata: in std_logic_vector(31 downto 0);
			fstoccbufFromMfsmtrack1AXIS_tlast: in std_logic;

			reqSeqbufFromMfsmtrack1: out std_logic;
			ackSeqbufFromMfsmtrack1: in std_logic;
			dneSeqbufFromMfsmtrack1: out std_logic;
			avllenSeqbufFromMfsmtrack1: in std_logic_vector(31 downto 0);

			seqbufFromMfsmtrack1AXIS_tready: out std_logic;
			seqbufFromMfsmtrack1AXIS_tvalid: in std_logic;
			seqbufFromMfsmtrack1AXIS_tdata: in std_logic_vector(31 downto 0);
			seqbufFromMfsmtrack1AXIS_tlast: in std_logic;

			rxAXIS_tvalid_sig: out std_logic;

			AXIL_araddr: in std_logic_vector(31 downto 0);
			AXIL_arprot: in std_logic_vector(2 downto 0);
			AXIL_arready: out std_logic;
			AXIL_arvalid: in std_logic;
			AXIL_rdata: out std_logic_vector(31 downto 0);
			AXIL_rready: in std_logic;
			AXIL_rresp: out std_logic_vector(1 downto 0);
			AXIL_rvalid: out std_logic;
			AXIL_rlast: out std_logic;
			AXIL_awaddr: in std_logic_vector(31 downto 0);
			AXIL_awprot: in std_logic_vector(2 downto 0);
			AXIL_awready: out std_logic;
			AXIL_awvalid: in std_logic;
			AXIL_wdata: in std_logic_vector(31 downto 0);
			AXIL_wready: out std_logic;
			AXIL_wstrb: in std_logic_vector(3 downto 0);
			AXIL_wvalid: in std_logic;
			AXIL_bready: in std_logic;
			AXIL_bresp: out std_logic_vector(1 downto 0);
			AXIL_bvalid: out std_logic;

			stateOp_dbg: out std_logic_vector(7 downto 0)
		);
	end component;

	component Ident is
		generic (
			fMclk: natural := 0;
			fMemclk: natural := 0
		);
		port (
			getVer: out std_logic_vector(63 downto 0);
			getHash: out std_logic_vector(63 downto 0);
			getWho: out std_logic_vector(63 downto 0);

			getCfgFMclk: out std_logic_vector(31 downto 0);
			getCfgFMemclk: out std_logic_vector(31 downto 0)
		);
	end component;

	component Memgptrack is
		port (
			reset: in std_logic;

			resetMemclk: in std_logic;

			mclk: in std_logic;

			memclk: in std_logic;

			resetTrkclk: in std_logic;
			trkclk: in std_logic;

			getInfoTixVState: out std_logic_vector(7 downto 0);

			reqInvSelect: in std_logic;
			ackInvSelect: out std_logic;

			selectStaTixVTrigger: in std_logic_vector(7 downto 0);
			selectStoTixVTrigger: in std_logic_vector(7 downto 0);

			reqInvSet: in std_logic;
			ackInvSet: out std_logic;

			setRng: in std_logic_vector(7 downto 0);
			setTCapt: in std_logic_vector(31 downto 0)
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

			selectTixVSource: in std_logic_vector(7 downto 0);
			selectStaTixVTrigger: in std_logic_vector(7 downto 0);
			selectStoTixVTrigger: in std_logic_vector(7 downto 0);

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
			cntbufToHostifAXIS_tdata: out std_logic_vector(31 downto 0);
			cntbufToHostifAXIS_tlast: out std_logic;

			reqFstoccbufToHostif: in std_logic;
			ackFstoccbufToHostif: out std_logic;
			dneFstoccbufToHostif: in std_logic;
			avllenFstoccbufToHostif: out std_logic_vector(31 downto 0);

			fstoccbufToHostifAXIS_tready: in std_logic;
			fstoccbufToHostifAXIS_tvalid: out std_logic;
			fstoccbufToHostifAXIS_tdata: out std_logic_vector(31 downto 0);
			fstoccbufToHostifAXIS_tlast: out std_logic;

			reqSeqbufToHostif: in std_logic;
			ackSeqbufToHostif: out std_logic;
			dneSeqbufToHostif: in std_logic;
			avllenSeqbufToHostif: out std_logic_vector(31 downto 0);

			seqbufToHostifAXIS_tready: in std_logic;
			seqbufToHostifAXIS_tvalid: out std_logic;
			seqbufToHostifAXIS_tdata: out std_logic_vector(31 downto 0);
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

			selectTixVSource: in std_logic_vector(7 downto 0);
			selectStaTixVTrigger: in std_logic_vector(7 downto 0);
			selectStoTixVTrigger: in std_logic_vector(7 downto 0);

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
			cntbufToHostifAXIS_tdata: out std_logic_vector(31 downto 0);
			cntbufToHostifAXIS_tlast: out std_logic;

			reqFstoccbufToHostif: in std_logic;
			ackFstoccbufToHostif: out std_logic;
			dneFstoccbufToHostif: in std_logic;
			avllenFstoccbufToHostif: out std_logic_vector(31 downto 0);

			fstoccbufToHostifAXIS_tready: in std_logic;
			fstoccbufToHostifAXIS_tvalid: out std_logic;
			fstoccbufToHostifAXIS_tdata: out std_logic_vector(31 downto 0);
			fstoccbufToHostifAXIS_tlast: out std_logic;

			reqSeqbufToHostif: in std_logic;
			ackSeqbufToHostif: out std_logic;
			dneSeqbufToHostif: in std_logic;
			avllenSeqbufToHostif: out std_logic_vector(31 downto 0);

			seqbufToHostifAXIS_tready: in std_logic;
			seqbufToHostifAXIS_tvalid: out std_logic;
			seqbufToHostifAXIS_tdata: out std_logic_vector(31 downto 0);
			seqbufToHostifAXIS_tlast: out std_logic;

			clientStateGetbufB: in std_logic_vector(7 downto 0);
			clientStateSetbufB: in std_logic_vector(7 downto 0);
			tkclksrcStateOp: in std_logic_vector(7 downto 0)
		);
	end component;

	component Mgptrack is
		port (
			reset: in std_logic;
			mclk: in std_logic;

			resetTrkclk: in std_logic;
			trkclk: in std_logic;

			getInfoTixVState: out std_logic_vector(7 downto 0);

			reqInvSelect: in std_logic;
			ackInvSelect: out std_logic;

			selectStaTixVTrigger: in std_logic_vector(7 downto 0);
			selectStoTixVTrigger: in std_logic_vector(7 downto 0);

			reqInvSet: in std_logic;
			ackInvSet: out std_logic;

			setRng: in std_logic_vector(7 downto 0);
			setTCapt: in std_logic_vector(31 downto 0)
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

			getTixVTidkState: out std_logic_vector(7 downto 0);

			commok: in std_logic;
			trafgenRng: in std_logic;
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

	component Trafgen is
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
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- mclk wiring and reset (mclk)

	signal reset: std_logic;
	signal mclk: std_logic;

	-- IP sigs.mclk.cust --- INSERT

	---- memclk wiring and reset (memclk)

	signal resetMemclk: std_logic;

	-- IP sigs.memclk.cust --- INSERT

	---- myClient
	signal avllenSetbufHostifToClient: std_logic_vector(31 downto 0);
	signal avllenGetbufClientToHostif: std_logic_vector(31 downto 0);

	signal setbufHostifToClientAXIS_tready: std_logic;

	signal getbufClientToHostifAXIS_tvalid: std_logic;
	signal getbufClientToHostifAXIS_tdata: std_logic_vector(31 downto 0);
	signal getbufClientToHostifAXIS_tlast: std_logic;

	signal memCRdAXI_araddr: std_logic_vector(19 downto 0);
	signal memCRdAXI_arvalid: std_logic;
	signal memCRdAXI_rready: std_logic;

	signal memCWrAXI_awaddr: std_logic_vector(19 downto 0);
	signal memCWrAXI_awvalid: std_logic;
	signal memCWrAXI_wdata: std_logic_vector(31 downto 0);
	signal memCWrAXI_wlast: std_logic;
	signal memCWrAXI_wvalid: std_logic;
	signal memCWrAXI_bready: std_logic;

	signal clientStateGetbufB_dbg: std_logic_vector(7 downto 0);
	signal clientStateSetbufB_dbg: std_logic_vector(7 downto 0);

	---- myDdrif
	signal memTWrAXI_awready: std_logic;
	signal memTWrAXI_wready: std_logic;
	signal memTWrAXI_bresp: std_logic_vector(1 downto 0);
	signal memTWrAXI_bvalid: std_logic;

	signal memCRdAXI_arready: std_logic;
	signal memCRdAXI_rdata: std_logic_vector(31 downto 0);
	signal memCRdAXI_rlast: std_logic;
	signal memCRdAXI_rresp: std_logic_vector(1 downto 0);
	signal memCRdAXI_rvalid: std_logic;

	signal memCWrAXI_awready: std_logic;
	signal memCWrAXI_wready: std_logic;
	signal memCWrAXI_bresp: std_logic_vector(1 downto 0);
	signal memCWrAXI_bvalid: std_logic;

	signal ddrifGetStatsNRdA: std_logic_vector(31 downto 0);
	signal ddrifGetStatsNWrA: std_logic_vector(31 downto 0);
	signal ddrifGetStatsNWrB: std_logic_vector(31 downto 0);

	---- myDebounceBtn0
	signal btn0_sig: std_logic;

	---- myGbufceAclk
	signal aclk_sig: std_logic;

	---- myHostif
	signal commok: std_logic;
	signal hostifRxAXIS_tvalid: std_logic;

	signal getbufClientToHostifAXIS_tready: std_logic;

	signal setbufHostifToClientAXIS_tvalid: std_logic;
	signal setbufHostifToClientAXIS_tdata: std_logic_vector(31 downto 0);
	signal setbufHostifToClientAXIS_tlast: std_logic;

	signal mgptrackSelectStaTixVTrigger: std_logic_vector(7 downto 0);

	signal cntbufMfsmtrack0ToHostifAXIS_tready: std_logic;

	signal mgptrackSelectStoTixVTrigger: std_logic_vector(7 downto 0);

	signal mgptrackSetRng: std_logic_vector(7 downto 0);

	signal fstoccbufMfsmtrack0ToHostifAXIS_tready: std_logic;

	signal mgptrackSetTCapt: std_logic_vector(31 downto 0);

	signal mfsmtrack0SelectTixVSource: std_logic_vector(7 downto 0);
	signal mfsmtrack0SelectStaTixVTrigger: std_logic_vector(7 downto 0);
	signal mfsmtrack0SelectStoTixVTrigger: std_logic_vector(7 downto 0);

	signal cntbufMfsmtrack1ToHostifAXIS_tready: std_logic;

	signal mfsmtrack0SetRng: std_logic_vector(7 downto 0);
	signal mfsmtrack0SetTCapt: std_logic_vector(31 downto 0);

	signal seqbufMfsmtrack0ToHostifAXIS_tready: std_logic;

	signal mfsmtrack1SelectTixVSource: std_logic_vector(7 downto 0);
	signal mfsmtrack1SelectStaTixVTrigger: std_logic_vector(7 downto 0);
	signal mfsmtrack1SelectStoTixVTrigger: std_logic_vector(7 downto 0);

	signal mfsmtrack1SetRng: std_logic_vector(7 downto 0);

	signal hostifStateOp_dbg: std_logic_vector(7 downto 0);

	signal mfsmtrack1SetTCapt: std_logic_vector(31 downto 0);

	signal fstoccbufMfsmtrack1ToHostifAXIS_tready: std_logic;

	signal trafgenSetRng: std_logic_vector(7 downto 0);

	signal seqbufMfsmtrack1ToHostifAXIS_tready: std_logic;

	signal tkclksrcSetTkstTkst: std_logic_vector(31 downto 0);

	signal memgptrackSelectStaTixVTrigger: std_logic_vector(7 downto 0);
	signal memgptrackSelectStoTixVTrigger: std_logic_vector(7 downto 0);

	signal memgptrackSetRng: std_logic_vector(7 downto 0);
	signal memgptrackSetTCapt: std_logic_vector(31 downto 0);

	---- myIdent
	signal identGetVer: std_logic_vector(63 downto 0);
	signal identGetHash: std_logic_vector(63 downto 0);
	signal identGetWho: std_logic_vector(63 downto 0);

	signal identGetCfgFMclk: std_logic_vector(31 downto 0);
	signal identGetCfgFMemclk: std_logic_vector(31 downto 0);

	---- myMemgptrack
	signal memgptrackGetInfoTixVState: std_logic_vector(7 downto 0);

	---- myMfsmtrack0
	signal avllenCntbufMfsmtrack0ToHostif: std_logic_vector(31 downto 0);

	signal cntbufMfsmtrack0ToHostifAXIS_tvalid: std_logic;
	signal cntbufMfsmtrack0ToHostifAXIS_tdata: std_logic_vector(31 downto 0);

	signal avllenFstoccbufMfsmtrack0ToHostif: std_logic_vector(31 downto 0);

	signal cntbufMfsmtrack0ToHostifAXIS_tlast: std_logic;

	signal fstoccbufMfsmtrack0ToHostifAXIS_tvalid: std_logic;

	signal mfsmtrack0GetInfoTixVState: std_logic_vector(7 downto 0);

	signal fstoccbufMfsmtrack0ToHostifAXIS_tdata: std_logic_vector(31 downto 0);

	signal mfsmtrack0GetInfoCoverage: std_logic_vector(255 downto 0);

	signal fstoccbufMfsmtrack0ToHostifAXIS_tlast: std_logic;

	signal avllenSeqbufMfsmtrack0ToHostif: std_logic_vector(31 downto 0);

	signal seqbufMfsmtrack0ToHostifAXIS_tvalid: std_logic;
	signal seqbufMfsmtrack0ToHostifAXIS_tdata: std_logic_vector(31 downto 0);
	signal seqbufMfsmtrack0ToHostifAXIS_tlast: std_logic;

	---- myMfsmtrack1
	signal avllenCntbufMfsmtrack1ToHostif: std_logic_vector(31 downto 0);

	signal cntbufMfsmtrack1ToHostifAXIS_tvalid: std_logic;
	signal cntbufMfsmtrack1ToHostifAXIS_tdata: std_logic_vector(31 downto 0);
	signal cntbufMfsmtrack1ToHostifAXIS_tlast: std_logic;

	signal mfsmtrack1GetInfoTixVState: std_logic_vector(7 downto 0);
	signal mfsmtrack1GetInfoCoverage: std_logic_vector(255 downto 0);

	signal avllenFstoccbufMfsmtrack1ToHostif: std_logic_vector(31 downto 0);

	signal fstoccbufMfsmtrack1ToHostifAXIS_tvalid: std_logic;
	signal fstoccbufMfsmtrack1ToHostifAXIS_tdata: std_logic_vector(31 downto 0);
	signal fstoccbufMfsmtrack1ToHostifAXIS_tlast: std_logic;

	signal avllenSeqbufMfsmtrack1ToHostif: std_logic_vector(31 downto 0);

	signal seqbufMfsmtrack1ToHostifAXIS_tvalid: std_logic;
	signal seqbufMfsmtrack1ToHostifAXIS_tdata: std_logic_vector(31 downto 0);
	signal seqbufMfsmtrack1ToHostifAXIS_tlast: std_logic;

	---- myMgptrack
	signal mgptrackGetInfoTixVState: std_logic_vector(7 downto 0);

	---- myState
	signal rgb0: std_logic_vector(23 downto 0);

	signal stateGetTixVTidkState: std_logic_vector(7 downto 0);

	---- myTkclksrc
	signal tkclk: std_logic;
	signal tkclksrcStateOp_dbg: std_logic_vector(7 downto 0);

	signal tkclksrcGetTkstTkst: std_logic_vector(31 downto 0);

	---- myTrafgen
	signal trafgenRng: std_logic;

	signal memTWrAXI_awaddr: std_logic_vector(19 downto 0);
	signal memTWrAXI_awvalid: std_logic;
	signal memTWrAXI_wdata: std_logic_vector(31 downto 0);
	signal memTWrAXI_wlast: std_logic;
	signal memTWrAXI_wvalid: std_logic;
	signal memTWrAXI_bready: std_logic;

	---- handshake
	-- myHostif to myClient
	signal reqSetbufHostifToClient: std_logic;
	signal ackSetbufHostifToClient: std_logic;
	signal dneSetbufHostifToClient: std_logic;

	-- myHostif to myClient
	signal reqGetbufClientToHostif: std_logic;
	signal ackGetbufClientToHostif: std_logic;
	signal dneGetbufClientToHostif: std_logic;

	-- myHostif to (many)
	signal reqResetFromHostif: std_logic;

	-- myHostif to myMfsmtrack0
	signal reqCntbufMfsmtrack0ToHostif: std_logic;
	signal ackCntbufMfsmtrack0ToHostif: std_logic;
	signal dneCntbufMfsmtrack0ToHostif: std_logic;

	-- myHostif to myMgptrack
	signal reqInvMgptrackSelect: std_logic;
	signal ackInvMgptrackSelect: std_logic;

	-- myHostif to myMfsmtrack0
	signal reqFstoccbufMfsmtrack0ToHostif: std_logic;
	signal ackFstoccbufMfsmtrack0ToHostif: std_logic;
	signal dneFstoccbufMfsmtrack0ToHostif: std_logic;

	-- myHostif to myMgptrack
	signal reqInvMgptrackSet: std_logic;
	signal ackInvMgptrackSet: std_logic;

	-- myHostif to myMfsmtrack0
	signal reqInvMfsmtrack0Select: std_logic;
	signal ackInvMfsmtrack0Select: std_logic;

	-- myHostif to myMfsmtrack1
	signal reqCntbufMfsmtrack1ToHostif: std_logic;
	signal ackCntbufMfsmtrack1ToHostif: std_logic;
	signal dneCntbufMfsmtrack1ToHostif: std_logic;

	-- myHostif to myMfsmtrack0
	signal reqInvMfsmtrack0Set: std_logic;
	signal ackInvMfsmtrack0Set: std_logic;

	-- myHostif to myMfsmtrack0
	signal reqSeqbufMfsmtrack0ToHostif: std_logic;
	signal ackSeqbufMfsmtrack0ToHostif: std_logic;
	signal dneSeqbufMfsmtrack0ToHostif: std_logic;

	-- myHostif to myMfsmtrack1
	signal reqInvMfsmtrack1Select: std_logic;
	signal ackInvMfsmtrack1Select: std_logic;

	-- myClient to myDdrif
	signal reqClientToDdrifRd: std_logic;
	signal ackClientToDdrifRd: std_logic;

	-- myClient to myDdrif
	signal reqClientToDdrifWr: std_logic;
	signal ackClientToDdrifWr: std_logic;

	-- myHostif to myMfsmtrack1
	signal reqInvMfsmtrack1Set: std_logic;
	signal ackInvMfsmtrack1Set: std_logic;

	-- myHostif to myMfsmtrack1
	signal reqFstoccbufMfsmtrack1ToHostif: std_logic;
	signal ackFstoccbufMfsmtrack1ToHostif: std_logic;
	signal dneFstoccbufMfsmtrack1ToHostif: std_logic;

	-- myTrafgen to myDdrif
	signal reqTrafgenToDdrifWr: std_logic;
	signal ackTrafgenToDdrifWr: std_logic;

	-- myHostif to myMfsmtrack1
	signal reqSeqbufMfsmtrack1ToHostif: std_logic;
	signal ackSeqbufMfsmtrack1ToHostif: std_logic;
	signal dneSeqbufMfsmtrack1ToHostif: std_logic;

	-- myHostif to myTrafgen
	signal reqInvTrafgenSet: std_logic;
	signal ackInvTrafgenSet: std_logic;

	-- myHostif to myTkclksrc
	signal reqInvTkclksrcSetTkst: std_logic;
	signal ackInvTkclksrcSetTkst: std_logic;

	-- myHostif to myMemgptrack
	signal reqInvMemgptrackSelect: std_logic;
	signal ackInvMemgptrackSelect: std_logic;

	-- myHostif to myMemgptrack
	signal reqInvMemgptrackSet: std_logic;
	signal ackInvMemgptrackSet: std_logic;

	-- myHostif to myClient
	signal reqInvClientLoadGetbuf: std_logic;
	signal ackInvClientLoadGetbuf: std_logic;

	-- myHostif to myClient
	signal reqInvClientStoreSetbuf: std_logic;
	signal ackInvClientStoreSetbuf: std_logic;

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myClient : Client
		port map (
			reset => reset,
			mclk => mclk,

			resetMemclk => resetMemclk,
			memclk => memclk,

			memCRdAXI_araddr => memCRdAXI_araddr,
			memCRdAXI_arready => memCRdAXI_arready,
			memCRdAXI_arvalid => memCRdAXI_arvalid,
			memCRdAXI_rdata => memCRdAXI_rdata,
			memCRdAXI_rlast => memCRdAXI_rlast,
			memCRdAXI_rready => memCRdAXI_rready,
			memCRdAXI_rresp => memCRdAXI_rresp,
			memCRdAXI_rvalid => memCRdAXI_rvalid,

			reqToDdrifRd => reqClientToDdrifRd,
			ackToDdrifRd => ackClientToDdrifRd,

			memCWrAXI_awaddr => memCWrAXI_awaddr,
			memCWrAXI_awready => memCWrAXI_awready,
			memCWrAXI_awvalid => memCWrAXI_awvalid,
			memCWrAXI_wdata => memCWrAXI_wdata,
			memCWrAXI_wlast => memCWrAXI_wlast,
			memCWrAXI_wready => memCWrAXI_wready,
			memCWrAXI_wvalid => memCWrAXI_wvalid,
			memCWrAXI_bready => memCWrAXI_bready,
			memCWrAXI_bresp => memCWrAXI_bresp,
			memCWrAXI_bvalid => memCWrAXI_bvalid,

			reqToDdrifWr => reqClientToDdrifWr,
			ackToDdrifWr => ackClientToDdrifWr,

			reqInvLoadGetbuf => reqInvClientLoadGetbuf,
			ackInvLoadGetbuf => ackInvClientLoadGetbuf,

			reqInvStoreSetbuf => reqInvClientStoreSetbuf,
			ackInvStoreSetbuf => ackInvClientStoreSetbuf,

			reqGetbufToHostif => reqGetbufClientToHostif,
			ackGetbufToHostif => ackGetbufClientToHostif,

			reqSetbufFromHostif => reqSetbufHostifToClient,

			dneGetbufToHostif => dneGetbufClientToHostif,

			ackSetbufFromHostif => ackSetbufHostifToClient,

			avllenGetbufToHostif => avllenGetbufClientToHostif,

			dneSetbufFromHostif => dneSetbufHostifToClient,
			avllenSetbufFromHostif => avllenSetbufHostifToClient,

			getbufToHostifAXIS_tready => getbufClientToHostifAXIS_tready,

			setbufFromHostifAXIS_tready => setbufHostifToClientAXIS_tready,

			getbufToHostifAXIS_tvalid => getbufClientToHostifAXIS_tvalid,
			getbufToHostifAXIS_tdata => getbufClientToHostifAXIS_tdata,

			setbufFromHostifAXIS_tvalid => setbufHostifToClientAXIS_tvalid,

			getbufToHostifAXIS_tlast => getbufClientToHostifAXIS_tlast,

			setbufFromHostifAXIS_tdata => setbufHostifToClientAXIS_tdata,
			setbufFromHostifAXIS_tlast => setbufHostifToClientAXIS_tlast,

			stateGetbufB_dbg => clientStateGetbufB_dbg,
			stateSetbufB_dbg => clientStateSetbufB_dbg
		);

	myDdrif : Ddrif
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,
			resetMemclk => resetMemclk,
			memclk => memclk,

			getStatsNRdA => ddrifGetStatsNRdA,
			getStatsNWrA => ddrifGetStatsNWrA,
			getStatsNWrB => ddrifGetStatsNWrB,

			reqRdA => reqClientToDdrifRd,
			ackRdA => ackClientToDdrifRd,

			rdAAXI_araddr => memCRdAXI_araddr,
			rdAAXI_arready => memCRdAXI_arready,
			rdAAXI_arvalid => memCRdAXI_arvalid,
			rdAAXI_rdata => memCRdAXI_rdata,
			rdAAXI_rlast => memCRdAXI_rlast,
			rdAAXI_rready => memCRdAXI_rready,
			rdAAXI_rresp => memCRdAXI_rresp,
			rdAAXI_rvalid => memCRdAXI_rvalid,

			reqWrA => reqClientToDdrifWr,
			ackWrA => ackClientToDdrifWr,

			wrAAXI_awaddr => memCWrAXI_awaddr,
			wrAAXI_awready => memCWrAXI_awready,
			wrAAXI_awvalid => memCWrAXI_awvalid,
			wrAAXI_wdata => memCWrAXI_wdata,
			wrAAXI_wlast => memCWrAXI_wlast,
			wrAAXI_wready => memCWrAXI_wready,
			wrAAXI_wvalid => memCWrAXI_wvalid,
			wrAAXI_bready => memCWrAXI_bready,
			wrAAXI_bresp => memCWrAXI_bresp,
			wrAAXI_bvalid => memCWrAXI_bvalid,

			reqWrB => reqTrafgenToDdrifWr,
			ackWrB => ackTrafgenToDdrifWr,

			wrBAXI_awaddr => memTWrAXI_awaddr,
			wrBAXI_awready => memTWrAXI_awready,
			wrBAXI_awvalid => memTWrAXI_awvalid,
			wrBAXI_wdata => memTWrAXI_wdata,
			wrBAXI_wlast => memTWrAXI_wlast,
			wrBAXI_wready => memTWrAXI_wready,
			wrBAXI_wvalid => memTWrAXI_wvalid,
			wrBAXI_bready => memTWrAXI_bready,
			wrBAXI_bresp => memTWrAXI_bresp,
			wrBAXI_bvalid => memTWrAXI_bvalid,

			ddrAXI_araddr => ddrAXI_araddr,
			ddrAXI_arburst => ddrAXI_arburst,
			ddrAXI_arcache => ddrAXI_arcache,
			ddrAXI_arlen => ddrAXI_arlen,
			ddrAXI_arlock => ddrAXI_arlock,
			ddrAXI_arprot => ddrAXI_arprot,
			ddrAXI_arqos => ddrAXI_arqos,
			ddrAXI_arready => ddrAXI_arready,
			ddrAXI_arregion => ddrAXI_arregion,
			ddrAXI_arsize => ddrAXI_arsize,
			ddrAXI_arvalid => ddrAXI_arvalid,

			ddrAXI_rdata => ddrAXI_rdata,
			ddrAXI_rlast => ddrAXI_rlast,
			ddrAXI_rready => ddrAXI_rready,
			ddrAXI_rresp => ddrAXI_rresp,
			ddrAXI_rvalid => ddrAXI_rvalid,

			ddrAXI_awaddr => ddrAXI_awaddr,
			ddrAXI_awburst => ddrAXI_awburst,
			ddrAXI_awcache => ddrAXI_awcache,
			ddrAXI_awlen => ddrAXI_awlen,
			ddrAXI_awlock => ddrAXI_awlock,
			ddrAXI_awprot => ddrAXI_awprot,
			ddrAXI_awqos => ddrAXI_awqos,
			ddrAXI_awready => ddrAXI_awready,
			ddrAXI_awregion => ddrAXI_awregion,
			ddrAXI_awsize => ddrAXI_awsize,
			ddrAXI_awvalid => ddrAXI_awvalid,

			ddrAXI_wdata => ddrAXI_wdata,
			ddrAXI_wlast => ddrAXI_wlast,
			ddrAXI_wready => ddrAXI_wready,
			ddrAXI_wstrb => ddrAXI_wstrb,
			ddrAXI_wvalid => ddrAXI_wvalid,

			ddrAXI_bready => ddrAXI_bready,
			ddrAXI_bresp => ddrAXI_bresp,
			ddrAXI_bvalid => ddrAXI_bvalid
		);

	myDebounceBtn0 : Debounce_v1_0
		generic map (
			invert => true,
			tdead => 100
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			noisy => btn0,
			clean => btn0_sig
		);

	myGbufceAclk : EFX_GBUFCE
		port map (
			I => aclk,
			CE => '1',
			O => aclk_sig
		);

	myHostif : Hostif
		generic map (
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
			mgptrackSelectStoTixVTrigger => mgptrackSelectStoTixVTrigger,

			reqInvMgptrackSet => reqInvMgptrackSet,
			ackInvMgptrackSet => ackInvMgptrackSet,

			mfsmtrack1SelectStoTixVTrigger => mfsmtrack1SelectStoTixVTrigger,

			reqInvMfsmtrack1Set => reqInvMfsmtrack1Set,
			ackInvMfsmtrack1Set => ackInvMfsmtrack1Set,

			mfsmtrack1SetRng => mfsmtrack1SetRng,
			mfsmtrack1SetTCapt => mfsmtrack1SetTCapt,

			mgptrackSetRng => mgptrackSetRng,

			identGetVer => identGetVer,

			mgptrackSetTCapt => mgptrackSetTCapt,

			mfsmtrack0GetInfoTixVState => mfsmtrack0GetInfoTixVState,

			identGetHash => identGetHash,

			mfsmtrack0GetInfoCoverage => mfsmtrack0GetInfoCoverage,

			identGetWho => identGetWho,

			identGetCfgFMclk => identGetCfgFMclk,
			identGetCfgFMemclk => identGetCfgFMemclk,

			reqInvTrafgenSet => reqInvTrafgenSet,
			ackInvTrafgenSet => ackInvTrafgenSet,

			trafgenSetRng => trafgenSetRng,

			reqInvMfsmtrack0Select => reqInvMfsmtrack0Select,
			ackInvMfsmtrack0Select => ackInvMfsmtrack0Select,

			tkclksrcGetTkstTkst => tkclksrcGetTkstTkst,

			mfsmtrack0SelectTixVSource => mfsmtrack0SelectTixVSource,

			reqInvTkclksrcSetTkst => reqInvTkclksrcSetTkst,

			mfsmtrack0SelectStaTixVTrigger => mfsmtrack0SelectStaTixVTrigger,

			ackInvTkclksrcSetTkst => ackInvTkclksrcSetTkst,

			tkclksrcSetTkstTkst => tkclksrcSetTkstTkst,

			stateGetTixVTidkState => stateGetTixVTidkState,

			memgptrackGetInfoTixVState => memgptrackGetInfoTixVState,

			reqInvMemgptrackSelect => reqInvMemgptrackSelect,

			mfsmtrack0SelectStoTixVTrigger => mfsmtrack0SelectStoTixVTrigger,

			ackInvMemgptrackSelect => ackInvMemgptrackSelect,

			reqInvMfsmtrack0Set => reqInvMfsmtrack0Set,

			memgptrackSelectStaTixVTrigger => memgptrackSelectStaTixVTrigger,
			memgptrackSelectStoTixVTrigger => memgptrackSelectStoTixVTrigger,

			ackInvMfsmtrack0Set => ackInvMfsmtrack0Set,

			reqInvMemgptrackSet => reqInvMemgptrackSet,

			mfsmtrack0SetRng => mfsmtrack0SetRng,
			mfsmtrack0SetTCapt => mfsmtrack0SetTCapt,

			ackInvMemgptrackSet => ackInvMemgptrackSet,

			memgptrackSetRng => memgptrackSetRng,
			memgptrackSetTCapt => memgptrackSetTCapt,

			reqInvClientLoadGetbuf => reqInvClientLoadGetbuf,
			ackInvClientLoadGetbuf => ackInvClientLoadGetbuf,

			mfsmtrack1GetInfoTixVState => mfsmtrack1GetInfoTixVState,

			reqInvClientStoreSetbuf => reqInvClientStoreSetbuf,
			ackInvClientStoreSetbuf => ackInvClientStoreSetbuf,

			mfsmtrack1GetInfoCoverage => mfsmtrack1GetInfoCoverage,

			ddrifGetStatsNRdA => ddrifGetStatsNRdA,

			reqInvMfsmtrack1Select => reqInvMfsmtrack1Select,

			ddrifGetStatsNWrA => ddrifGetStatsNWrA,

			ackInvMfsmtrack1Select => ackInvMfsmtrack1Select,

			ddrifGetStatsNWrB => ddrifGetStatsNWrB,

			mfsmtrack1SelectTixVSource => mfsmtrack1SelectTixVSource,
			mfsmtrack1SelectStaTixVTrigger => mfsmtrack1SelectStaTixVTrigger,

			reqGetbufFromClient => reqGetbufClientToHostif,
			ackGetbufFromClient => ackGetbufClientToHostif,
			dneGetbufFromClient => dneGetbufClientToHostif,
			avllenGetbufFromClient => avllenGetbufClientToHostif,

			reqSetbufToClient => reqSetbufHostifToClient,
			ackSetbufToClient => ackSetbufHostifToClient,
			dneSetbufToClient => dneSetbufHostifToClient,
			avllenSetbufToClient => avllenSetbufHostifToClient,

			getbufFromClientAXIS_tready => getbufClientToHostifAXIS_tready,
			getbufFromClientAXIS_tvalid => getbufClientToHostifAXIS_tvalid,
			getbufFromClientAXIS_tdata => getbufClientToHostifAXIS_tdata,
			getbufFromClientAXIS_tlast => getbufClientToHostifAXIS_tlast,

			setbufToClientAXIS_tready => setbufHostifToClientAXIS_tready,
			setbufToClientAXIS_tvalid => setbufHostifToClientAXIS_tvalid,
			setbufToClientAXIS_tdata => setbufHostifToClientAXIS_tdata,
			setbufToClientAXIS_tlast => setbufHostifToClientAXIS_tlast,

			reqCntbufFromMfsmtrack0 => reqCntbufMfsmtrack0ToHostif,
			ackCntbufFromMfsmtrack0 => ackCntbufMfsmtrack0ToHostif,
			dneCntbufFromMfsmtrack0 => dneCntbufMfsmtrack0ToHostif,
			avllenCntbufFromMfsmtrack0 => avllenCntbufMfsmtrack0ToHostif,

			cntbufFromMfsmtrack0AXIS_tready => cntbufMfsmtrack0ToHostifAXIS_tready,

			reqSeqbufFromMfsmtrack0 => reqSeqbufMfsmtrack0ToHostif,

			cntbufFromMfsmtrack0AXIS_tvalid => cntbufMfsmtrack0ToHostifAXIS_tvalid,

			ackSeqbufFromMfsmtrack0 => ackSeqbufMfsmtrack0ToHostif,

			cntbufFromMfsmtrack0AXIS_tdata => cntbufMfsmtrack0ToHostifAXIS_tdata,

			dneSeqbufFromMfsmtrack0 => dneSeqbufMfsmtrack0ToHostif,

			cntbufFromMfsmtrack0AXIS_tlast => cntbufMfsmtrack0ToHostifAXIS_tlast,

			avllenSeqbufFromMfsmtrack0 => avllenSeqbufMfsmtrack0ToHostif,

			seqbufFromMfsmtrack0AXIS_tready => seqbufMfsmtrack0ToHostifAXIS_tready,
			seqbufFromMfsmtrack0AXIS_tvalid => seqbufMfsmtrack0ToHostifAXIS_tvalid,
			seqbufFromMfsmtrack0AXIS_tdata => seqbufMfsmtrack0ToHostifAXIS_tdata,

			reqFstoccbufFromMfsmtrack0 => reqFstoccbufMfsmtrack0ToHostif,

			seqbufFromMfsmtrack0AXIS_tlast => seqbufMfsmtrack0ToHostifAXIS_tlast,

			ackFstoccbufFromMfsmtrack0 => ackFstoccbufMfsmtrack0ToHostif,

			reqFstoccbufFromMfsmtrack1 => reqFstoccbufMfsmtrack1ToHostif,

			dneFstoccbufFromMfsmtrack0 => dneFstoccbufMfsmtrack0ToHostif,

			ackFstoccbufFromMfsmtrack1 => ackFstoccbufMfsmtrack1ToHostif,

			avllenFstoccbufFromMfsmtrack0 => avllenFstoccbufMfsmtrack0ToHostif,

			dneFstoccbufFromMfsmtrack1 => dneFstoccbufMfsmtrack1ToHostif,
			avllenFstoccbufFromMfsmtrack1 => avllenFstoccbufMfsmtrack1ToHostif,

			fstoccbufFromMfsmtrack1AXIS_tready => fstoccbufMfsmtrack1ToHostifAXIS_tready,
			fstoccbufFromMfsmtrack1AXIS_tvalid => fstoccbufMfsmtrack1ToHostifAXIS_tvalid,
			fstoccbufFromMfsmtrack1AXIS_tdata => fstoccbufMfsmtrack1ToHostifAXIS_tdata,

			fstoccbufFromMfsmtrack0AXIS_tready => fstoccbufMfsmtrack0ToHostifAXIS_tready,

			fstoccbufFromMfsmtrack1AXIS_tlast => fstoccbufMfsmtrack1ToHostifAXIS_tlast,

			fstoccbufFromMfsmtrack0AXIS_tvalid => fstoccbufMfsmtrack0ToHostifAXIS_tvalid,

			reqSeqbufFromMfsmtrack1 => reqSeqbufMfsmtrack1ToHostif,
			ackSeqbufFromMfsmtrack1 => ackSeqbufMfsmtrack1ToHostif,

			fstoccbufFromMfsmtrack0AXIS_tdata => fstoccbufMfsmtrack0ToHostifAXIS_tdata,

			dneSeqbufFromMfsmtrack1 => dneSeqbufMfsmtrack1ToHostif,

			fstoccbufFromMfsmtrack0AXIS_tlast => fstoccbufMfsmtrack0ToHostifAXIS_tlast,

			avllenSeqbufFromMfsmtrack1 => avllenSeqbufMfsmtrack1ToHostif,

			seqbufFromMfsmtrack1AXIS_tready => seqbufMfsmtrack1ToHostifAXIS_tready,
			seqbufFromMfsmtrack1AXIS_tvalid => seqbufMfsmtrack1ToHostifAXIS_tvalid,
			seqbufFromMfsmtrack1AXIS_tdata => seqbufMfsmtrack1ToHostifAXIS_tdata,
			seqbufFromMfsmtrack1AXIS_tlast => seqbufMfsmtrack1ToHostifAXIS_tlast,

			reqCntbufFromMfsmtrack1 => reqCntbufMfsmtrack1ToHostif,
			ackCntbufFromMfsmtrack1 => ackCntbufMfsmtrack1ToHostif,
			dneCntbufFromMfsmtrack1 => dneCntbufMfsmtrack1ToHostif,
			avllenCntbufFromMfsmtrack1 => avllenCntbufMfsmtrack1ToHostif,

			cntbufFromMfsmtrack1AXIS_tready => cntbufMfsmtrack1ToHostifAXIS_tready,
			cntbufFromMfsmtrack1AXIS_tvalid => cntbufMfsmtrack1ToHostifAXIS_tvalid,
			cntbufFromMfsmtrack1AXIS_tdata => cntbufMfsmtrack1ToHostifAXIS_tdata,
			cntbufFromMfsmtrack1AXIS_tlast => cntbufMfsmtrack1ToHostifAXIS_tlast,

			rxAXIS_tvalid_sig => hostifRxAXIS_tvalid,

			AXIL_araddr => apuAXIL_araddr,
			AXIL_arprot => apuAXIL_arprot,
			AXIL_arready => apuAXIL_arready,
			AXIL_arvalid => apuAXIL_arvalid,
			AXIL_rdata => apuAXIL_rdata,
			AXIL_rready => apuAXIL_rready,
			AXIL_rresp => apuAXIL_rresp,
			AXIL_rvalid => apuAXIL_rvalid,
			AXIL_rlast => apuAXIL_rlast,
			AXIL_awaddr => apuAXIL_awaddr,
			AXIL_awprot => apuAXIL_awprot,
			AXIL_awready => apuAXIL_awready,
			AXIL_awvalid => apuAXIL_awvalid,
			AXIL_wdata => apuAXIL_wdata,
			AXIL_wready => apuAXIL_wready,
			AXIL_wstrb => apuAXIL_wstrb,
			AXIL_wvalid => apuAXIL_wvalid,
			AXIL_bready => apuAXIL_bready,
			AXIL_bresp => apuAXIL_bresp,
			AXIL_bvalid => apuAXIL_bvalid,

			stateOp_dbg => hostifStateOp_dbg
		);

	myIdent : Ident
		generic map (
			fMclk => fMclk,
			fMemclk => fMemclk
		)
		port map (
			getVer => identGetVer,
			getHash => identGetHash,
			getWho => identGetWho,

			getCfgFMclk => identGetCfgFMclk,
			getCfgFMemclk => identGetCfgFMemclk
		);

	myMemgptrack : Memgptrack
		port map (
			reset => reset,

			resetMemclk => resetMemclk,

			mclk => mclk,

			memclk => memclk,

			resetTrkclk => open,
			trkclk => open,

			getInfoTixVState => memgptrackGetInfoTixVState,

			reqInvSelect => reqInvMemgptrackSelect,
			ackInvSelect => ackInvMemgptrackSelect,

			selectStaTixVTrigger => memgptrackSelectStaTixVTrigger,
			selectStoTixVTrigger => memgptrackSelectStoTixVTrigger,

			reqInvSet => reqInvMemgptrackSet,
			ackInvSet => ackInvMemgptrackSet,

			setRng => memgptrackSetRng,
			setTCapt => memgptrackSetTCapt
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

			selectTixVSource => mfsmtrack0SelectTixVSource,
			selectStaTixVTrigger => mfsmtrack0SelectStaTixVTrigger,
			selectStoTixVTrigger => mfsmtrack0SelectStoTixVTrigger,

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

			selectTixVSource => mfsmtrack1SelectTixVSource,
			selectStaTixVTrigger => mfsmtrack1SelectStaTixVTrigger,
			selectStoTixVTrigger => mfsmtrack1SelectStoTixVTrigger,

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

			clientStateGetbufB => clientStateGetbufB_dbg,
			clientStateSetbufB => clientStateSetbufB_dbg,
			tkclksrcStateOp => tkclksrcStateOp_dbg
		);

	myMgptrack : Mgptrack
		port map (
			reset => reset,
			mclk => mclk,

			resetTrkclk => open,
			trkclk => open,

			getInfoTixVState => mgptrackGetInfoTixVState,

			reqInvSelect => reqInvMgptrackSelect,
			ackInvSelect => ackInvMgptrackSelect,

			selectStaTixVTrigger => mgptrackSelectStaTixVTrigger,
			selectStoTixVTrigger => mgptrackSelectStoTixVTrigger,

			reqInvSet => reqInvMgptrackSet,
			ackInvSet => ackInvMgptrackSet,

			setRng => mgptrackSetRng,
			setTCapt => mgptrackSetTCapt
		);

	myRgbled0 : Rgbled_v1_0
		generic map (
			fMclk => 50000
		)
		port map (
			reset => reset,
			mclk => mclk,
			rgb => rgb0,

			r => rgb0_r,
			g => rgb0_g,
			b => b
		);

	myState : State
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			getTixVTidkState => stateGetTixVTidkState,

			commok => commok,
			trafgenRng => trafgenRng,
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

	myTrafgen : Trafgen
		port map (
			reset => reset,
			mclk => mclk,

			resetMemclk => resetMemclk,
			memclk => memclk,

			memTWrAXI_awaddr => memTWrAXI_awaddr,
			memTWrAXI_awready => memTWrAXI_awready,
			memTWrAXI_awvalid => memTWrAXI_awvalid,
			memTWrAXI_wdata => memTWrAXI_wdata,
			memTWrAXI_wlast => memTWrAXI_wlast,
			memTWrAXI_wready => memTWrAXI_wready,
			memTWrAXI_wvalid => memTWrAXI_wvalid,
			memTWrAXI_bready => memTWrAXI_bready,
			memTWrAXI_bresp => memTWrAXI_bresp,
			memTWrAXI_bvalid => memTWrAXI_bvalid,

			reqToDdrifWr => reqTrafgenToDdrifWr,
			ackToDdrifWr => ackTrafgenToDdrifWr,

			reqInvSet => reqInvTrafgenSet,
			ackInvSet => ackInvTrafgenSet,

			setRng => trafgenSetRng
		);

	------------------------------------------------------------------------
	-- implementation: mclk wiring and reset (mclk)
	------------------------------------------------------------------------

	-- IP impl.mclk.wiring --- BEGIN
	mclk <= aclk_sig;
	-- IP impl.mclk.wiring --- END

	-- IP impl.mclk.rising --- BEGIN
	process (areset, mclk)
		-- IP impl.mclk.vars --- BEGIN
		constant imax: natural := 16;
		variable i: natural range 0 to imax;

		constant jmax: natural := 1;
		variable j: natural range 0 to jmax;
		-- IP impl.mclk.vars --- END

	begin
		if areset='1' then
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
	-- implementation: memclk wiring and reset (memclk)
	------------------------------------------------------------------------

	-- IP impl.memclk.wiring --- BEGIN
	-- IP impl.memclk.wiring --- END

	-- IP impl.memclk.rising --- BEGIN
	process (areset, memclk)
		-- IP impl.memclk.vars --- BEGIN
		constant imax: natural := (16*fMemclk)/fMclk+1;
		variable i: natural range 0 to imax;
		-- IP impl.memclk.vars --- END

	begin
		if areset='1' then
			-- IP impl.memclk.asyncrst --- BEGIN
			resetMemclk <= '1';

			i := 0;
			-- IP impl.memclk.asyncrst --- END

		elsif rising_edge(memclk) then
			if reqResetFromHostif='1' then
				resetMemclk <= '1';
				i := 0;

			elsif i=imax then
				resetMemclk <= '0';
			else
				i := i + 1;
			end if;
		end if;
	end process;
	-- IP impl.memclk.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Rtl;
