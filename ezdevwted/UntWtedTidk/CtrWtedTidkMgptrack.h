/**
	* \file CtrWtedTidkMgptrack.h
	* mgptrack controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDTIDKMGPTRACK_H
#define CTRWTEDTIDKMGPTRACK_H

#include "Wted.h"

#define CmdWtedTidkMgptrackGetInfo CtrWtedTidkMgptrack::CmdGetInfo

#define VecVWtedTidkMgptrackCapture CtrWtedTidkMgptrack::VecVCapture
#define VecVWtedTidkMgptrackCommand CtrWtedTidkMgptrack::VecVCommand
#define VecVWtedTidkMgptrackState CtrWtedTidkMgptrack::VecVState
#define VecVWtedTidkMgptrackTrigger CtrWtedTidkMgptrack::VecVTrigger

/**
	* CtrWtedTidkMgptrack
	*/
class CtrWtedTidkMgptrack : public CtrWted {

public:
	/**
		* VecVCapture (full: VecVWtedTidkMgptrackCapture)
		*/
	class VecVCapture {

	public:
		static constexpr uint8_t TKCLK = 0x00;
		static constexpr uint8_t RGB0R = 0x01;
		static constexpr uint8_t RGB0G = 0x02;
		static constexpr uint8_t RGB0B = 0x03;
		static constexpr uint8_t BTN0 = 0x04;
		static constexpr uint8_t BTN0SIG = 0x05;
		static constexpr uint8_t TKCLKSRCGETTKSTTKST0 = 0x06;
		static constexpr uint8_t TKCLKSRCGETTKSTTKST1 = 0x07;
		static constexpr uint8_t TKCLKSRCGETTKSTTKST2 = 0x08;
		static constexpr uint8_t TKCLKSRCGETTKSTTKST3 = 0x09;
		static constexpr uint8_t TKCLKSRCGETTKSTTKST4 = 0x0A;
		static constexpr uint8_t TKCLKSRCGETTKSTTKST5 = 0x0B;
		static constexpr uint8_t TKCLKSRCGETTKSTTKST6 = 0x0C;
		static constexpr uint8_t TKCLKSRCGETTKSTTKST7 = 0x0D;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static std::string getTitle(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVCommand (full: VecVWtedTidkMgptrackCommand)
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
		* VecVState (full: VecVWtedTidkMgptrackState)
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
		* VecVTrigger (full: VecVWtedTidkMgptrackTrigger)
		*/
	class VecVTrigger {

	public:
		static constexpr uint8_t VOID = 0x00;
		static constexpr uint8_t BTN0 = 0x02;
		static constexpr uint8_t HOSTIFRXAXISTVALID = 0x03;
		static constexpr uint8_t ACKINVTKCLKSRCSETTKST = 0x04;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static std::string getTitle(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedTidkMgptrack(UntWted* unt);
	~CtrWtedTidkMgptrack();

public:
	static const uint8_t tixVController = 0x06;

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
