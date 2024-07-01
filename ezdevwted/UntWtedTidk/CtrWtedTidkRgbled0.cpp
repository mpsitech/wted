/**
	* \file CtrWtedTidkRgbled0.cpp
	* rgbled0 controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "CtrWtedTidkRgbled0.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWtedTidkRgbled0::VecVCommand
 ******************************************************************************/

uint8_t CtrWtedTidkRgbled0::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	return(0xFF);
};

string CtrWtedTidkRgbled0::VecVCommand::getSref(
			const uint8_t tix
		) {

	return("");
};

void CtrWtedTidkRgbled0::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();
};

/******************************************************************************
 class CtrWtedTidkRgbled0
 ******************************************************************************/

CtrWtedTidkRgbled0::CtrWtedTidkRgbled0(
			UntWted* unt
		) : CtrWted(unt) {
	// IP constructor.easy.cmdvars --- INSERT
};

CtrWtedTidkRgbled0::~CtrWtedTidkRgbled0() {
	// IP destructor.easy.cmdvars --- INSERT
};

uint8_t CtrWtedTidkRgbled0::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWtedTidkRgbled0::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWtedTidkRgbled0::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWtedTidkRgbled0::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	return cmd;
};
