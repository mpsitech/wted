/**
	* \file CtrWtedTidkMfsmtrack1.cpp
	* mfsmtrack1 controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedTidkMfsmtrack1.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedTidkMfsmtrack1::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedTidkMfsmtrack1::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getinfo") return GETINFO;
	else if (s == "select") return SELECT;
	else if (s == "set") return SET;

	return(0xFF);
};

string CtrWtedTidkMfsmtrack1::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETINFO) return("getInfo");
	else if (tix == SELECT) return("select");
	else if (tix == SET) return("set");

	return("");
};

void CtrWtedTidkMfsmtrack1::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETINFO,SELECT,SET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedTidkMfsmtrack1::VecVSource
 ******************************************************************************/

uint8_t CtrWtedTidkMfsmtrack1::VecVSource::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "clientgetbufb") return CLIENTGETBUFB;
	else if (s == "clientsetbufb") return CLIENTSETBUFB;
	else if (s == "tkclksrcop") return TKCLKSRCOP;

	return(0xFF);
};

string CtrWtedTidkMfsmtrack1::VecVSource::getSref(
			const uint8_t tix
		) {
	if (tix == CLIENTGETBUFB) return("clientGetbufB");
	else if (tix == CLIENTSETBUFB) return("clientSetbufB");
	else if (tix == TKCLKSRCOP) return("tkclksrcOp");

	return("");
};

string CtrWtedTidkMfsmtrack1::VecVSource::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedTidkMfsmtrack1::VecVSource::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {CLIENTGETBUFB,CLIENTSETBUFB,TKCLKSRCOP};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMfsmtrack1::VecVState
 ******************************************************************************/

uint8_t CtrWtedTidkMfsmtrack1::VecVState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "arm") return ARM;
	else if (s == "acq") return ACQ;
	else if (s == "done") return DONE;

	return(0xFF);
};

string CtrWtedTidkMfsmtrack1::VecVState::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == ARM) return("arm");
	else if (tix == ACQ) return("acq");
	else if (tix == DONE) return("done");

	return("");
};

string CtrWtedTidkMfsmtrack1::VecVState::getTitle(
			const uint8_t tix
		) {
	if (tix == ARM) return("armed");
	if (tix == ACQ) return("acquiring");

	return(getSref(tix));
};

void CtrWtedTidkMfsmtrack1::VecVState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,ARM,ACQ,DONE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMfsmtrack1::VecVTrigger
 ******************************************************************************/

uint8_t CtrWtedTidkMfsmtrack1::VecVTrigger::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "void") return VOID;
	else if (s == "hostifrxaxis_tvalid") return HOSTIFRXAXISTVALID;
	else if (s == "ackinvtkclksrcsettkst") return ACKINVTKCLKSRCSETTKST;

	return(0xFF);
};

string CtrWtedTidkMfsmtrack1::VecVTrigger::getSref(
			const uint8_t tix
		) {
	if (tix == VOID) return("void");
	else if (tix == HOSTIFRXAXISTVALID) return("hostifRxAXIS_tvalid");
	else if (tix == ACKINVTKCLKSRCSETTKST) return("ackInvTkclksrcSetTkst");

	return("");
};

string CtrWtedTidkMfsmtrack1::VecVTrigger::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedTidkMfsmtrack1::VecVTrigger::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {VOID,HOSTIFRXAXISTVALID,ACKINVTKCLKSRCSETTKST};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMfsmtrack1
 ******************************************************************************/

CtrWtedTidkMfsmtrack1::CtrWtedTidkMfsmtrack1(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedTidkMfsmtrack1::~CtrWtedTidkMfsmtrack1() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedTidkMfsmtrack1::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedTidkMfsmtrack1::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedTidkMfsmtrack1::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedTidkMfsmtrack1::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETINFO) cmd = getNewCmdGetInfo();
	else if (tixVCommand == VecVCommand::SELECT) cmd = getNewCmdSelect();
	else if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();

	return cmd;
};

Cmd* CtrWtedTidkMfsmtrack1::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVState", Par::VecVType::TIX, CtrWtedTidkMfsmtrack1::VecVState::getTix, CtrWtedTidkMfsmtrack1::VecVState::getSref, CtrWtedTidkMfsmtrack1::VecVState::fillFeed);
	cmd->addParRet("coverage", Par::VecVType::BLOB, NULL, NULL, NULL, 32);

	return cmd;
};

void CtrWtedTidkMfsmtrack1::getInfo(
			uint8_t& tixVState
			, unsigned char*& coverage
			, size_t& coveragelen
		) {
	unt->lockAccess("CtrWtedTidkMfsmtrack1::getInfo");

	Cmd* cmd = cmdGetInfo;

	if (unt->runCmd(cmd)) {
		tixVState = cmd->parsRet["tixVState"].getTix();
		coverage = cmd->parsRet["coverage"].getBlob();
		coveragelen = cmd->parsRet["coverage"].getLen();
	} else throw DbeException("error running getInfo");

	unt->unlockAccess("CtrWtedTidkMfsmtrack1::getInfo");
};

Cmd* CtrWtedTidkMfsmtrack1::getNewCmdSelect() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SELECT, Cmd::VecVRettype::VOID);

	cmd->addParInv("tixVSource", Par::VecVType::TIX, CtrWtedTidkMfsmtrack1::VecVSource::getTix, CtrWtedTidkMfsmtrack1::VecVSource::getSref, CtrWtedTidkMfsmtrack1::VecVSource::fillFeed);
	cmd->addParInv("staTixVTrigger", Par::VecVType::TIX, CtrWtedTidkMfsmtrack1::VecVTrigger::getTix, CtrWtedTidkMfsmtrack1::VecVTrigger::getSref, CtrWtedTidkMfsmtrack1::VecVTrigger::fillFeed);
	cmd->addParInv("stoTixVTrigger", Par::VecVType::TIX, CtrWtedTidkMfsmtrack1::VecVTrigger::getTix, CtrWtedTidkMfsmtrack1::VecVTrigger::getSref, CtrWtedTidkMfsmtrack1::VecVTrigger::fillFeed);

	return cmd;
};

void CtrWtedTidkMfsmtrack1::select(
			const uint8_t tixVSource
			, const uint8_t staTixVTrigger
			, const uint8_t stoTixVTrigger
		) {
	unt->lockAccess("CtrWtedTidkMfsmtrack1::select");

	Cmd* cmd = cmdSelect;

	cmd->parsInv["tixVSource"].setTix(tixVSource);
	cmd->parsInv["staTixVTrigger"].setTix(staTixVTrigger);
	cmd->parsInv["stoTixVTrigger"].setTix(stoTixVTrigger);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running select");

	unt->unlockAccess("CtrWtedTidkMfsmtrack1::select");
};

Cmd* CtrWtedTidkMfsmtrack1::getNewCmdSet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("TCapt", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedTidkMfsmtrack1::set(
			const bool rng
			, const uint32_t TCapt
		) {
	unt->lockAccess("CtrWtedTidkMfsmtrack1::set");

	Cmd* cmd = cmdSet;

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["TCapt"].setUint32(TCapt);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running set");

	unt->unlockAccess("CtrWtedTidkMfsmtrack1::set");
};
