/**
	* \file UntWtedTidk.h
	* Efinix Titanium Ti180 development kit unit (declarations)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef UNTWTEDTIDK_H
#define UNTWTEDTIDK_H

#include "Wted.h"

#include "UntWtedTidk_vecs.h"

#include "CtrWtedTidkClient.h"
#include "CtrWtedTidkDdrif.h"
#include "CtrWtedTidkHostif.h"
#include "CtrWtedTidkIdent.h"
#include "CtrWtedTidkMemrdtrack.h"
#include "CtrWtedTidkMemwrtrack.h"
#include "CtrWtedTidkMfsmtrack0.h"
#include "CtrWtedTidkMfsmtrack1.h"
#include "CtrWtedTidkMgptrack.h"
#include "CtrWtedTidkRgbled0.h"
#include "CtrWtedTidkState.h"
#include "CtrWtedTidkTkclksrc.h"
#include "CtrWtedTidkTrafgen.h"

// IP include.cust --- INSERT

/**
	* UntWtedTidk
	*/
class UntWtedTidk : public UntWted {

public:
	static constexpr size_t sizeRxbuf = 1024;
	static constexpr size_t sizeTxbuf = 1024;
	static constexpr size_t sizeParbuf = 1024;

public:
	UntWtedTidk();
	~UntWtedTidk();

public:
	// IP vars.cust --- IBEGIN
	std::string path;
	int fd;
	// IP vars.cust --- IEND

public:
	CtrWtedTidkClient* client;
	CtrWtedTidkDdrif* ddrif;
	CtrWtedTidkHostif* hostif;
	CtrWtedTidkIdent* ident;
	CtrWtedTidkMemrdtrack* memrdtrack;
	CtrWtedTidkMemwrtrack* memwrtrack;
	CtrWtedTidkMfsmtrack0* mfsmtrack0;
	CtrWtedTidkMfsmtrack1* mfsmtrack1;
	CtrWtedTidkMgptrack* mgptrack;
	CtrWtedTidkRgbled0* rgbled0;
	CtrWtedTidkState* state;
	CtrWtedTidkTkclksrc* tkclksrc;
	CtrWtedTidkTrafgen* trafgen;

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

	Dbecore::Bufxf* getNewBufxfCntbufFromMfsmtrack1(const size_t reqlen, unsigned char* buf);
	void readCntbufFromMfsmtrack1(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfCntbufFromMfsmtrack0(const size_t reqlen, unsigned char* buf);
	void readCntbufFromMfsmtrack0(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfFstoccbufFromMfsmtrack1(const size_t reqlen, unsigned char* buf);
	void readFstoccbufFromMfsmtrack1(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfFstoccbufFromMfsmtrack0(const size_t reqlen, unsigned char* buf);
	void readFstoccbufFromMfsmtrack0(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfGetbufFromClient(const size_t reqlen, unsigned char* buf);
	void readGetbufFromClient(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfSeqbufFromMfsmtrack1(const size_t reqlen, unsigned char* buf);
	void readSeqbufFromMfsmtrack1(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfSeqbufFromMemwrtrack(const size_t reqlen, unsigned char* buf);
	void readSeqbufFromMemwrtrack(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfSeqbufFromMemrdtrack(const size_t reqlen, unsigned char* buf);
	void readSeqbufFromMemrdtrack(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfSeqbufFromMfsmtrack0(const size_t reqlen, unsigned char* buf);
	void readSeqbufFromMfsmtrack0(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfSeqbufFromMgptrack(const size_t reqlen, unsigned char* buf);
	void readSeqbufFromMgptrack(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfSetbufToClient(const size_t reqlen, unsigned char* buf);
	void writeSetbufToClient(const unsigned char* data, const size_t datalen, const bool copy);

};

#endif
