/**
	* \file CtrWtedZudkDdrif.h
	* ddrif controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDZUDKDDRIF_H
#define CTRWTEDZUDKDDRIF_H

#include "Wted.h"

#define CmdWtedZudkDdrifGetStats CtrWtedZudkDdrif::CmdGetStats

#define VecVWtedZudkDdrifCommand CtrWtedZudkDdrif::VecVCommand

/**
	* CtrWtedZudkDdrif
	*/
class CtrWtedZudkDdrif : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedZudkDdrifCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t GETSTATS = 0x00;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedZudkDdrif(UntWted* unt);
	~CtrWtedZudkDdrif();

public:
	static const uint8_t tixVController = 0x03;

public:
	Dbecore::Cmd* cmdGetStats ;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdGetStats();
	void getStats(uint32_t& NRdA, uint32_t& NWrA, uint32_t& NWrB);

};

#endif
