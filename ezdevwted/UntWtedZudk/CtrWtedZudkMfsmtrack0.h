/**
	* \file CtrWtedZudkMfsmtrack0.h
	* mfsmtrack0 controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 10 Jul 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDZUDKMFSMTRACK0_H
#define CTRWTEDZUDKMFSMTRACK0_H

#include "Wted.h"

#define CmdWtedZudkMfsmtrack0GetInfo CtrWtedZudkMfsmtrack0::CmdGetInfo

#define VecVWtedZudkMfsmtrack0Capture CtrWtedZudkMfsmtrack0::VecVCapture
#define VecVWtedZudkMfsmtrack0Command CtrWtedZudkMfsmtrack0::VecVCommand
#define VecVWtedZudkMfsmtrack0State CtrWtedZudkMfsmtrack0::VecVState
#define VecVWtedZudkMfsmtrack0Trigger CtrWtedZudkMfsmtrack0::VecVTrigger

/**
	* CtrWtedZudkMfsmtrack0
	*/
class CtrWtedZudkMfsmtrack0 : public CtrWted {

public:
	/**
		* VecVCapture (full: VecVWtedZudkMfsmtrack0Capture)
		*/
	class VecVCapture {

	public:
		static constexpr uint8_t HOSTIFOP = 0x01;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static std::string getTitle(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVCommand (full: VecVWtedZudkMfsmtrack0Command)
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
		* VecVState (full: VecVWtedZudkMfsmtrack0State)
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
		* VecVTrigger (full: VecVWtedZudkMfsmtrack0Trigger)
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
	CtrWtedZudkMfsmtrack0(UntWted* unt);
	~CtrWtedZudkMfsmtrack0();

public:
	static const uint8_t tixVController = 0x04;

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
