/**
	* \file CtrWtedClebState.cpp
	* state controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedClebState.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedClebState::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedClebState::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "get") return GET;

	return(0xFF);
};

string CtrWtedClebState::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GET) return("get");

	return("");
};

void CtrWtedClebState::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedClebState
 ******************************************************************************/

CtrWtedClebState::CtrWtedClebState(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedClebState::~CtrWtedClebState() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedClebState::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedClebState::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedClebState::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedClebState::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GET) cmd = getNewCmdGet();

	return cmd;
};

Cmd* CtrWtedClebState::getNewCmdGet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GET, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVClebState", Par::VecVType::TIX, VecVWtedClebState::getTix, VecVWtedClebState::getSref, VecVWtedClebState::fillFeed);

	return cmd;
};

void CtrWtedClebState::get(
			uint8_t& tixVClebState
		) {
	unt->lockAccess("CtrWtedClebState::get");

	Cmd* cmd = cmdGet;

	if (unt->runCmd(cmd)) {
		tixVClebState = cmd->parsRet["tixVClebState"].getTix();
	} else throw DbeException("error running get");

	unt->unlockAccess("CtrWtedClebState::get");
};
