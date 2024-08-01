/**
	* \file CtrWtedZudkMemwrtrack.cpp
	* memwrtrack controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 24 Jul 2024
	*/
// IP header --- ABOVE

#include "CtrWtedZudkMemwrtrack.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedZudkMemwrtrack::VecVCapture
 ******************************************************************************/

uint8_t CtrWtedZudkMemwrtrack::VecVCapture::getTix(
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

string CtrWtedZudkMemwrtrack::VecVCapture::getSref(
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

string CtrWtedZudkMemwrtrack::VecVCapture::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedZudkMemwrtrack::VecVCapture::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {REQCLIENTTODDRIFWR,ACKCLIENTTODDRIFWR,REQTRAFGENTODDRIFWR,ACKTRAFGENTODDRIFWR,DDRAXIAWADDRSIG0,DDRAXIAWADDRSIG1,DDRAXIAWREADY,DDRAXIAWVALIDSIG,DDRAXIWREADY,DDRAXIWDATASIG0,DDRAXIWDATASIG1,DDRAXIWLASTSIG,DDRAXIBREADYSIG,DDRAXIBVALID};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedZudkMemwrtrack::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedZudkMemwrtrack::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getinfo") return GETINFO;
	else if (s == "select") return SELECT;
	else if (s == "set") return SET;

	return(0xFF);
};

string CtrWtedZudkMemwrtrack::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETINFO) return("getInfo");
	else if (tix == SELECT) return("select");
	else if (tix == SET) return("set");

	return("");
};

void CtrWtedZudkMemwrtrack::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETINFO,SELECT,SET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedZudkMemwrtrack::VecVState
 ******************************************************************************/

uint8_t CtrWtedZudkMemwrtrack::VecVState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "arm") return ARM;
	else if (s == "acq") return ACQ;
	else if (s == "done") return DONE;

	return(0xFF);
};

string CtrWtedZudkMemwrtrack::VecVState::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == ARM) return("arm");
	else if (tix == ACQ) return("acq");
	else if (tix == DONE) return("done");

	return("");
};

string CtrWtedZudkMemwrtrack::VecVState::getTitle(
			const uint8_t tix
		) {
	if (tix == ARM) return("armed");
	if (tix == ACQ) return("acquiring");

	return(getSref(tix));
};

void CtrWtedZudkMemwrtrack::VecVState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,ARM,ACQ,DONE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedZudkMemwrtrack::VecVTrigger
 ******************************************************************************/

uint8_t CtrWtedZudkMemwrtrack::VecVTrigger::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "void") return VOID;
	else if (s == "ackinvclientloadgetbuf") return ACKINVCLIENTLOADGETBUF;
	else if (s == "ackinvclientstoresetbuf") return ACKINVCLIENTSTORESETBUF;

	return(0xFF);
};

string CtrWtedZudkMemwrtrack::VecVTrigger::getSref(
			const uint8_t tix
		) {
	if (tix == VOID) return("void");
	else if (tix == ACKINVCLIENTLOADGETBUF) return("ackInvClientLoadGetbuf");
	else if (tix == ACKINVCLIENTSTORESETBUF) return("ackInvClientStoreSetbuf");

	return("");
};

string CtrWtedZudkMemwrtrack::VecVTrigger::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedZudkMemwrtrack::VecVTrigger::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {VOID,ACKINVCLIENTLOADGETBUF,ACKINVCLIENTSTORESETBUF};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedZudkMemwrtrack
 ******************************************************************************/

CtrWtedZudkMemwrtrack::CtrWtedZudkMemwrtrack(
			UntWted* unt
		) : CtrWted(unt) {
	cmdGetInfo = getNewCmdGetInfo();
	cmdSelect = getNewCmdSelect();
	cmdSet = getNewCmdSet();
};

CtrWtedZudkMemwrtrack::~CtrWtedZudkMemwrtrack() {
	delete cmdGetInfo;
	delete cmdSelect;
	delete cmdSet;
};

uint8_t CtrWtedZudkMemwrtrack::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedZudkMemwrtrack::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedZudkMemwrtrack::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedZudkMemwrtrack::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETINFO) cmd = getNewCmdGetInfo();
	else if (tixVCommand == VecVCommand::SELECT) cmd = getNewCmdSelect();
	else if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();

	return cmd;
};

Cmd* CtrWtedZudkMemwrtrack::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVState", Par::VecVType::TIX, CtrWtedZudkMemwrtrack::VecVState::getTix, CtrWtedZudkMemwrtrack::VecVState::getSref, CtrWtedZudkMemwrtrack::VecVState::fillFeed);

	return cmd;
};

void CtrWtedZudkMemwrtrack::getInfo(
			uint8_t& tixVState
		) {
	unt->lockAccess("CtrWtedZudkMemwrtrack::getInfo");

	Cmd* cmd = cmdGetInfo;

	if (unt->runCmd(cmd)) {
		tixVState = cmd->parsRet["tixVState"].getTix();
	} else throw DbeException("error running getInfo");

	unt->unlockAccess("CtrWtedZudkMemwrtrack::getInfo");
};

Cmd* CtrWtedZudkMemwrtrack::getNewCmdSelect() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SELECT, Cmd::VecVRettype::VOID);

	cmd->addParInv("staTixVTrigger", Par::VecVType::TIX, CtrWtedZudkMemwrtrack::VecVTrigger::getTix, CtrWtedZudkMemwrtrack::VecVTrigger::getSref, CtrWtedZudkMemwrtrack::VecVTrigger::fillFeed);
	cmd->addParInv("staFallingNotRising", Par::VecVType::_BOOL);
	cmd->addParInv("stoTixVTrigger", Par::VecVType::TIX, CtrWtedZudkMemwrtrack::VecVTrigger::getTix, CtrWtedZudkMemwrtrack::VecVTrigger::getSref, CtrWtedZudkMemwrtrack::VecVTrigger::fillFeed);
	cmd->addParInv("stoFallingNotRising", Par::VecVType::_BOOL);

	return cmd;
};

void CtrWtedZudkMemwrtrack::select(
			const uint8_t staTixVTrigger
			, const bool staFallingNotRising
			, const uint8_t stoTixVTrigger
			, const bool stoFallingNotRising
		) {
	unt->lockAccess("CtrWtedZudkMemwrtrack::select");

	Cmd* cmd = cmdSelect;

	cmd->parsInv["staTixVTrigger"].setTix(staTixVTrigger);
	cmd->parsInv["staFallingNotRising"].setBool(staFallingNotRising);
	cmd->parsInv["stoTixVTrigger"].setTix(stoTixVTrigger);
	cmd->parsInv["stoFallingNotRising"].setBool(stoFallingNotRising);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running select");

	unt->unlockAccess("CtrWtedZudkMemwrtrack::select");
};

Cmd* CtrWtedZudkMemwrtrack::getNewCmdSet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("TCapt", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedZudkMemwrtrack::set(
			const bool rng
			, const uint32_t TCapt
		) {
	unt->lockAccess("CtrWtedZudkMemwrtrack::set");

	Cmd* cmd = cmdSet;

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["TCapt"].setUint32(TCapt);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running set");

	unt->unlockAccess("CtrWtedZudkMemwrtrack::set");
};
