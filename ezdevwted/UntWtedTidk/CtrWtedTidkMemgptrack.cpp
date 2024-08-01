/**
	* \file CtrWtedTidkMemgptrack.cpp
	* memgptrack controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedTidkMemgptrack.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedTidkMemgptrack::VecVCapture
 ******************************************************************************/

uint8_t CtrWtedTidkMemgptrack::VecVCapture::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "reqclienttoddrifrd") return REQCLIENTTODDRIFRD;
	else if (s == "ackclienttoddrifrd") return ACKCLIENTTODDRIFRD;
	else if (s == "memcrdaxi_rvalid") return MEMCRDAXIRVALID;
	else if (s == "reqclienttoddrifwr") return REQCLIENTTODDRIFWR;
	else if (s == "ackclienttoddrifwr") return ACKCLIENTTODDRIFWR;
	else if (s == "memcwraxi_wready") return MEMCWRAXIWREADY;
	else if (s == "reqtrafgentoddrifwr") return REQTRAFGENTODDRIFWR;
	else if (s == "acktrafgentoddrifwr") return ACKTRAFGENTODDRIFWR;
	else if (s == "memtwraxi_wready") return MEMTWRAXIWREADY;

	return(0xFF);
};

string CtrWtedTidkMemgptrack::VecVCapture::getSref(
			const uint8_t tix
		) {
	if (tix == REQCLIENTTODDRIFRD) return("reqClientToDdrifRd");
	else if (tix == ACKCLIENTTODDRIFRD) return("ackClientToDdrifRd");
	else if (tix == MEMCRDAXIRVALID) return("memCRdAXI_rvalid");
	else if (tix == REQCLIENTTODDRIFWR) return("reqClientToDdrifWr");
	else if (tix == ACKCLIENTTODDRIFWR) return("ackClientToDdrifWr");
	else if (tix == MEMCWRAXIWREADY) return("memCWrAXI_wready");
	else if (tix == REQTRAFGENTODDRIFWR) return("reqTrafgenToDdrifWr");
	else if (tix == ACKTRAFGENTODDRIFWR) return("ackTrafgenToDdrifWr");
	else if (tix == MEMTWRAXIWREADY) return("memTWrAXI_wready");

	return("");
};

string CtrWtedTidkMemgptrack::VecVCapture::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedTidkMemgptrack::VecVCapture::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {REQCLIENTTODDRIFRD,ACKCLIENTTODDRIFRD,MEMCRDAXIRVALID,REQCLIENTTODDRIFWR,ACKCLIENTTODDRIFWR,MEMCWRAXIWREADY,REQTRAFGENTODDRIFWR,ACKTRAFGENTODDRIFWR,MEMTWRAXIWREADY};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMemgptrack::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedTidkMemgptrack::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getinfo") return GETINFO;
	else if (s == "select") return SELECT;
	else if (s == "set") return SET;

	return(0xFF);
};

string CtrWtedTidkMemgptrack::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETINFO) return("getInfo");
	else if (tix == SELECT) return("select");
	else if (tix == SET) return("set");

	return("");
};

void CtrWtedTidkMemgptrack::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETINFO,SELECT,SET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedTidkMemgptrack::VecVState
 ******************************************************************************/

uint8_t CtrWtedTidkMemgptrack::VecVState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "arm") return ARM;
	else if (s == "acq") return ACQ;
	else if (s == "done") return DONE;

	return(0xFF);
};

string CtrWtedTidkMemgptrack::VecVState::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == ARM) return("arm");
	else if (tix == ACQ) return("acq");
	else if (tix == DONE) return("done");

	return("");
};

string CtrWtedTidkMemgptrack::VecVState::getTitle(
			const uint8_t tix
		) {
	if (tix == ARM) return("armed");
	if (tix == ACQ) return("acquiring");

	return(getSref(tix));
};

void CtrWtedTidkMemgptrack::VecVState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,ARM,ACQ,DONE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMemgptrack::VecVTrigger
 ******************************************************************************/

uint8_t CtrWtedTidkMemgptrack::VecVTrigger::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "void") return VOID;
	else if (s == "ackinvclientloadgetbuf") return ACKINVCLIENTLOADGETBUF;
	else if (s == "ackinvclientstoresetbuf") return ACKINVCLIENTSTORESETBUF;

	return(0xFF);
};

string CtrWtedTidkMemgptrack::VecVTrigger::getSref(
			const uint8_t tix
		) {
	if (tix == VOID) return("void");
	else if (tix == ACKINVCLIENTLOADGETBUF) return("ackInvClientLoadGetbuf");
	else if (tix == ACKINVCLIENTSTORESETBUF) return("ackInvClientStoreSetbuf");

	return("");
};

string CtrWtedTidkMemgptrack::VecVTrigger::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedTidkMemgptrack::VecVTrigger::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {VOID,ACKINVCLIENTLOADGETBUF,ACKINVCLIENTSTORESETBUF};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMemgptrack
 ******************************************************************************/

CtrWtedTidkMemgptrack::CtrWtedTidkMemgptrack(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedTidkMemgptrack::~CtrWtedTidkMemgptrack() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedTidkMemgptrack::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedTidkMemgptrack::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedTidkMemgptrack::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedTidkMemgptrack::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETINFO) cmd = getNewCmdGetInfo();
	else if (tixVCommand == VecVCommand::SELECT) cmd = getNewCmdSelect();
	else if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();

	return cmd;
};

Cmd* CtrWtedTidkMemgptrack::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVState", Par::VecVType::TIX, CtrWtedTidkMemgptrack::VecVState::getTix, CtrWtedTidkMemgptrack::VecVState::getSref, CtrWtedTidkMemgptrack::VecVState::fillFeed);

	return cmd;
};

void CtrWtedTidkMemgptrack::getInfo(
			uint8_t& tixVState
		) {
	unt->lockAccess("CtrWtedTidkMemgptrack::getInfo");

	Cmd* cmd = cmdGetInfo;

	if (unt->runCmd(cmd)) {
		tixVState = cmd->parsRet["tixVState"].getTix();
	} else throw DbeException("error running getInfo");

	unt->unlockAccess("CtrWtedTidkMemgptrack::getInfo");
};

Cmd* CtrWtedTidkMemgptrack::getNewCmdSelect() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SELECT, Cmd::VecVRettype::VOID);

	cmd->addParInv("staTixVTrigger", Par::VecVType::TIX, CtrWtedTidkMemgptrack::VecVTrigger::getTix, CtrWtedTidkMemgptrack::VecVTrigger::getSref, CtrWtedTidkMemgptrack::VecVTrigger::fillFeed);
	cmd->addParInv("stoTixVTrigger", Par::VecVType::TIX, CtrWtedTidkMemgptrack::VecVTrigger::getTix, CtrWtedTidkMemgptrack::VecVTrigger::getSref, CtrWtedTidkMemgptrack::VecVTrigger::fillFeed);

	return cmd;
};

void CtrWtedTidkMemgptrack::select(
			const uint8_t staTixVTrigger
			, const uint8_t stoTixVTrigger
		) {
	unt->lockAccess("CtrWtedTidkMemgptrack::select");

	Cmd* cmd = cmdSelect;

	cmd->parsInv["staTixVTrigger"].setTix(staTixVTrigger);
	cmd->parsInv["stoTixVTrigger"].setTix(stoTixVTrigger);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running select");

	unt->unlockAccess("CtrWtedTidkMemgptrack::select");
};

Cmd* CtrWtedTidkMemgptrack::getNewCmdSet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("TCapt", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedTidkMemgptrack::set(
			const bool rng
			, const uint32_t TCapt
		) {
	unt->lockAccess("CtrWtedTidkMemgptrack::set");

	Cmd* cmd = cmdSet;

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["TCapt"].setUint32(TCapt);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running set");

	unt->unlockAccess("CtrWtedTidkMemgptrack::set");
};
