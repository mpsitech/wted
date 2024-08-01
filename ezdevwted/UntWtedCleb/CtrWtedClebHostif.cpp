/**
	* \file CtrWtedClebHostif.cpp
	* hostif controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedClebHostif.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedClebHostif::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedClebHostif::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "reset") return RESET;

	return(0xFF);
};

string CtrWtedClebHostif::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == RESET) return("reset");

	return("");
};

void CtrWtedClebHostif::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {RESET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedClebHostif
 ******************************************************************************/

CtrWtedClebHostif::CtrWtedClebHostif(
			UntWted* unt
		) : CtrWted(unt) {
	cmdReset = getNewCmdReset();
};

CtrWtedClebHostif::~CtrWtedClebHostif() {
	delete cmdReset;
};

uint8_t CtrWtedClebHostif::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedClebHostif::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedClebHostif::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedClebHostif::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::RESET) cmd = getNewCmdReset();

	return cmd;
};

Cmd* CtrWtedClebHostif::getNewCmdReset() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::RESET, Cmd::VecVRettype::VOID);

	return cmd;
};

void CtrWtedClebHostif::reset(
		) {
	unt->lockAccess("CtrWtedClebHostif::reset");

	Cmd* cmd = cmdReset;

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running reset");

	unt->unlockAccess("CtrWtedClebHostif::reset");
};
