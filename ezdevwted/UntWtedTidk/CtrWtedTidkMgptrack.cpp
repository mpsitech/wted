/**
	* \file CtrWtedTidkMgptrack.cpp
	* mgptrack controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedTidkMgptrack.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedTidkMgptrack::VecVCapture
 ******************************************************************************/

uint8_t CtrWtedTidkMgptrack::VecVCapture::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "tkclk") return TKCLK;
	else if (s == "rgb0_r") return RGB0R;
	else if (s == "rgb0_g") return RGB0G;
	else if (s == "rgb0_b") return RGB0B;
	else if (s == "btn0") return BTN0;
	else if (s == "btn0_sig") return BTN0SIG;
	else if (s == "tkclksrcgettksttkst0") return TKCLKSRCGETTKSTTKST0;
	else if (s == "tkclksrcgettksttkst1") return TKCLKSRCGETTKSTTKST1;
	else if (s == "tkclksrcgettksttkst2") return TKCLKSRCGETTKSTTKST2;
	else if (s == "tkclksrcgettksttkst3") return TKCLKSRCGETTKSTTKST3;
	else if (s == "tkclksrcgettksttkst4") return TKCLKSRCGETTKSTTKST4;
	else if (s == "tkclksrcgettksttkst5") return TKCLKSRCGETTKSTTKST5;
	else if (s == "tkclksrcgettksttkst6") return TKCLKSRCGETTKSTTKST6;
	else if (s == "tkclksrcgettksttkst7") return TKCLKSRCGETTKSTTKST7;

	return(0xFF);
};

string CtrWtedTidkMgptrack::VecVCapture::getSref(
			const uint8_t tix
		) {
	if (tix == TKCLK) return("tkclk");
	else if (tix == RGB0R) return("rgb0_r");
	else if (tix == RGB0G) return("rgb0_g");
	else if (tix == RGB0B) return("rgb0_b");
	else if (tix == BTN0) return("btn0");
	else if (tix == BTN0SIG) return("btn0_sig");
	else if (tix == TKCLKSRCGETTKSTTKST0) return("tkclksrcGetTkstTkst0");
	else if (tix == TKCLKSRCGETTKSTTKST1) return("tkclksrcGetTkstTkst1");
	else if (tix == TKCLKSRCGETTKSTTKST2) return("tkclksrcGetTkstTkst2");
	else if (tix == TKCLKSRCGETTKSTTKST3) return("tkclksrcGetTkstTkst3");
	else if (tix == TKCLKSRCGETTKSTTKST4) return("tkclksrcGetTkstTkst4");
	else if (tix == TKCLKSRCGETTKSTTKST5) return("tkclksrcGetTkstTkst5");
	else if (tix == TKCLKSRCGETTKSTTKST6) return("tkclksrcGetTkstTkst6");
	else if (tix == TKCLKSRCGETTKSTTKST7) return("tkclksrcGetTkstTkst7");

	return("");
};

string CtrWtedTidkMgptrack::VecVCapture::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedTidkMgptrack::VecVCapture::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {TKCLK,RGB0R,RGB0G,RGB0B,BTN0,BTN0SIG,TKCLKSRCGETTKSTTKST0,TKCLKSRCGETTKSTTKST1,TKCLKSRCGETTKSTTKST2,TKCLKSRCGETTKSTTKST3,TKCLKSRCGETTKSTTKST4,TKCLKSRCGETTKSTTKST5,TKCLKSRCGETTKSTTKST6,TKCLKSRCGETTKSTTKST7};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMgptrack::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedTidkMgptrack::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getinfo") return GETINFO;
	else if (s == "select") return SELECT;
	else if (s == "set") return SET;

	return(0xFF);
};

string CtrWtedTidkMgptrack::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETINFO) return("getInfo");
	else if (tix == SELECT) return("select");
	else if (tix == SET) return("set");

	return("");
};

void CtrWtedTidkMgptrack::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETINFO,SELECT,SET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedTidkMgptrack::VecVState
 ******************************************************************************/

uint8_t CtrWtedTidkMgptrack::VecVState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "arm") return ARM;
	else if (s == "acq") return ACQ;
	else if (s == "done") return DONE;

	return(0xFF);
};

string CtrWtedTidkMgptrack::VecVState::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == ARM) return("arm");
	else if (tix == ACQ) return("acq");
	else if (tix == DONE) return("done");

	return("");
};

string CtrWtedTidkMgptrack::VecVState::getTitle(
			const uint8_t tix
		) {
	if (tix == ARM) return("armed");
	if (tix == ACQ) return("acquiring");

	return(getSref(tix));
};

void CtrWtedTidkMgptrack::VecVState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,ARM,ACQ,DONE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMgptrack::VecVTrigger
 ******************************************************************************/

uint8_t CtrWtedTidkMgptrack::VecVTrigger::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "void") return VOID;
	else if (s == "btn0") return BTN0;
	else if (s == "hostifrxaxis_tvalid") return HOSTIFRXAXISTVALID;
	else if (s == "ackinvtkclksrcsettkst") return ACKINVTKCLKSRCSETTKST;

	return(0xFF);
};

string CtrWtedTidkMgptrack::VecVTrigger::getSref(
			const uint8_t tix
		) {
	if (tix == VOID) return("void");
	else if (tix == BTN0) return("btn0");
	else if (tix == HOSTIFRXAXISTVALID) return("hostifRxAXIS_tvalid");
	else if (tix == ACKINVTKCLKSRCSETTKST) return("ackInvTkclksrcSetTkst");

	return("");
};

string CtrWtedTidkMgptrack::VecVTrigger::getTitle(
			const uint8_t tix
		) {

	return(getSref(tix));
};

void CtrWtedTidkMgptrack::VecVTrigger::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {VOID,BTN0,HOSTIFRXAXISTVALID,ACKINVTKCLKSRCSETTKST};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWtedTidkMgptrack
 ******************************************************************************/

CtrWtedTidkMgptrack::CtrWtedTidkMgptrack(
			UntWted* unt
		) : CtrWted(unt) {
	cmdGetInfo = getNewCmdGetInfo();
	cmdSelect = getNewCmdSelect();
	cmdSet = getNewCmdSet();
};

CtrWtedTidkMgptrack::~CtrWtedTidkMgptrack() {
	delete cmdGetInfo;
	delete cmdSelect;
	delete cmdSet;
};

uint8_t CtrWtedTidkMgptrack::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedTidkMgptrack::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedTidkMgptrack::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedTidkMgptrack::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETINFO) cmd = getNewCmdGetInfo();
	else if (tixVCommand == VecVCommand::SELECT) cmd = getNewCmdSelect();
	else if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();

	return cmd;
};

Cmd* CtrWtedTidkMgptrack::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVState", Par::VecVType::TIX, CtrWtedTidkMgptrack::VecVState::getTix, CtrWtedTidkMgptrack::VecVState::getSref, CtrWtedTidkMgptrack::VecVState::fillFeed);

	return cmd;
};

void CtrWtedTidkMgptrack::getInfo(
			uint8_t& tixVState
		) {
	unt->lockAccess("CtrWtedTidkMgptrack::getInfo");

	Cmd* cmd = cmdGetInfo;

	if (unt->runCmd(cmd)) {
		tixVState = cmd->parsRet["tixVState"].getTix();
	} else throw DbeException("error running getInfo");

	unt->unlockAccess("CtrWtedTidkMgptrack::getInfo");
};

Cmd* CtrWtedTidkMgptrack::getNewCmdSelect() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SELECT, Cmd::VecVRettype::VOID);

	cmd->addParInv("staTixVTrigger", Par::VecVType::TIX, CtrWtedTidkMgptrack::VecVTrigger::getTix, CtrWtedTidkMgptrack::VecVTrigger::getSref, CtrWtedTidkMgptrack::VecVTrigger::fillFeed);
	cmd->addParInv("staFallingNotRising", Par::VecVType::_BOOL);
	cmd->addParInv("stoTixVTrigger", Par::VecVType::TIX, CtrWtedTidkMgptrack::VecVTrigger::getTix, CtrWtedTidkMgptrack::VecVTrigger::getSref, CtrWtedTidkMgptrack::VecVTrigger::fillFeed);
	cmd->addParInv("stoFallingNotRising", Par::VecVType::_BOOL);

	return cmd;
};

void CtrWtedTidkMgptrack::select(
			const uint8_t staTixVTrigger
			, const bool staFallingNotRising
			, const uint8_t stoTixVTrigger
			, const bool stoFallingNotRising
		) {
	unt->lockAccess("CtrWtedTidkMgptrack::select");

	Cmd* cmd = cmdSelect;

	cmd->parsInv["staTixVTrigger"].setTix(staTixVTrigger);
	cmd->parsInv["staFallingNotRising"].setBool(staFallingNotRising);
	cmd->parsInv["stoTixVTrigger"].setTix(stoTixVTrigger);
	cmd->parsInv["stoFallingNotRising"].setBool(stoFallingNotRising);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running select");

	unt->unlockAccess("CtrWtedTidkMgptrack::select");
};

Cmd* CtrWtedTidkMgptrack::getNewCmdSet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("TCapt", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedTidkMgptrack::set(
			const bool rng
			, const uint32_t TCapt
		) {
	unt->lockAccess("CtrWtedTidkMgptrack::set");

	Cmd* cmd = cmdSet;

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["TCapt"].setUint32(TCapt);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running set");

	unt->unlockAccess("CtrWtedTidkMgptrack::set");
};
