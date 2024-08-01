/**
	* \file CtrWtedTidkState.cpp
	* state controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedTidkState.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedTidkState::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedTidkState::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "get") return GET;

	return(0xFF);
};

string CtrWtedTidkState::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GET) return("get");

	return("");
};

void CtrWtedTidkState::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedTidkState
 ******************************************************************************/

CtrWtedTidkState::CtrWtedTidkState(
			UntWted* unt
		) : CtrWted(unt) {
	cmdGet = getNewCmdGet();
};

CtrWtedTidkState::~CtrWtedTidkState() {
	delete cmdGet;
};

uint8_t CtrWtedTidkState::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedTidkState::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedTidkState::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedTidkState::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GET) cmd = getNewCmdGet();

	return cmd;
};

Cmd* CtrWtedTidkState::getNewCmdGet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GET, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVTidkState", Par::VecVType::TIX, VecVWtedTidkState::getTix, VecVWtedTidkState::getSref, VecVWtedTidkState::fillFeed);

	return cmd;
};

void CtrWtedTidkState::get(
			uint8_t& tixVTidkState
		) {
	unt->lockAccess("CtrWtedTidkState::get");

	Cmd* cmd = cmdGet;

	if (unt->runCmd(cmd)) {
		tixVTidkState = cmd->parsRet["tixVTidkState"].getTix();
	} else throw DbeException("error running get");

	unt->unlockAccess("CtrWtedTidkState::get");
};
