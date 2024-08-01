/**
	* \file CtrWtedTidkMemrdtrack.h
	* memrdtrack controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 24 Jul 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDTIDKMEMRDTRACK_H
#define CTRWTEDTIDKMEMRDTRACK_H

#include "Wted.h"

#define CmdWtedTidkMemrdtrackGetInfo CtrWtedTidkMemrdtrack::CmdGetInfo

#define VecVWtedTidkMemrdtrackCapture CtrWtedTidkMemrdtrack::VecVCapture
#define VecVWtedTidkMemrdtrackCommand CtrWtedTidkMemrdtrack::VecVCommand
#define VecVWtedTidkMemrdtrackState CtrWtedTidkMemrdtrack::VecVState
#define VecVWtedTidkMemrdtrackTrigger CtrWtedTidkMemrdtrack::VecVTrigger

/**
	* CtrWtedTidkMemrdtrack
	*/
class CtrWtedTidkMemrdtrack : public CtrWted {

public:
	/**
		* VecVCapture (full: VecVWtedTidkMemrdtrackCapture)
		*/
	class VecVCapture {

	public:
		static constexpr uint8_t REQCLIENTTODDRIFRD = 0x00;
		static constexpr uint8_t ACKCLIENTTODDRIFRD = 0x01;
		static constexpr uint8_t MEMCRDAXIRVALID = 0x02;
		static constexpr uint8_t DDRAXIARADDRSIG0 = 0x03;
		static constexpr uint8_t DDRAXIARADDRSIG1 = 0x04;
		static constexpr uint8_t DDRAXIARREADY = 0x05;
		static constexpr uint8_t DDRAXIARVALIDSIG = 0x06;
		static constexpr uint8_t DDRAXIRREADYSIG = 0x07;
		static constexpr uint8_t DDRAXIRDATA0 = 0x08;
		static constexpr uint8_t DDRAXIRDATA1 = 0x09;
		static constexpr uint8_t DDRAXIRDATA2 = 0x0A;
		static constexpr uint8_t DDRAXIRDATA3 = 0x0B;
		static constexpr uint8_t DDRAXIRLAST = 0x0C;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static std::string getTitle(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVCommand (full: VecVWtedTidkMemrdtrackCommand)
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
		* VecVState (full: VecVWtedTidkMemrdtrackState)
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
		* VecVTrigger (full: VecVWtedTidkMemrdtrackTrigger)
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
	CtrWtedTidkMemrdtrack(UntWted* unt);
	~CtrWtedTidkMemrdtrack();

public:
	static const uint8_t tixVController = 0x07;

public:
	Dbecore::Cmd* cmdGetInfo;
	Dbecore::Cmd* cmdSelect;
	Dbecore::Cmd* cmdSet;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdGetInfo();
	void getInfo(uint8_t& tixVState);

	static Dbecore::Cmd* getNewCmdSelect();
	void select(const uint8_t staTixVTrigger, const bool staFallingNotRising, const uint8_t stoTixVTrigger, const bool stoFallingNotRising);

	static Dbecore::Cmd* getNewCmdSet();
	void set(const bool rng, const uint32_t TCapt);

};

#endif
