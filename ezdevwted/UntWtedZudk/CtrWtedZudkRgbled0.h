/**
	* \file CtrWtedZudkRgbled0.h
	* rgbled0 controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 10 Jul 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDZUDKRGBLED0_H
#define CTRWTEDZUDKRGBLED0_H

#include "Wted.h"

#define VecVWtedZudkRgbled0Command CtrWtedZudkRgbled0::VecVCommand

/**
	* CtrWtedZudkRgbled0
	*/
class CtrWtedZudkRgbled0 : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedZudkRgbled0Command)
		*/
	class VecVCommand {

	public:

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedZudkRgbled0(UntWted* unt);
	~CtrWtedZudkRgbled0();

public:
	static const uint8_t tixVController = 0x09;

public:

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

};

#endif
