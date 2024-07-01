/**
	* \file CtrWtedClebMfsmtrack1.cpp
	* mfsmtrack1 controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedClebMfsmtrack1.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedClebMfsmtrack1::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedClebMfsmtrack1::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getinfo") return GETINFO;
	else if (s == "select") return SELECT;
	else if (s == "set") return SET;

	return(0xFF);
};

string CtrWtedClebMfsmtrack1::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETINFO) return("getInfo");
	else if (tix == SELECT) return("select");
	else if (tix == SET) return("set");

	return("");
};

void CtrWtedClebMfsmtrack1::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETINFO,SELECT,SET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedClebMfsmtrack1::VecVSource
 ******************************************************************************/

uint8_t CtrWtedClebMfsmtrack1::VecVSource::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "tkclksrcop") return TKCLKSRCOP;

	return(0xFF);
};

string CtrWtedClebMfsmtrack1::VecVSource::getSref(
			const uint8_t tix
		) {
	if (tix == TKCLKSRCOP) return("tkclksrcOp");

	return("");
};

string CtrWtedClebMfsmtrack1::VecVSource::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedClebMfsmtrack1::VecVSource::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {TKCLKSRCOP};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedClebMfsmtrack1::VecVState
 ******************************************************************************/

uint8_t CtrWtedClebMfsmtrack1::VecVState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "arm") return ARM;
	else if (s == "acq") return ACQ;
	else if (s == "done") return DONE;

	return(0xFF);
};

string CtrWtedClebMfsmtrack1::VecVState::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == ARM) return("arm");
	else if (tix == ACQ) return("acq");
	else if (tix == DONE) return("done");

	return("");
};

string CtrWtedClebMfsmtrack1::VecVState::getTitle(
			const uint8_t tix
		) {
	if (tix == ARM) return("armed");
	if (tix == ACQ) return("acquiring");

	return(getSref(tix));
};

void CtrWtedClebMfsmtrack1::VecVState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,ARM,ACQ,DONE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedClebMfsmtrack1::VecVTrigger
 ******************************************************************************/

uint8_t CtrWtedClebMfsmtrack1::VecVTrigger::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "void") return VOID;
	else if (s == "hostifrxaxis_tvalid") return HOSTIFRXAXISTVALID;
	else if (s == "ackinvtkclksrcsettkst") return ACKINVTKCLKSRCSETTKST;

	return(0xFF);
};

string CtrWtedClebMfsmtrack1::VecVTrigger::getSref(
			const uint8_t tix
		) {
	if (tix == VOID) return("void");
	else if (tix == HOSTIFRXAXISTVALID) return("hostifRxAXIS_tvalid");
	else if (tix == ACKINVTKCLKSRCSETTKST) return("ackInvTkclksrcSetTkst");

	return("");
};

string CtrWtedClebMfsmtrack1::VecVTrigger::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedClebMfsmtrack1::VecVTrigger::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {VOID,HOSTIFRXAXISTVALID,ACKINVTKCLKSRCSETTKST};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedClebMfsmtrack1
 ******************************************************************************/

CtrWtedClebMfsmtrack1::CtrWtedClebMfsmtrack1(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedClebMfsmtrack1::~CtrWtedClebMfsmtrack1() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedClebMfsmtrack1::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedClebMfsmtrack1::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedClebMfsmtrack1::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedClebMfsmtrack1::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETINFO) cmd = getNewCmdGetInfo();
	else if (tixVCommand == VecVCommand::SELECT) cmd = getNewCmdSelect();
	else if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();

	return cmd;
};

Cmd* CtrWtedClebMfsmtrack1::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVState", Par::VecVType::TIX, CtrWtedClebMfsmtrack1::VecVState::getTix, CtrWtedClebMfsmtrack1::VecVState::getSref, CtrWtedClebMfsmtrack1::VecVState::fillFeed);
	cmd->addParRet("coverage", Par::VecVType::BLOB, NULL, NULL, NULL, 32);

	return cmd;
};

void CtrWtedClebMfsmtrack1::getInfo(
			uint8_t& tixVState
			, unsigned char*& coverage
			, size_t& coveragelen
		) {
	unt->lockAccess("CtrWtedClebMfsmtrack1::getInfo");

	Cmd* cmd = cmdGetInfo;

	if (unt->runCmd(cmd)) {
		tixVState = cmd->parsRet["tixVState"].getTix();
		coverage = cmd->parsRet["coverage"].getBlob();
		coveragelen = cmd->parsRet["coverage"].getLen();
	} else throw DbeException("error running getInfo");

	unt->unlockAccess("CtrWtedClebMfsmtrack1::getInfo");
};

Cmd* CtrWtedClebMfsmtrack1::getNewCmdSelect() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SELECT, Cmd::VecVRettype::VOID);

	cmd->addParInv("tixVSource", Par::VecVType::TIX, CtrWtedClebMfsmtrack1::VecVSource::getTix, CtrWtedClebMfsmtrack1::VecVSource::getSref, CtrWtedClebMfsmtrack1::VecVSource::fillFeed);
	cmd->addParInv("staTixVTrigger", Par::VecVType::TIX, CtrWtedClebMfsmtrack1::VecVTrigger::getTix, CtrWtedClebMfsmtrack1::VecVTrigger::getSref, CtrWtedClebMfsmtrack1::VecVTrigger::fillFeed);
	cmd->addParInv("stoTixVTrigger", Par::VecVType::TIX, CtrWtedClebMfsmtrack1::VecVTrigger::getTix, CtrWtedClebMfsmtrack1::VecVTrigger::getSref, CtrWtedClebMfsmtrack1::VecVTrigger::fillFeed);

	return cmd;
};

void CtrWtedClebMfsmtrack1::select(
			const uint8_t tixVSource
			, const uint8_t staTixVTrigger
			, const uint8_t stoTixVTrigger
		) {
	unt->lockAccess("CtrWtedClebMfsmtrack1::select");

	Cmd* cmd = cmdSelect;

	cmd->parsInv["tixVSource"].setTix(tixVSource);
	cmd->parsInv["staTixVTrigger"].setTix(staTixVTrigger);
	cmd->parsInv["stoTixVTrigger"].setTix(stoTixVTrigger);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running select");

	unt->unlockAccess("CtrWtedClebMfsmtrack1::select");
};

Cmd* CtrWtedClebMfsmtrack1::getNewCmdSet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("TCapt", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedClebMfsmtrack1::set(
			const bool rng
			, const uint32_t TCapt
		) {
	unt->lockAccess("CtrWtedClebMfsmtrack1::set");

	Cmd* cmd = cmdSet;

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["TCapt"].setUint32(TCapt);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running set");

	unt->unlockAccess("CtrWtedClebMfsmtrack1::set");
};
