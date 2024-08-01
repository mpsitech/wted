/**
	* \file CtrWtedZudkHostif.cpp
	* hostif controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 10 Jul 2024
	*/
// IP header --- ABOVE

#include "CtrWtedZudkHostif.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedZudkHostif::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedZudkHostif::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "reset") return RESET;

	return(0xFF);
};

string CtrWtedZudkHostif::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == RESET) return("reset");

	return("");
};

void CtrWtedZudkHostif::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {RESET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedZudkHostif
 ******************************************************************************/

CtrWtedZudkHostif::CtrWtedZudkHostif(
			UntWted* unt
		) : CtrWted(unt) {
	cmdReset = getNewCmdReset();
};

CtrWtedZudkHostif::~CtrWtedZudkHostif() {
	delete cmdReset;
};

uint8_t CtrWtedZudkHostif::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedZudkHostif::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedZudkHostif::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedZudkHostif::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::RESET) cmd = getNewCmdReset();

	return cmd;
};

Cmd* CtrWtedZudkHostif::getNewCmdReset() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::RESET, Cmd::VecVRettype::VOID);

	return cmd;
};

void CtrWtedZudkHostif::reset(
		) {
	unt->lockAccess("CtrWtedZudkHostif::reset");

	Cmd* cmd = cmdReset;

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running reset");

	unt->unlockAccess("CtrWtedZudkHostif::reset");
};
