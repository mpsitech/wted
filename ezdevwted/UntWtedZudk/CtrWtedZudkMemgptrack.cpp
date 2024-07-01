/**
	* \file CtrWtedZudkMemgptrack.cpp
	* memgptrack controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedZudkMemgptrack.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedZudkMemgptrack::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedZudkMemgptrack::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getinfo") return GETINFO;
	else if (s == "select") return SELECT;
	else if (s == "set") return SET;

	return(0xFF);
};

string CtrWtedZudkMemgptrack::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETINFO) return("getInfo");
	else if (tix == SELECT) return("select");
	else if (tix == SET) return("set");

	return("");
};

void CtrWtedZudkMemgptrack::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETINFO,SELECT,SET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedZudkMemgptrack::VecVState
 ******************************************************************************/

uint8_t CtrWtedZudkMemgptrack::VecVState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "arm") return ARM;
	else if (s == "acq") return ACQ;
	else if (s == "done") return DONE;

	return(0xFF);
};

string CtrWtedZudkMemgptrack::VecVState::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == ARM) return("arm");
	else if (tix == ACQ) return("acq");
	else if (tix == DONE) return("done");

	return("");
};

string CtrWtedZudkMemgptrack::VecVState::getTitle(
			const uint8_t tix
		) {
	if (tix == ARM) return("armed");
	if (tix == ACQ) return("acquiring");

	return(getSref(tix));
};

void CtrWtedZudkMemgptrack::VecVState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,ARM,ACQ,DONE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedZudkMemgptrack::VecVTrigger
 ******************************************************************************/

uint8_t CtrWtedZudkMemgptrack::VecVTrigger::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "void") return VOID;

	return(0xFF);
};

string CtrWtedZudkMemgptrack::VecVTrigger::getSref(
			const uint8_t tix
		) {
	if (tix == VOID) return("void");

	return("");
};

string CtrWtedZudkMemgptrack::VecVTrigger::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedZudkMemgptrack::VecVTrigger::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {VOID};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedZudkMemgptrack
 ******************************************************************************/

CtrWtedZudkMemgptrack::CtrWtedZudkMemgptrack(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedZudkMemgptrack::~CtrWtedZudkMemgptrack() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedZudkMemgptrack::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedZudkMemgptrack::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedZudkMemgptrack::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedZudkMemgptrack::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETINFO) cmd = getNewCmdGetInfo();
	else if (tixVCommand == VecVCommand::SELECT) cmd = getNewCmdSelect();
	else if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();

	return cmd;
};

Cmd* CtrWtedZudkMemgptrack::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVState", Par::VecVType::TIX, CtrWtedZudkMemgptrack::VecVState::getTix, CtrWtedZudkMemgptrack::VecVState::getSref, CtrWtedZudkMemgptrack::VecVState::fillFeed);

	return cmd;
};

void CtrWtedZudkMemgptrack::getInfo(
			uint8_t& tixVState
		) {
	unt->lockAccess("CtrWtedZudkMemgptrack::getInfo");

	Cmd* cmd = cmdGetInfo;

	if (unt->runCmd(cmd)) {
		tixVState = cmd->parsRet["tixVState"].getTix();
	} else throw DbeException("error running getInfo");

	unt->unlockAccess("CtrWtedZudkMemgptrack::getInfo");
};

Cmd* CtrWtedZudkMemgptrack::getNewCmdSelect() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SELECT, Cmd::VecVRettype::VOID);

	cmd->addParInv("staTixVTrigger", Par::VecVType::TIX, CtrWtedZudkMemgptrack::VecVTrigger::getTix, CtrWtedZudkMemgptrack::VecVTrigger::getSref, CtrWtedZudkMemgptrack::VecVTrigger::fillFeed);
	cmd->addParInv("stoTixVTrigger", Par::VecVType::TIX, CtrWtedZudkMemgptrack::VecVTrigger::getTix, CtrWtedZudkMemgptrack::VecVTrigger::getSref, CtrWtedZudkMemgptrack::VecVTrigger::fillFeed);

	return cmd;
};

void CtrWtedZudkMemgptrack::select(
			const uint8_t staTixVTrigger
			, const uint8_t stoTixVTrigger
		) {
	unt->lockAccess("CtrWtedZudkMemgptrack::select");

	Cmd* cmd = cmdSelect;

	cmd->parsInv["staTixVTrigger"].setTix(staTixVTrigger);
	cmd->parsInv["stoTixVTrigger"].setTix(stoTixVTrigger);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running select");

	unt->unlockAccess("CtrWtedZudkMemgptrack::select");
};

Cmd* CtrWtedZudkMemgptrack::getNewCmdSet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("TCapt", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedZudkMemgptrack::set(
			const bool rng
			, const uint32_t TCapt
		) {
	unt->lockAccess("CtrWtedZudkMemgptrack::set");

	Cmd* cmd = cmdSet;

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["TCapt"].setUint32(TCapt);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running set");

	unt->unlockAccess("CtrWtedZudkMemgptrack::set");
};
