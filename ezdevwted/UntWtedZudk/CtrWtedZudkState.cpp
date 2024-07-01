/**
	* \file CtrWtedZudkState.cpp
	* state controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedZudkState.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedZudkState::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedZudkState::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "get") return GET;

	return(0xFF);
};

string CtrWtedZudkState::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GET) return("get");

	return("");
};

void CtrWtedZudkState::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedZudkState
 ******************************************************************************/

CtrWtedZudkState::CtrWtedZudkState(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedZudkState::~CtrWtedZudkState() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedZudkState::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedZudkState::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedZudkState::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedZudkState::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GET) cmd = getNewCmdGet();

	return cmd;
};

Cmd* CtrWtedZudkState::getNewCmdGet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GET, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVZudkState", Par::VecVType::TIX, VecVWtedZudkState::getTix, VecVWtedZudkState::getSref, VecVWtedZudkState::fillFeed);

	return cmd;
};

void CtrWtedZudkState::get(
			uint8_t& tixVZudkState
		) {
	unt->lockAccess("CtrWtedZudkState::get");

	Cmd* cmd = cmdGet;

	if (unt->runCmd(cmd)) {
		tixVZudkState = cmd->parsRet["tixVZudkState"].getTix();
	} else throw DbeException("error running get");

	unt->unlockAccess("CtrWtedZudkState::get");
};
