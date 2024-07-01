/**
	* \file CtrWtedZudkHostif.h
	* hostif controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDZUDKHOSTIF_H
#define CTRWTEDZUDKHOSTIF_H

#include "Wted.h"

#define VecVWtedZudkHostifCommand CtrWtedZudkHostif::VecVCommand

/**
	* CtrWtedZudkHostif
	*/
class CtrWtedZudkHostif : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedZudkHostifCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t RESET = 0x00;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedZudkHostif(UntWted* unt);
	~CtrWtedZudkHostif();

public:
	static const uint8_t tixVController = 0x00;

public:
	Dbecore::Cmd* cmdReset ;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdReset();
	void reset();

};

#endif
