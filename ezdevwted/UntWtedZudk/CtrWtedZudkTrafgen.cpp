/**
	* \file CtrWtedZudkTrafgen.cpp
	* trafgen controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedZudkTrafgen.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedZudkTrafgen::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedZudkTrafgen::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "set") return SET;

	return(0xFF);
};

string CtrWtedZudkTrafgen::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == SET) return("set");

	return("");
};

void CtrWtedZudkTrafgen::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {SET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedZudkTrafgen
 ******************************************************************************/

CtrWtedZudkTrafgen::CtrWtedZudkTrafgen(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedZudkTrafgen::~CtrWtedZudkTrafgen() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedZudkTrafgen::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedZudkTrafgen::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedZudkTrafgen::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedZudkTrafgen::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();

	return cmd;
};

Cmd* CtrWtedZudkTrafgen::getNewCmdSet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);

	return cmd;
};

void CtrWtedZudkTrafgen::set(
			const bool rng
		) {
	unt->lockAccess("CtrWtedZudkTrafgen::set");

	Cmd* cmd = cmdSet;

	cmd->parsInv["rng"].setBool(rng);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running set");

	unt->unlockAccess("CtrWtedZudkTrafgen::set");
};
