/**
	* \file CtrWtedTidkClient.h
	* client controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDTIDKCLIENT_H
#define CTRWTEDTIDKCLIENT_H

#include "Wted.h"

#define VecVWtedTidkClientCommand CtrWtedTidkClient::VecVCommand

/**
	* CtrWtedTidkClient
	*/
class CtrWtedTidkClient : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedTidkClientCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t LOADGETBUF = 0x00;
		static constexpr uint8_t STORESETBUF = 0x01;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedTidkClient(UntWted* unt);
	~CtrWtedTidkClient();

public:
	static const uint8_t tixVController = 0x02;

public:
	Dbecore::Cmd* cmdLoadGetbuf;
	Dbecore::Cmd* cmdStoreSetbuf;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdLoadGetbuf();
	void loadGetbuf();

	static Dbecore::Cmd* getNewCmdStoreSetbuf();
	void storeSetbuf();

};

#endif
