/**
	* \file CtrWtedTidkState.h
	* state controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDTIDKSTATE_H
#define CTRWTEDTIDKSTATE_H

#include "Wted.h"

#include "UntWtedTidk_vecs.h"

#define CmdWtedTidkStateGet CtrWtedTidkState::CmdGet

#define VecVWtedTidkStateCommand CtrWtedTidkState::VecVCommand

/**
	* CtrWtedTidkState
	*/
class CtrWtedTidkState : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedTidkStateCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t GET = 0x00;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedTidkState(UntWted* unt);
	~CtrWtedTidkState();

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
	void get(uint8_t& tixVTidkState);

};

#endif
