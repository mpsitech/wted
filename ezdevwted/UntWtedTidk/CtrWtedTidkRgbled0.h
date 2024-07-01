/**
	* \file CtrWtedTidkRgbled0.h
	* rgbled0 controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDTIDKRGBLED0_H
#define CTRWTEDTIDKRGBLED0_H

#include "Wted.h"

#define VecVWtedTidkRgbled0Command CtrWtedTidkRgbled0::VecVCommand

/**
	* CtrWtedTidkRgbled0
	*/
class CtrWtedTidkRgbled0 : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedTidkRgbled0Command)
		*/
	class VecVCommand {

	public:

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedTidkRgbled0(UntWted* unt);
	~CtrWtedTidkRgbled0();

public:
	static const uint8_t tixVController = 0x08;

public:

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

};

#endif
