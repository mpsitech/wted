/**
	* \file CtrWtedZudkClient.cpp
	* client controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 10 Jul 2024
	*/
// IP header --- ABOVE

#include "CtrWtedZudkClient.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedZudkClient::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedZudkClient::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "loadgetbuf") return LOADGETBUF;
	else if (s == "storesetbuf") return STORESETBUF;

	return(0xFF);
};

string CtrWtedZudkClient::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == LOADGETBUF) return("loadGetbuf");
	else if (tix == STORESETBUF) return("storeSetbuf");

	return("");
};

void CtrWtedZudkClient::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {LOADGETBUF,STORESETBUF};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWtedZudkClient
 ******************************************************************************/

CtrWtedZudkClient::CtrWtedZudkClient(
			UntWted* unt
		) : CtrWted(unt) {
	cmdLoadGetbuf = getNewCmdLoadGetbuf();
	cmdStoreSetbuf = getNewCmdStoreSetbuf();
};

CtrWtedZudkClient::~CtrWtedZudkClient() {
	delete cmdLoadGetbuf;
	delete cmdStoreSetbuf;
};

uint8_t CtrWtedZudkClient::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedZudkClient::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedZudkClient::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedZudkClient::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::LOADGETBUF) cmd = getNewCmdLoadGetbuf();
	else if (tixVCommand == VecVCommand::STORESETBUF) cmd = getNewCmdStoreSetbuf();

	return cmd;
};

Cmd* CtrWtedZudkClient::getNewCmdLoadGetbuf() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::LOADGETBUF, Cmd::VecVRettype::VOID);

	return cmd;
};

void CtrWtedZudkClient::loadGetbuf(
		) {
	unt->lockAccess("CtrWtedZudkClient::loadGetbuf");

	Cmd* cmd = cmdLoadGetbuf;

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running loadGetbuf");

	unt->unlockAccess("CtrWtedZudkClient::loadGetbuf");
};

Cmd* CtrWtedZudkClient::getNewCmdStoreSetbuf() {
	Cmd* cmd = new Cmd(tixVController, VecVCommand::STORESETBUF, Cmd::VecVRettype::VOID);

	return cmd;
};

void CtrWtedZudkClient::storeSetbuf(
		) {
	unt->lockAccess("CtrWtedZudkClient::storeSetbuf");

	Cmd* cmd = cmdStoreSetbuf;

	if (unt->runCmd(cmd)) {
	} else throw DbeException("error running storeSetbuf");

	unt->unlockAccess("CtrWtedZudkClient::storeSetbuf");
};
