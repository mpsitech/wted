/**
	* \file CtrWtedTidkDdrif.cpp
	* ddrif controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedTidkDdrif.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedTidkDdrif::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedTidkDdrif::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getstats") return GETSTATS;

	return(0xFF);
};

string CtrWtedTidkDdrif::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETSTATS) return("getStats");

	return("");
};

void CtrWtedTidkDdrif::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETSTATS};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedTidkDdrif
 ******************************************************************************/

CtrWtedTidkDdrif::CtrWtedTidkDdrif(
			UntWted* unt
		) : CtrWted(unt) {
	cmdGetStats = getNewCmdGetStats();
};

CtrWtedTidkDdrif::~CtrWtedTidkDdrif() {
	delete cmdGetStats;
};

uint8_t CtrWtedTidkDdrif::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedTidkDdrif::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedTidkDdrif::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedTidkDdrif::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETSTATS) cmd = getNewCmdGetStats();

	return cmd;
};

Cmd* CtrWtedTidkDdrif::getNewCmdGetStats() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GETSTATS, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("NRdA", Par::VecVType::UINT32);
	cmd->addParRet("NWrA", Par::VecVType::UINT32);
	cmd->addParRet("NWrB", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedTidkDdrif::getStats(
			uint32_t& NRdA
			, uint32_t& NWrA
			, uint32_t& NWrB
		) {
	unt->lockAccess("CtrWtedTidkDdrif::getStats");

	Cmd* cmd = cmdGetStats;

	if (unt->runCmd(cmd)) {
		NRdA = cmd->parsRet["NRdA"].getUint32();
		NWrA = cmd->parsRet["NWrA"].getUint32();
		NWrB = cmd->parsRet["NWrB"].getUint32();
	} else throw DbeException("error running getStats");

	unt->unlockAccess("CtrWtedTidkDdrif::getStats");
};
