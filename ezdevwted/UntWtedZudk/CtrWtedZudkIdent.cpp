/**
	* \file CtrWtedZudkIdent.cpp
	* ident controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedZudkIdent.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedZudkIdent::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedZudkIdent::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "get") return GET;
	else if (s == "getcfg") return GETCFG;

	return(0xFF);
};

string CtrWtedZudkIdent::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GET) return("get");
	else if (tix == GETCFG) return("getCfg");

	return("");
};

void CtrWtedZudkIdent::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GET,GETCFG};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedZudkIdent
 ******************************************************************************/

CtrWtedZudkIdent::CtrWtedZudkIdent(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedZudkIdent::~CtrWtedZudkIdent() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedZudkIdent::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedZudkIdent::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedZudkIdent::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedZudkIdent::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GET) cmd = getNewCmdGet();
	else if (tixVCommand == VecVCommand::GETCFG) cmd = getNewCmdGetCfg();

	return cmd;
};

Cmd* CtrWtedZudkIdent::getNewCmdGet() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GET, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("ver", Par::VecVType::BLOB, NULL, NULL, NULL, 8);
	cmd->addParRet("hash", Par::VecVType::BLOB, NULL, NULL, NULL, 8);
	cmd->addParRet("who", Par::VecVType::BLOB, NULL, NULL, NULL, 8);

	return cmd;
};

void CtrWtedZudkIdent::get(
			unsigned char*& ver
			, size_t& verlen
			, unsigned char*& hash
			, size_t& hashlen
			, unsigned char*& who
			, size_t& wholen
		) {
	unt->lockAccess("CtrWtedZudkIdent::get");

	Cmd* cmd = cmdGet;

	if (unt->runCmd(cmd)) {
		ver = cmd->parsRet["ver"].getBlob();
		verlen = cmd->parsRet["ver"].getLen();
		hash = cmd->parsRet["hash"].getBlob();
		hashlen = cmd->parsRet["hash"].getLen();
		who = cmd->parsRet["who"].getBlob();
		wholen = cmd->parsRet["who"].getLen();
	} else throw DbeException("error running get");

	unt->unlockAccess("CtrWtedZudkIdent::get");
};

Cmd* CtrWtedZudkIdent::getNewCmdGetCfg() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::GETCFG, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("fMclk", Par::VecVType::UINT32);
	cmd->addParRet("fMemclk", Par::VecVType::UINT32);

	return cmd;
};

void CtrWtedZudkIdent::getCfg(
			uint32_t& fMclk
			, uint32_t& fMemclk
		) {
	unt->lockAccess("CtrWtedZudkIdent::getCfg");

	Cmd* cmd = cmdGetCfg;

	if (unt->runCmd(cmd)) {
		fMclk = cmd->parsRet["fMclk"].getUint32();
		fMemclk = cmd->parsRet["fMemclk"].getUint32();
	} else throw DbeException("error running getCfg");

	unt->unlockAccess("CtrWtedZudkIdent::getCfg");
};
