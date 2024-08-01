/**
	* \file CtrWtedTidkMfsmtrack1.h
	* mfsmtrack1 controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDTIDKMFSMTRACK1_H
#define CTRWTEDTIDKMFSMTRACK1_H

#include "Wted.h"

#define CmdWtedTidkMfsmtrack1GetInfo CtrWtedTidkMfsmtrack1::CmdGetInfo

#define VecVWtedTidkMfsmtrack1Capture CtrWtedTidkMfsmtrack1::VecVCapture
#define VecVWtedTidkMfsmtrack1Command CtrWtedTidkMfsmtrack1::VecVCommand
#define VecVWtedTidkMfsmtrack1State CtrWtedTidkMfsmtrack1::VecVState
#define VecVWtedTidkMfsmtrack1Trigger CtrWtedTidkMfsmtrack1::VecVTrigger

/**
	* CtrWtedTidkMfsmtrack1
	*/
class CtrWtedTidkMfsmtrack1 : public CtrWted {

public:
	/**
		* VecVCapture (full: VecVWtedTidkMfsmtrack1Capture)
		*/
	class VecVCapture {

	public:
		static constexpr uint8_t CLIENTGETBUFB = 0x01;
		static constexpr uint8_t CLIENTSETBUFB = 0x02;
		static constexpr uint8_t TKCLKSRCOP = 0x03;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static std::string getTitle(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVCommand (full: VecVWtedTidkMfsmtrack1Command)
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
		* VecVState (full: VecVWtedTidkMfsmtrack1State)
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
		* VecVTrigger (full: VecVWtedTidkMfsmtrack1Trigger)
		*/
	class VecVTrigger {

	public:
		static constexpr uint8_t VOID = 0x00;
		static constexpr uint8_t HOSTIFRXAXISTVALID = 0x02;
		static constexpr uint8_t ACKINVTKCLKSRCSETTKST = 0x03;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static std::string getTitle(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWtedTidkMfsmtrack1(UntWted* unt);
	~CtrWtedTidkMfsmtrack1();

public:
	static const uint8_t tixVController = 0x05;

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
	void getInfo(uint8_t& tixVState, unsigned char*& coverage, size_t& coveragelen);

	static Dbecore::Cmd* getNewCmdSelect();
	void select(const uint8_t tixVCapture, const uint8_t staTixVTrigger, const bool staFallingNotRising, const uint8_t stoTixVTrigger, const bool stoFallingNotRising);

	static Dbecore::Cmd* getNewCmdSet();
	void set(const bool rng, const uint32_t TCapt);

};

#endif
