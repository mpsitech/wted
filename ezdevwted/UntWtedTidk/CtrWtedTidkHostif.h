/**
	* \file CtrWtedTidkHostif.h
	* hostif controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDTIDKHOSTIF_H
#define CTRWTEDTIDKHOSTIF_H

#include "Wted.h"

#define VecVWtedTidkHostifCommand CtrWtedTidkHostif::VecVCommand

/**
	* CtrWtedTidkHostif
	*/
class CtrWtedTidkHostif : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedTidkHostifCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t RESET = 0x00;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedTidkHostif(UntWted* unt);
	~CtrWtedTidkHostif();

public:
	static const uint8_t tixVController = 0x00;

public:
	Dbecore::Cmd* cmdReset;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdReset();
	void reset();

};

#endif
