/**
	* \file CtrWtedClebTkclksrc.h
	* tkclksrc controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDCLEBTKCLKSRC_H
#define CTRWTEDCLEBTKCLKSRC_H

#include "Wted.h"

#define CmdWtedClebTkclksrcGetTkst CtrWtedClebTkclksrc::CmdGetTkst

#define VecVWtedClebTkclksrcCommand CtrWtedClebTkclksrc::VecVCommand

/**
	* CtrWtedClebTkclksrc
	*/
class CtrWtedClebTkclksrc : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedClebTkclksrcCommand)
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
	CtrWtedClebTkclksrc(UntWted* unt);
	~CtrWtedClebTkclksrc();

public:
	static const uint8_t tixVController = 0x07;

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
