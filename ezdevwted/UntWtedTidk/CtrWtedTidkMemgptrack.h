/**
	* \file CtrWtedTidkMemgptrack.h
	* memgptrack controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDTIDKMEMGPTRACK_H
#define CTRWTEDTIDKMEMGPTRACK_H

#include "Wted.h"

#define CmdWtedTidkMemgptrackGetInfo CtrWtedTidkMemgptrack::CmdGetInfo

#define VecVWtedTidkMemgptrackCapture CtrWtedTidkMemgptrack::VecVCapture
#define VecVWtedTidkMemgptrackCommand CtrWtedTidkMemgptrack::VecVCommand
#define VecVWtedTidkMemgptrackState CtrWtedTidkMemgptrack::VecVState
#define VecVWtedTidkMemgptrackTrigger CtrWtedTidkMemgptrack::VecVTrigger

/**
	* CtrWtedTidkMemgptrack
	*/
class CtrWtedTidkMemgptrack : public CtrWted {

public:
	/**
		* VecVCapture (full: VecVWtedTidkMemgptrackCapture)
		*/
	class VecVCapture {

	public:
		static constexpr uint8_t REQCLIENTTODDRIFRD = 0x00;
		static constexpr uint8_t ACKCLIENTTODDRIFRD = 0x01;
		static constexpr uint8_t MEMCRDAXIRVALID = 0x02;
		static constexpr uint8_t REQCLIENTTODDRIFWR = 0x03;
		static constexpr uint8_t ACKCLIENTTODDRIFWR = 0x04;
		static constexpr uint8_t MEMCWRAXIWREADY = 0x05;
		static constexpr uint8_t REQTRAFGENTODDRIFWR = 0x06;
		static constexpr uint8_t ACKTRAFGENTODDRIFWR = 0x07;
		static constexpr uint8_t MEMTWRAXIWREADY = 0x08;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static std::string getTitle(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVCommand (full: VecVWtedTidkMemgptrackCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t GETINFO = 0x00;
		static constexpr uint8_t SELECT = 0x01;
		static constexpr uint8_t SET = 0x02;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVState (full: VecVWtedTidkMemgptrackState)
		*/
	class VecVState {

	public:
		static constexpr uint8_t IDLE = 0x00;
		static constexpr uint8_t ARM = 0x01;
		static constexpr uint8_t ACQ = 0x02;
		static constexpr uint8_t DONE = 0x03;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static std::string getTitle(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVTrigger (full: VecVWtedTidkMemgptrackTrigger)
		*/
	class VecVTrigger {

	public:
		static constexpr uint8_t VOID = 0x00;
		static constexpr uint8_t ACKINVCLIENTLOADGETBUF = 0x02;
		static constexpr uint8_t ACKINVCLIENTSTORESETBUF = 0x03;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static std::string getTitle(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedTidkMemgptrack(UntWted* unt);
	~CtrWtedTidkMemgptrack();

public:
	static const uint8_t tixVController = 0x07;

public:
	Dbecore::Cmd* cmdGetInfo ;
	Dbecore::Cmd* cmdSelect ;
	Dbecore::Cmd* cmdSet ;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdGetInfo();
	void getInfo(uint8_t& tixVState);

	static Dbecore::Cmd* getNewCmdSelect();
	void select(const uint8_t staTixVTrigger, const uint8_t stoTixVTrigger);

	static Dbecore::Cmd* getNewCmdSet();
	void set(const bool rng, const uint32_t TCapt);

};

#endif
