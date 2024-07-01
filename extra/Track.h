/**
	* \file Track.h
	* Fsmtrack and Gptrack readout, analysis and output to .vcd (declarations)
	* \copyright (C) 2024 MPSI Technologies GmbH
	* \author Alexander Wirthmueller
	* \date created: 30 Jun 2024
	*/

#include <iostream>

#include "DevWted.h"

/**
	* Fsmtrack
	*/
class Fsmtrack {

public:
	uint8_t tixVSource;
	double fTrkclk; // in kHz

	std::string (*getSrefFst)(const uint8_t tix);
	std::vector<bool> cvr;

public:
	Track(const uint8_t tixVSource, const double fTrkclk);

public:
	virtual std::string getSrefModule();
	virtual std::string getSrefSource();

	std::string getSrefFst_showUnknown(const uint8_t tix, const bool tixFallback = false);
	static std::string getSrefFstDefault(const uint8_t tix);

	void analyzeCoverage(unsigned char* coverage); // 256
	void analyzeCntbuf(unsigned char* cntbuf); // 256 * 4
	void analyzeFstoccbuf(unsigned char* fstoccbuf); // 256 * 4
	void analyzeSeqbuf(const std::string& Prjshort, const std::string& Untshort, unsigned char* seqbuf, const size_t sizeSeqbuf);
};

/**
	* ClebMfsmtrack0
	*/
class ClebMfsmtrack0 : public Fsmtrack {

public:
	ClebMfsmtrack0(const uint8_t tixVSource, const double fTrkclk);

public:
	std::string getSrefModule();
	std::string getSrefSource();
};

/**
	* ClebMfsmtrack1
	*/
class ClebMfsmtrack1 : public Fsmtrack {

public:
	ClebMfsmtrack1(const uint8_t tixVSource, const double fTrkclk);

public:
	std::string getSrefModule();
	std::string getSrefSource();
};

/**
	* TidkMfsmtrack0
	*/
class TidkMfsmtrack0 : public Fsmtrack {

public:
	TidkMfsmtrack0(const uint8_t tixVSource, const double fTrkclk);

public:
	std::string getSrefModule();
	std::string getSrefSource();
};

/**
	* TidkMfsmtrack1
	*/
class TidkMfsmtrack1 : public Fsmtrack {

public:
	TidkMfsmtrack1(const uint8_t tixVSource, const double fTrkclk);

public:
	std::string getSrefModule();
	std::string getSrefSource();
};

/**
	* ZudkMfsmtrack0
	*/
class ZudkMfsmtrack0 : public Fsmtrack {

public:
	ZudkMfsmtrack0(const uint8_t tixVSource, const double fTrkclk);

public:
	std::string getSrefModule();
	std::string getSrefSource();
};

/**
	* ZudkMfsmtrack1
	*/
class ZudkMfsmtrack1 : public Fsmtrack {

public:
	ZudkMfsmtrack1(const uint8_t tixVSource, const double fTrkclk);

public:
	std::string getSrefModule();
	std::string getSrefSource();
};

/**
	* Gptrack
	*/
class Gptrack {

public:
	double fTrkclk; // in kHz

public:
	Gptrack(const double fTrkclk);

public:
	virtual std::string getSrefBit(const uint8_t bit);

	void analyzeSeqbuf(unsigned char* seqbuf, const size_t sizeSeqbuf);
};

/**
	* Ixsim
	*/
class Ixsim {

public:
	static std::string pathBase; // "/dev/dbeaxilite0";
	static std::string pathReplay; // "/dev/dbeaxilite1";

	static std::string pathShmem; // "/dev/dbeaxishmem0";

	static constexpr uint8_t ixMemInvalid = 0xFF;

	static constexpr unsigned int NChunk = 4;
	static constexpr unsigned int sizeChunk = 64; // in MB; those are 2x 32 MB sections in reality

	//static constexpr unsigned int NRepeat = 32; // for ixsim: same as V0
	//static constexpr unsigned int NSample = 1024; // for ixsim: same as R0

	static constexpr Sbecore::uint ixFrdpVFlavor = VecFrdpVFlavor::X10_6X8;//X14_48X1_1TX;//X14_96X1;//X14_16X3_LHS;

	unsigned int TX, RX;

	unsigned int R0, V0, A0, E0;
	unsigned int R, V, A, E;

	std::vector<TxRx> txRx0s, txRx1s; // by ramp sequence number modulo V0
	std::map<TxRx,AziEle> aziEles;

	UntWtedBase base;
	UntWtedReplay replay;

	double t0Base, t0Replay;

	int fdShmem;
	unsigned char* buf;

	std::vector<bool> icsMem;

	bool initdone;

public:
	Ixsim();
	~Ixsim();

public:
	bool initShmem(const std::string& path);

	bool getIxsim4DNot3D();

	// stripped down copies from JobFrdpAcqFpgacube
	// srcbase->shrdat.hw -> base
	// delete R0, ... copy from shrdat
	void configBaseX10_6x8();
	void configBaseX14_96x1();
	void configBaseX14_16x3_lhs();
	void configBaseX14_48x1_1tx();

	void setMapbuf(const bool mapbuf1Not0, unsigned char* mapbuf);
	void setCalbuf(const bool calbuf1Not0,  std::map<TxRx,std::complex<double> >& cals, unsigned char* calbuf); // come in from complex<double>, pick relevant TxRx pairs, normalize to highest
	void setWndbuf(const unsigned int lenIn, const unsigned int lenOut, unsigned char* wndbuf, const size_t ix0, const bool sfftNotLfft, const bool fillonlyNotXfer); // align with LenIn (zeroes are irrelevant)
	//

	void configReplayX10_6x8();
	void configReplayX14_96x1();
	void configReplayX14_16x3_lhs();
	void configReplayX14_48x1_1tx();

	void loadCalsFromFile(const std::string&  path, std::map<TxRx,std::complex<double> >& cals);

	void startReplay();
	void runMainLoop();
	void stopReplay();

	unsigned int dequeue(const unsigned int ixMemAvoid);
	void unlock(const unsigned int ixMem);

	double getNow();
	double tkstToT(const bool replayNotBase, const uint32_t tkst);

	void validate(const uint8_t ixMem);
	void validate2(const uint8_t ixMem);
	unsigned int invertOrder(unsigned int base, const unsigned int w);

	void scrubCache();
};
