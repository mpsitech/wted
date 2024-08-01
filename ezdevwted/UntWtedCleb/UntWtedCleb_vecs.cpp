/**
	* \file UntWtedCleb_vecs.cpp
	* Lattice CrossLink-NX Evaluation Board unit vectors (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "UntWtedCleb_vecs.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;

/******************************************************************************
 namespace VecVWtedClebBuffer
 ******************************************************************************/

uint8_t VecVWtedClebBuffer::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "cmdrettohostif") return CMDRETTOHOSTIF;
	else if (s == "hostiftocmdinv") return HOSTIFTOCMDINV;
	else if (s == "cntbufmfsmtrack1tohostif") return CNTBUFMFSMTRACK1TOHOSTIF;
	else if (s == "cntbufmfsmtrack0tohostif") return CNTBUFMFSMTRACK0TOHOSTIF;
	else if (s == "fstoccbufmfsmtrack1tohostif") return FSTOCCBUFMFSMTRACK1TOHOSTIF;
	else if (s == "fstoccbufmfsmtrack0tohostif") return FSTOCCBUFMFSMTRACK0TOHOSTIF;
	else if (s == "seqbufmfsmtrack1tohostif") return SEQBUFMFSMTRACK1TOHOSTIF;
	else if (s == "seqbufmfsmtrack0tohostif") return SEQBUFMFSMTRACK0TOHOSTIF;
	else if (s == "seqbufmgptracktohostif") return SEQBUFMGPTRACKTOHOSTIF;

	return(0xFF);
};

string VecVWtedClebBuffer::getSref(
			const uint8_t tix
		) {
	if (tix == CMDRETTOHOSTIF) return("cmdretToHostif");
	else if (tix == HOSTIFTOCMDINV) return("hostifToCmdinv");
	else if (tix == CNTBUFMFSMTRACK1TOHOSTIF) return("cntbufMfsmtrack1ToHostif");
	else if (tix == CNTBUFMFSMTRACK0TOHOSTIF) return("cntbufMfsmtrack0ToHostif");
	else if (tix == FSTOCCBUFMFSMTRACK1TOHOSTIF) return("fstoccbufMfsmtrack1ToHostif");
	else if (tix == FSTOCCBUFMFSMTRACK0TOHOSTIF) return("fstoccbufMfsmtrack0ToHostif");
	else if (tix == SEQBUFMFSMTRACK1TOHOSTIF) return("seqbufMfsmtrack1ToHostif");
	else if (tix == SEQBUFMFSMTRACK0TOHOSTIF) return("seqbufMfsmtrack0ToHostif");
	else if (tix == SEQBUFMGPTRACKTOHOSTIF) return("seqbufMgptrackToHostif");

	return("");
};

void VecVWtedClebBuffer::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {CMDRETTOHOSTIF,HOSTIFTOCMDINV,CNTBUFMFSMTRACK1TOHOSTIF,CNTBUFMFSMTRACK0TOHOSTIF,FSTOCCBUFMFSMTRACK1TOHOSTIF,FSTOCCBUFMFSMTRACK0TOHOSTIF,SEQBUFMFSMTRACK1TOHOSTIF,SEQBUFMFSMTRACK0TOHOSTIF,SEQBUFMGPTRACKTOHOSTIF};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 namespace VecVWtedClebController
 ******************************************************************************/

uint8_t VecVWtedClebController::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "hostif") return HOSTIF;
	else if (s == "ident") return IDENT;
	else if (s == "mfsmtrack0") return MFSMTRACK0;
	else if (s == "mfsmtrack1") return MFSMTRACK1;
	else if (s == "mgptrack") return MGPTRACK;
	else if (s == "rgbled0") return RGBLED0;
	else if (s == "state") return STATE;
	else if (s == "tkclksrc") return TKCLKSRC;

	return(0xFF);
};

string VecVWtedClebController::getSref(
			const uint8_t tix
		) {
	if (tix == HOSTIF) return("hostif");
	else if (tix == IDENT) return("ident");
	else if (tix == MFSMTRACK0) return("mfsmtrack0");
	else if (tix == MFSMTRACK1) return("mfsmtrack1");
	else if (tix == MGPTRACK) return("mgptrack");
	else if (tix == RGBLED0) return("rgbled0");
	else if (tix == STATE) return("state");
	else if (tix == TKCLKSRC) return("tkclksrc");

	return("");
};

void VecVWtedClebController::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {HOSTIF,IDENT,MFSMTRACK0,MFSMTRACK1,MGPTRACK,RGBLED0,STATE,TKCLKSRC};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 namespace VecVWtedClebState
 ******************************************************************************/

uint8_t VecVWtedClebState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "nc") return NC;
	else if (s == "ready") return READY;

	return(0xFF);
};

string VecVWtedClebState::getSref(
			const uint8_t tix
		) {
	if (tix == NC) return("nc");
	else if (tix == READY) return("ready");

	return("");
};

string VecVWtedClebState::getTitle(
			const uint8_t tix
		) {
	if (tix == NC) return("offline");
	if (tix == READY) return("ready");

	return(getSref(tix));
};

void VecVWtedClebState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {NC,READY};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 namespace VecVWtedClebHostifOp
 ******************************************************************************/

uint8_t VecVWtedClebHostifOp::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "init") return INIT;
	else if (s == "idle") return IDLE;
	else if (s == "rxopa") return RXOPA;
	else if (s == "rxopb") return RXOPB;
	else if (s == "rxopc") return RXOPC;
	else if (s == "rxopd") return RXOPD;
	else if (s == "rxope") return RXOPE;
	else if (s == "txpolla") return TXPOLLA;
	else if (s == "txpollb") return TXPOLLB;
	else if (s == "txpollc") return TXPOLLC;
	else if (s == "txpolld") return TXPOLLD;
	else if (s == "txpolle") return TXPOLLE;
	else if (s == "txpollf") return TXPOLLF;
	else if (s == "txpollg") return TXPOLLG;
	else if (s == "txa") return TXA;
	else if (s == "txb") return TXB;
	else if (s == "txc") return TXC;
	else if (s == "txd") return TXD;
	else if (s == "txe") return TXE;
	else if (s == "txf") return TXF;
	else if (s == "txg") return TXG;
	else if (s == "txbufa") return TXBUFA;
	else if (s == "txbufb") return TXBUFB;
	else if (s == "txbufc") return TXBUFC;
	else if (s == "txbufd") return TXBUFD;
	else if (s == "txbufe") return TXBUFE;
	else if (s == "txbuff") return TXBUFF;
	else if (s == "txbufg") return TXBUFG;
	else if (s == "txbufh") return TXBUFH;
	else if (s == "rxa") return RXA;
	else if (s == "rxb") return RXB;
	else if (s == "rxc") return RXC;
	else if (s == "rxd") return RXD;
	else if (s == "rxbufa") return RXBUFA;
	else if (s == "rxbufb") return RXBUFB;
	else if (s == "rxbufc") return RXBUFC;
	else if (s == "rxbufd") return RXBUFD;
	else if (s == "rxbufe") return RXBUFE;
	else if (s == "rxbuff") return RXBUFF;
	else if (s == "inv") return INV;

	return(0xFF);
};

string VecVWtedClebHostifOp::getSref(
			const uint8_t tix
		) {
	if (tix == INIT) return("init");
	else if (tix == IDLE) return("idle");
	else if (tix == RXOPA) return("rxopA");
	else if (tix == RXOPB) return("rxopB");
	else if (tix == RXOPC) return("rxopC");
	else if (tix == RXOPD) return("rxopD");
	else if (tix == RXOPE) return("rxopE");
	else if (tix == TXPOLLA) return("txpollA");
	else if (tix == TXPOLLB) return("txpollB");
	else if (tix == TXPOLLC) return("txpollC");
	else if (tix == TXPOLLD) return("txpollD");
	else if (tix == TXPOLLE) return("txpollE");
	else if (tix == TXPOLLF) return("txpollF");
	else if (tix == TXPOLLG) return("txpollG");
	else if (tix == TXA) return("txA");
	else if (tix == TXB) return("txB");
	else if (tix == TXC) return("txC");
	else if (tix == TXD) return("txD");
	else if (tix == TXE) return("txE");
	else if (tix == TXF) return("txF");
	else if (tix == TXG) return("txG");
	else if (tix == TXBUFA) return("txbufA");
	else if (tix == TXBUFB) return("txbufB");
	else if (tix == TXBUFC) return("txbufC");
	else if (tix == TXBUFD) return("txbufD");
	else if (tix == TXBUFE) return("txbufE");
	else if (tix == TXBUFF) return("txbufF");
	else if (tix == TXBUFG) return("txbufG");
	else if (tix == TXBUFH) return("txbufH");
	else if (tix == RXA) return("rxA");
	else if (tix == RXB) return("rxB");
	else if (tix == RXC) return("rxC");
	else if (tix == RXD) return("rxD");
	else if (tix == RXBUFA) return("rxbufA");
	else if (tix == RXBUFB) return("rxbufB");
	else if (tix == RXBUFC) return("rxbufC");
	else if (tix == RXBUFD) return("rxbufD");
	else if (tix == RXBUFE) return("rxbufE");
	else if (tix == RXBUFF) return("rxbufF");
	else if (tix == INV) return("inv");

	return("");
};

void VecVWtedClebHostifOp::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {INIT,IDLE,RXOPA,RXOPB,RXOPC,RXOPD,RXOPE,TXPOLLA,TXPOLLB,TXPOLLC,TXPOLLD,TXPOLLE,TXPOLLF,TXPOLLG,TXA,TXB,TXC,TXD,TXE,TXF,TXG,TXBUFA,TXBUFB,TXBUFC,TXBUFD,TXBUFE,TXBUFF,TXBUFG,TXBUFH,RXA,RXB,RXC,RXD,RXBUFA,RXBUFB,RXBUFC,RXBUFD,RXBUFE,RXBUFF,INV};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 namespace VecVWtedClebTkclksrcOp
 ******************************************************************************/

uint8_t VecVWtedClebTkclksrcOp::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "init") return INIT;
	else if (s == "inv") return INV;
	else if (s == "run") return RUN;

	return(0xFF);
};

string VecVWtedClebTkclksrcOp::getSref(
			const uint8_t tix
		) {
	if (tix == INIT) return("init");
	else if (tix == INV) return("inv");
	else if (tix == RUN) return("run");

	return("");
};

void VecVWtedClebTkclksrcOp::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {INIT,INV,RUN};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};
