/**
	* \file CtrWtedTidkClient.cpp
	* client controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedTidkClient.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedTidkClient::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedTidkClient::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "loadgetbuf") return LOADGETBUF;
	else if (s == "storesetbuf") return STORESETBUF;

	return(0xFF);
};

string CtrWtedTidkClient::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == LOADGETBUF) return("loadGetbuf");
	else if (tix == STORESETBUF) return("storeSetbuf");

	return("");
};

void CtrWtedTidkClient::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {LOADGETBUF,STORESETBUF};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedTidkClient
 ******************************************************************************/

CtrWtedTidkClient::CtrWtedTidkClient(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedTidkClient::~CtrWtedTidkClient() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedTidkClient::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedTidkClient::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedTidkClient::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedTidkClient::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::LOADGETBUF) cmd = getNewCmdLoadGetbuf();
	else if (tixVCommand == VecVCommand::STORESETBUF) cmd = getNewCmdStoreSetbuf();

	return cmd;
};

Cmd* CtrWtedTidkClient::getNewCmdLoadGetbuf() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::LOADGETBUF, Cmd::VecVRettype::VOID);

	return cmd;
};

void CtrWtedTidkClient::loadGetbuf(
		) {
	unt->lockAccess("CtrWtedTidkClient::loadGetbuf");

	Cmd* cmd = cmdLoadGetbuf;

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running loadGetbuf");

	unt->unlockAccess("CtrWtedTidkClient::loadGetbuf");
};

Cmd* CtrWtedTidkClient::getNewCmdStoreSetbuf() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::STORESETBUF, Cmd::VecVRettype::VOID);

	return cmd;
};

void CtrWtedTidkClient::storeSetbuf(
		) {
	unt->lockAccess("CtrWtedTidkClient::storeSetbuf");

	Cmd* cmd = cmdStoreSetbuf;

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running storeSetbuf");

	unt->unlockAccess("CtrWtedTidkClient::storeSetbuf");
};
