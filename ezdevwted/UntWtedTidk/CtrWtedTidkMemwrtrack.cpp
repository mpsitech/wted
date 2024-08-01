/**
	* \file CtrWtedTidkMemwrtrack.cpp
	* memwrtrack controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 24 Jul 2024
	*/
// IP header --- ABOVE

#include "CtrWtedTidkMemwrtrack.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedTidkMemwrtrack::VecVCapture
 ******************************************************************************/

uint8_t CtrWtedTidkMemwrtrack::VecVCapture::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "reqclienttoddrifwr") return REQCLIENTTODDRIFWR;
	else if (s == "ackclienttoddrifwr") return ACKCLIENTTODDRIFWR;
	else if (s == "reqtrafgentoddrifwr") return REQTRAFGENTODDRIFWR;
	else if (s == "acktrafgentoddrifwr") return ACKTRAFGENTODDRIFWR;
	else if (s == "ddraxi_awaddr_sig0") return DDRAXIAWADDRSIG0;
	else if (s == "ddraxi_awaddr_sig1") return DDRAXIAWADDRSIG1;
	else if (s == "ddraxi_awready") return DDRAXIAWREADY;
	else if (s == "ddraxi_awvalid_sig") return DDRAXIAWVALIDSIG;
	else if (s == "ddraxi_wready") return DDRAXIWREADY;
	else if (s == "ddraxi_wdata_sig0") return DDRAXIWDATASIG0;
	else if (s == "ddraxi_wdata_sig1") return DDRAXIWDATASIG1;
	else if (s == "ddraxi_wlast_sig") return DDRAXIWLASTSIG;
	else if (s == "ddraxi_bready_sig") return DDRAXIBREADYSIG;
	else if (s == "ddraxi_bvalid") return DDRAXIBVALID;

	return(0xFF);
};

string CtrWtedTidkMemwrtrack::VecVCapture::getSref(
			const uint8_t tix
		) {
	if (tix == REQCLIENTTODDRIFWR) return("reqClientToDdrifWr");
	else if (tix == ACKCLIENTTODDRIFWR) return("ackClientToDdrifWr");
	else if (tix == REQTRAFGENTODDRIFWR) return("reqTrafgenToDdrifWr");
	else if (tix == ACKTRAFGENTODDRIFWR) return("ackTrafgenToDdrifWr");
	else if (tix == DDRAXIAWADDRSIG0) return("ddrAXI_awaddr_sig0");
	else if (tix == DDRAXIAWADDRSIG1) return("ddrAXI_awaddr_sig1");
	else if (tix == DDRAXIAWREADY) return("ddrAXI_awready");
	else if (tix == DDRAXIAWVALIDSIG) return("ddrAXI_awvalid_sig");
	else if (tix == DDRAXIWREADY) return("ddrAXI_wready");
	else if (tix == DDRAXIWDATASIG0) return("ddrAXI_wdata_sig0");
	else if (tix == DDRAXIWDATASIG1) return("ddrAXI_wdata_sig1");
	else if (tix == DDRAXIWLASTSIG) return("ddrAXI_wlast_sig");
	else if (tix == DDRAXIBREADYSIG) return("ddrAXI_bready_sig");
	else if (tix == DDRAXIBVALID) return("ddrAXI_bvalid");

	return("");
};

string CtrWtedTidkMemwrtrack::VecVCapture::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedTidkMemwrtrack::VecVCapture::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {REQCLIENTTODDRIFWR,ACKCLIENTTODDRIFWR,REQTRAFGENTODDRIFWR,ACKTRAFGENTODDRIFWR,DDRAXIAWADDRSIG0,DDRAXIAWADDRSIG1,DDRAXIAWREADY,DDRAXIAWVALIDSIG,DDRAXIWREADY,DDRAXIWDATASIG0,DDRAXIWDATASIG1,DDRAXIWLASTSIG,DDRAXIBREADYSIG,DDRAXIBVALID};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMemwrtrack::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedTidkMemwrtrack::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getinfo") return GETINFO;
	else if (s == "select") return SELECT;
	else if (s == "set") return SET;

	return(0xFF);
};

string CtrWtedTidkMemwrtrack::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETINFO) return("getInfo");
	else if (tix == SELECT) return("select");
	else if (tix == SET) return("set");

	return("");
};

void CtrWtedTidkMemwrtrack::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETINFO,SELECT,SET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedTidkMemwrtrack::VecVState
 ******************************************************************************/

uint8_t CtrWtedTidkMemwrtrack::VecVState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "arm") return ARM;
	else if (s == "acq") return ACQ;
	else if (s == "done") return DONE;

	return(0xFF);
};

string CtrWtedTidkMemwrtrack::VecVState::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == ARM) return("arm");
	else if (tix == ACQ) return("acq");
	else if (tix == DONE) return("done");

	return("");
};

string CtrWtedTidkMemwrtrack::VecVState::getTitle(
			const uint8_t tix
		) {
	if (tix == ARM) return("armed");
	if (tix == ACQ) return("acquiring");

	return(getSref(tix));
};

void CtrWtedTidkMemwrtrack::VecVState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,ARM,ACQ,DONE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMemwrtrack::VecVTrigger
 ******************************************************************************/

uint8_t CtrWtedTidkMemwrtrack::VecVTrigger::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "void") return VOID;
	else if (s == "ackinvclientloadgetbuf") return ACKINVCLIENTLOADGETBUF;
	else if (s == "ackinvclientstoresetbuf") return ACKINVCLIENTSTORESETBUF;

	return(0xFF);
};

string CtrWtedTidkMemwrtrack::VecVTrigger::getSref(
			const uint8_t tix
		) {
	if (tix == VOID) return("void");
	else if (tix == ACKINVCLIENTLOADGETBUF) return("ackInvClientLoadGetbuf");
	else if (tix == ACKINVCLIENTSTORESETBUF) return("ackInvClientStoreSetbuf");

	return("");
};

string CtrWtedTidkMemwrtrack::VecVTrigger::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedTidkMemwrtrack::VecVTrigger::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {VOID,ACKINVCLIENTLOADGETBUF,ACKINVCLIENTSTORESETBUF};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMemwrtrack
 ******************************************************************************/

CtrWtedTidkMemwrtrack::CtrWtedTidkMemwrtrack(
			UntWted* unt
		) : CtrWted(unt) {
	cmdGetInfo = getNewCmdGetInfo();
	cmdSelect = getNewCmdSelect();
	cmdSet = getNewCmdSet();
};

CtrWtedTidkMemwrtrack::~CtrWtedTidkMemwrtrack() {
	delete cmdGetInfo;
	delete cmdSelect;
	delete cmdSet;
};

uint8_t CtrWtedTidkMemwrtrack::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedTidkMemwrtrack::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedTidkMemwrtrack::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedTidkMemwrtrack::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETINFO) cmd = getNewCmdGetInfo();
	else if (tixVCommand == VecVCommand::SELECT) cmd = getNewCmdSelect();
	else if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();

	return cmd;
};

Cmd* CtrWtedTidkMemwrtrack::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVState", Par::VecVType::TIX, CtrWtedTidkMemwrtrack::VecVState::getTix, CtrWtedTidkMemwrtrack::VecVState::getSref, CtrWtedTidkMemwrtrack::VecVState::fillFeed);

	return cmd;
};

void CtrWtedTidkMemwrtrack::getInfo(
			uint8_t& tixVState
		) {
	unt->lockAccess("CtrWtedTidkMemwrtrack::getInfo");

	Cmd* cmd = cmdGetInfo;

	if (unt->runCmd(cmd)) {
		tixVState = cmd->parsRet["tixVState"].getTix();
	} else throw DbeException("error running getInfo");

	unt->unlockAccess("CtrWtedTidkMemwrtrack::getInfo");
};

Cmd* CtrWtedTidkMemwrtrack::getNewCmdSelect() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SELECT, Cmd::VecVRettype::VOID);

	cmd->addParInv("staTixVTrigger", Par::VecVType::TIX, CtrWtedTidkMemwrtrack::VecVTrigger::getTix, CtrWtedTidkMemwrtrack::VecVTrigger::getSref, CtrWtedTidkMemwrtrack::VecVTrigger::fillFeed);
	cmd->addParInv("staFallingNotRising", Par::VecVType::_BOOL);
	cmd->addParInv("stoTixVTrigger", Par::VecVType::TIX, CtrWtedTidkMemwrtrack::VecVTrigger::getTix, CtrWtedTidkMemwrtrack::VecVTrigger::getSref, CtrWtedTidkMemwrtrack::VecVTrigger::fillFeed);
	cmd->addParInv("stoFallingNotRising", Par::VecVType::_BOOL);

	return cmd;
};

void CtrWtedTidkMemwrtrack::select(
			const uint8_t staTixVTrigger
			, const bool staFallingNotRising
			, const uint8_t stoTixVTrigger
			, const bool stoFallingNotRising
		) {
	unt->lockAccess("CtrWtedTidkMemwrtrack::select");

	Cmd* cmd = cmdSelect;

	cmd->parsInv["staTixVTrigger"].setTix(staTixVTrigger);
	cmd->parsInv["staFallingNotRising"].setBool(staFallingNotRising);
	cmd->parsInv["stoTixVTrigger"].setTix(stoTixVTrigger);
	cmd->parsInv["stoFallingNotRising"].setBool(stoFallingNotRising);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running select");

	unt->unlockAccess("CtrWtedTidkMemwrtrack::select");
};

Cmd* CtrWtedTidkMemwrtrack::getNewCmdSet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("TCapt", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedTidkMemwrtrack::set(
			const bool rng
			, const uint32_t TCapt
		) {
	unt->lockAccess("CtrWtedTidkMemwrtrack::set");

	Cmd* cmd = cmdSet;

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["TCapt"].setUint32(TCapt);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running set");

	unt->unlockAccess("CtrWtedTidkMemwrtrack::set");
};
