/**
	* \file CtrWtedTidkTrafgen.cpp
	* trafgen controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedTidkTrafgen.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedTidkTrafgen::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedTidkTrafgen::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "set") return SET;

	return(0xFF);
};

string CtrWtedTidkTrafgen::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == SET) return("set");

	return("");
};

void CtrWtedTidkTrafgen::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {SET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedTidkTrafgen
 ******************************************************************************/

CtrWtedTidkTrafgen::CtrWtedTidkTrafgen(
			UntWted* unt
		) : CtrWted(unt) {
	cmdSet = getNewCmdSet();
};

CtrWtedTidkTrafgen::~CtrWtedTidkTrafgen() {
	delete cmdSet;
};

uint8_t CtrWtedTidkTrafgen::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedTidkTrafgen::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedTidkTrafgen::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedTidkTrafgen::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();

	return cmd;
};

Cmd* CtrWtedTidkTrafgen::getNewCmdSet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);

	return cmd;
};

void CtrWtedTidkTrafgen::set(
			const bool rng
		) {
	unt->lockAccess("CtrWtedTidkTrafgen::set");

	Cmd* cmd = cmdSet;

	cmd->parsInv["rng"].setBool(rng);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running set");

	unt->unlockAccess("CtrWtedTidkTrafgen::set");
};
