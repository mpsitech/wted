/**
	* \file CtrWtedClebTkclksrc.cpp
	* tkclksrc controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedClebTkclksrc.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedClebTkclksrc::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedClebTkclksrc::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "gettkst") return GETTKST;
	else if (s == "settkst") return SETTKST;

	return(0xFF);
};

string CtrWtedClebTkclksrc::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETTKST) return("getTkst");
	else if (tix == SETTKST) return("setTkst");

	return("");
};

void CtrWtedClebTkclksrc::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETTKST,SETTKST};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedClebTkclksrc
 ******************************************************************************/

CtrWtedClebTkclksrc::CtrWtedClebTkclksrc(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedClebTkclksrc::~CtrWtedClebTkclksrc() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedClebTkclksrc::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedClebTkclksrc::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedClebTkclksrc::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedClebTkclksrc::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETTKST) cmd = getNewCmdGetTkst();
	else if (tixVCommand == VecVCommand::SETTKST) cmd = getNewCmdSetTkst();

	return cmd;
};

Cmd* CtrWtedClebTkclksrc::getNewCmdGetTkst() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GETTKST, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tkst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedClebTkclksrc::getTkst(
			uint32_t& tkst
		) {
	unt->lockAccess("CtrWtedClebTkclksrc::getTkst");

	Cmd* cmd = cmdGetTkst;

	if (unt->runCmd(cmd)) {
		tkst = cmd->parsRet["tkst"].getUint32();
	} else throw DbeException("error running getTkst");

	unt->unlockAccess("CtrWtedClebTkclksrc::getTkst");
};

Cmd* CtrWtedClebTkclksrc::getNewCmdSetTkst() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::SETTKST, Cmd::VecVRettype::VOID);

	cmd->addParInv("tkst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedClebTkclksrc::setTkst(
			const uint32_t tkst
		) {
	unt->lockAccess("CtrWtedClebTkclksrc::setTkst");

	Cmd* cmd = cmdSetTkst;

	cmd->parsInv["tkst"].setUint32(tkst);

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running setTkst");

	unt->unlockAccess("CtrWtedClebTkclksrc::setTkst");
};
