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
	constexpr uint8_t FSTOCCBUFMFSMTRACK1TOHOSTIF = 0x04;
	constexpr uint8_t FSTOCCBUFMFSMTRACK0TOHOSTIF = 0x05;
	constexpr uint8_t GETBUFCLIENTTOHOSTIF = 0x06;
	constexpr uint8_t SEQBUFMFSMTRACK0TOHOSTIF = 0x07;
	constexpr uint8_t SEQBUFMFSMTRACK1TOHOSTIF = 0x08;
	constexpr uint8_t SEQBUFMEMWRTRACKTOHOSTIF = 0x09;
	constexpr uint8_t SEQBUFMEMRDTRACKTOHOSTIF = 0x0A;
	constexpr uint8_t SEQBUFMGPTRACKTOHOSTIF = 0x0B;
	constexpr uint8_t SETBUFHOSTIFTOCLIENT = 0x0C;

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
	constexpr uint8_t MEMRDTRACK = 0x07;
	constexpr uint8_t MEMWRTRACK = 0x08;
	constexpr uint8_t RGBLED0 = 0x09;
	constexpr uint8_t STATE = 0x0A;
	constexpr uint8_t TKCLKSRC = 0x0B;
	constexpr uint8_t TRAFGEN = 0x0C;

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

/**
	* VecVWtedZudkHostifOp
	*/
namespace VecVWtedZudkHostifOp {
	constexpr uint8_t INIT = 0x00;
	constexpr uint8_t IDLE = 0x10;
	constexpr uint8_t RXOPA = 0x20;
	constexpr uint8_t RXOPB = 0x21;
	constexpr uint8_t RXOPC = 0x22;
	constexpr uint8_t RXOPD = 0x23;
	constexpr uint8_t RXOPE = 0x24;
	constexpr uint8_t TXPOLLA = 0x30;
	constexpr uint8_t TXPOLLB = 0x31;
	constexpr uint8_t TXPOLLC = 0x32;
	constexpr uint8_t TXPOLLD = 0x33;
	constexpr uint8_t TXPOLLE = 0x34;
	constexpr uint8_t TXPOLLF = 0x35;
	constexpr uint8_t TXPOLLG = 0x36;
	constexpr uint8_t TXA = 0x40;
	constexpr uint8_t TXB = 0x41;
	constexpr uint8_t TXC = 0x42;
	constexpr uint8_t TXD = 0x43;
	constexpr uint8_t TXE = 0x44;
	constexpr uint8_t TXF = 0x45;
	constexpr uint8_t TXG = 0x46;
	constexpr uint8_t TXBUFA = 0x50;
	constexpr uint8_t TXBUFB = 0x51;
	constexpr uint8_t TXBUFC = 0x52;
	constexpr uint8_t TXBUFD = 0x53;
	constexpr uint8_t TXBUFE = 0x54;
	constexpr uint8_t TXBUFF = 0x55;
	constexpr uint8_t TXBUFG = 0x56;
	constexpr uint8_t TXBUFH = 0x57;
	constexpr uint8_t RXA = 0x60;
	constexpr uint8_t RXB = 0x61;
	constexpr uint8_t RXC = 0x62;
	constexpr uint8_t RXD = 0x63;
	constexpr uint8_t RXBUFA = 0x70;
	constexpr uint8_t RXBUFB = 0x71;
	constexpr uint8_t RXBUFC = 0x72;
	constexpr uint8_t RXBUFD = 0x73;
	constexpr uint8_t RXBUFE = 0x74;
	constexpr uint8_t RXBUFF = 0x75;
	constexpr uint8_t INV = 0x80;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecVWtedZudkTkclksrcOp
	*/
namespace VecVWtedZudkTkclksrcOp {
	constexpr uint8_t INIT = 0x00;
	constexpr uint8_t INV = 0x10;
	constexpr uint8_t RUN = 0x20;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

#endif
