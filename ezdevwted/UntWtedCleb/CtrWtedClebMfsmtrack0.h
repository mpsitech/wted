/**
	* \file CtrWtedClebMfsmtrack0.h
	* mfsmtrack0 controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDCLEBMFSMTRACK0_H
#define CTRWTEDCLEBMFSMTRACK0_H

#include "Wted.h"

#define CmdWtedClebMfsmtrack0GetInfo CtrWtedClebMfsmtrack0::CmdGetInfo

#define VecVWtedClebMfsmtrack0Command CtrWtedClebMfsmtrack0::VecVCommand
#define VecVWtedClebMfsmtrack0Source CtrWtedClebMfsmtrack0::VecVSource
#define VecVWtedClebMfsmtrack0State CtrWtedClebMfsmtrack0::VecVState
#define VecVWtedClebMfsmtrack0Trigger CtrWtedClebMfsmtrack0::VecVTrigger

/**
	* CtrWtedClebMfsmtrack0
	*/
class CtrWtedClebMfsmtrack0 : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedClebMfsmtrack0Command)
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
		* VecVSource (full: VecVWtedClebMfsmtrack0Source)
		*/
	class VecVSource {

	public:
		static constexpr uint8_t HOSTIFOP = 0x01;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static std::string getTitle(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVState (full: VecVWtedClebMfsmtrack0State)
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
		* VecVTrigger (full: VecVWtedClebMfsmtrack0Trigger)
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
	CtrWtedClebMfsmtrack0(UntWted* unt);
	~CtrWtedClebMfsmtrack0();

public:
	static const uint8_t tixVController = 0x02;

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
	void getInfo(uint8_t& tixVState, unsigned char*& coverage, size_t& coveragelen);

	static Dbecore::Cmd* getNewCmdSelect();
	void select(const uint8_t tixVSource, const uint8_t staTixVTrigger, const uint8_t stoTixVTrigger);

	static Dbecore::Cmd* getNewCmdSet();
	void set(const bool rng, const uint32_t TCapt);

};

#endif
