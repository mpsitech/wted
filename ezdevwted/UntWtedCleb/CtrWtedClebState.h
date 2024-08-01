/**
	* \file CtrWtedClebState.h
	* state controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDCLEBSTATE_H
#define CTRWTEDCLEBSTATE_H

#include "Wted.h"

#include "UntWtedCleb_vecs.h"

#define CmdWtedClebStateGet CtrWtedClebState::CmdGet

#define VecVWtedClebStateCommand CtrWtedClebState::VecVCommand

/**
	* CtrWtedClebState
	*/
class CtrWtedClebState : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedClebStateCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t GET = 0x00;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedClebState(UntWted* unt);
	~CtrWtedClebState();

public:
	static const uint8_t tixVController = 0x06;

public:
	Dbecore::Cmd* cmdGet;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdGet();
	void get(uint8_t& tixVClebState);

};

#endif
