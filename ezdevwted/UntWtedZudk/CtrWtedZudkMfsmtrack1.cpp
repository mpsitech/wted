/**
	* \file CtrWtedZudkMfsmtrack1.cpp
	* mfsmtrack1 controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedZudkMfsmtrack1.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedZudkMfsmtrack1::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedZudkMfsmtrack1::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getinfo") return GETINFO;
	else if (s == "select") return SELECT;
	else if (s == "set") return SET;

	return(0xFF);
};

string CtrWtedZudkMfsmtrack1::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETINFO) return("getInfo");
	else if (tix == SELECT) return("select");
	else if (tix == SET) return("set");

	return("");
};

void CtrWtedZudkMfsmtrack1::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETINFO,SELECT,SET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedZudkMfsmtrack1::VecVSource
 ******************************************************************************/

uint8_t CtrWtedZudkMfsmtrack1::VecVSource::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "clientgetbufb") return CLIENTGETBUFB;
	else if (s == "clientsetbufb") return CLIENTSETBUFB;
	else if (s == "tkclksrcop") return TKCLKSRCOP;

	return(0xFF);
};

string CtrWtedZudkMfsmtrack1::VecVSource::getSref(
			const uint8_t tix
		) {
	if (tix == CLIENTGETBUFB) return("clientGetbufB");
	else if (tix == CLIENTSETBUFB) return("clientSetbufB");
	else if (tix == TKCLKSRCOP) return("tkclksrcOp");

	return("");
};

string CtrWtedZudkMfsmtrack1::VecVSource::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedZudkMfsmtrack1::VecVSource::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {CLIENTGETBUFB,CLIENTSETBUFB,TKCLKSRCOP};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedZudkMfsmtrack1::VecVState
 ******************************************************************************/

uint8_t CtrWtedZudkMfsmtrack1::VecVState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "arm") return ARM;
	else if (s == "acq") return ACQ;
	else if (s == "done") return DONE;

	return(0xFF);
};

string CtrWtedZudkMfsmtrack1::VecVState::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == ARM) return("arm");
	else if (tix == ACQ) return("acq");
	else if (tix == DONE) return("done");

	return("");
};

string CtrWtedZudkMfsmtrack1::VecVState::getTitle(
			const uint8_t tix
		) {
	if (tix == ARM) return("armed");
	if (tix == ACQ) return("acquiring");

	return(getSref(tix));
};

void CtrWtedZudkMfsmtrack1::VecVState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,ARM,ACQ,DONE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedZudkMfsmtrack1::VecVTrigger
 ******************************************************************************/

uint8_t CtrWtedZudkMfsmtrack1::VecVTrigger::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "void") return VOID;
	else if (s == "hostifrxaxis_tvalid") return HOSTIFRXAXISTVALID;
	else if (s == "ackinvtkclksrcsettkst") return ACKINVTKCLKSRCSETTKST;

	return(0xFF);
};

string CtrWtedZudkMfsmtrack1::VecVTrigger::getSref(
			const uint8_t tix
		) {
	if (tix == VOID) return("void");
	else if (tix == HOSTIFRXAXISTVALID) return("hostifRxAXIS_tvalid");
	else if (tix == ACKINVTKCLKSRCSETTKST) return("ackInvTkclksrcSetTkst");

	return("");
};

string CtrWtedZudkMfsmtrack1::VecVTrigger::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedZudkMfsmtrack1::VecVTrigger::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {VOID,HOSTIFRXAXISTVALID,ACKINVTKCLKSRCSETTKST};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedZudkMfsmtrack1
 ******************************************************************************/

CtrWtedZudkMfsmtrack1::CtrWtedZudkMfsmtrack1(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedZudkMfsmtrack1::~CtrWtedZudkMfsmtrack1() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedZudkMfsmtrack1::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedZudkMfsmtrack1::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedZudkMfsmtrack1::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedZudkMfsmtrack1::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETINFO) cmd = getNewCmdGetInfo();
	else if (tixVCommand == VecVCommand::SELECT) cmd = getNewCmdSelect();
	else if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();

	return cmd;
};

Cmd* CtrWtedZudkMfsmtrack1::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVState", Par::VecVType::TIX, CtrWtedZudkMfsmtrack1::VecVState::getTix, CtrWtedZudkMfsmtrack1::VecVState::getSref, CtrWtedZudkMfsmtrack1::VecVState::fillFeed);
	cmd->addParRet("coverage", Par::VecVType::BLOB, NULL, NULL, NULL, 32);

	return cmd;
};

void CtrWtedZudkMfsmtrack1::getInfo(
			uint8_t& tixVState
			, unsigned char*& coverage
			, size_t& coveragelen
		) {
	unt->lockAccess("CtrWtedZudkMfsmtrack1::getInfo");

	Cmd* cmd = cmdGetInfo;

	if (unt->runCmd(cmd)) {
		tixVState = cmd->parsRet["tixVState"].getTix();
		coverage = cmd->parsRet["coverage"].getBlob();
		coveragelen = cmd->parsRet["coverage"].getLen();
	} else throw DbeException("error running getInfo");

	unt->unlockAccess("CtrWtedZudkMfsmtrack1::getInfo");
};

Cmd* CtrWtedZudkMfsmtrack1::getNewCmdSelect() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SELECT, Cmd::VecVRettype::VOID);

	cmd->addParInv("tixVSource", Par::VecVType::TIX, CtrWtedZudkMfsmtrack1::VecVSource::getTix, CtrWtedZudkMfsmtrack1::VecVSource::getSref, CtrWtedZudkMfsmtrack1::VecVSource::fillFeed);
	cmd->addParInv("staTixVTrigger", Par::VecVType::TIX, CtrWtedZudkMfsmtrack1::VecVTrigger::getTix, CtrWtedZudkMfsmtrack1::VecVTrigger::getSref, CtrWtedZudkMfsmtrack1::VecVTrigger::fillFeed);
	cmd->addParInv("stoTixVTrigger", Par::VecVType::TIX, CtrWtedZudkMfsmtrack1::VecVTrigger::getTix, CtrWtedZudkMfsmtrack1::VecVTrigger::getSref, CtrWtedZudkMfsmtrack1::VecVTrigger::fillFeed);

	return cmd;
};

void CtrWtedZudkMfsmtrack1::select(
			const uint8_t tixVSource
			, const uint8_t staTixVTrigger
			, const uint8_t stoTixVTrigger
		) {
	unt->lockAccess("CtrWtedZudkMfsmtrack1::select");

	Cmd* cmd = cmdSelect;

	cmd->parsInv["tixVSource"].setTix(tixVSource);
	cmd->parsInv["staTixVTrigger"].setTix(staTixVTrigger);
	cmd->parsInv["stoTixVTrigger"].setTix(stoTixVTrigger);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running select");

	unt->unlockAccess("CtrWtedZudkMfsmtrack1::select");
};

Cmd* CtrWtedZudkMfsmtrack1::getNewCmdSet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("TCapt", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedZudkMfsmtrack1::set(
			const bool rng
			, const uint32_t TCapt
		) {
	unt->lockAccess("CtrWtedZudkMfsmtrack1::set");

	Cmd* cmd = cmdSet;

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["TCapt"].setUint32(TCapt);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running set");

	unt->unlockAccess("CtrWtedZudkMfsmtrack1::set");
};
