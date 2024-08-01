/**
	* \file CtrWtedTidkMemrdtrack.cpp
	* memrdtrack controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 24 Jul 2024
	*/
// IP header --- ABOVE

#include "CtrWtedTidkMemrdtrack.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedTidkMemrdtrack::VecVCapture
 ******************************************************************************/

uint8_t CtrWtedTidkMemrdtrack::VecVCapture::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "reqclienttoddrifrd") return REQCLIENTTODDRIFRD;
	else if (s == "ackclienttoddrifrd") return ACKCLIENTTODDRIFRD;
	else if (s == "memcrdaxi_rvalid") return MEMCRDAXIRVALID;
	else if (s == "ddraxi_araddr_sig0") return DDRAXIARADDRSIG0;
	else if (s == "ddraxi_araddr_sig1") return DDRAXIARADDRSIG1;
	else if (s == "ddraxi_arready") return DDRAXIARREADY;
	else if (s == "ddraxi_arvalid_sig") return DDRAXIARVALIDSIG;
	else if (s == "ddraxi_rready_sig") return DDRAXIRREADYSIG;
	else if (s == "ddraxi_rdata0") return DDRAXIRDATA0;
	else if (s == "ddraxi_rdata1") return DDRAXIRDATA1;
	else if (s == "ddraxi_rdata2") return DDRAXIRDATA2;
	else if (s == "ddraxi_rdata3") return DDRAXIRDATA3;
	else if (s == "ddraxi_rlast") return DDRAXIRLAST;

	return(0xFF);
};

string CtrWtedTidkMemrdtrack::VecVCapture::getSref(
			const uint8_t tix
		) {
	if (tix == REQCLIENTTODDRIFRD) return("reqClientToDdrifRd");
	else if (tix == ACKCLIENTTODDRIFRD) return("ackClientToDdrifRd");
	else if (tix == MEMCRDAXIRVALID) return("memCRdAXI_rvalid");
	else if (tix == DDRAXIARADDRSIG0) return("ddrAXI_araddr_sig0");
	else if (tix == DDRAXIARADDRSIG1) return("ddrAXI_araddr_sig1");
	else if (tix == DDRAXIARREADY) return("ddrAXI_arready");
	else if (tix == DDRAXIARVALIDSIG) return("ddrAXI_arvalid_sig");
	else if (tix == DDRAXIRREADYSIG) return("ddrAXI_rready_sig");
	else if (tix == DDRAXIRDATA0) return("ddrAXI_rdata0");
	else if (tix == DDRAXIRDATA1) return("ddrAXI_rdata1");
	else if (tix == DDRAXIRDATA2) return("ddrAXI_rdata2");
	else if (tix == DDRAXIRDATA3) return("ddrAXI_rdata3");
	else if (tix == DDRAXIRLAST) return("ddrAXI_rlast");

	return("");
};

string CtrWtedTidkMemrdtrack::VecVCapture::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedTidkMemrdtrack::VecVCapture::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {REQCLIENTTODDRIFRD,ACKCLIENTTODDRIFRD,MEMCRDAXIRVALID,DDRAXIARADDRSIG0,DDRAXIARADDRSIG1,DDRAXIARREADY,DDRAXIARVALIDSIG,DDRAXIRREADYSIG,DDRAXIRDATA0,DDRAXIRDATA1,DDRAXIRDATA2,DDRAXIRDATA3,DDRAXIRLAST};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMemrdtrack::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedTidkMemrdtrack::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getinfo") return GETINFO;
	else if (s == "select") return SELECT;
	else if (s == "set") return SET;

	return(0xFF);
};

string CtrWtedTidkMemrdtrack::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETINFO) return("getInfo");
	else if (tix == SELECT) return("select");
	else if (tix == SET) return("set");

	return("");
};

void CtrWtedTidkMemrdtrack::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETINFO,SELECT,SET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedTidkMemrdtrack::VecVState
 ******************************************************************************/

uint8_t CtrWtedTidkMemrdtrack::VecVState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "arm") return ARM;
	else if (s == "acq") return ACQ;
	else if (s == "done") return DONE;

	return(0xFF);
};

string CtrWtedTidkMemrdtrack::VecVState::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == ARM) return("arm");
	else if (tix == ACQ) return("acq");
	else if (tix == DONE) return("done");

	return("");
};

string CtrWtedTidkMemrdtrack::VecVState::getTitle(
			const uint8_t tix
		) {
	if (tix == ARM) return("armed");
	if (tix == ACQ) return("acquiring");

	return(getSref(tix));
};

void CtrWtedTidkMemrdtrack::VecVState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,ARM,ACQ,DONE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMemrdtrack::VecVTrigger
 ******************************************************************************/

uint8_t CtrWtedTidkMemrdtrack::VecVTrigger::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "void") return VOID;
	else if (s == "ackinvclientloadgetbuf") return ACKINVCLIENTLOADGETBUF;
	else if (s == "ackinvclientstoresetbuf") return ACKINVCLIENTSTORESETBUF;

	return(0xFF);
};

string CtrWtedTidkMemrdtrack::VecVTrigger::getSref(
			const uint8_t tix
		) {
	if (tix == VOID) return("void");
	else if (tix == ACKINVCLIENTLOADGETBUF) return("ackInvClientLoadGetbuf");
	else if (tix == ACKINVCLIENTSTORESETBUF) return("ackInvClientStoreSetbuf");

	return("");
};

string CtrWtedTidkMemrdtrack::VecVTrigger::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedTidkMemrdtrack::VecVTrigger::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {VOID,ACKINVCLIENTLOADGETBUF,ACKINVCLIENTSTORESETBUF};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMemrdtrack
 ******************************************************************************/

CtrWtedTidkMemrdtrack::CtrWtedTidkMemrdtrack(
			UntWted* unt
		) : CtrWted(unt) {
	cmdGetInfo = getNewCmdGetInfo();
	cmdSelect = getNewCmdSelect();
	cmdSet = getNewCmdSet();
};

CtrWtedTidkMemrdtrack::~CtrWtedTidkMemrdtrack() {
	delete cmdGetInfo;
	delete cmdSelect;
	delete cmdSet;
};

uint8_t CtrWtedTidkMemrdtrack::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedTidkMemrdtrack::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedTidkMemrdtrack::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedTidkMemrdtrack::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETINFO) cmd = getNewCmdGetInfo();
	else if (tixVCommand == VecVCommand::SELECT) cmd = getNewCmdSelect();
	else if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();

	return cmd;
};

Cmd* CtrWtedTidkMemrdtrack::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVState", Par::VecVType::TIX, CtrWtedTidkMemrdtrack::VecVState::getTix, CtrWtedTidkMemrdtrack::VecVState::getSref, CtrWtedTidkMemrdtrack::VecVState::fillFeed);

	return cmd;
};

void CtrWtedTidkMemrdtrack::getInfo(
			uint8_t& tixVState
		) {
	unt->lockAccess("CtrWtedTidkMemrdtrack::getInfo");

	Cmd* cmd = cmdGetInfo;

	if (unt->runCmd(cmd)) {
		tixVState = cmd->parsRet["tixVState"].getTix();
	} else throw DbeException("error running getInfo");

	unt->unlockAccess("CtrWtedTidkMemrdtrack::getInfo");
};

Cmd* CtrWtedTidkMemrdtrack::getNewCmdSelect() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SELECT, Cmd::VecVRettype::VOID);

	cmd->addParInv("staTixVTrigger", Par::VecVType::TIX, CtrWtedTidkMemrdtrack::VecVTrigger::getTix, CtrWtedTidkMemrdtrack::VecVTrigger::getSref, CtrWtedTidkMemrdtrack::VecVTrigger::fillFeed);
	cmd->addParInv("staFallingNotRising", Par::VecVType::_BOOL);
	cmd->addParInv("stoTixVTrigger", Par::VecVType::TIX, CtrWtedTidkMemrdtrack::VecVTrigger::getTix, CtrWtedTidkMemrdtrack::VecVTrigger::getSref, CtrWtedTidkMemrdtrack::VecVTrigger::fillFeed);
	cmd->addParInv("stoFallingNotRising", Par::VecVType::_BOOL);

	return cmd;
};

void CtrWtedTidkMemrdtrack::select(
			const uint8_t staTixVTrigger
			, const bool staFallingNotRising
			, const uint8_t stoTixVTrigger
			, const bool stoFallingNotRising
		) {
	unt->lockAccess("CtrWtedTidkMemrdtrack::select");

	Cmd* cmd = cmdSelect;

	cmd->parsInv["staTixVTrigger"].setTix(staTixVTrigger);
	cmd->parsInv["staFallingNotRising"].setBool(staFallingNotRising);
	cmd->parsInv["stoTixVTrigger"].setTix(stoTixVTrigger);
	cmd->parsInv["stoFallingNotRising"].setBool(stoFallingNotRising);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running select");

	unt->unlockAccess("CtrWtedTidkMemrdtrack::select");
};

Cmd* CtrWtedTidkMemrdtrack::getNewCmdSet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("TCapt", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedTidkMemrdtrack::set(
			const bool rng
			, const uint32_t TCapt
		) {
	unt->lockAccess("CtrWtedTidkMemrdtrack::set");

	Cmd* cmd = cmdSet;

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["TCapt"].setUint32(TCapt);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running set");

	unt->unlockAccess("CtrWtedTidkMemrdtrack::set");
};
