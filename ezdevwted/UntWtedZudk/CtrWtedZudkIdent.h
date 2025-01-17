/**
	* \file CtrWtedZudkIdent.h
	* ident controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 10 Jul 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDZUDKIDENT_H
#define CTRWTEDZUDKIDENT_H

#include "Wted.h"

#define CmdWtedZudkIdentGet CtrWtedZudkIdent::CmdGet
#define CmdWtedZudkIdentGetCfg CtrWtedZudkIdent::CmdGetCfg

#define VecVWtedZudkIdentCommand CtrWtedZudkIdent::VecVCommand

/**
	* CtrWtedZudkIdent
	*/
class CtrWtedZudkIdent : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedZudkIdentCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t GET = 0x00;
		static constexpr uint8_t GETCFG = 0x02;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedZudkIdent(UntWted* unt);
	~CtrWtedZudkIdent();

public:
	static const uint8_t tixVController = 0x01;

public:
	Dbecore::Cmd* cmdGet;
	Dbecore::Cmd* cmdGetCfg;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdGet();
	void get(unsigned char*& ver, size_t& verlen, unsigned char*& hash, size_t& hashlen, unsigned char*& who, size_t& wholen);

	static Dbecore::Cmd* getNewCmdGetCfg();
	void getCfg(uint32_t& fMclk, uint32_t& fMemclk);

};

#endif
