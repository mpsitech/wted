/**
	* \file CtrWtedClebRgbled0.cpp
	* rgbled0 controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedClebRgbled0.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedClebRgbled0::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedClebRgbled0::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	return(0xFF);
};

string CtrWtedClebRgbled0::VecVCommand::getSref(
			const uint8_t tix
		) {

	return("");
};

void CtrWtedClebRgbled0::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();
};

/******************************************************************************
 class CtrWtedClebRgbled0
 ******************************************************************************/

CtrWtedClebRgbled0::CtrWtedClebRgbled0(
			UntWted* unt
		) : CtrWted(unt) {
};

CtrWtedClebRgbled0::~CtrWtedClebRgbled0() {
};

uint8_t CtrWtedClebRgbled0::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedClebRgbled0::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedClebRgbled0::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedClebRgbled0::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	return cmd;
};
