/**
	* \file Track.cpp
	* Fsmtrack and Gptrack readout, analysis and output to .vcd (implementation)
	* \copyright (C) 2024 MPSI Technologies GmbH
	* \author Alexander Wirthmueller
	* \date created: 30 Jun 2024
	*/

#include "Track.h"

using namespace std;

using namespace Dbecore;
using namespace Sbecore;

/******************************************************************************
 class Fsmtrack
 ******************************************************************************/

Fsmtrack::Fsmtrack(
			const uint8_t tixVSource
			, const double fTrkclk
		) :
			tixVSource(tixVSource)
			, fTrkclk(fTrkclk)
		{
	getSrefFst = getSrefFstDefault;
	cvr.resize(256, false);
};

string Fsmtrack::getSrefFst_showUnknown(
			const uint8_t tix
			, const bool tixFallback
		) {
	string sref;

	sref = getSrefFst(tix);

	if (sref == "") {
		if (tixFallback) sref = "? (0x" + Dbe::binToHex(tix) + ")";
		else sref = "?";
	};

	return sref;
};

string Fsmtrack::getSrefFstDefault(
			const uint8_t tix
		) {
	return "?";
};

void Fsmtrack::analyzeCoverage(
			unsigned char* coverage
		) {
	cvr.clear();
	cvr.resize(256, false);

	if (!coverage) return;

	for (unsigned int j = 0; j < cvr.size(); j++) cvr[j] = (coverage[j/8] & (0x01 << (j%8)));

	cout << "state coverage comprises";
	for (unsigned int j = 0; j < cvr.size(); j++) if (cvr[j]) cout << " 0x" << Dbe::binToHex(j) << "/" << getSrefFst_showUnknown(j);
	cout << endl;
};

void Fsmtrack::analyzeCntbuf(
			unsigned char* cntbuf
		) {
	//map<uint32_t, string> cnts;
	map<uint32_t, uint8_t> cnts;

	uint64_t total = 0;
	uint32_t cnt;

	if (!cntbuf) return;

	cout << "state occurrence count and share:" << endl;

	for (unsigned int i = 0; i < 256; i++) {//if (cvr[i]) {
		cnt = 0;

		for (unsigned int j = 0; j < 4; j++) cnt = 256*cnt + cntbuf[4*i + (4-j-1)];

		if (cnt != 0) cnts[cnt] = i;

		total += cnt;
	};

	for (auto it = cnts.begin(); it != cnts.end(); it++) cout << ((int) it->second) << ": " << it->first << " (" << (((double) (it->first)) / ((double) total)) << ")" << endl;
};

void Fsmtrack::analyzeFstoccbuf(
			unsigned char* fstoccbuf
		) {
	map<double, string> fstoccs;
	uint32_t fstocc;

	if (!fstoccbuf) return;

	cout << "first state occurrences in ms:" << endl;

	for (unsigned int i = 0; i < 256; i++) if (cvr[i]) {
		fstocc = (fstoccbuf[4*i] << 24) + (fstoccbuf[4*i+1] << 16) + (fstoccbuf[4*i+2] << 8) + fstoccbuf[4*i+3];
		fstoccs[((double) fstocc) / fTrkclk] = getSrefFst_showUnknown(i);
	};

	for (auto it = fstoccs.begin(); it != fstoccs.end(); it++) cout << "[" << it->first << "] " << it->second << endl;
};

void Fsmtrack::analyzeSeqbuf(
			const string& Prjshort
			, const string& Untshort
			unsigned char* seqbuf
			, const size_t sizeSeqbuf
		) {
	string path;
	fstream vcdfile;

	time_t now;
	time(&now);

	unsigned int t = 0;
	unsigned char quad[4];

	uint8_t state_last = 0xFF;

	if (!seqbuf) return;

	path = "./" + getSrefModule() + ".vcd";
	vcdfile.open(path.c_str(), ios::out);

	vcdfile << "$version " << Prjshort << " tracker $end" << endl;
	vcdfile << "$date " << Ftm::stamp(now) << " $end" << endl;
	vcdfile << "$timescale " << lround(1e6/fTrkclk) << "ns $end" << endl;
	vcdfile << "$scope module " << Untshort << " $end" << endl;
	vcdfile << "\t\t$var wire 1 M trkclk $end" << endl;
	vcdfile << "\t\t$scope module " << getSrefModule() << " $end" << endl;
	vcdfile << "\t\t\t$var string 1 A0 " << getSrefSource() << " $end" << endl;
	vcdfile << "\t\t$upscope $end" << endl;
	vcdfile << "$upscope $end" << endl;
	vcdfile << "$enddefinitions $end" << endl;
	vcdfile << "$dumpvars" << endl;

	for (unsigned int i = 0; i < sizeSeqbuf/4; i++) {
		for (unsigned int j = 0; j < 4; j++) quad[j] = seqbuf[4*i + j];

		if (quad[3] == 0xFF) {
			if (quad[2] != state_last) {
				vcdfile << "#" << t << endl;
				vcdfile << "s" << getSrefFst_showUnknown(quad[2]) << " A0" << endl;

				state_last = quad[2];
			};

			t += 4 * ((quad[1] << 8) + quad[0]);

		} else {
			for (unsigned int j = 0; j < 4; j++) {
				if (quad[j] != state_last) {
					vcdfile << "#" << t << endl;
					vcdfile << "s" << getSrefFst_showUnknown(quad[j]) << " A0" << endl;

					state_last = quad[j];
				};

				t++;
			};
		};
	};

	vcdfile.close();
};

string Fsmtrack::getSrefModule() {
	return("");
};

string Fsmtrack::getSrefSource() {
	return("");
};

/******************************************************************************
 class ClebMfsmtrack0
 ******************************************************************************/

ClebMfsmtrack0::ClebMfsmtrack0(
			const uint8_t tixVSource
			, const double fTrkclk
		) : Track(tixVSource, fTrkclk) {
	if (tixVSource == VecVWtedClebMfsmtrack0Source::HOSTIFOP) getSrefFst = VecVWtedClebHostifOp::getSref;
};

string ClebMfsmtrack0::getSrefModule() {
	return("mfsmtrack0");
};

string ClebMfsmtrack0::getSrefSource() {
	return(VecVWtedClebMfsmtrack0Source::getSref(tixVSource));
};

/******************************************************************************
 class ClebMfsmtrack1
 ******************************************************************************/

ClebMfsmtrack1::ClebMfsmtrack1(
			const uint8_t tixVSource
			, const double fTrkclk
		) : Track(tixVSource, fTrkclk) {
	if (tixVSource == VecVWtedClebMfsmtrack1Source::TKCLKSRCOP) getSrefFst = VecVWtedClebTkclksrcOp::getSref;
};

string ClebMfsmtrack1::getSrefModule() {
	return("mfsmtrack1");
};

string ClebMfsmtrack1::getSrefSource() {
	return(VecVWtedClebMfsmtrack1Source::getSref(tixVSource));
};

/******************************************************************************
 class TidkMfsmtrack0
 ******************************************************************************/

TidkMfsmtrack0::TidkMfsmtrack0(
			const uint8_t tixVSource
			, const double fTrkclk
		) : Track(tixVSource, fTrkclk) {
	if (tixVSource == VecVWtedTidkMfsmtrack0Source::HOSTIFOP) getSrefFst = VecVWtedTidkHostifOp::getSref;
};

string TidkMfsmtrack0::getSrefModule() {
	return("mfsmtrack0");
};

string TidkMfsmtrack0::getSrefSource() {
	return(VecVWtedTidkMfsmtrack0Source::getSref(tixVSource));
};

/******************************************************************************
 class TidkMfsmtrack1
 ******************************************************************************/

TidkMfsmtrack1::TidkMfsmtrack1(
			const uint8_t tixVSource
			, const double fTrkclk
		) : Track(tixVSource, fTrkclk) {
	if (tixVSource == VecVWtedTidkMfsmtrack1Source::CLIENTGETBUFB) getSrefFst = VecVWtedTidkClientGetbufB::getSref;
	else if (tixVSource == VecVWtedTidkMfsmtrack1Source::CLIENTSETBUFB) getSrefFst = VecVWtedTidkClientSetbufB::getSref;
	else if (tixVSource == VecVWtedTidkMfsmtrack1Source::TKCLKSRCOP) getSrefFst = VecVWtedTidkTkclksrcOp::getSref;
};

string TidkMfsmtrack1::getSrefModule() {
	return("mfsmtrack1");
};

string TidkMfsmtrack1::getSrefSource() {
	return(VecVWtedTidkMfsmtrack1Source::getSref(tixVSource));
};

/******************************************************************************
 class ZudkMfsmtrack0
 ******************************************************************************/

ZudkMfsmtrack0::ZudkMfsmtrack0(
			const uint8_t tixVSource
			, const double fTrkclk
		) : Track(tixVSource, fTrkclk) {
	if (tixVSource == VecVWtedZudkMfsmtrack0Source::HOSTIFOP) getSrefFst = VecVWtedZudkHostifOp::getSref;
};

string ZudkMfsmtrack0::getSrefModule() {
	return("mfsmtrack0");
};

string ZudkMfsmtrack0::getSrefSource() {
	return(VecVWtedZudkMfsmtrack0Source::getSref(tixVSource));
};

/******************************************************************************
 class ZudkMfsmtrack1
 ******************************************************************************/

ZudkMfsmtrack1::ZudkMfsmtrack1(
			const uint8_t tixVSource
			, const double fTrkclk
		) : Track(tixVSource, fTrkclk) {
	if (tixVSource == VecVWtedZudkMfsmtrack1Source::CLIENTGETBUFB) getSrefFst = VecVWtedZudkClientGetbufB::getSref;
	else if (tixVSource == VecVWtedZudkMfsmtrack1Source::CLIENTSETBUFB) getSrefFst = VecVWtedZudkClientSetbufB::getSref;
	else if (tixVSource == VecVWtedZudkMfsmtrack1Source::TKCLKSRCOP) getSrefFst = VecVWtedZudkTkclksrcOp::getSref;
};

string ZudkMfsmtrack1::getSrefModule() {
	return("mfsmtrack1");
};

string ZudkMfsmtrack1::getSrefSource() {
	return(VecVWtedZudkMfsmtrack1Source::getSref(tixVSource));
};

// ... continue here ...

/******************************************************************************
 class Ixsim
 ******************************************************************************/

Ixsim::Ixsim() {
	bool success = true;

	TX = 0; RX = 0;

	R0 = 0; V0 = 0; A0 = 0; E0 = 0;
	R = 0; V = 0; A = 0; E = 0;

	try {
		base.init(pathBase);
		base.histNotDump = false;
		//base.rxtxdump = true;

		base.hostif->reset();
		//base.tkclksrc->setTkst(0);
		t0Base = getNow();

#ifdef REPLAY
		replay.init(pathReplay);
		replay.histNotDump = false;
		//replay.rxtxdump = true;

		replay.hostif->reset();
		//replay.tkclksrc->setTkst(0);
		t0Replay = getNow();
#endif

	} catch (DbeException& e) {
		success = false;
	};

	fdShmem = 0;
	if (success) success = initShmem(pathShmem);

	if (success) {
		if (ixFrdpVFlavor == VecFrdpVFlavor::X10_6X8) {
			TX = 6; RX = 8;

			R0 = 1024; V0 = 32; A0 = 8; E0 = 6;
			R = 1024; V = 32; A = 16; E = 16;

			configBaseX10_6x8();
			configReplayX10_6x8();

		} else if (ixFrdpVFlavor == VecFrdpVFlavor::X14_96X1) {
			TX = 12; RX = 16;

			R0 = 1024; V0 = 32; A0 = 96; E0 = 1;
			R = 1024; V = 32; A = 128; E = 1;

			configBaseX14_96x1();
			configReplayX14_96x1();

		} else if (ixFrdpVFlavor == VecFrdpVFlavor::X14_16X3_LHS) {
			TX = 12; RX = 16;

			R0 = 1024; V0 = 32; A0 = 16; E0 = 3;
			//R = 1024; V = 32; A = 32; E = 16; // would result in 64 MB radar cube
			R = 1024; V = 32; A = 16; E = 16;

			configBaseX14_16x3_lhs();
			configReplayX14_16x3_lhs();

		} else if (ixFrdpVFlavor == VecFrdpVFlavor::X14_48X1_1TX) {
			TX = 3; RX = 16;

			R0 = 512; V0 = 32; A0 = 48; E0 = 1;
			R = 512; V = 32; A = 64; E = 1;

			configBaseX14_48x1_1tx();
			configReplayX14_48x1_1tx();
		};
	};

	icsMem.resize(NChunk, false);

	initdone = success;
};

Ixsim::~Ixsim() {
	base.term();
#ifdef REPLAY
	replay.term();
#endif

	if (fdShmem > 0) close(fdShmem);
};

bool Ixsim::initShmem(
			const string& path
		) {
	bool success = true;

	cout << "Opening shared memory device ..." << endl;

	fdShmem = open(path.c_str(), O_RDWR);
	if (fdShmem < 0) {
		cout << "... error" << endl;
		return false;
	};

	cout << "Mapping memory ..." << endl;

	buf = (unsigned char*) mmap(NULL, NChunk * sizeChunk * 1048576, PROT_READ | PROT_WRITE, MAP_SHARED, fdShmem, 0);
	if (buf == MAP_FAILED) {
		cout << "... error" << endl;
		return false;
	};

	return success;
};

bool Ixsim::getIxsim4DNot3D() {
	return((ixFrdpVFlavor == VecFrdpVFlavor::X10_6X8) || (ixFrdpVFlavor == VecFrdpVFlavor::X14_16X3_LHS));
};

void Ixsim::configBaseX10_6x8() {
	// -- flavor 0x10 (e.g. DY27CR0002) as 6x8 rectangular array

	// raw in is (unverified) 32, 6, 1024 x 8
	// lfft processes 32 x 48 x 1024
	// after lfft, have 32 x 8 x 6 x 1024 v0a0e0r
	// after sfft0, have 8 x 6 x 1024 x 32 a0e0rv
	// after sfft1, have 6 x 1024 x 32 x 16 e0rva
	// after sfft2, have 1024 x 32 x 16 x 16 rvae

	unsigned char lwndbuf[2048*2];
	unsigned char calbuf[2048*4];
	unsigned char mapbuf[4096*2];

	unsigned char swndbuf[8*128*2];

#if defined(_LFFT)
	const unsigned int sfft0Stride = 0;
#else
	const unsigned int sfft0Stride = A0 * E0 * R / 64; // 768
#endif

#if defined(_LFFT) || defined(_SFFT0)
	const unsigned int sfft1Stride = 0;
#else
	const unsigned int sfft1Stride = E0 * R * V / 64; // 3072
#endif

#if defined(_LFFT) || defined(_SFFT0) || defined(_SFFT1)
	const unsigned int sfft2Stride = 0;
#else
	const unsigned int sfft2Stride = R * V * A / 64; // 8192
#endif

	base.cubeacq->config(
				TX*V0, // lfftNRamp=[uint16]
				V0, // lfftNOuter=[uint8]
				RX*TX, // lfftNInner=[uint8]
				R, // lfftLen=[uint16]
				sfft0Stride, // sfft0Stride=[uint16]
				V0, // sfft0LenIn=[uint8]
				V, // sfft0LenOut=[uint8]
				sfft1Stride, // sfft1Stride=[uint16]
				A0, // sfft1LenIn=[uint8]
				A, // sfft1LenOut=[uint8]
				sfft2Stride, // sfft2Stride=[uint16]
				E0, // sfft2LenIn=[uint8]
				E // sfft2LenOut=[uint8]
			);

	base.lcoll->config(
				2, // NMmic=[uint8]
				4 // NChPerMmic=[uint8]
			);

	// lwndbuf
	setWndbuf(R0, R, lwndbuf, 0, false, false);

	// calbuf
	for (unsigned int j = 0; j < TX; j++)
		for (unsigned int k = 0; k < RX; k++)
			if (((k/4)%2) == 0) txRx0s.push_back(TxRx(j, k));
			else txRx1s.push_back(TxRx(j, k));

	map<TxRx,complex<double> > cals;
	loadCalsFromFile("./cal/TBD.txt", cals);
	setCalbuf(false, cals, calbuf);
	setCalbuf(true, cals, calbuf);

	// mapbuf
	aziEles[TxRx(2, 1)] = AziEle(0, 0);
	aziEles[TxRx(0, 1)] = AziEle(1, 0);
	aziEles[TxRx(1, 1)] = AziEle(2, 0);
	aziEles[TxRx(5, 1)] = AziEle(3, 0);
	aziEles[TxRx(3, 1)] = AziEle(4, 0);
	aziEles[TxRx(4, 1)] = AziEle(5, 0);
	aziEles[TxRx(2, 0)] = AziEle(0, 1);
	aziEles[TxRx(0, 0)] = AziEle(1, 1);
	aziEles[TxRx(1, 0)] = AziEle(2, 1);
	aziEles[TxRx(5, 0)] = AziEle(3, 1);
	aziEles[TxRx(3, 0)] = AziEle(4, 1);
	aziEles[TxRx(4, 0)] = AziEle(5, 1);
	aziEles[TxRx(2, 2)] = AziEle(0, 2);
	aziEles[TxRx(0, 2)] = AziEle(1, 2);
	aziEles[TxRx(1, 2)] = AziEle(2, 2);
	aziEles[TxRx(5, 2)] = AziEle(3, 2);
	aziEles[TxRx(3, 2)] = AziEle(4, 2);
	aziEles[TxRx(4, 2)] = AziEle(5, 2);
	aziEles[TxRx(2, 3)] = AziEle(0, 3);
	aziEles[TxRx(0, 3)] = AziEle(1, 3);
	aziEles[TxRx(1, 3)] = AziEle(2, 3);
	aziEles[TxRx(5, 3)] = AziEle(3, 3);
	aziEles[TxRx(3, 3)] = AziEle(4, 3);
	aziEles[TxRx(4, 3)] = AziEle(5, 3);
	aziEles[TxRx(2, 4)] = AziEle(0, 4);
	aziEles[TxRx(0, 4)] = AziEle(1, 4);
	aziEles[TxRx(1, 4)] = AziEle(2, 4);
	aziEles[TxRx(5, 4)] = AziEle(3, 4);
	aziEles[TxRx(3, 4)] = AziEle(4, 4);
	aziEles[TxRx(4, 4)] = AziEle(5, 4);
	aziEles[TxRx(2, 5)] = AziEle(0, 5);
	aziEles[TxRx(0, 5)] = AziEle(1, 5);
	aziEles[TxRx(1, 5)] = AziEle(2, 5);
	aziEles[TxRx(5, 5)] = AziEle(3, 5);
	aziEles[TxRx(3, 5)] = AziEle(4, 5);
	aziEles[TxRx(4, 5)] = AziEle(5, 5);
	aziEles[TxRx(2, 6)] = AziEle(0, 6);
	aziEles[TxRx(0, 6)] = AziEle(1, 6);
	aziEles[TxRx(1, 6)] = AziEle(2, 6);
	aziEles[TxRx(5, 6)] = AziEle(3, 6);
	aziEles[TxRx(3, 6)] = AziEle(4, 6);
	aziEles[TxRx(4, 6)] = AziEle(5, 6);
	aziEles[TxRx(2, 7)] = AziEle(0, 7);
	aziEles[TxRx(0, 7)] = AziEle(1, 7);
	aziEles[TxRx(1, 7)] = AziEle(2, 7);
	aziEles[TxRx(5, 7)] = AziEle(3, 7);
	aziEles[TxRx(3, 7)] = AziEle(4, 7);
	aziEles[TxRx(4, 7)] = AziEle(5, 7);

	setMapbuf(false, mapbuf);
	setMapbuf(true, mapbuf);

	// swndbuf (sfft0)
	setWndbuf(V0, V, swndbuf, 0*128*2, true, true);

	// swndbuf (sfft1)
	setWndbuf(A0, A, swndbuf, 1*128*2, true, false);
};

void Ixsim::configBaseX14_96x1() {
	// flavor 0x14 (e.g. E0275U0020) as 1x96 linear array

	// raw in is 32, 12, 1024 x 16
	// lfft processes 32 x 192 x 1024
	// after lfft, have 32 x 96 x 1024 v0a0r
	// after sfft0, have 96 x 1024 x 32 a0rv
	// after sfft1, have 1024 x 32 x 128 rva

	unsigned char lwndbuf[2048*2];
	unsigned char calbuf[2048*4];
	unsigned char mapbuf[4096*2];

	unsigned char swndbuf[8*128*2];

#if defined(_LFFT)
	const unsigned int sfft0Stride = 0;
#else
	const unsigned int sfft0Stride = A0 * R / 64; // 1536
#endif

#if defined(_LFFT) || defined(_SFFT0)
	const unsigned int sfft1Stride = 0;
#else
	const unsigned int sfft1Stride = R * V / 64; // 512
#endif

	base.cubeacq->config(
				TX*V0, // lfftNRamp=[uint16]
				V0, // lfftNOuter=[uint8]
				RX*TX, // lfftNInner=[uint8]
				R, // lfftLen=[uint16]
				sfft0Stride, // sfft0Stride=[uint16]
				V0, // sfft0LenIn=[uint8]
				V, // sfft0LenOut=[uint8]
				sfft1Stride, // sfft1Stride=[uint16]
				A0, // sfft1LenIn=[uint8]
				A, // sfft1LenOut=[uint8]
				0, // sfft2Stride=[uint16]
				0, // sfft2LenIn=[uint8]
				0 // sfft2LenOut=[uint8]
			);

	base.lcoll->config(
				4, // NMmic=[uint8]
				4 // NChPerMmic=[uint8]
			);

	// lwndbuf
	setWndbuf(R0, R, lwndbuf, 0, false, false);

	// calbuf
	for (unsigned int j = 0; j < TX; j++)
		for (unsigned int k = 0; k < RX; k++)
			if (((k/4)%2) == 0) txRx0s.push_back(TxRx(j, k));
			else txRx1s.push_back(TxRx(j, k));

	map<TxRx,complex<double> > cals;
	loadCalsFromFile("./cal/calibration_E0275U0020_config_000118.txt", cals);
	setCalbuf(false, cals, calbuf);
	setCalbuf(true, cals, calbuf);

	// mapbuf
	aziEles[TxRx(11, 15)] = AziEle(0, 0);
	aziEles[TxRx(10, 15)] = AziEle(1, 0);
	aziEles[TxRx(9, 15)] = AziEle(2, 0);
	aziEles[TxRx(11, 14)] = AziEle(3, 0);
	aziEles[TxRx(10, 14)] = AziEle(4, 0);
	aziEles[TxRx(9, 14)] = AziEle(5, 0);
	aziEles[TxRx(11, 13)] = AziEle(6, 0);
	aziEles[TxRx(10, 13)] = AziEle(7, 0);
	aziEles[TxRx(9, 13)] = AziEle(8, 0);
	aziEles[TxRx(11, 12)] = AziEle(9, 0);
	aziEles[TxRx(10, 12)] = AziEle(10, 0);
	aziEles[TxRx(9, 12)] = AziEle(11, 0);
	aziEles[TxRx(11, 11)] = AziEle(12, 0);
	aziEles[TxRx(10, 11)] = AziEle(13, 0);
	aziEles[TxRx(9, 11)] = AziEle(14, 0);
	aziEles[TxRx(11, 10)] = AziEle(15, 0);
	aziEles[TxRx(10, 10)] = AziEle(16, 0);
	aziEles[TxRx(9, 10)] = AziEle(17, 0);
	aziEles[TxRx(11, 9)] = AziEle(18, 0);
	aziEles[TxRx(10, 9)] = AziEle(19, 0);
	aziEles[TxRx(9, 9)] = AziEle(20, 0);
	aziEles[TxRx(11, 8)] = AziEle(21, 0);
	aziEles[TxRx(10, 8)] = AziEle(22, 0);
	aziEles[TxRx(9, 8)] = AziEle(23, 0);
	aziEles[TxRx(6, 14)] = AziEle(24, 0);
	aziEles[TxRx(8, 13)] = AziEle(25, 0);
	aziEles[TxRx(7, 13)] = AziEle(26, 0);
	aziEles[TxRx(6, 13)] = AziEle(27, 0);
	aziEles[TxRx(8, 12)] = AziEle(28, 0);
	aziEles[TxRx(7, 12)] = AziEle(29, 0);
	aziEles[TxRx(6, 12)] = AziEle(30, 0);
	aziEles[TxRx(8, 11)] = AziEle(31, 0);
	aziEles[TxRx(7, 11)] = AziEle(32, 0);
	aziEles[TxRx(6, 11)] = AziEle(33, 0);
	aziEles[TxRx(8, 10)] = AziEle(34, 0);
	aziEles[TxRx(7, 10)] = AziEle(35, 0);
	aziEles[TxRx(6, 10)] = AziEle(36, 0);
	aziEles[TxRx(8, 9)] = AziEle(37, 0);
	aziEles[TxRx(7, 9)] = AziEle(38, 0);
	aziEles[TxRx(6, 9)] = AziEle(39, 0);
	aziEles[TxRx(8, 8)] = AziEle(40, 0);
	aziEles[TxRx(7, 8)] = AziEle(41, 0);
	aziEles[TxRx(6, 8)] = AziEle(42, 0);
	aziEles[TxRx(8, 3)] = AziEle(43, 0);
	aziEles[TxRx(7, 3)] = AziEle(44, 0);
	aziEles[TxRx(6, 3)] = AziEle(45, 0);
	aziEles[TxRx(8, 2)] = AziEle(46, 0);
	aziEles[TxRx(7, 2)] = AziEle(47, 0);
	aziEles[TxRx(1, 10)] = AziEle(48, 0);
	aziEles[TxRx(0, 10)] = AziEle(49, 0);
	aziEles[TxRx(2, 9)] = AziEle(50, 0);
	aziEles[TxRx(1, 9)] = AziEle(51, 0);
	aziEles[TxRx(0, 9)] = AziEle(52, 0);
	aziEles[TxRx(2, 8)] = AziEle(53, 0);
	aziEles[TxRx(1, 8)] = AziEle(54, 0);
	aziEles[TxRx(0, 8)] = AziEle(55, 0);
	aziEles[TxRx(2, 3)] = AziEle(56, 0);
	aziEles[TxRx(1, 3)] = AziEle(57, 0);
	aziEles[TxRx(0, 3)] = AziEle(58, 0);
	aziEles[TxRx(2, 2)] = AziEle(59, 0);
	aziEles[TxRx(1, 2)] = AziEle(60, 0);
	aziEles[TxRx(0, 2)] = AziEle(61, 0);
	aziEles[TxRx(2, 1)] = AziEle(62, 0);
	aziEles[TxRx(1, 1)] = AziEle(63, 0);
	aziEles[TxRx(0, 1)] = AziEle(64, 0);
	aziEles[TxRx(2, 0)] = AziEle(65, 0);
	aziEles[TxRx(1, 0)] = AziEle(66, 0);
	aziEles[TxRx(0, 0)] = AziEle(67, 0);
	aziEles[TxRx(2, 7)] = AziEle(68, 0);
	aziEles[TxRx(1, 7)] = AziEle(69, 0);
	aziEles[TxRx(0, 7)] = AziEle(70, 0);
	aziEles[TxRx(2, 6)] = AziEle(71, 0);
	aziEles[TxRx(5, 3)] = AziEle(72, 0);
	aziEles[TxRx(4, 3)] = AziEle(73, 0);
	aziEles[TxRx(3, 3)] = AziEle(74, 0);
	aziEles[TxRx(5, 2)] = AziEle(75, 0);
	aziEles[TxRx(4, 2)] = AziEle(76, 0);
	aziEles[TxRx(3, 2)] = AziEle(77, 0);
	aziEles[TxRx(5, 1)] = AziEle(78, 0);
	aziEles[TxRx(4, 1)] = AziEle(79, 0);
	aziEles[TxRx(3, 1)] = AziEle(80, 0);
	aziEles[TxRx(5, 0)] = AziEle(81, 0);
	aziEles[TxRx(4, 0)] = AziEle(82, 0);
	aziEles[TxRx(3, 0)] = AziEle(83, 0);
	aziEles[TxRx(5, 7)] = AziEle(84, 0);
	aziEles[TxRx(4, 7)] = AziEle(85, 0);
	aziEles[TxRx(3, 7)] = AziEle(86, 0);
	aziEles[TxRx(5, 6)] = AziEle(87, 0);
	aziEles[TxRx(4, 6)] = AziEle(88, 0);
	aziEles[TxRx(3, 6)] = AziEle(89, 0);
	aziEles[TxRx(5, 5)] = AziEle(90, 0);
	aziEles[TxRx(4, 5)] = AziEle(91, 0);
	aziEles[TxRx(3, 5)] = AziEle(92, 0);
	aziEles[TxRx(5, 4)] = AziEle(93, 0);
	aziEles[TxRx(4, 4)] = AziEle(94, 0);
	aziEles[TxRx(3, 4)] = AziEle(95, 0);

	setMapbuf(false, mapbuf);
	setMapbuf(true, mapbuf);

	// swndbuf (sfft0)
	setWndbuf(V0, V, swndbuf, 0*128*2, true, true);

	// swndbuf (sfft1)
	setWndbuf(A0, A, swndbuf, 1*128*2, true, false);
};

void Ixsim::configBaseX14_16x3_lhs() {
	// -- flavor 0x14 (e.g. E0275U0020) as 3x16 rectangular array (lhs)

	// raw in is 32, 12, 1024 x 16
	// lfft processes 32 x 192 x 1024
	// after lfft, have 32 x 16 x 3 x 1024 v0a0e0r
	// after sfft0, have 16 x 3 x 1024 x 32 a0e0rv
	// after sfft1, have 3 x 1024 x 32 x 32 e0rva
	// after sfft2, have 1024 x 32 x 32 x 16 rvae

	unsigned char lwndbuf[2048*2];
	unsigned char calbuf[2048*4];
	unsigned char mapbuf[4096*2];

	unsigned char swndbuf[8*128*2];

#if defined(_LFFT)
	const unsigned int sfft0Stride = 0;
#else
	const unsigned int sfft0Stride = A0 * E0 * R / 64; // 768
#endif

#if defined(_LFFT) || defined(_SFFT0)
	const unsigned int sfft1Stride = 0;
#else
	const unsigned int sfft1Stride = E0 * R * V / 64; // 1536
#endif

#if defined(_LFFT) || defined(_SFFT0) || defined(_SFFT1)
	const unsigned int sfft2Stride = 0;
#else
	const unsigned int sfft2Stride = R * V * A / 64; // 8192
#endif

	base.cubeacq->config(
				TX*V0, // lfftNRamp=[uint16]
				V0, // lfftNOuter=[uint8]
				RX*TX, // lfftNInner=[uint8]
				R, // lfftLen=[uint16]
				sfft0Stride, // sfft0Stride=[uint16]
				V0, // sfft0LenIn=[uint8]
				V, // sfft0LenOut=[uint8]
				sfft1Stride, // sfft1Stride=[uint16]
				A0, // sfft1LenIn=[uint8]
				A, // sfft1LenOut=[uint8]
				sfft2Stride, // sfft2Stride=[uint16]
				E0, // sfft2LenIn=[uint8]
				E // sfft2LenOut=[uint8]
			);

	base.lcoll->config(
				4, // NMmic=[uint8]
				4 // NChPerMmic=[uint8]
			);

	// lwndbuf
	setWndbuf(R0, R, lwndbuf, 0, false, false);

	// calbuf
	for (unsigned int j = 0; j < TX; j++)
		for (unsigned int k = 0; k < RX; k++)
			if (((k/4)%2) == 0) txRx0s.push_back(TxRx(j, k));
			else txRx1s.push_back(TxRx(j, k));

	map<TxRx,complex<double> > cals;
	loadCalsFromFile("./cal/calibration_E0275U0020_config_000118.txt", cals);
	setCalbuf(false, cals, calbuf);
	setCalbuf(true, cals, calbuf);

	// mapbuf
	aziEles[TxRx(9, 1)] = AziEle(0, 0);
	aziEles[TxRx(11, 0)] = AziEle(1, 0);
	aziEles[TxRx(10, 0)] = AziEle(2, 0);
	aziEles[TxRx(9, 0)] = AziEle(3, 0);
	aziEles[TxRx(11, 7)] = AziEle(4, 0);
	aziEles[TxRx(10, 7)] = AziEle(5, 0);
	aziEles[TxRx(9, 7)] = AziEle(6, 0);
	aziEles[TxRx(11, 6)] = AziEle(7, 0);
	aziEles[TxRx(10, 6)] = AziEle(8, 0);
	aziEles[TxRx(9, 6)] = AziEle(9, 0);
	aziEles[TxRx(11, 5)] = AziEle(10, 0);
	aziEles[TxRx(10, 5)] = AziEle(11, 0);
	aziEles[TxRx(9, 5)] = AziEle(12, 0);
	aziEles[TxRx(11, 4)] = AziEle(13, 0);
	aziEles[TxRx(10, 4)] = AziEle(14, 0);
	aziEles[TxRx(9, 4)] = AziEle(15, 0);
	aziEles[TxRx(7, 11)] = AziEle(0, 1);
	aziEles[TxRx(6, 11)] = AziEle(1, 1);
	aziEles[TxRx(8, 10)] = AziEle(2, 1);
	aziEles[TxRx(7, 10)] = AziEle(3, 1);
	aziEles[TxRx(6, 10)] = AziEle(4, 1);
	aziEles[TxRx(8, 9)] = AziEle(5, 1);
	aziEles[TxRx(7, 9)] = AziEle(6, 1);
	aziEles[TxRx(6, 9)] = AziEle(7, 1);
	aziEles[TxRx(8, 8)] = AziEle(8, 1);
	aziEles[TxRx(7, 8)] = AziEle(9, 1);
	aziEles[TxRx(6, 8)] = AziEle(10, 1);
	aziEles[TxRx(8, 3)] = AziEle(11, 1);
	aziEles[TxRx(7, 3)] = AziEle(12, 1);
	aziEles[TxRx(6, 3)] = AziEle(13, 1);
	aziEles[TxRx(8, 2)] = AziEle(14, 1);
	aziEles[TxRx(7, 2)] = AziEle(15, 1);
	aziEles[TxRx(2, 15)] = AziEle(0, 2);
	aziEles[TxRx(1, 15)] = AziEle(1, 2);
	aziEles[TxRx(0, 15)] = AziEle(2, 2);
	aziEles[TxRx(2, 14)] = AziEle(3, 2);
	aziEles[TxRx(1, 14)] = AziEle(4, 2);
	aziEles[TxRx(0, 14)] = AziEle(5, 2);
	aziEles[TxRx(2, 13)] = AziEle(6, 2);
	aziEles[TxRx(1, 13)] = AziEle(7, 2);
	aziEles[TxRx(0, 13)] = AziEle(8, 2);
	aziEles[TxRx(2, 12)] = AziEle(9, 2);
	aziEles[TxRx(1, 12)] = AziEle(10, 2);
	aziEles[TxRx(0, 12)] = AziEle(11, 2);
	aziEles[TxRx(2, 1)] = AziEle(12, 2);
	aziEles[TxRx(1, 1)] = AziEle(13, 2);
	aziEles[TxRx(0, 1)] = AziEle(14, 2);
	aziEles[TxRx(2, 10)] = AziEle(15, 2);

	setMapbuf(false, mapbuf);
	setMapbuf(true, mapbuf);

	// swndbuf (sfft0)
	setWndbuf(V0, V, swndbuf, 0*128*2, true, true);

	// swndbuf (sfft1)
	setWndbuf(A0, A, swndbuf, 1*128*2, true, true);

	// swndbuf (sfft2)
	setWndbuf(E0, E, swndbuf, 2*128*2, true, false);
};

void Ixsim::configBaseX14_48x1_1tx() {
	// flavor 0x14 as 1x48 linear array

	// raw in is 32, 3, 512 x 16
	// lfft processes 32 x 48 x 512
	// after lfft, have 32 x 48 x 512 v0a0r
	// after sfft0, have 48 x 512 x 32 a0rv
	// after sfft1, have 512 x 32 x 64 rva

	unsigned char lwndbuf[2048*2];
	unsigned char calbuf[2048*4];
	unsigned char mapbuf[4096*2];

	unsigned char swndbuf[8*128*2];

#if defined(_LFFT)
	const unsigned int sfft0Stride = 0;
#else
	const unsigned int sfft0Stride = A0 * R / 64; // 384
#endif

#if defined(_LFFT) || defined(_SFFT0)
	const unsigned int sfft1Stride = 0;
#else
	const unsigned int sfft1Stride = R * V / 64; // 512
#endif

	base.cubeacq->config(
				TX*V0, // lfftNRamp=[uint16]
				V0, // lfftNOuter=[uint8]
				RX*TX, // lfftNInner=[uint8]
				R, // lfftLen=[uint16]
				sfft0Stride, // sfft0Stride=[uint16]
				V0, // sfft0LenIn=[uint8]
				V, // sfft0LenOut=[uint8]
				sfft1Stride, // sfft1Stride=[uint16]
				A0, // sfft1LenIn=[uint8]
				A, // sfft1LenOut=[uint8]
				0, // sfft2Stride=[uint16]
				0, // sfft2LenIn=[uint8]
				0 // sfft2LenOut=[uint8]
			);

	base.lcoll->config(
				4, // NMmic=[uint8]
				4 // NChPerMmic=[uint8]
			);

	// lwndbuf
	setWndbuf(R0, R, lwndbuf, 0, false, false);

	// calbuf
	for (unsigned int j = 0; j < TX; j++)
		for (unsigned int k = 0; k < RX; k++)
			if (((k/4)%2) == 0) txRx0s.push_back(TxRx(j, k));
			else txRx1s.push_back(TxRx(j, k));

	map<TxRx,complex<double> > cals;
	loadCalsFromFile("./cal/E0275U0022_conf_000109_0deg_cal.txt", cals);
	setCalbuf(false, cals, calbuf);
	setCalbuf(true, cals, calbuf);

	// mapbuf
	aziEles[TxRx(2, 15)] = AziEle(0, 0);
	aziEles[TxRx(1, 15)] = AziEle(1, 0);
	aziEles[TxRx(0, 15)] = AziEle(2, 0);
	aziEles[TxRx(2, 14)] = AziEle(3, 0);
	aziEles[TxRx(1, 14)] = AziEle(4, 0);
	aziEles[TxRx(0, 14)] = AziEle(5, 0);
	aziEles[TxRx(2, 13)] = AziEle(6, 0);
	aziEles[TxRx(1, 13)] = AziEle(7, 0);
	aziEles[TxRx(0, 13)] = AziEle(8, 0);
	aziEles[TxRx(2, 12)] = AziEle(9, 0);
	aziEles[TxRx(1, 12)] = AziEle(10, 0);
	aziEles[TxRx(0, 12)] = AziEle(11, 0);
	aziEles[TxRx(2, 11)] = AziEle(12, 0);
	aziEles[TxRx(1, 11)] = AziEle(13, 0);
	aziEles[TxRx(0, 11)] = AziEle(14, 0);
	aziEles[TxRx(2, 10)] = AziEle(15, 0);
	aziEles[TxRx(1, 10)] = AziEle(16, 0);
	aziEles[TxRx(0, 10)] = AziEle(17, 0);
	aziEles[TxRx(2, 9)] = AziEle(18, 0);
	aziEles[TxRx(1, 9)] = AziEle(19, 0);
	aziEles[TxRx(0, 9)] = AziEle(20, 0);
	aziEles[TxRx(2, 8)] = AziEle(21, 0);
	aziEles[TxRx(1, 8)] = AziEle(22, 0);
	aziEles[TxRx(0, 8)] = AziEle(23, 0);
	aziEles[TxRx(2, 7)] = AziEle(24, 0);
	aziEles[TxRx(1, 7)] = AziEle(25, 0);
	aziEles[TxRx(0, 7)] = AziEle(26, 0);
	aziEles[TxRx(2, 6)] = AziEle(27, 0);
	aziEles[TxRx(1, 6)] = AziEle(28, 0);
	aziEles[TxRx(0, 6)] = AziEle(29, 0);
	aziEles[TxRx(2, 5)] = AziEle(30, 0);
	aziEles[TxRx(1, 5)] = AziEle(31, 0);
	aziEles[TxRx(0, 5)] = AziEle(32, 0);
	aziEles[TxRx(2, 4)] = AziEle(33, 0);
	aziEles[TxRx(1, 4)] = AziEle(34, 0);
	aziEles[TxRx(0, 4)] = AziEle(35, 0);
	aziEles[TxRx(2, 3)] = AziEle(36, 0);
	aziEles[TxRx(1, 3)] = AziEle(37, 0);
	aziEles[TxRx(0, 3)] = AziEle(38, 0);
	aziEles[TxRx(2, 2)] = AziEle(39, 0);
	aziEles[TxRx(1, 2)] = AziEle(40, 0);
	aziEles[TxRx(0, 2)] = AziEle(41, 0);
	aziEles[TxRx(2, 1)] = AziEle(42, 0);
	aziEles[TxRx(1, 1)] = AziEle(43, 0);
	aziEles[TxRx(0, 1)] = AziEle(44, 0);
	aziEles[TxRx(2, 0)] = AziEle(45, 0);
	aziEles[TxRx(1, 0)] = AziEle(46, 0);
	aziEles[TxRx(0, 0)] = AziEle(47, 0);

	setMapbuf(false, mapbuf);
	setMapbuf(true, mapbuf);

	// swndbuf (sfft0)
	setWndbuf(V0, V, swndbuf, 0*128*2, true, true);

	// swndbuf (sfft1)
	setWndbuf(A0, A, swndbuf, 1*128*2, true, false);
};

void Ixsim::setMapbuf(
			const bool mapbuf1Not0
			, unsigned char* mapbuf
		) {
	std::vector<TxRx>& txRxs = (mapbuf1Not0) ? txRx1s : txRx0s;

	// to achieve vaer ordering, use
	// ix_vae = v*A0*E0 + a*E0 + e

	const int ixInvalid = 0xFFFF;

	vector<uint16_t> ics;
	ics.resize(V0 * txRxs.size(), ixInvalid);

	for (unsigned int v = 0; v < V0; v++)
		for (unsigned int j = 0; j < txRxs.size(); j++) {
			auto it = aziEles.find(txRxs[j]);
			if (it != aziEles.end()) ics[v*txRxs.size() + j] = v*A0*E0 + it->second.azi*E0 + it->second.ele;
		};

	for (unsigned int i = 0; i < ics.size(); i++) {
		mapbuf[2*i] = ics[i] & (0x00FF);
		mapbuf[2*i+1] = ics[i] >> 8;
	};

	if (!mapbuf1Not0) base.writeMapbuf0ToLemit(mapbuf, 4096*2, true);
	else base.writeMapbuf1ToLemit(mapbuf, 4096*2, true);
};

void Ixsim::setCalbuf(
			const bool calbuf1Not0
			, map<TxRx,complex<double> >& cals
			, unsigned char* calbuf
		) {
	// normalize to highest absolute value used
	std::vector<TxRx>& txRxs = (calbuf1Not0) ? txRx1s : txRx0s;

	double norm;

	complex<double> cal;
	int16_t re, im;

	unsigned char* c;

	bool bigNotLittle = Dbe::bigendian();

	norm = 0.0;

	for (unsigned int i = 0; i < txRxs.size(); i++) {
		auto it = cals.find(txRxs[i]);
		if (it != cals.end()) if (abs(it->second) > norm) norm = abs(it->second); 
	};

	if (norm == 0.0) norm = 1.0;

	for (unsigned int i = 0; i < txRxs.size(); i++) {
		re = 32767;
		im = 0;

		auto it = cals.find(txRxs[i]);
		if (it != cals.end()) {
			cal = it->second * 32767.0/norm;

			re = lround(cal.real());
			im = lround(cal.imag());
		};

		c = (unsigned char*) &re;
		calbuf[4*i+3] = ((bigNotLittle) ? c[0] : c[1]);
		calbuf[4*i+2] = ((bigNotLittle) ? c[1] : c[0]);

		c = (unsigned char*) &im;
		calbuf[4*i+1] = ((bigNotLittle) ? c[0] : c[1]);
		calbuf[4*i] = ((bigNotLittle) ? c[1] : c[0]);
	};

	if (!calbuf1Not0) base.writeCalbuf0ToLfft(calbuf, 2048*4, true);
	else base.writeCalbuf1ToLfft(calbuf, 2048*4, true);
};

void Ixsim::setWndbuf(
			const unsigned int lenIn
			, const unsigned int lenOut
			, unsigned char* wndbuf
			, const size_t ix0
			, const bool sfftNotLfft
			, const bool fillonlyNotXfer
		) {
	// only values corresponding to lenIn (zeroes are irrelevant)

	// ex. lenIn = 3, lenOut = 8 => ix0 = (lenOut - lenIn) / 2 = 2
	// 0 1 2 3 4 5 6 7
	// - - X X X - - -

	// in wndbuf
	// W W W - - - - -

	double d;
	int16_t wnd;

	unsigned char* c;

	bool bigNotLittle = Dbe::bigendian();

	// Hann filter
	unsigned int ofs = (lenOut - lenIn) / 2;

	for (unsigned int i = 0; i < lenIn; i++) {
		d = 0.5 * (1.0 + cos(2.0*M_PI * ((double) ((i+ofs) - lenOut/2)) / ((double) (lenOut-1))));
		wnd = lround(32767.0 * d);

		c = (unsigned char*) &wnd;
		wndbuf[ix0 + 2*i+1] = ((bigNotLittle) ? c[0] : c[1]);
		wndbuf[ix0 + 2*i] = ((bigNotLittle) ? c[1] : c[0]);
	};

	if (!fillonlyNotXfer) {
		if (!sfftNotLfft) base.writeWndbufToLfft(wndbuf, 2048*2, true);
		else base.writeWndbufToSfft(wndbuf, 8*128*2, true);
	};
};

void Ixsim::configReplayX10_6x8() {
#ifdef REPLAY
	unsigned char mmic0ch0[] = {0x11, 0x21, 0x01, 0x41, 0x51, 0x31, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic0ch1[] = {0x10, 0x20, 0x00, 0x40, 0x50, 0x30, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic0ch2[] = {0x12, 0x22, 0x02, 0x42, 0x52, 0x32, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic0ch3[] = {0x13, 0x23, 0x03, 0x43, 0x53, 0x33, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic1ch0[] = {0x14, 0x24, 0x04, 0x44, 0x54, 0x34, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic1ch1[] = {0x15, 0x25, 0x05, 0x45, 0x55, 0x35, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic1ch2[] = {0x16, 0x26, 0x06, 0x46, 0x56, 0x36, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic1ch3[] = {0x17, 0x27, 0x07, 0x47, 0x57, 0x37, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};

	replay.stream->config(V0, TX, R0);

	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH0, mmic0ch0, 6);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH1, mmic0ch1, 6);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH2, mmic0ch2, 6);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH3, mmic0ch3, 6);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH0, mmic1ch0, 6);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH1, mmic1ch1, 6);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH2, mmic1ch2, 6);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH3, mmic1ch3, 6);
#endif
};

void Ixsim::configReplayX14_96x1() {
#ifdef REPLAY
	unsigned char mmic0ch0[] = {0x43, 0x42, 0x41, 0x53, 0x52, 0x51, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic0ch1[] = {0x40, 0x3F, 0x3E, 0x50, 0x4F, 0x4E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic0ch2[] = {0x3D, 0x3C, 0x3B, 0x4D, 0x4C, 0x4B, 0xFF, 0x2F, 0x2E, 0xFF, 0xFF, 0xFF};
	unsigned char mmic0ch3[] = {0x3A, 0x39, 0x38, 0x4A, 0x49, 0x48, 0x2D, 0x2C, 0x2B, 0xFF, 0xFF, 0xFF};
	unsigned char mmic1ch0[] = {0xFF, 0xFF, 0xFF, 0x5F, 0x5E, 0x5D, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic1ch1[] = {0xFF, 0xFF, 0xFF, 0x5C, 0x5B, 0x5A, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic1ch2[] = {0xFF, 0xFF, 0x47, 0x59, 0x58, 0x57, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic1ch3[] = {0x46, 0x45, 0x44, 0x56, 0x55, 0x54, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic2ch0[] = {0x37, 0x36, 0x35, 0xFF, 0xFF, 0xFF, 0x2A, 0x29, 0x28, 0x17, 0x16, 0x15};
	unsigned char mmic2ch1[] = {0x34, 0x33, 0x32, 0xFF, 0xFF, 0xFF, 0x27, 0x26, 0x25, 0x14, 0x13, 0x12};
	unsigned char mmic2ch2[] = {0x31, 0x30, 0xFF, 0xFF, 0xFF, 0xFF, 0x24, 0x23, 0x22, 0x11, 0x10, 0x0F};
	unsigned char mmic2ch3[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x21, 0x20, 0x1F, 0x0E, 0x0D, 0x0C};
	unsigned char mmic3ch0[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1E, 0x1D, 0x1C, 0x0B, 0x0A, 0x09};
	unsigned char mmic3ch1[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x1B, 0x1A, 0x19, 0x08, 0x07, 0x06};
	unsigned char mmic3ch2[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x18, 0xFF, 0xFF, 0x05, 0x04, 0x03};
	unsigned char mmic3ch3[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x02, 0x01, 0x00};

	replay.stream->config(V0, TX, R0);

	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH0, mmic0ch0, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH1, mmic0ch1, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH2, mmic0ch2, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH3, mmic0ch3, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH0, mmic1ch0, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH1, mmic1ch1, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH2, mmic1ch2, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH3, mmic1ch3, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC2, VecWFrpdReplayCh::CH0, mmic2ch0, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC2, VecWFrpdReplayCh::CH1, mmic2ch1, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC2, VecWFrpdReplayCh::CH2, mmic2ch2, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC2, VecWFrpdReplayCh::CH3, mmic2ch3, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC3, VecWFrpdReplayCh::CH0, mmic3ch0, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC3, VecWFrpdReplayCh::CH1, mmic3ch1, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC3, VecWFrpdReplayCh::CH2, mmic3ch2, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC3, VecWFrpdReplayCh::CH3, mmic3ch3, 12);
#endif
};

void Ixsim::configReplayX14_16x3_lhs() {
#ifdef REPLAY
	unsigned char mmic0ch0[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x30, 0x20, 0x10};
	unsigned char mmic0ch1[] = {0xE2, 0xD2, 0xC2, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0xFF};
	unsigned char mmic0ch2[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xF1, 0xE1, 0xFF, 0xFF, 0xFF};
	unsigned char mmic0ch3[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xD1, 0xC1, 0xB1, 0xFF, 0xFF, 0xFF};
	unsigned char mmic1ch0[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xF0, 0xE0, 0xD0};
	unsigned char mmic1ch1[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xC0, 0xB0, 0xA0};
	unsigned char mmic1ch2[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x90, 0x80, 0x70};
	unsigned char mmic1ch3[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x60, 0x50, 0x40};
	unsigned char mmic2ch0[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xA1, 0x91, 0x81, 0xFF, 0xFF, 0xFF};
	unsigned char mmic2ch1[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x71, 0x61, 0x51, 0xFF, 0xFF, 0xFF};
	unsigned char mmic2ch2[] = {0xFF, 0xFF, 0xF2, 0xFF, 0xFF, 0xFF, 0x41, 0x31, 0x21, 0xFF, 0xFF, 0xFF};
	unsigned char mmic2ch3[] = {0x01, 0x11, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic3ch0[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x92, 0xA2, 0xB2};
	unsigned char mmic3ch1[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x62, 0x72, 0x82, 0xFF, 0xFF, 0xFF};
	unsigned char mmic3ch2[] = {0xFF, 0xFF, 0xFF, 0x32, 0x42, 0x52, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic3ch3[] = {0x02, 0x12, 0x22, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};

	replay.stream->config(V0, TX, R0);

	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH0, mmic0ch0, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH1, mmic0ch1, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH2, mmic0ch2, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH3, mmic0ch3, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH0, mmic1ch0, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH1, mmic1ch1, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH2, mmic1ch2, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH3, mmic1ch3, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC2, VecWFrpdReplayCh::CH0, mmic2ch0, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC2, VecWFrpdReplayCh::CH1, mmic2ch1, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC2, VecWFrpdReplayCh::CH2, mmic2ch2, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC2, VecWFrpdReplayCh::CH3, mmic2ch3, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC3, VecWFrpdReplayCh::CH0, mmic3ch0, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC3, VecWFrpdReplayCh::CH1, mmic3ch1, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC3, VecWFrpdReplayCh::CH2, mmic3ch2, 12);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC3, VecWFrpdReplayCh::CH3, mmic3ch3, 12);
#endif
};

void Ixsim::configReplayX14_48x1_1tx() {
#ifdef REPLAY
	unsigned char mmic0ch0[] = {0x2F, 0x2E, 0x2D, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic0ch1[] = {0x2C, 0x2B, 0x2A, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic0ch2[] = {0x29, 0x28, 0x27, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic0ch3[] = {0x26, 0x25, 0x24, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic1ch0[] = {0x23, 0x22, 0x21, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic1ch1[] = {0x20, 0x1F, 0x1E, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic1ch2[] = {0x1D, 0x1C, 0x1B, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic1ch3[] = {0x1A, 0x19, 0x18, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic2ch0[] = {0x17, 0x16, 0x15, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic2ch1[] = {0x14, 0x13, 0x12, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic2ch2[] = {0x11, 0x10, 0x0F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic2ch3[] = {0x0E, 0x0D, 0x0C, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic3ch0[] = {0x0B, 0x0A, 0x09, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic3ch1[] = {0x08, 0x07, 0x06, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic3ch2[] = {0x05, 0x04, 0x03, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
	unsigned char mmic3ch3[] = {0x02, 0x01, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};

	replay.stream->config(V0, TX, R0);

	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH0, mmic0ch0, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH1, mmic0ch1, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH2, mmic0ch2, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC0, VecWFrpdReplayCh::CH3, mmic0ch3, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH0, mmic1ch0, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH1, mmic1ch1, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH2, mmic1ch2, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC1, VecWFrpdReplayCh::CH3, mmic1ch3, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC2, VecWFrpdReplayCh::CH0, mmic2ch0, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC2, VecWFrpdReplayCh::CH1, mmic2ch1, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC2, VecWFrpdReplayCh::CH2, mmic2ch2, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC2, VecWFrpdReplayCh::CH3, mmic2ch3, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC3, VecWFrpdReplayCh::CH0, mmic3ch0, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC3, VecWFrpdReplayCh::CH1, mmic3ch1, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC3, VecWFrpdReplayCh::CH2, mmic3ch2, 3);
	replay.stream->configIxsim(VecWFrpdReplayMmic::MMIC3, VecWFrpdReplayCh::CH3, mmic3ch3, 3);
#endif
};

void Ixsim::loadCalsFromFile(
			const string& path
			, map<TxRx,complex<double> >& cals
		) {
	// expect one value per line, TX major, RX minor
	// real<TAB>imag

	ifstream infile;
	char buf[256];

	vector<string> ss;
	string s;

	double real, imag;

	infile.open(path.c_str(), ios::in);

	for (unsigned int i = 0; i < TX; i++)
		for (unsigned int j = 0; j < RX; j++) {
			real = 1.0;
			imag = 0.0;

			if (infile.good() && !infile.eof()) {
				s = StrMod::readLine(infile, buf, 256);
				StrMod::stringToVector(s, ss, '\t');

				if (ss.size() == 2) {
					real = atof(ss[0].c_str());
					imag = atof(ss[1].c_str());
				};
			};

			cals[TxRx(i, j)] = complex<double>(real, imag);
		};

	infile.close();
};

void Ixsim::startReplay() {
#ifdef REPLAY
	utinyint tixWReplayMmic = 0;

	if (ixFrdpVFlavor == VecFrdpVFlavor::X10_6X8) tixWReplayMmic = VecWFrpdReplayMmic::MMIC0 + VecWFrpdReplayMmic::MMIC1;
	else if (ixFrdpVFlavor == VecFrdpVFlavor::X14_96X1) tixWReplayMmic = VecWFrpdReplayMmic::MMIC0 + VecWFrpdReplayMmic::MMIC1 + VecWFrpdReplayMmic::MMIC2 + VecWFrpdReplayMmic::MMIC3;
	else if (ixFrdpVFlavor == VecFrdpVFlavor::X14_16X3_LHS) tixWReplayMmic = VecWFrpdReplayMmic::MMIC0 + VecWFrpdReplayMmic::MMIC1 + VecWFrpdReplayMmic::MMIC2 + VecWFrpdReplayMmic::MMIC3;
	else if (ixFrdpVFlavor == VecFrdpVFlavor::X14_48X1_1TX) tixWReplayMmic = VecWFrpdReplayMmic::MMIC0 + VecWFrpdReplayMmic::MMIC1 + VecWFrpdReplayMmic::MMIC2 + VecWFrpdReplayMmic::MMIC3;

	replay.stream->set(
				true // rng
				, true // ixsimNotData
				, tixWReplayMmic // tixWReplayMmic
				, VecWFrpdReplayCh::CH0 + VecWFrpdReplayCh::CH1 + VecWFrpdReplayCh::CH2 + VecWFrpdReplayCh::CH3 // tixWReplayCh
			);
#endif
};

void Ixsim::runMainLoop() {
	bool first = true;

	char c;

	uint8_t ixMem0 = ixMemInvalid;
	uint8_t ixMem1 = ixMemInvalid;

	uint8_t tixVState;
	uint8_t ixMem;
	uint8_t tixVSuccess;
	uint8_t tixVSuccess_expect;
	uint32_t tkst;
	uint8_t ixMemLfft;
	uint8_t ixMemSfft;

	bool newframe;

#if defined(_LFFT)
	tixVSuccess_expect = VecVFrpdBaseCubeacqSuccess::LFFT;
#elif defined(_SFFT0)
	tixVSuccess_expect = VecVFrpdBaseCubeacqSuccess::SFFT0;
#elif defined(_SFFT1)
	tixVSuccess_expect = VecVFrpdBaseCubeacqSuccess::SFFT1;
#elif defined(_SFFT2)
	tixVSuccess_expect = (getIxsim4DNot3D()) ? VecVFrpdBaseCubeacqSuccess::SFFT2 : VecVFrpdBaseCubeacqSuccess::SFFT1;
#endif

	// at any given time, there can be at most two ixMem's assign()ed to cubeacq
	// accordingly, new results can only be associated with either ixMem0 or ixMem1

	// - prepare
	// set(rng=false)
	// assert(tixVState == idle)
	// configure
	// set(rng=true)

	// - loop
	// poll: getInfo(ixMem)
	// if ixMem match: resultNew (ixMem0 or ixMem1)
	//		if ixMem == ixMem0: resultNew(ixMem0), ixMem0 = ixMem1
	//		if ixMem == ixMem1: resultNew(ixMem1), slip detected, give up on ixMem0
	// if ixMem0 invalid: assign(ixMem0)
	// else if ixMem1 invalid and ixMem0 in progress: assign(ixMem1)

	timespec deltatFixed, deltatFrame, deltatLong;

	deltatFixed = {.tv_sec = 0, .tv_nsec = 100000}; // 0.1 ms
	deltatFrame = {.tv_sec = 0, .tv_nsec = 1000000}; // 1 ms, max. half-frame duration (adaptive in future)
	deltatLong = {.tv_sec = 0, .tv_nsec = 333000000}; // 333 ms

	cout << "start: ";
	cin >> c;

	try {
		// track, dsptrack, xdsptrack start (arm)

#ifdef TRACK
		const uint8_t trackTixVSource = VecVFrpdBaseTrackSource::CUBEACQSFFT;
		TrackFrpdBaseTrack track(trackTixVSource, 100000.0);
		base.track->select(
					trackTixVSource, // tixVSource={cubeacqAssign,cubeacqLfft,cubeacqOp,cubeacqSfft}
					VecVFrpdBaseTrackTrigger::REQINVCUBEACQSET, // staTixVTrigger={void,reqInvCubeacqAssign,reqInvCubeacqSet}
					VecVFrpdBaseTrackTrigger::VOID // stoTixVTrigger={void,reqInvCubeacqAssign,reqInvCubeacqSet}
				);

		base.track->set(
					true, // rng={false,true}
					1000000 // TCapt=[uint32]; 10 ms for fMclk = 100 MHz
				);
#endif

#ifdef DSPTRACK
		// of s*, only scollEgr, sfftPipe(ixsim only) are of interest
		const uint8_t dsptrackTixVSource = VecVFrpdBaseDsptrackSource::SCOLLEGR;
		TrackFrpdBaseDsptrack dsptrack(dsptrackTixVSource, 250000.0);
		base.dsptrack->select(
					dsptrackTixVSource, // tixVSource={scollEgr,sfftIgr,sfftPipe,semitIgr}
					VecVFrpdBaseDsptrackTrigger::ACKCUBEACQTOSFFTRUN, // staTixVTrigger={void,ackCubeacqToSfftRun}
					VecVFrpdBaseDsptrackTrigger::VOID // stoTixVTrigger={void,ackCubeacqToSfftRun}
				);

		base.dsptrack->set(
					true, // rng={false,true}
					2500000 // TCapt=[uint32]; 10 ms for fDspclk = 250 MHz
				);
#endif

#ifdef XDSPTRACK
		const uint8_t xdsptrackTixVSource = VecVFrpdBaseXdsptrackSource::LEMITIGR;
		TrackFrpdBaseXdsptrack xdsptrack(xdsptrackTixVSource, 434000.0);
		base.xdsptrack->select(
					xdsptrackTixVSource, // tixVSource={lcollEgr,lfftIgr,lfftPipe,lfftEgr,lemitIgr}
					VecVFrpdBaseXdsptrackTrigger::ACKCUBEACQTOLFFTRUN, // staTixVTrigger={void,ackCubeacqToLfftRun}
					VecVFrpdBaseXdsptrackTrigger::VOID // stoTixVTrigger={void,ackCubeacqToLfftRun}
				);

		base.xdsptrack->set(
					true, // rng={false,true}
					4340000 // TCapt=[uint32]; 10 ms for fXdspclk = 434 MHz
				);
#endif

		// switch on
		base.cubeacq->set(
					true, // rng={false,true}
					true, // ixsimNotData={false,true}
					getIxsim4DNot3D() // ixsim4DNot3D={false,true}
				);

		// - loop
		for (unsigned int i = 0; ; i++) {
			base.cubeacq->getInfo(tixVState, ixMem, tixVSuccess, tkst, ixMemLfft, ixMemSfft);

			newframe = false;

			// ixMem0: latest to have been assigned

			if (ixMem != ixMemInvalid) {
				if ((ixMem == ixMem0) || (ixMem == ixMem1)) {
					// next frame fully processed

					cout << "[" << (((double) tkst) / 10000.0) << "] new frame with ixMem = " << ((unsigned int) ixMem) << " (ixMemLfft = " << ((unsigned int) ixMemLfft) << ", ixMemSfft = " << ((unsigned int) ixMemSfft) << "); last successful FFT: " << VecVFrpdBaseCubeacqSuccess::getSref(tixVSuccess) << endl;

					// check on buf[ixMem*sizeChunk*1048576], outsourced to another thread in Frdpcmbd
					if (tixVSuccess == tixVSuccess_expect) validate2(ixMem);

					newframe = true;

					if (ixMem == ixMem0) {
						// slip case (ixMem1 result was missed)
						ixMem0 = ixMemInvalid;

						if (ixMem1 != ixMemInvalid) {
							unlock(ixMem1);
							ixMem1 = ixMemInvalid;
						};

					} else if (ixMem == ixMem1) {
						// no-slip case
						ixMem1 = ixMemInvalid;
					};
				};
			};

			//if (first) {
				if ((ixMem0 != ixMemInvalid) && (ixMem1 == ixMemInvalid) && ((ixMemLfft == ixMem0) || (ixMemSfft == ixMem0)) ) {
					// condition when processing at ixMem0 is in progress
					ixMem1 = ixMem0;

					uint8_t ixMem0_temp = dequeue(ixMem);

					if (ixMem0_temp != ixMemInvalid) {
						ixMem0 = ixMem0_temp;
						base.cubeacq->assign(ixMem0);
						cout << "assigned ixMem0 = " << ((unsigned int) ixMem0) << " on top"  << " (ixMem = " << ((unsigned int) ixMem) << ", ixMemLfft = " << ((unsigned int) ixMemLfft) << ", ixMemSfft = " << ((unsigned int) ixMemSfft) << ")" << endl;
					};

				} else if (ixMem0 == ixMemInvalid) {
					// condition at start or after slip
					uint8_t ixMem0_temp = dequeue(ixMem);

					if (ixMem0_temp != ixMemInvalid) {
						ixMem0 = ixMem0_temp;
						base.cubeacq->assign(ixMem0);
						cout << "assigned ixMem0 = " << ((unsigned int) ixMem0) << " after slip"  << " (ixMem = " << ((unsigned int) ixMem) << ", ixMemLfft = " << ((unsigned int) ixMemLfft) << ", ixMemSfft = " << ((unsigned int) ixMemSfft) << ")" << endl;
					};
				};

				first = false;
			//};

			if (newframe) {
				unlock(ixMem); // instead of processing in another thread
				nanosleep(&deltatFrame, NULL);

			} else nanosleep(&deltatFixed, NULL);

			// track, dsptrack read out
			uint8_t tixVState;

			unsigned char* coverage = NULL;
			size_t coveragelen;

			vector<bool> cvr;

			unsigned char cntbuf[256*4]; // actual buffer is 2kB to allow for parallel write
			unsigned char fstoccbuf[256*4]; // actual buffer is 2kB to allow for parallel write
			unsigned char seqbuf[1024*4];
			
			unsigned char* bufptr = NULL;
			size_t len;

#ifdef TRACK
			base.track->getInfo(tixVState, coverage, coveragelen);
			//cout << "track state is " << VecVFrpdBaseTrackState::getTitle(tixVState) << endl;

			if (tixVState != VecVFrpdBaseTrackState::DONE) {
				delete[] coverage;
				continue;
			};
#endif

#ifdef DSPTRACK
			base.dsptrack->getInfo(tixVState, coverage, coveragelen);
			//cout << "dsptrack state is " << VecVFrpdBaseDsptrackState::getTitle(tixVState) << endl;

			if (tixVState != VecVFrpdBaseDsptrackState::DONE) {
				delete[] coverage;
				continue;
			};
#endif

#ifdef XDSPTRACK
			base.xdsptrack->getInfo(tixVState, coverage, coveragelen);
			//cout << "xdsptrack state is " << VecVFrpdBaseXdsptrackState::getTitle(tixVState) << endl;

			if (tixVState != VecVFrpdBaseXdsptrackState::DONE) {
				delete[] coverage;
				continue;
			};
#endif

#ifdef TRACK
			cout << "results of track (" << VecVFrpdBaseTrackSource::getSref(trackTixVSource) << "):" << endl;

			// track (mclk)
			base.track->getInfo(tixVState, coverage, coveragelen);

			bufptr = fstoccbuf;
			base.readFstoccbufFromTrack(1024, bufptr, len);

			bufptr = cntbuf;
			base.readCntbufFromTrack(1024, bufptr, len);

			bufptr = seqbuf;
			base.readSeqbufFromTrack(4096, bufptr, len);

			track.analyzeCoverage(coverage);
			track.analyzeFstoccbuf(fstoccbuf);
			track.analyzeCntbuf(cntbuf);
			track.analyzeSeqbuf(seqbuf, 4096);

			delete[] coverage;

			base.track->set(
						false, // rng={false,true}
						0 // TCapt=[uint32]
					);
#endif

#ifdef DSPTRACK
			cout << "results of dsptrack (" << VecVFrpdBaseDsptrackSource::getSref(dsptrackTixVSource) << "):" << endl;

			// dsptrack (dspclk)
			base.dsptrack->getInfo(tixVState, coverage, coveragelen);

			bufptr = fstoccbuf;
			base.readFstoccbufFromDsptrack(1024, bufptr, len);

			bufptr = cntbuf;
			base.readCntbufFromDsptrack(1024, bufptr, len);

			bufptr = seqbuf;
			base.readSeqbufFromDsptrack(4096, bufptr, len);

			dsptrack.analyzeCoverage(coverage);
			dsptrack.analyzeFstoccbuf(fstoccbuf);
			dsptrack.analyzeCntbuf(cntbuf);
			dsptrack.analyzeSeqbuf(seqbuf, 4096);

			delete[] coverage;

			base.dsptrack->set(
						false, // rng={false,true}
						0 // TCapt=[uint32]
					);
#endif

#ifdef XDSPTRACK
			cout << "results of xdsptrack (" << VecVFrpdBaseXdsptrackSource::getSref(xdsptrackTixVSource) << "):" << endl;

			// xdsptrack (xdspclk)
			base.xdsptrack->getInfo(tixVState, coverage, coveragelen);

			bufptr = fstoccbuf;
			base.readFstoccbufFromXdsptrack(1024, bufptr, len);

			bufptr = cntbuf;
			base.readCntbufFromXdsptrack(1024, bufptr, len);

			bufptr = seqbuf;
			base.readSeqbufFromXdsptrack(4096, bufptr, len);

			xdsptrack.analyzeCoverage(coverage);
			xdsptrack.analyzeFstoccbuf(fstoccbuf);
			xdsptrack.analyzeCntbuf(cntbuf);
			xdsptrack.analyzeSeqbuf(seqbuf, 4096);

			delete[] coverage;

			base.xdsptrack->set(
						false, // rng={false,true}
						0 // TCapt=[uint32]
					);
#endif

			for (unsigned int j = 0; j < 9; j++) {
				uint32_t NRdA, NWrA, NWrB;

				base.lddrif->getStats(NWrB);
				base.sddrif->getStats(NRdA, NWrA);
				cout << "DDR memory interface NRdA = " << NRdA << ", NWrA = " << NWrA << ", NWrB = " << NWrB << endl;

				nanosleep(&deltatLong, NULL);
			};

			//cout << "abort: ";
			//cin >> c;

			//break;
		};

	} catch (DbeException& e) {
		cout << e.err << endl;
	};

	try {
		// - clean up
		base.cubeacq->set(
					false, // rng={false,true}
					false, // ixsimNotData={false,true}
					false // ixsim4DNot3D={false,true}
				);

	} catch (DbeException& e) {
		cout << e.err << endl;
	};
};

void Ixsim::stopReplay() {
#ifdef REPLAY
	replay.stream->set(false, true, 0, 0);
#endif
};

unsigned int Ixsim::dequeue(
			const unsigned int ixMemAvoid
		) {
	unsigned int ixMem;

	for (ixMem = 0; ixMem < NChunk; ixMem++)
		if (ixMem != ixMemAvoid)
			if (!icsMem[ixMem]) break;

	if (ixMem == NChunk) ixMem = ixMemInvalid;
	else icsMem[ixMem] = true;

	return ixMem;
};

void Ixsim::unlock(
			const unsigned int ixMem
		) {
	icsMem[ixMem] = false;
};

double Ixsim::getNow() {
	timespec ts;
	clock_gettime(CLOCK_REALTIME, &ts);

	return(((double) ts.tv_sec) + 1.0e-9*((double) ts.tv_nsec));
};

double Ixsim::tkstToT(
			const bool replayNotBase
			, const uint32_t tkst
		) {
	if (!replayNotBase) return(t0Base + ((double) tkst) / 10000.0);
	return(t0Replay + ((double) tkst) / 10000.0);
};

void Ixsim::validate(
			const uint8_t ixMem
		) {
	unsigned int i = 0;

	unsigned int vv, aa, ee;

	const size_t ptr0 = ixMem * sizeChunk * 1048576;

	for (unsigned int r = 0; r < R; r++)
		for (unsigned int v = 0; v < V; v++) {
			if (A == 1) vv = invertOrder(v, log2(V));
			else vv = v;

			for (unsigned int a = 0; a < A; a++) {
				if (E == 1) aa = invertOrder(a, log2(A));
				else aa = a;

				for (unsigned int e = 0; e < E; e++) {
					ee = invertOrder(e, log2(E));

					if (Ix(buf[ptr0 + 4*i], E != 1) == Ix(r, vv, aa, ee)) {
					} else {
						cout << "at position " << i << ", expected " << Ix(r, vv, aa, ee).toString() << " but found " << Ix(buf[ptr0 + 4*i], E != 1).toString() << endl;
						return;
					};

					i++;
				};
			};
		};
};


void Ixsim::validate2(
			const uint8_t ixMem
		) {
	// initial strategy: disregard r(ange) index and track first occurrence of each (v,a) combination
	// revised strategy, seeing that all (v,a) combinations are present and that r=64 typically is first, look for first occurrence of (v,a,64)

	fstream outfile, outfile2;

	bool ixsim4DNot3D = getIxsim4DNot3D();

	unsigned int rr, vv, aa, ee;

	unsigned int cnt = 0;

	const unsigned int wR = log2(R);
	const unsigned int wV = log2(V);
	const unsigned int wA = log2(A);
	const unsigned int wE = log2(E);

	size_t ptr0 = ixMem * sizeChunk * 1048576;
	// R, A: first chunk
	// V, E: second  chunk
#if (defined(_SFFT0) and !defined(_LFFT)) || (defined(_SFFT2) && !defined(_SFFT1))
	ptr0 += 32 * 1048576;
#endif
	size_t ptr;

///
	set<unsigned int> vs;
	unsigned int NValid = 0;

	unsigned int NMatch = 0; // counter for exact matches

	const unsigned int NMismatchMax = 10000;
	unsigned int NMismatch = 0;

	set<Ix> founds; // collector for (x,x,x,*) matches

	// - mask {a,e} combinations resulting from RX4..15 getting ignored in v01
	// in v02, all RX are available but keep this feature for debug
	set<AziEle> mask;
	//for (auto it = aziEles.begin(); it != aziEles.end(); it++) if (it->first.rx < 4) mask.insert(it->second);
	for (auto it = aziEles.begin(); it != aziEles.end(); it++) mask.insert(it->second);
	cout << "mask contains " << mask.size() << " elements." << endl;

	// - extract ten indices at first valid menory location within chunk (v = 0, r = 0) 
	cout << "validating ixMem = " << ((int) ixMem) << ": content is";

	ptr = 0;
	aa = 0;
	ee = 0;
	{
		auto it = mask.begin();
		if (it != mask.end()) {
			aa = (*it).azi;
			ee = (*it).ele;
		};
 	};
#if defined(_LFFT)
	// V0A0E0R ordering after lfft
	ptr = 4 * (aa*E0*R + ee*R);
#elif defined(_SFFT0)
	// A0E0R'V ordering after sfft0
	ptr = 4 * (aa*E0*R*V + ee*R*V);
#elif defined(_SFFT1)
	// E0R'V'A ordering after sfft1
	ptr = 4 * (ee*R*V*A + aa);
#elif defined(_SFFT2)
	// R'V'A'E ordering after sfft2
	aa = invertOrder(aa, wA);
	ptr = 4 * (aa*E + ee);
#endif

	for (unsigned int i = 0; i < 100; i++) {
		Ix ix(&(buf[ptr0 + ptr + 4 * i]), ixsim4DNot3D);

		cout << " " << ix.toString();
	};
	cout << endl;

	// -
	outfile.open("./validation.txt", ios::out);

#if defined(_LFFT)
	outfile << "identify first memory spot addr0 where a valid index (v,a,e,r) is found, for each (v,a,e) combination" << endl;
	outfile << "v\ta\te\tr_actual\taddr0_actual\taddr0_expected" << endl;
#elif defined(_SFFT0)
	outfile << "identify first memory spot addr0 where a valid index (a,e,r,v) is found, for each (a,e,r) combination" << endl;
	outfile << "a\te\tr\tv_actual\taddr0_actual\taddr0_expected" << endl;
#elif defined(_SFFT1)
	outfile << "identify first memory spot addr0 where a valid index (e,r,v,a) is found, for each (e,r,v) combination" << endl;
	outfile << "e\tr\tv\ta_actual\taddr0_actual\taddr0_expected" << endl;
#elif defined(_SFFT2)
	outfile << "identify first memory spot addr0 where a valid index (r,v,a,e) is found, for each (r,v,a) combination" << endl;
	outfile << "r\tv\ta\te_actual\taddr0_actual\taddr0_expected" << endl;
#endif

	outfile2.open("./mismatch.txt", ios::out);
	outfile2 << "unexpected memory content (first " << NMismatchMax << " occurrences)" << endl;
	outfile2 << "addr0\tactual\texpected" << endl;

#if defined(_LFFT)
	// V0A0E0R ordering after lfft
	for (unsigned int v = 0; v < V0; v++) {
		vv = v;
		for (unsigned int a = 0; a < A0; a++) {
			aa = a;
			for (unsigned int e = 0; e < E0; e++) {
				ee = e;
				for (unsigned int r = 0; r < R; r++) {
					rr = r;
#elif defined(_SFFT0)
	// A0E0R'V ordering after sfft0
	for (unsigned int a = 0; a < A0; a++) {
		aa = a;
		for (unsigned int e = 0; e < E0; e++) {
			ee = e;
			for (unsigned int r = 0; r < R; r++) {
				rr = invertOrder(r, wR);
				for (unsigned int v = 0; v < V; v++) {
					vv = v;
#elif defined(_SFFT1)
	// E0R'V'A ordering after sfft1
	for (unsigned int e = 0; e < E0; e++) {
		ee = e;
		for (unsigned int r = 0; r < R; r++) {
			rr = invertOrder(r, wR);
			for (unsigned int v = 0; v < V; v++) {
				vv = invertOrder(v, wV);
				for (unsigned int a = 0; a < A; a++) {
					aa = a;
#elif defined(_SFFT2)
	// R'V'A'E ordering after sfft2
	for (unsigned int r = 0; r < R; r++) {
		rr = invertOrder(r, wR);
		for (unsigned int v = 0; v < V; v++) {
			vv = invertOrder(v, wV);
			for (unsigned int a = 0; a < A; a++) {
				aa = invertOrder(a, wA);
				for (unsigned int e = 0; e < E; e++) {
					ee = e;
#endif

					if (mask.find(AziEle(a, e)) == mask.end()) continue; // for SFFT1/2, this misses out on zero-padded indices

#if defined(_LFFT)
					ptr = 4 * (vv*A0*E0*R + aa*E0*R + ee*R + rr);
#elif defined(_SFFT0)
					ptr = 4 * (aa*E0*R*V + ee*R*V + rr*V + vv);
#elif defined(_SFFT1)
					ptr = 4 * (ee*R*V*A + rr*V*A + vv*A + aa);
#elif defined(_SFFT2)
					ptr = 4 * (rr*V*A*E + vv*A*E + aa*E + ee);
#endif

					// assume there is valid data at this spot, expect non-inverted indices
					Ix ix(&(buf[ptr0 + ptr]), ixsim4DNot3D);
					if (ix == Ix(r, v, a, e)) NMatch++; // notably not (rr, vv, aa, ee) because the address order already is inverted (cf. ptr)
					else {
						if (NMismatch < NMismatchMax) outfile2 << ptr/4 << "\t" << ix.toString() << "\t" << Ix(r, v, a, e).toString() << endl;
						NMismatch++;
					};

#if defined(_LFFT)
					if ((ix.v >= V0) || (ix.a >= A0) || (ix.e >= E0) || (ix.r >= R)) {
#elif defined(_SFFT0)
					if ((ix.v >= V) || (ix.a >= A0) || (ix.e >= E0) || (ix.r >= R)) {
#elif defined(_SFFT1)
					if ((ix.v >= V) || (ix.a >= A) || (ix.e >= E0) || (ix.r >= R)) {
#elif defined(_SFFT2)
					if ((ix.v >= V) || (ix.a >= A) || (ix.e >= E) || (ix.r >= R)) {
#endif
						continue;
					};

					///
					vs.insert(ix.v);
					NValid++;

#if defined(_LFFT)
					unsigned int r_save = ix.r;
					ix.r = 0;

					if (founds.find(ix) == founds.end()) {
						//outfile << "v\ta\te\tr_actual\taddr0_actual\taddr0_expected" << endl;
						outfile << ix.v << "\t" << ix.a << "\t" << ix.e << "\t" << r_save << "\t" << ptr/4 << "\t" << (ix.v*A0*E0*R + ix.a*E0*R + ix.e*R + ix.r) << endl;
						founds.insert(ix);
					};
#elif defined(_SFFT0)
					//if ((ix.a == 43) && (ix.e == 0) && (ix.r == 50)) cout << "ix.v = " << ix.v << " @ " << ptr/4 << endl;
					unsigned int v_save = ix.v;
					ix.v = 0;

					if (founds.find(ix) == founds.end()) {
						//outfile << "a\te\tr\tv_actual\taddr0_actual\taddr0_expected" << endl;
						outfile << ix.a << "\t" << ix.e << "\t" << ix.r << "\t" << v_save << "\t" << ptr/4 << "\t" << (ix.a*E0*R*V + ix.e*R*V + invertOrder(ix.r, wR)*V + ix.v) << endl;
						founds.insert(ix);
					};
#elif defined(_SFFT1)
					unsigned int a_save = ix.a;
					ix.a = 0;

					if (founds.find(ix) == founds.end()) {
						//outfile << "e\tr\tv\ta_actual\taddr0_actual\taddr0_expected" << endl;
						outfile << ix.e << "\t" << ix.r << "\t" << ix.v << "\t" << a_save << "\t" << ptr/4 << "\t" << (ix.e*R*V*A + invertOrder(ix.r, wR)*V*A + invertOrder(ix.v, wV)*A + ix.a) << endl;
						founds.insert(ix);
					};
#elif defined(_SFFT2)
					unsigned int e_save = ix.e;
					ix.e = 0;

					if (founds.find(ix) == founds.end()) {
						//outfile << "r\tv\ta\te_actual\taddr0_actual\taddr0_expected" << endl;
						outfile << ix.r << "\t" << ix.v << "\t" << ix.a << "\t" << e_save << "\t" << ptr/4 << "\t" << (invertOrder(ix.r, wR)*V*A*E + invertOrder(ix.v, wV)*A*E + invertOrder(ix.a, wA)*E + ix.e) << endl;
						founds.insert(ix);
					};
#endif
				};
			};
		};
	};

	outfile.close();
	outfile2.close();

#if defined(_LFFT)
	cout << "exact-matched " << NMatch << " out of " << (V0 * mask.size() * R) << " expected indices (" << NMismatch << " mismatches)." << endl;
	cout << "found data for " << founds.size() << " out of " << (V * mask.size()) << " expected (V,A,E,*) combinations." << endl;
#elif defined(_SFFT0)
	cout << "exact-matched " << NMatch << " out of " << (mask.size() * R * V) << " expected indices (" << NMismatch << " mismatches)." << endl;
	cout << "found data for " << founds.size() << " out of " << (mask.size() * R) << " expected (A,E,R,*) combinations." << endl;
#elif defined(_SFFT1)
	cout << "exact-matched " << NMatch << " out of " << (R * V * mask.size()) << " expected indices (" << NMismatch << " mismatches)." << endl;
	cout << "found data for " << founds.size() << " out of ? expected (E,R,V,*) combinations." << endl;
#elif defined(_SFFT2)
	cout << "exact-matched " << NMatch << " out of " << (R * V * mask.size()) << " expected indices (" << NMismatch << " mismatches)." << endl;
	cout << "found data for " << founds.size() << " out of ? expected (R,V,A,*) combinations." << endl;
#endif

/*
	cout << "vs = {";
	for (auto it = vs.begin(); it != vs.end(); it++)
		if (it == vs.begin()) cout << *it;
		else cout << "," << *it;
	cout << "}, NValid = " << NValid << endl;
*/
};

unsigned int Ixsim::invertOrder(
			unsigned int base
			, const unsigned int w
		) {
	// ex. w=8 0000 0000 1010 0011 -> 0000 0000 1100 0101

	unsigned int inv = 0;

	for (unsigned int i = 0; i < w; i++) {
		inv <<= 1;
		if (base & 1) inv |= 1;
		base >>= 1;
	};

	return inv;
};

void Ixsim::scrubCache() {

};

/******************************************************************************
 main program
 ******************************************************************************/

int main() {
	Ixsim::pathBase = "/dev/dbeaxilite0";
	Ixsim::pathReplay = "/dev/dbeaxilite1";

	Ixsim::pathShmem = "/dev/dbeaxishmem0";

	Ixsim ixsim;

	if (ixsim.initdone) {
#ifdef REPLAY
		ixsim.startReplay(); // this sequence only works because replay doesn't look at _tready; else lcoll would be deadlocked waiting on strbFrame
		cout << "replay is running with flavor " << VecFrdpVFlavor::getTitle(Ixsim::ixFrdpVFlavor) << "." << endl;
#endif

#if defined(_LFFT)
		cout << "processing up to lfft" << endl;
#elif defined(_SFFT0)
		cout << "processing up to sfft0 (v)" << endl;
#elif defined(_SFFT1)
		cout << "processing up to sfft1 (a)" << endl;
#elif defined(_SFFT2)
		cout << "processing up to sfft2 (e)" << endl;
#endif

		ixsim.runMainLoop();

#ifdef REPLAY
		ixsim.stopReplay();
		cout << "replay is stopped." << endl;
#endif
	};

	return 0;
};
