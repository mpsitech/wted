/**
	* \file CtrWtedZudkTkclksrc.h
	* tkclksrc controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 10 Jul 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDZUDKTKCLKSRC_H
#define CTRWTEDZUDKTKCLKSRC_H

#include "Wted.h"

#define CmdWtedZudkTkclksrcGetTkst CtrWtedZudkTkclksrc::CmdGetTkst

#define VecVWtedZudkTkclksrcCommand CtrWtedZudkTkclksrc::VecVCommand

/**
	* CtrWtedZudkTkclksrc
	*/
class CtrWtedZudkTkclksrc : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedZudkTkclksrcCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t GETTKST = 0x00;
		static constexpr uint8_t SETTKST = 0x01;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedZudkTkclksrc(UntWted* unt);
	~CtrWtedZudkTkclksrc();

public:
	static const uint8_t tixVController = 0x0B;

public:
	Dbecore::Cmd* cmdGetTkst;
	Dbecore::Cmd* cmdSetTkst;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdGetTkst();
	void getTkst(uint32_t& tkst);

	static Dbecore::Cmd* getNewCmdSetTkst();
	void setTkst(const uint32_t tkst);

};

#endif
