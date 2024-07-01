/**
	* \file CtrWtedTidkMfsmtrack0.h
	* mfsmtrack0 controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDTIDKMFSMTRACK0_H
#define CTRWTEDTIDKMFSMTRACK0_H

#include "Wted.h"

#define CmdWtedTidkMfsmtrack0GetInfo CtrWtedTidkMfsmtrack0::CmdGetInfo

#define VecVWtedTidkMfsmtrack0Command CtrWtedTidkMfsmtrack0::VecVCommand
#define VecVWtedTidkMfsmtrack0Source CtrWtedTidkMfsmtrack0::VecVSource
#define VecVWtedTidkMfsmtrack0State CtrWtedTidkMfsmtrack0::VecVState
#define VecVWtedTidkMfsmtrack0Trigger CtrWtedTidkMfsmtrack0::VecVTrigger

/**
	* CtrWtedTidkMfsmtrack0
	*/
class CtrWtedTidkMfsmtrack0 : public CtrWted {

public:
	/**
		* VecVCommand (full: VecVWtedTidkMfsmtrack0Command)
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
		* VecVSource (full: VecVWtedTidkMfsmtrack0Source)
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
		* VecVState (full: VecVWtedTidkMfsmtrack0State)
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
		* VecVTrigger (full: VecVWtedTidkMfsmtrack0Trigger)
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
	CtrWtedTidkMfsmtrack0(UntWted* unt);
	~CtrWtedTidkMfsmtrack0();

public:
	static const uint8_t tixVController = 0x04;

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
