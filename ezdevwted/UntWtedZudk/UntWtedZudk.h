/**
	* \file UntWtedZudk.h
	* Avnet Zynq UltraScale+ MPSoC development kit unit (declarations)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef UNTWTEDZUDK_H
#define UNTWTEDZUDK_H

#include "Wted.h"

#include "UntWtedZudk_vecs.h"

#include "CtrWtedZudkClient.h"
#include "CtrWtedZudkDdrif.h"
#include "CtrWtedZudkHostif.h"
#include "CtrWtedZudkIdent.h"
#include "CtrWtedZudkMemgptrack.h"
#include "CtrWtedZudkMfsmtrack0.h"
#include "CtrWtedZudkMfsmtrack1.h"
#include "CtrWtedZudkMgptrack.h"
#include "CtrWtedZudkRgbled0.h"
#include "CtrWtedZudkState.h"
#include "CtrWtedZudkTkclksrc.h"
#include "CtrWtedZudkTrafgen.h"

// IP include.cust --- INSERT

/**
	* UntWtedZudk
	*/
class UntWtedZudk : public UntWted {

public:
	static constexpr size_t sizeRxbuf = 1024;
	static constexpr size_t sizeTxbuf = 1024;
	static constexpr size_t sizeParbuf = 1024;

public:
	UntWtedZudk();
	~UntWtedZudk();

public:
	// IP vars.cust --- IBEGIN
	std::string path;
	int fd;
	// IP vars.cust --- IEND

public:
	CtrWtedZudkClient* client;
	CtrWtedZudkDdrif* ddrif;
	CtrWtedZudkHostif* hostif;
	CtrWtedZudkIdent* ident;
	CtrWtedZudkMemgptrack* memgptrack;
	CtrWtedZudkMfsmtrack0* mfsmtrack0;
	CtrWtedZudkMfsmtrack1* mfsmtrack1;
	CtrWtedZudkMgptrack* mgptrack;
	CtrWtedZudkRgbled0* rgbled0;
	CtrWtedZudkState* state;
	CtrWtedZudkTkclksrc* tkclksrc;
	CtrWtedZudkTrafgen* trafgen;

public:
	void init(const std::string& _path); // IP init --- RLINE
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

	Dbecore::Bufxf* getNewBufxfGetbufFromClient(const size_t reqlen, unsigned char* buf);
	void readGetbufFromClient(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfSeqbufFromMfsmtrack0(const size_t reqlen, unsigned char* buf);
	void readSeqbufFromMfsmtrack0(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfSeqbufFromMfsmtrack1(const size_t reqlen, unsigned char* buf);
	void readSeqbufFromMfsmtrack1(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfSetbufToClient(const size_t reqlen, unsigned char* buf);
	void writeSetbufToClient(const unsigned char* data, const size_t datalen, const bool copy);

};

#endif
