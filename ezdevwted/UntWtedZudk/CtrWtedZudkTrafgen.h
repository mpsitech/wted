/**
	* \file CtrWtedZudkTrafgen.h
	* trafgen controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDZUDKTRAFGEN_H
#define CTRWTEDZUDKTRAFGEN_H

#include "Wted.h"

#define VecVWtedZudkTrafgenCommand CtrWtedZudkTrafgen::VecVCommand

/**
	* CtrWtedZudkTrafgen
	*/
class CtrWtedZudkTrafgen : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedZudkTrafgenCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t SET = 0x00;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedZudkTrafgen(UntWted* unt);
	~CtrWtedZudkTrafgen();

public:
	static const uint8_t tixVController = 0x0B;

public:
	Dbecore::Cmd* cmdSet ;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdSet();
	void set(const bool rng);

};

#endif
