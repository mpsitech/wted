/**
	* \file CtrWtedZudkState.h
	* state controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 10 Jul 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDZUDKSTATE_H
#define CTRWTEDZUDKSTATE_H

#include "Wted.h"

#include "UntWtedZudk_vecs.h"

#define CmdWtedZudkStateGet CtrWtedZudkState::CmdGet

#define VecVWtedZudkStateCommand CtrWtedZudkState::VecVCommand

/**
	* CtrWtedZudkState
	*/
class CtrWtedZudkState : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedZudkStateCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t GET = 0x00;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedZudkState(UntWted* unt);
	~CtrWtedZudkState();

public:
	static const uint8_t tixVController = 0x0A;

public:
	Dbecore::Cmd* cmdGet;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdGet();
	void get(uint8_t& tixVZudkState);

};

#endif
