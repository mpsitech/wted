/**
	* \file CtrWtedClebRgbled0.h
	* rgbled0 controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDCLEBRGBLED0_H
#define CTRWTEDCLEBRGBLED0_H

#include "Wted.h"

#define VecVWtedClebRgbled0Command CtrWtedClebRgbled0::VecVCommand

/**
	* CtrWtedClebRgbled0
	*/
class CtrWtedClebRgbled0 : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedClebRgbled0Command)
		*/
	class VecVCommand {

	public:

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedClebRgbled0(UntWted* unt);
	~CtrWtedClebRgbled0();

public:
	static const uint8_t tixVController = 0x05;

public:

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

};

#endif
