/**
	* \file CtrWtedTidkMemwrtrack.h
	* memwrtrack controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 24 Jul 2024
	*/
// IP header --- ABOVE

#ifndef CTRWTEDTIDKMEMWRTRACK_H
#define CTRWTEDTIDKMEMWRTRACK_H

#include "Wted.h"

#define CmdWtedTidkMemwrtrackGetInfo CtrWtedTidkMemwrtrack::CmdGetInfo

#define VecVWtedTidkMemwrtrackCapture CtrWtedTidkMemwrtrack::VecVCapture
#define VecVWtedTidkMemwrtrackCommand CtrWtedTidkMemwrtrack::VecVCommand
#define VecVWtedTidkMemwrtrackState CtrWtedTidkMemwrtrack::VecVState
#define VecVWtedTidkMemwrtrackTrigger CtrWtedTidkMemwrtrack::VecVTrigger

/**
	* CtrWtedTidkMemwrtrack
	*/
class CtrWtedTidkMemwrtrack : public CtrWted {

public:
	/**
		* VecVCapture (full: VecVWtedTidkMemwrtrackCapture)
		*/
	class VecVCapture {

	public:
		static constexpr uint8_t REQCLIENTTODDRIFWR = 0x00;
		static constexpr uint8_t ACKCLIENTTODDRIFWR = 0x01;
		static constexpr uint8_t REQTRAFGENTODDRIFWR = 0x02;
		static constexpr uint8_t ACKTRAFGENTODDRIFWR = 0x03;
		static constexpr uint8_t DDRAXIAWADDRSIG0 = 0x04;
		static constexpr uint8_t DDRAXIAWADDRSIG1 = 0x05;
		static constexpr uint8_t DDRAXIAWREADY = 0x06;
		static constexpr uint8_t DDRAXIAWVALIDSIG = 0x07;
		static constexpr uint8_t DDRAXIWREADY = 0x08;
		static constexpr uint8_t DDRAXIWDATASIG0 = 0x09;
		static constexpr uint8_t DDRAXIWDATASIG1 = 0x0A;
		static constexpr uint8_t DDRAXIWLASTSIG = 0x0B;
		static constexpr uint8_t DDRAXIBREADYSIG = 0x0C;
		static constexpr uint8_t DDRAXIBVALID = 0x0D;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static std::string getTitle(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVCommand (full: VecVWtedTidkMemwrtrackCommand)
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
		* VecVState (full: VecVWtedTidkMemwrtrackState)
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
		* VecVTrigger (full: VecVWtedTidkMemwrtrackTrigger)
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
	CtrWtedTidkMemwrtrack(UntWted* unt);
	~CtrWtedTidkMemwrtrack();

public:
	static const uint8_t tixVController = 0x08;

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
