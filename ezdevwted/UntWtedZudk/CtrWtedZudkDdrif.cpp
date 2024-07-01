/**
	* \file CtrWtedZudkDdrif.cpp
	* ddrif controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedZudkDdrif.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedZudkDdrif::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedZudkDdrif::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getstats") return GETSTATS;

	return(0xFF);
};

string CtrWtedZudkDdrif::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETSTATS) return("getStats");

	return("");
};

void CtrWtedZudkDdrif::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETSTATS};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedZudkDdrif
 ******************************************************************************/

CtrWtedZudkDdrif::CtrWtedZudkDdrif(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedZudkDdrif::~CtrWtedZudkDdrif() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedZudkDdrif::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedZudkDdrif::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedZudkDdrif::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedZudkDdrif::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETSTATS) cmd = getNewCmdGetStats();

	return cmd;
};

Cmd* CtrWtedZudkDdrif::getNewCmdGetStats() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GETSTATS, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("NRdA", Par::VecVType::UINT32);
	cmd->addParRet("NWrA", Par::VecVType::UINT32);
	cmd->addParRet("NWrB", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedZudkDdrif::getStats(
			uint32_t& NRdA
			, uint32_t& NWrA
			, uint32_t& NWrB
		) {
	unt->lockAccess("CtrWtedZudkDdrif::getStats");

	Cmd* cmd = cmdGetStats;

	if (unt->runCmd(cmd)) {
		NRdA = cmd->parsRet["NRdA"].getUint32();
		NWrA = cmd->parsRet["NWrA"].getUint32();
		NWrB = cmd->parsRet["NWrB"].getUint32();
	} else throw DbeException("error running getStats");

	unt->unlockAccess("CtrWtedZudkDdrif::getStats");
};
