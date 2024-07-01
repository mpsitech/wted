/**
	* \file CtrWtedTidkTkclksrc.cpp
	* tkclksrc controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedTidkTkclksrc.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedTidkTkclksrc::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedTidkTkclksrc::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "gettkst") return GETTKST;
	else if (s == "settkst") return SETTKST;

	return(0xFF);
};

string CtrWtedTidkTkclksrc::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETTKST) return("getTkst");
	else if (tix == SETTKST) return("setTkst");

	return("");
};

void CtrWtedTidkTkclksrc::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETTKST,SETTKST};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedTidkTkclksrc
 ******************************************************************************/

CtrWtedTidkTkclksrc::CtrWtedTidkTkclksrc(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedTidkTkclksrc::~CtrWtedTidkTkclksrc() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedTidkTkclksrc::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedTidkTkclksrc::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedTidkTkclksrc::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedTidkTkclksrc::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETTKST) cmd = getNewCmdGetTkst();
	else if (tixVCommand == VecVCommand::SETTKST) cmd = getNewCmdSetTkst();

	return cmd;
};

Cmd* CtrWtedTidkTkclksrc::getNewCmdGetTkst() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GETTKST, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tkst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedTidkTkclksrc::getTkst(
			uint32_t& tkst
		) {
	unt->lockAccess("CtrWtedTidkTkclksrc::getTkst");

	Cmd* cmd = cmdGetTkst;

	if (unt->runCmd(cmd)) {
		tkst = cmd->parsRet["tkst"].getUint32();
	} else throw DbeException("error running getTkst");

	unt->unlockAccess("CtrWtedTidkTkclksrc::getTkst");
};

Cmd* CtrWtedTidkTkclksrc::getNewCmdSetTkst() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SETTKST, Cmd::VecVRettype::VOID);

	cmd->addParInv("tkst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedTidkTkclksrc::setTkst(
			const uint32_t tkst
		) {
	unt->lockAccess("CtrWtedTidkTkclksrc::setTkst");

	Cmd* cmd = cmdSetTkst;

	cmd->parsInv["tkst"].setUint32(tkst);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running setTkst");

	unt->unlockAccess("CtrWtedTidkTkclksrc::setTkst");
};
