/**
	* \file UntWtedCleb.h
	* Lattice CrossLink-NX Evaluation Board unit (declarations)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef UNTWTEDCLEB_H
#define UNTWTEDCLEB_H

#include "Wted.h"

#include "UntWtedCleb_vecs.h"

#include "CtrWtedClebHostif.h"
#include "CtrWtedClebIdent.h"
#include "CtrWtedClebMfsmtrack0.h"
#include "CtrWtedClebMfsmtrack1.h"
#include "CtrWtedClebMgptrack.h"
#include "CtrWtedClebRgbled0.h"
#include "CtrWtedClebState.h"
#include "CtrWtedClebTkclksrc.h"

// IP include.cust --- IBEGIN
#ifdef __linux__
	#include <fcntl.h>
	#include <errno.h>
	#include <stdio.h>
	#include <string.h>
	#include <termios.h>
	#include <unistd.h>

	#include <linux/serial_core.h>
	#include <sys/ioctl.h>
#endif
// IP include.cust --- IEND

/**
	* UntWtedCleb
	*/
class UntWtedCleb : public UntWted {

public:
	static constexpr size_t sizeRxbuf = 1024;
	static constexpr size_t sizeTxbuf = 1024;
	static constexpr size_t sizeParbuf = 1024;

public:
	UntWtedCleb();
	~UntWtedCleb();

public:
	// IP vars.cust --- IBEGIN
	std::string path;
	unsigned int bpsRx;
	unsigned int bpsTx;

	int fd;
	// IP vars.cust --- IEND

public:
	CtrWtedClebHostif* hostif;
	CtrWtedClebIdent* ident;
	CtrWtedClebMfsmtrack0* mfsmtrack0;
	CtrWtedClebMfsmtrack1* mfsmtrack1;
	CtrWtedClebMgptrack* mgptrack;
	CtrWtedClebRgbled0* rgbled0;
	CtrWtedClebState* state;
	CtrWtedClebTkclksrc* tkclksrc;

public:
	void init(const std::string& _path, const unsigned int _bpsRx, const unsigned int _bpsTx); // IP init --- RLINE
	void term();

public:
	bool rx(unsigned char* buf, const size_t reqlen);
	bool tx(unsigned char* buf, const size_t reqlen);

	void flush();

public:
	uint8_t getTixVControllerBySref(const std::string& sref);
	std::string getSrefByTixVController(const uint8_t tixVController);
	void fillFeedFController(Sbecore::Feed& feed);

	uint8_t getTixVBufferBySref(const std::string& sref);
	std::string getSrefByTixVBuffer(const uint8_t tixVBuffer);
	void fillFeedFBuffer(Sbecore::Feed& feed);

	uint8_t getTixVCommandBySref(const uint8_t tixVController, const std::string& sref);
	std::string getSrefByTixVCommand(const uint8_t tixVController, const uint8_t tixVCommand);
	void fillFeedFCommand(const uint8_t tixVController, Sbecore::Feed& feed);

	Dbecore::Bufxf* getNewBufxf(const uint8_t tixVBuffer, const size_t reqlen, unsigned char* buf);
	Dbecore::Cmd* getNewCmd(const uint8_t tixVController, const uint8_t tixVCommand);

	Dbecore::Bufxf* getNewBufxfCntbufFromMfsmtrack0(const size_t reqlen, unsigned char* buf);
	void readCntbufFromMfsmtrack0(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfCntbufFromMfsmtrack1(const size_t reqlen, unsigned char* buf);
	void readCntbufFromMfsmtrack1(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfFstoccbufFromMfsmtrack0(const size_t reqlen, unsigned char* buf);
	void readFstoccbufFromMfsmtrack0(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfFstoccbufFromMfsmtrack1(const size_t reqlen, unsigned char* buf);
	void readFstoccbufFromMfsmtrack1(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfSeqbufFromMfsmtrack0(const size_t reqlen, unsigned char* buf);
	void readSeqbufFromMfsmtrack0(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfSeqbufFromMfsmtrack1(const size_t reqlen, unsigned char* buf);
	void readSeqbufFromMfsmtrack1(const size_t reqlen, unsigned char*& data, size_t& datalen);

};

#endif
