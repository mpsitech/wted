/**
	* \file UntWtedZudk_vecs.h
	* Avnet Zynq UltraScale+ MPSoC development kit unit vectors (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#ifndef UNTWTEDZUDK_VECS_H
#define UNTWTEDZUDK_VECS_H

#include <sbecore/Xmlio.h>

/**
	* VecVWtedZudkBuffer
	*/
namespace VecVWtedZudkBuffer {
	constexpr uint8_t CMDRETTOHOSTIF = 0x00;
	constexpr uint8_t HOSTIFTOCMDINV = 0x01;
	constexpr uint8_t CNTBUFMFSMTRACK0TOHOSTIF = 0x02;
	constexpr uint8_t CNTBUFMFSMTRACK1TOHOSTIF = 0x03;
	constexpr uint8_t FSTOCCBUFMFSMTRACK0TOHOSTIF = 0x04;
	constexpr uint8_t FSTOCCBUFMFSMTRACK1TOHOSTIF = 0x05;
	constexpr uint8_t GETBUFCLIENTTOHOSTIF = 0x06;
	constexpr uint8_t SEQBUFMFSMTRACK0TOHOSTIF = 0x07;
	constexpr uint8_t SEQBUFMFSMTRACK1TOHOSTIF = 0x08;
	constexpr uint8_t SETBUFHOSTIFTOCLIENT = 0x09;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecVWtedZudkController
	*/
namespace VecVWtedZudkController {
	constexpr uint8_t HOSTIF = 0x00;
	constexpr uint8_t IDENT = 0x01;
	constexpr uint8_t CLIENT = 0x02;
	constexpr uint8_t DDRIF = 0x03;
	constexpr uint8_t MFSMTRACK0 = 0x04;
	constexpr uint8_t MFSMTRACK1 = 0x05;
	constexpr uint8_t MGPTRACK = 0x06;
	constexpr uint8_t MEMGPTRACK = 0x07;
	constexpr uint8_t RGBLED0 = 0x08;
	constexpr uint8_t STATE = 0x09;
	constexpr uint8_t TKCLKSRC = 0x0A;
	constexpr uint8_t TRAFGEN = 0x0B;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecVWtedZudkState
	*/
namespace VecVWtedZudkState {
	constexpr uint8_t NC = 0x00;
	constexpr uint8_t READY = 0x01;
	constexpr uint8_t ACTIVE = 0x02;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	std::string getTitle(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecVWtedZudkClientGetbufB
	*/
namespace VecVWtedZudkClientGetbufB {
	constexpr uint8_t INIT = 0x00;
	constexpr uint8_t IDLE = 0x10;
	constexpr uint8_t TRYLOCK = 0x20;
	constexpr uint8_t XFERA = 0x30;
	constexpr uint8_t XFERB = 0x31;
	constexpr uint8_t DONE = 0x40;
	constexpr uint8_t UNLOCK = 0x50;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecVWtedZudkClientSetbufB
	*/
namespace VecVWtedZudkClientSetbufB {
	constexpr uint8_t INIT = 0x00;
	constexpr uint8_t IDLE = 0x10;
	constexpr uint8_t TRYLOCK = 0x20;
	constexpr uint8_t WRITE = 0x30;
	constexpr uint8_t DONE = 0x40;
	constexpr uint8_t UNLOCK = 0x50;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

#endif
