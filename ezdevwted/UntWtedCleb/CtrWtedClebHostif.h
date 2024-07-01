/**
	* \file CtrWtedClebHostif.h
	* hostif controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDCLEBHOSTIF_H
#define CTRWTEDCLEBHOSTIF_H

#include "Wted.h"

#define VecVWtedClebHostifCommand CtrWtedClebHostif::VecVCommand

/**
	* CtrWtedClebHostif
	*/
class CtrWtedClebHostif : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedClebHostifCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t RESET = 0x00;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedClebHostif(UntWted* unt);
	~CtrWtedClebHostif();

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
