/**
	* \file CtrWtedTidkHostif.cpp
	* hostif controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedTidkHostif.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedTidkHostif::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedTidkHostif::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "reset") return RESET;

	return(0xFF);
};

string CtrWtedTidkHostif::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == RESET) return("reset");

	return("");
};

void CtrWtedTidkHostif::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {RESET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedTidkHostif
 ******************************************************************************/

CtrWtedTidkHostif::CtrWtedTidkHostif(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedTidkHostif::~CtrWtedTidkHostif() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedTidkHostif::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedTidkHostif::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedTidkHostif::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedTidkHostif::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::RESET) cmd = getNewCmdReset();

	return cmd;
};

Cmd* CtrWtedTidkHostif::getNewCmdReset() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::RESET, Cmd::VecVRettype::VOID);

	return cmd;
};

void CtrWtedTidkHostif::reset(
		) {
	unt->lockAccess("CtrWtedTidkHostif::reset");

	Cmd* cmd = cmdReset;

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running reset");

	unt->unlockAccess("CtrWtedTidkHostif::reset");
};
