#include "Track_exe.h"

using namespace std;
using namespace Dbecore;
using namespace Sbecore;

string TrackZudk::pathHw;

/******************************************************************************
 class TrackZudk
 ******************************************************************************/

TrackZudk::TrackZudk() {
	bool success = true;

	try {
		hw.init(pathHw);
		hw.histNotDump = false;
		//hw.rxtxdump = true;

		hw.hostif->reset();
		t0 = getNow();

	} catch (DbeException& e) {
		success = false;
	};

	initdone = success;
};

TrackZudk::~TrackZudk() {
	hw.term();
};

void TrackZudk::runDebounce() {
	cout << "running pushbutton de-bounce experiment ..." << endl;

	timespec deltatPause = {.tv_sec = 0, .tv_nsec = 10000000}; // 10 ms

	uint32_t TCaptMclk = lround(fMclk * 25e-3); // 25 ms

	utinyint tixVState;

	const size_t sizeSeqbuf = 4 * 1024;
	unsigned char seqbuf[sizeSeqbuf];
			
	unsigned char* bufptr = NULL;
	size_t len;

	vector<string> toc;
	vector<unsigned int> ts;
	vector<unsigned int> keys;
	vector<string> vals;

	Vcdwr vcdwr("Wted", "Zudk", 1.0/fMclk, 1);

	Gptrack mgptrack("mgptrack", VecVWtedZudkMgptrackCapture::getSref, sizeSeqbuf, fMclk);

	// - acqusition
	hw.mgptrack->select(
				VecVWtedZudkMgptrackTrigger::BTN0, // staTixVTrigger
				true, // staFallingNotRising
				VecVWtedZudkMgptrackTrigger::VOID, // stoTixVTrigger
				false // stoFallingNotRising
			);

	hw.mgptrack->set(
				true, // rng
				TCaptMclk // TCapt
			);

	cout << "push button now!" << endl;

	while (true) {
		hw.mgptrack->getInfo(tixVState);
		if (tixVState == VecVWtedZudkMgptrackState::DONE) break;

		nanosleep(&deltatPause, NULL);
	};

	// - read-out and analysis
	bufptr = seqbuf;
	hw.readSeqbufFromMgptrack(sizeSeqbuf, bufptr, len);
	mgptrack.analyzeSeqbuf(seqbuf, TCaptMclk); // need to limit to TCaptMclk

	mgptrack.getVcd(toc, ts, keys, vals);
	vcdwr.append(toc, 0, 1, ts, keys, vals);

	cout << "ts.size() = " << vcdwr.ts.size() << endl;

	// - write .vcd file
	vcdwr.writeVcd("./debounce.vcd");

	cout << "... done. Results in ./debounce.vcd." << endl;
};

void TrackZudk::runCpuFpga() {
	cout << "running CPU-FPGA transaction experiment ..." << endl;

	timespec deltatPause = {.tv_sec = 0, .tv_nsec = 10000000}; // 10 ms

	uint32_t TCaptMclk = lround(fMclk * 5e-3); // 5 ms

	utinyint tixVStateMfsm0, tixVStateMfsm1, tixVState;

	//const size_t sizeCvr = 256/8;
	unsigned char* cvrHostifOp = NULL;
	unsigned char* cvrTkclksrcOp = NULL;

	const size_t sizeCntbuf = 256 * 4;
	unsigned char cntbuf[sizeCntbuf];

	const size_t sizeFstoccbuf = 256 * 4;
	unsigned char fstoccbuf[sizeFstoccbuf];

	const size_t sizeSeqbuf = 1024 * 4;
	unsigned char seqbuf[sizeSeqbuf];
			
	unsigned char* bufptr = NULL;
	size_t len;

	vector<string> toc;
	vector<unsigned int> ts;
	vector<unsigned int> keys;
	vector<string> vals;

	Vcdwr vcdwr("Wted", "Zudk", 1.0/fMclk, 1);

	utinyint tixVCaptureMfsmtrack0 = VecVWtedZudkMfsmtrack0Capture::HOSTIFOP;
	Fsmtrack mfsmtrack0("mfsmtrack0", VecVWtedZudkMfsmtrack0Capture::getSref(tixVCaptureMfsmtrack0), VecVWtedZudkHostifOp::getSref, sizeSeqbuf, fMclk);

	utinyint tixVCaptureMfsmtrack1 = VecVWtedZudkMfsmtrack1Capture::TKCLKSRCOP;
	Fsmtrack mfsmtrack1("mfsmtrack1", VecVWtedZudkMfsmtrack1Capture::getSref(tixVCaptureMfsmtrack1), VecVWtedZudkTkclksrcOp::getSref, sizeSeqbuf, fMclk);

	Gptrack mgptrack("mgptrack", VecVWtedZudkMgptrackCapture::getSref, sizeSeqbuf, fMclk);

	// - acquisition
	hw.mfsmtrack0->select(tixVCaptureMfsmtrack0, VecVWtedZudkMfsmtrack0Trigger::HOSTIFRXAXISTVALID, false, VecVWtedZudkMfsmtrack0Trigger::VOID, false);
	hw.mfsmtrack0->set(true, TCaptMclk);

	hw.mfsmtrack1->select(tixVCaptureMfsmtrack1, VecVWtedZudkMfsmtrack1Trigger::HOSTIFRXAXISTVALID, false, VecVWtedZudkMfsmtrack1Trigger::VOID, false);
	hw.mfsmtrack1->set(true, TCaptMclk);

	hw.mgptrack->select(VecVWtedZudkMgptrackTrigger::HOSTIFRXAXISTVALID, false, VecVWtedZudkMgptrackTrigger::VOID, false);
	hw.mgptrack->set(true, TCaptMclk);

	hw.tkclksrc->setTkst(0x55555555); // trigger

	tixVStateMfsm0 = VecVWtedZudkMfsmtrack0State::IDLE;
	tixVStateMfsm1 = VecVWtedZudkMfsmtrack1State::IDLE;
	tixVState = VecVWtedZudkMgptrackState::IDLE;

	while (true) {
		if (tixVStateMfsm0 != VecVWtedZudkMfsmtrack0State::DONE) {
			//hw.mfsmtrack0->getInfo(tixVStateMfsm0, bufptr, len); // not possible due to how getBlob/getVblob works
			if (cvrHostifOp) delete[] cvrHostifOp;
			hw.mfsmtrack0->getInfo(tixVStateMfsm0, cvrHostifOp, len);
		};

		if (tixVStateMfsm1 != VecVWtedZudkMfsmtrack1State::DONE) {
			//hw.mfsmtrack1->getInfo(tixVStateMfsm1, bufptr, len); // not possible due to how getBlob/getVblob works
			if (cvrTkclksrcOp) delete[] cvrTkclksrcOp;
			hw.mfsmtrack1->getInfo(tixVStateMfsm1, cvrTkclksrcOp, len);
		};

		if (tixVState != VecVWtedZudkMgptrackState::DONE) hw.mgptrack->getInfo(tixVState);

		if ((tixVStateMfsm0 == VecVWtedZudkMfsmtrack0State::DONE) && (tixVStateMfsm1 == VecVWtedZudkMfsmtrack1State::DONE) && (tixVState == VecVWtedZudkMgptrackState::DONE)) break;

		nanosleep(&deltatPause, NULL);
	};

	// - read-out and analysis
	fstream txtfile;
	txtfile.open("./cpufpga.txt", ios::out);

	// mclk FSM for hostif.op
	mfsmtrack0.analyzeCoverage(cvrHostifOp);
	delete[] cvrHostifOp;

	bufptr = cntbuf;
	hw.readCntbufFromMfsmtrack0(sizeCntbuf, bufptr, len);
	mfsmtrack0.analyzeCntbuf(cntbuf);

	bufptr = fstoccbuf;
	hw.readFstoccbufFromMfsmtrack0(sizeFstoccbuf, bufptr, len);
	mfsmtrack0.analyzeFstoccbuf(fstoccbuf);

	bufptr = seqbuf;
	hw.readSeqbufFromMfsmtrack0(sizeSeqbuf, bufptr, len);
	mfsmtrack0.analyzeSeqbuf(seqbuf, TCaptMclk);

	mfsmtrack0.getVcd(toc, ts, keys, vals);
	vcdwr.append(toc, 0, 1, ts, keys, vals);

	txtfile << "### hostif.op FSM (mclk)" << endl;
	txtfile << mfsmtrack0.statsToString() << endl;
	txtfile << endl;

	// mclk FSM for tkclksrc.op
	mfsmtrack1.analyzeCoverage(cvrTkclksrcOp);
	delete[] cvrTkclksrcOp;

	bufptr = cntbuf;
	hw.readCntbufFromMfsmtrack1(sizeCntbuf, bufptr, len);
	mfsmtrack1.analyzeCntbuf(cntbuf);

	bufptr = fstoccbuf;
	hw.readFstoccbufFromMfsmtrack1(sizeFstoccbuf, bufptr, len);
	mfsmtrack1.analyzeFstoccbuf(fstoccbuf);

	bufptr = seqbuf;
	hw.readSeqbufFromMfsmtrack1(sizeSeqbuf, bufptr, len);
	mfsmtrack1.analyzeSeqbuf(seqbuf, TCaptMclk);

	mfsmtrack1.getVcd(toc, ts, keys, vals);
	vcdwr.append(toc, 0, 1, ts, keys, vals);

	txtfile << "### tkclksrc.op FSM (mclk)" << endl;
	txtfile << mfsmtrack1.statsToString() << endl;
	txtfile << endl;

	// mclk general purpose for tkst and others
	bufptr = seqbuf;
	hw.readSeqbufFromMgptrack(sizeSeqbuf, bufptr, len);
	mgptrack.analyzeSeqbuf(seqbuf, TCaptMclk);

	mgptrack.getVcd(toc, ts, keys, vals);
	vcdwr.append(toc, 0, 1, ts, keys, vals);

	txtfile.close();

	// - write .vcd file
	vcdwr.writeVcd("./cpufpga.vcd");

	cout << "... done. Results in ./cpufpga.txt and ./cpufpga.vcd." << endl;
};

void TrackZudk::runDdrAccess() {
	cout << "running time-multiplexed DDR memory access experiment ..." << endl;

	timespec deltatPause = {.tv_sec = 0, .tv_nsec = 10000000}; // 10 ms

	uint32_t TCaptMemclk = lround(fMemclk * 5e-3); // 5 ms

	utinyint tixVState;

	const size_t sizeSetbuf = 2048;
	unsigned char setbuf[sizeSetbuf];

	const size_t sizeSeqbuf = 1024 * 4;
	unsigned char seqbuf[sizeSeqbuf];
			
	unsigned char* bufptr = NULL;
	size_t len;

	vector<string> toc;
	vector<unsigned int> ts;
	vector<unsigned int> keys;
	vector<string> vals;

	Vcdwr vcdwr("Wted", "Zudk", 1.0/fMemclk, 1);

	Gptrack memwrtrack("memwrtrack", VecVWtedZudkMemwrtrackCapture::getSref, 4*1024, fMemclk);

	// - acquisition
	hw.memwrtrack->select(
				VecVWtedZudkMemwrtrackTrigger::ACKINVCLIENTSTORESETBUF, // staTixVTrigger
				false, // staFallingNotRising
				VecVWtedZudkMemwrtrackTrigger::VOID, // stoTixVTrigger
				false // stoFallingNotRising
			);

	hw.memwrtrack->set(
				true, // rng
				TCaptMemclk // TCapt
			);

	//hw.trafgen->set(true);

	for (size_t i = 0; i < sizeSetbuf; i++) setbuf[i] = (i + 128);
	hw.writeSetbufToClient(setbuf, sizeSetbuf, false);

	hw.client->storeSetbuf();

	tixVState = 0xFF;
	while (true) {
		utinyint tixVState_last = tixVState;
		hw.memwrtrack->getInfo(tixVState);
		if (tixVState != tixVState_last) cout << "now in state " << VecVWtedZudkMemwrtrackState::getSref(tixVState) << endl;

		if (tixVState == VecVWtedZudkMemwrtrackState::DONE) break;

		nanosleep(&deltatPause, NULL);
	};

	// - read-out and analysis
	bufptr = seqbuf;
	hw.readSeqbufFromMemwrtrack(sizeSeqbuf, bufptr, len);
	memwrtrack.analyzeSeqbuf(seqbuf, TCaptMemclk);

	memwrtrack.getVcd(toc, ts, keys, vals);
	vcdwr.append(toc, 0, 1, ts, keys, vals);

	// - write .vcd file
	vcdwr.writeVcd("./ddracc.vcd");

	cout << "... done. Results in ./ddracc.vcd." << endl;
};

void TrackZudk::clientStoreThenLoad() {
	// memory chunk at 768 MB via /dev/dbeaxishmem0
	unsigned char* buf = NULL;

	int fdShmem;

	cout << "Opening shared memory device ..." << endl;

	fdShmem = open("/dev/dbeaxishmem0", O_RDWR);
	if (fdShmem < 0) {
		cout << "... error" << endl;
		return;
	};

	cout << "Mapping memory ..." << endl;

	buf = (unsigned char*) mmap(NULL, 256 * 1048576, PROT_READ | PROT_WRITE, MAP_SHARED, fdShmem, 0);
	if (buf == MAP_FAILED) {
		cout << "... error" << endl;
		return;
	};

	memset(buf, 0xAA, 1048576);
	for (unsigned int i = 0; i < 256; i++) buf[i*32] = i;

	timespec deltatPause = {.tv_sec = 0, .tv_nsec = 10000000}; // 10 ms

	const size_t sizeGetbuf = 2048;
	unsigned char getbuf[sizeGetbuf];

	const size_t sizeSetbuf = 2048;
	unsigned char setbuf[sizeSetbuf];

	unsigned char* bufptr = NULL;
	size_t len;

	bool truncated;

	memset(setbuf, 0xAA, 2048);
	for (size_t i = 0; i < 64; i++) setbuf[i*32] = i;
	hw.writeSetbufToClient(setbuf, sizeSetbuf, false);

	hw.client->storeSetbuf();

	// in theory, could validate in shmem instead

	nanosleep(&deltatPause, NULL);

	hw.client->loadGetbuf();

	nanosleep(&deltatPause, NULL);

	bufptr = getbuf;
	hw.readGetbufFromClient(sizeGetbuf, bufptr, len);

	cout << "read back buffer content is: " << Dbe::bufToHex(getbuf, sizeGetbuf, true, &truncated) << endl;

	close(fdShmem);
};


double TrackZudk::getNow() {
	timespec ts;
	clock_gettime(CLOCK_REALTIME, &ts);

	return(((double) ts.tv_sec) + 1.0e-9*((double) ts.tv_nsec));
};

double TrackZudk::tkstToT(
			const uint32_t tkst
		) {
	return(t0 + ((double) tkst) / 10000.0);
};

/******************************************************************************
 main program
 ******************************************************************************/

int main(
			int argc
			, char** argv
		) {
	TrackZudk::pathHw = "/dev/dbeaxilite0";

	TrackZudk zudk;
	if (!zudk.initdone) return -1;

	zudk.runDebounce();
	zudk.runCpuFpga();
	zudk.runDdrAccess();

	zudk.clientStoreThenLoad();

	return 0;
};
