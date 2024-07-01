/**
	* \file Wted.h
	* Wted global functionality and unit/controller exchange (declarations)
	* \copyright (C) 2016-2023 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef WTED_H
#define WTED_H

#include <list>
#include <string>

#include <dbecore/Bufxf.h>
#include <dbecore/Crc.h>

/**
	* UntWted
	*/
class UntWted {

public:
	UntWted();
	virtual ~UntWted();

public:
	void lockAccess(const std::string& who);
	void unlockAccess(const std::string& who);

	void reset();

	bool runBufxf(Dbecore::Bufxf* bufxf);
	bool runBufxfFromBuf(Dbecore::Bufxf* bufxf);
	bool runBufxfToBuf(Dbecore::Bufxf* bufxf);
	size_t pollBufxf(Dbecore::Bufxf* bufxf);

	bool runCmd(Dbecore::Cmd* cmd);

	timespec calcTimeout(const size_t length);

	void setBuffer(const uint8_t tixVBuffer);
	void setController(const uint8_t tixVController);
	void setCommand(const uint8_t tixVCommand);
	void setCmdop(const uint8_t tixVCmdop);
	void setBufxfop(const uint8_t tixVBufxfop);
	void setLength(const size_t length);
	void setCrc(const uint16_t crc, unsigned char* ptr = NULL);

	uint8_t getCmdController();
	uint8_t getCmdCommand();
	size_t getCmdLength();

	size_t getBufxfLength();

public:
	virtual bool rx(unsigned char* buf, const size_t reqlen);
	virtual bool tx(unsigned char* buf, const size_t reqlen);

	virtual void flush();

	virtual uint8_t getTixVControllerBySref(const std::string& sref);
	virtual std::string getSrefByTixVController(const uint8_t tixVController);
	virtual void fillFeedFController(Sbecore::Feed& feed);

	virtual uint8_t getTixVBufferBySref(const std::string& sref);
	virtual std::string getSrefByTixVBuffer(const uint8_t tixVBuffer);
	virtual void fillFeedFBuffer(Sbecore::Feed& feed);

	virtual uint8_t getTixVCommandBySref(const uint8_t tixVController, const std::string& sref);
	virtual std::string getSrefByTixVCommand(const uint8_t tixVController, const uint8_t tixVCommand);
	virtual void fillFeedFCommand(const uint8_t tixVController, Sbecore::Feed& feed);

	virtual Dbecore::Bufxf* getNewBufxf(const uint8_t tixVBuffer, const size_t reqlen, unsigned char* buf);
	virtual Dbecore::Cmd* getNewCmd(const uint8_t tixVController, const uint8_t tixVCommand);

	void parseBufxf(std::string s, Dbecore::Bufxf*& bufxf);

	std::string getCmdTemplate(const uint8_t tixVController, const uint8_t tixVCommand, const bool invretNotInv = false);

	void parseCmd(std::string s, Dbecore::Cmd*& cmd);
	Sbecore::uint getCmdix(const std::string& cmdsref);
	std::string getCmdsref(const Sbecore::uint cmdix);

	void clearHist();
	void appendToHist(const std::string& s);
	void appendToLastInHist(const std::string& s);
	void copyHist(std::vector<std::string>& vec, const bool append = false);

public:
	bool initdone;

	bool txburst;

	bool rxtxdump;
	bool histNotDump;
	unsigned int histlimit;

	unsigned int NRetry;

	unsigned int wordlen;

	unsigned int timeoutDev; // in µs

	unsigned int timeoutRx; // in µs
	unsigned int timeoutRxWord; // in µs

	unsigned char* rxbuf;
	unsigned char* txbuf;
	unsigned char* parbuf;

	Sbecore::Mutex mAccess;

	Sbecore::Rwmutex rwmHist;
	std::list<std::string> hist;
};

/**
	* CtrWted
	*/
class CtrWted {

public:
	CtrWted(UntWted* unt);
	virtual ~CtrWted();

public:
	UntWted* unt;
};

#endif
