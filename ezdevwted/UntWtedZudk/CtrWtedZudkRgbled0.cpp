/**
	* \file CtrWtedZudkRgbled0.cpp
	* rgbled0 controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedZudkRgbled0.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedZudkRgbled0::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedZudkRgbled0::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	return(0xFF);
};

string CtrWtedZudkRgbled0::VecVCommand::getSref(
			const uint8_t tix
		) {

	return("");
};

void CtrWtedZudkRgbled0::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();
};

/******************************************************************************
 class CtrWtedZudkRgbled0
 ******************************************************************************/

CtrWtedZudkRgbled0::CtrWtedZudkRgbled0(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedZudkRgbled0::~CtrWtedZudkRgbled0() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedZudkRgbled0::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedZudkRgbled0::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedZudkRgbled0::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedZudkRgbled0::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	return cmd;
};
