/**
	* \file UntWtedCleb_vecs.h
	* Lattice CrossLink-NX Evaluation Board unit vectors (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef UNTWTEDCLEB_VECS_H
#define UNTWTEDCLEB_VECS_H

#include <sbecore/Xmlio.h>

/**
	* VecVWtedClebBuffer
	*/
namespace VecVWtedClebBuffer {
	constexpr uint8_t CMDRETTOHOSTIF = 0x00;
	constexpr uint8_t HOSTIFTOCMDINV = 0x01;
	constexpr uint8_t CNTBUFMFSMTRACK0TOHOSTIF = 0x02;
	constexpr uint8_t CNTBUFMFSMTRACK1TOHOSTIF = 0x03;
	constexpr uint8_t FSTOCCBUFMFSMTRACK0TOHOSTIF = 0x04;
	constexpr uint8_t FSTOCCBUFMFSMTRACK1TOHOSTIF = 0x05;
	constexpr uint8_t SEQBUFMFSMTRACK0TOHOSTIF = 0x06;
	constexpr uint8_t SEQBUFMFSMTRACK1TOHOSTIF = 0x07;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecVWtedClebController
	*/
namespace VecVWtedClebController {
	constexpr uint8_t HOSTIF = 0x00;
	constexpr uint8_t IDENT = 0x01;
	constexpr uint8_t MFSMTRACK0 = 0x02;
	constexpr uint8_t MFSMTRACK1 = 0x03;
	constexpr uint8_t MGPTRACK = 0x04;
	constexpr uint8_t RGBLED0 = 0x05;
	constexpr uint8_t STATE = 0x06;
	constexpr uint8_t TKCLKSRC = 0x07;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecVWtedClebState
	*/
namespace VecVWtedClebState {
	constexpr uint8_t NC = 0x00;
	constexpr uint8_t READY = 0x01;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	std::string getTitle(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

#endif
