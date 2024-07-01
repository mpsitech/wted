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
	else if (s == "cntbufmfsmtrack0tohostif") return CNTBUFMFSMTRACK0TOHOSTIF;
	else if (s == "cntbufmfsmtrack1tohostif") return CNTBUFMFSMTRACK1TOHOSTIF;
	else if (s == "fstoccbufmfsmtrack0tohostif") return FSTOCCBUFMFSMTRACK0TOHOSTIF;
	else if (s == "fstoccbufmfsmtrack1tohostif") return FSTOCCBUFMFSMTRACK1TOHOSTIF;
	else if (s == "seqbufmfsmtrack0tohostif") return SEQBUFMFSMTRACK0TOHOSTIF;
	else if (s == "seqbufmfsmtrack1tohostif") return SEQBUFMFSMTRACK1TOHOSTIF;

	return(0xFF);
};

string VecVWtedClebBuffer::getSref(
			const uint8_t tix
		) {
	if (tix == CMDRETTOHOSTIF) return("cmdretToHostif");
	else if (tix == HOSTIFTOCMDINV) return("hostifToCmdinv");
	else if (tix == CNTBUFMFSMTRACK0TOHOSTIF) return("cntbufMfsmtrack0ToHostif");
	else if (tix == CNTBUFMFSMTRACK1TOHOSTIF) return("cntbufMfsmtrack1ToHostif");
	else if (tix == FSTOCCBUFMFSMTRACK0TOHOSTIF) return("fstoccbufMfsmtrack0ToHostif");
	else if (tix == FSTOCCBUFMFSMTRACK1TOHOSTIF) return("fstoccbufMfsmtrack1ToHostif");
	else if (tix == SEQBUFMFSMTRACK0TOHOSTIF) return("seqbufMfsmtrack0ToHostif");
	else if (tix == SEQBUFMFSMTRACK1TOHOSTIF) return("seqbufMfsmtrack1ToHostif");

	return("");
};

void VecVWtedClebBuffer::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {CMDRETTOHOSTIF,HOSTIFTOCMDINV,CNTBUFMFSMTRACK0TOHOSTIF,CNTBUFMFSMTRACK1TOHOSTIF,FSTOCCBUFMFSMTRACK0TOHOSTIF,FSTOCCBUFMFSMTRACK1TOHOSTIF,SEQBUFMFSMTRACK0TOHOSTIF,SEQBUFMFSMTRACK1TOHOSTIF};

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
