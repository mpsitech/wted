/**
	* \file UntWtedZudk.cpp
	* Avnet Zynq UltraScale+ MPSoC development kit unit (implementation)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "UntWtedZudk.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

UntWtedZudk::UntWtedZudk() : UntWted() {
	// IP constructor --- IBEGIN
	fd = 0;

	histNotDump = false;
	// IP constructor --- IEND
};

UntWtedZudk::~UntWtedZudk() {
	if (initdone) term();
};

// IP init.hdr --- RBEGIN
void UntWtedZudk::init(
			const string& _path
		) {
// IP init.hdr --- REND
	client = new CtrWtedZudkClient(this);
	ddrif = new CtrWtedZudkDdrif(this);
	hostif = new CtrWtedZudkHostif(this);
	ident = new CtrWtedZudkIdent(this);
	memgptrack = new CtrWtedZudkMemgptrack(this);
	mfsmtrack0 = new CtrWtedZudkMfsmtrack0(this);
	mfsmtrack1 = new CtrWtedZudkMfsmtrack1(this);
	mgptrack = new CtrWtedZudkMgptrack(this);
	rgbled0 = new CtrWtedZudkRgbled0(this);
	state = new CtrWtedZudkState(this);
	tkclksrc = new CtrWtedZudkTkclksrc(this);
	trafgen = new CtrWtedZudkTrafgen(this);

	// IP init.cust --- IBEGIN
	path = _path;

	NRetry = 5;

	rxbuf = new unsigned char[sizeRxbuf];
	txbuf = new unsigned char[sizeTxbuf];
	parbuf = new unsigned char[sizeParbuf];

	// open character device
	fd = open(path.c_str(), O_RDWR);
	if (fd == -1) {
		fd = 0;
		throw DbeException("error opening device " + path + "");
	};
	// IP init.cust --- IEND

	initdone = true;
};

void UntWtedZudk::term() {
	// IP term.cust --- IBEGIN
	if (fd) {
		close(fd);
		fd = 0;
	};
	// IP term.cust --- IEND

	delete client;
	delete ddrif;
	delete hostif;
	delete ident;
	delete memgptrack;
	delete mfsmtrack0;
	delete mfsmtrack1;
	delete mgptrack;
	delete rgbled0;
	delete state;
	delete tkclksrc;
	delete trafgen;

	initdone = false;
};

bool UntWtedZudk::rx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: receive data from device observing history / rxtxdump settings

	// IP rx --- IBEGIN
	if (reqlen != 0) {
		fd_set fds;
		timeval timeout;
		int s;

		size_t nleft;
		int n;

		int en;

		string msg;

		FD_ZERO(&fds);
		FD_SET(fd, &fds);

		timeout.tv_sec = 0;
		timeout.tv_usec = timeoutRx;

		if (rxtxdump) {
			if (!histNotDump) cout << "rx ";
			else hist.push_back("rx ");
		};

		nleft = reqlen;
		en = 0;

		while (nleft > 0) {
			s = select(fd+1, &fds, NULL, NULL, &timeout);

			if (s > 0) {
				n = read(fd, &(buf[reqlen-nleft]), nleft);

				if (n > 0) nleft -= n;
				else {
					if (n == 0) en = ETIMEDOUT; // driver transfers all data at a time or none
					else en = errno;

					break;
				};

			} else if (s == 0) {
				en = ETIMEDOUT;
				break;
			} else {
				en = errno;
			};
		};

		retval = (nleft == 0);

		if (rxtxdump) {
			if (nleft == 0) msg = "0x" + Dbe::bufToHex(buf, reqlen, true);
			else msg = string(strerror(en));
			
			if (!histNotDump) cout << msg << endl;
			else hist.back() += msg;
		};
	};
	// IP rx --- IEND

	return retval;
};

bool UntWtedZudk::tx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: transmit data to device observing history / rxtxdump settings

	// IP tx --- IBEGIN
	if (reqlen != 0) {
		size_t nleft;
		int n;

		string msg;

		if (rxtxdump) {
			if (!histNotDump) cout << "tx ";
			else hist.push_back("tx ");
		};

		nleft = reqlen;
		n = 0;

		while (nleft > 0) {
			n = write(fd, &(buf[reqlen-nleft]), nleft);

			if (n > 0) nleft -= n; // driver transfers all data at a time or none
			else break;
		};

		retval = (nleft == 0);

		if (rxtxdump) {
			if (nleft == 0) msg = "0x" + Dbe::bufToHex(buf, reqlen, true);
			else msg = string(strerror(n));

			if (!histNotDump) cout << msg << endl;
			else hist.back() += msg;
		};
	};
	// IP tx --- IEND

	return retval;
};

void UntWtedZudk::flush() {
	// IP flush --- INSERT
};

uint8_t UntWtedZudk::getTixVControllerBySref(
			const string& sref
		) {
	return VecVWtedZudkController::getTix(sref);
};

string UntWtedZudk::getSrefByTixVController(
			const uint8_t tixVController
		) {
	return VecVWtedZudkController::getSref(tixVController);
};

void UntWtedZudk::fillFeedFController(
			Feed& feed
		) {
	VecVWtedZudkController::fillFeed(feed);
};

uint8_t UntWtedZudk::getTixVBufferBySref(
			const string& sref
		) {
	return VecVWtedZudkBuffer::getTix(sref);
};

string UntWtedZudk::getSrefByTixVBuffer(
			const uint8_t tixVBuffer
		) {
	return VecVWtedZudkBuffer::getSref(tixVBuffer);
};

void UntWtedZudk::fillFeedFBuffer(
			Feed& feed
		) {
	VecVWtedZudkBuffer::fillFeed(feed);
};

uint8_t UntWtedZudk::getTixVCommandBySref(
			const uint8_t tixVController
			, const string& sref
		) {
	uint8_t tixVCommand = 0xFF;

	if (tixVController == VecVWtedZudkController::CLIENT) tixVCommand = VecVWtedZudkClientCommand::getTix(sref);
	else if (tixVController == VecVWtedZudkController::DDRIF) tixVCommand = VecVWtedZudkDdrifCommand::getTix(sref);
	else if (tixVController == VecVWtedZudkController::HOSTIF) tixVCommand = VecVWtedZudkHostifCommand::getTix(sref);
	else if (tixVController == VecVWtedZudkController::IDENT) tixVCommand = VecVWtedZudkIdentCommand::getTix(sref);
	else if (tixVController == VecVWtedZudkController::MEMGPTRACK) tixVCommand = VecVWtedZudkMemgptrackCommand::getTix(sref);
	else if (tixVController == VecVWtedZudkController::MFSMTRACK0) tixVCommand = VecVWtedZudkMfsmtrack0Command::getTix(sref);
	else if (tixVController == VecVWtedZudkController::MFSMTRACK1) tixVCommand = VecVWtedZudkMfsmtrack1Command::getTix(sref);
	else if (tixVController == VecVWtedZudkController::MGPTRACK) tixVCommand = VecVWtedZudkMgptrackCommand::getTix(sref);
	else if (tixVController == VecVWtedZudkController::RGBLED0) tixVCommand = VecVWtedZudkRgbled0Command::getTix(sref);
	else if (tixVController == VecVWtedZudkController::STATE) tixVCommand = VecVWtedZudkStateCommand::getTix(sref);
	else if (tixVController == VecVWtedZudkController::TKCLKSRC) tixVCommand = VecVWtedZudkTkclksrcCommand::getTix(sref);
	else if (tixVController == VecVWtedZudkController::TRAFGEN) tixVCommand = VecVWtedZudkTrafgenCommand::getTix(sref);

	return tixVCommand;
};

string UntWtedZudk::getSrefByTixVCommand(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	string sref;

	if (tixVController == VecVWtedZudkController::CLIENT) sref = VecVWtedZudkClientCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedZudkController::DDRIF) sref = VecVWtedZudkDdrifCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedZudkController::HOSTIF) sref = VecVWtedZudkHostifCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedZudkController::IDENT) sref = VecVWtedZudkIdentCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedZudkController::MEMGPTRACK) sref = VecVWtedZudkMemgptrackCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedZudkController::MFSMTRACK0) sref = VecVWtedZudkMfsmtrack0Command::getSref(tixVCommand);
	else if (tixVController == VecVWtedZudkController::MFSMTRACK1) sref = VecVWtedZudkMfsmtrack1Command::getSref(tixVCommand);
	else if (tixVController == VecVWtedZudkController::MGPTRACK) sref = VecVWtedZudkMgptrackCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedZudkController::RGBLED0) sref = VecVWtedZudkRgbled0Command::getSref(tixVCommand);
	else if (tixVController == VecVWtedZudkController::STATE) sref = VecVWtedZudkStateCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedZudkController::TKCLKSRC) sref = VecVWtedZudkTkclksrcCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedZudkController::TRAFGEN) sref = VecVWtedZudkTrafgenCommand::getSref(tixVCommand);

	return sref;
};

void UntWtedZudk::fillFeedFCommand(
			const uint8_t tixVController
			, Feed& feed
		) {
	feed.clear();

	if (tixVController == VecVWtedZudkController::CLIENT) VecVWtedZudkClientCommand::fillFeed(feed);
	else if (tixVController == VecVWtedZudkController::DDRIF) VecVWtedZudkDdrifCommand::fillFeed(feed);
	else if (tixVController == VecVWtedZudkController::HOSTIF) VecVWtedZudkHostifCommand::fillFeed(feed);
	else if (tixVController == VecVWtedZudkController::IDENT) VecVWtedZudkIdentCommand::fillFeed(feed);
	else if (tixVController == VecVWtedZudkController::MEMGPTRACK) VecVWtedZudkMemgptrackCommand::fillFeed(feed);
	else if (tixVController == VecVWtedZudkController::MFSMTRACK0) VecVWtedZudkMfsmtrack0Command::fillFeed(feed);
	else if (tixVController == VecVWtedZudkController::MFSMTRACK1) VecVWtedZudkMfsmtrack1Command::fillFeed(feed);
	else if (tixVController == VecVWtedZudkController::MGPTRACK) VecVWtedZudkMgptrackCommand::fillFeed(feed);
	else if (tixVController == VecVWtedZudkController::RGBLED0) VecVWtedZudkRgbled0Command::fillFeed(feed);
	else if (tixVController == VecVWtedZudkController::STATE) VecVWtedZudkStateCommand::fillFeed(feed);
	else if (tixVController == VecVWtedZudkController::TKCLKSRC) VecVWtedZudkTkclksrcCommand::fillFeed(feed);
	else if (tixVController == VecVWtedZudkController::TRAFGEN) VecVWtedZudkTrafgenCommand::fillFeed(feed);
};

Bufxf* UntWtedZudk::getNewBufxf(
			const uint8_t tixVBuffer
			, const size_t reqlen
			, unsigned char* buf
		) {
	Bufxf* bufxf = NULL;

	if (tixVBuffer == VecVWtedZudkBuffer::CNTBUFMFSMTRACK0TOHOSTIF) bufxf = getNewBufxfCntbufFromMfsmtrack0(reqlen, buf);
	else if (tixVBuffer == VecVWtedZudkBuffer::CNTBUFMFSMTRACK1TOHOSTIF) bufxf = getNewBufxfCntbufFromMfsmtrack1(reqlen, buf);
	else if (tixVBuffer == VecVWtedZudkBuffer::FSTOCCBUFMFSMTRACK0TOHOSTIF) bufxf = getNewBufxfFstoccbufFromMfsmtrack0(reqlen, buf);
	else if (tixVBuffer == VecVWtedZudkBuffer::FSTOCCBUFMFSMTRACK1TOHOSTIF) bufxf = getNewBufxfFstoccbufFromMfsmtrack1(reqlen, buf);
	else if (tixVBuffer == VecVWtedZudkBuffer::GETBUFCLIENTTOHOSTIF) bufxf = getNewBufxfGetbufFromClient(reqlen, buf);
	else if (tixVBuffer == VecVWtedZudkBuffer::SEQBUFMFSMTRACK0TOHOSTIF) bufxf = getNewBufxfSeqbufFromMfsmtrack0(reqlen, buf);
	else if (tixVBuffer == VecVWtedZudkBuffer::SEQBUFMFSMTRACK1TOHOSTIF) bufxf = getNewBufxfSeqbufFromMfsmtrack1(reqlen, buf);
	else if (tixVBuffer == VecVWtedZudkBuffer::SETBUFHOSTIFTOCLIENT) bufxf = getNewBufxfSetbufToClient(reqlen, buf);

	return bufxf;
};

Cmd* UntWtedZudk::getNewCmd(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVController == VecVWtedZudkController::CLIENT) cmd = CtrWtedZudkClient::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedZudkController::DDRIF) cmd = CtrWtedZudkDdrif::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedZudkController::HOSTIF) cmd = CtrWtedZudkHostif::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedZudkController::IDENT) cmd = CtrWtedZudkIdent::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedZudkController::MEMGPTRACK) cmd = CtrWtedZudkMemgptrack::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedZudkController::MFSMTRACK0) cmd = CtrWtedZudkMfsmtrack0::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedZudkController::MFSMTRACK1) cmd = CtrWtedZudkMfsmtrack1::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedZudkController::MGPTRACK) cmd = CtrWtedZudkMgptrack::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedZudkController::RGBLED0) cmd = CtrWtedZudkRgbled0::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedZudkController::STATE) cmd = CtrWtedZudkState::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedZudkController::TKCLKSRC) cmd = CtrWtedZudkTkclksrc::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedZudkController::TRAFGEN) cmd = CtrWtedZudkTrafgen::getNewCmd(tixVCommand);

	return cmd;
};

Bufxf* UntWtedZudk::getNewBufxfCntbufFromMfsmtrack0(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedZudkBuffer::CNTBUFMFSMTRACK0TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedZudk::readCntbufFromMfsmtrack0(
			const size_t reqlen
			, unsigned char*& data
			, size_t& datalen
		) {
	Bufxf* bufxf = getNewBufxfCntbufFromMfsmtrack0(reqlen, data);

	if (runBufxf(bufxf)) {
		if (!data) data = bufxf->getReadData();
		datalen = bufxf->getReadDatalen();

	} else {
		datalen = 0;

		delete bufxf;
		throw DbeException("error running readCntbufFromMfsmtrack0");
	};

	delete bufxf;
};

Bufxf* UntWtedZudk::getNewBufxfCntbufFromMfsmtrack1(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedZudkBuffer::CNTBUFMFSMTRACK1TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedZudk::readCntbufFromMfsmtrack1(
			const size_t reqlen
			, unsigned char*& data
			, size_t& datalen
		) {
	Bufxf* bufxf = getNewBufxfCntbufFromMfsmtrack1(reqlen, data);

	if (runBufxf(bufxf)) {
		if (!data) data = bufxf->getReadData();
		datalen = bufxf->getReadDatalen();

	} else {
		datalen = 0;

		delete bufxf;
		throw DbeException("error running readCntbufFromMfsmtrack1");
	};

	delete bufxf;
};

Bufxf* UntWtedZudk::getNewBufxfFstoccbufFromMfsmtrack0(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedZudkBuffer::FSTOCCBUFMFSMTRACK0TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedZudk::readFstoccbufFromMfsmtrack0(
			const size_t reqlen
			, unsigned char*& data
			, size_t& datalen
		) {
	Bufxf* bufxf = getNewBufxfFstoccbufFromMfsmtrack0(reqlen, data);

	if (runBufxf(bufxf)) {
		if (!data) data = bufxf->getReadData();
		datalen = bufxf->getReadDatalen();

	} else {
		datalen = 0;

		delete bufxf;
		throw DbeException("error running readFstoccbufFromMfsmtrack0");
	};

	delete bufxf;
};

Bufxf* UntWtedZudk::getNewBufxfFstoccbufFromMfsmtrack1(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedZudkBuffer::FSTOCCBUFMFSMTRACK1TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedZudk::readFstoccbufFromMfsmtrack1(
			const size_t reqlen
			, unsigned char*& data
			, size_t& datalen
		) {
	Bufxf* bufxf = getNewBufxfFstoccbufFromMfsmtrack1(reqlen, data);

	if (runBufxf(bufxf)) {
		if (!data) data = bufxf->getReadData();
		datalen = bufxf->getReadDatalen();

	} else {
		datalen = 0;

		delete bufxf;
		throw DbeException("error running readFstoccbufFromMfsmtrack1");
	};

	delete bufxf;
};

Bufxf* UntWtedZudk::getNewBufxfGetbufFromClient(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedZudkBuffer::GETBUFCLIENTTOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedZudk::readGetbufFromClient(
			const size_t reqlen
			, unsigned char*& data
			, size_t& datalen
		) {
	Bufxf* bufxf = getNewBufxfGetbufFromClient(reqlen, data);

	if (runBufxf(bufxf)) {
		if (!data) data = bufxf->getReadData();
		datalen = bufxf->getReadDatalen();

	} else {
		datalen = 0;

		delete bufxf;
		throw DbeException("error running readGetbufFromClient");
	};

	delete bufxf;
};

Bufxf* UntWtedZudk::getNewBufxfSeqbufFromMfsmtrack0(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedZudkBuffer::SEQBUFMFSMTRACK0TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedZudk::readSeqbufFromMfsmtrack0(
			const size_t reqlen
			, unsigned char*& data
			, size_t& datalen
		) {
	Bufxf* bufxf = getNewBufxfSeqbufFromMfsmtrack0(reqlen, data);

	if (runBufxf(bufxf)) {
		if (!data) data = bufxf->getReadData();
		datalen = bufxf->getReadDatalen();

	} else {
		datalen = 0;

		delete bufxf;
		throw DbeException("error running readSeqbufFromMfsmtrack0");
	};

	delete bufxf;
};

Bufxf* UntWtedZudk::getNewBufxfSeqbufFromMfsmtrack1(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedZudkBuffer::SEQBUFMFSMTRACK1TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedZudk::readSeqbufFromMfsmtrack1(
			const size_t reqlen
			, unsigned char*& data
			, size_t& datalen
		) {
	Bufxf* bufxf = getNewBufxfSeqbufFromMfsmtrack1(reqlen, data);

	if (runBufxf(bufxf)) {
		if (!data) data = bufxf->getReadData();
		datalen = bufxf->getReadDatalen();

	} else {
		datalen = 0;

		delete bufxf;
		throw DbeException("error running readSeqbufFromMfsmtrack1");
	};

	delete bufxf;
};

Bufxf* UntWtedZudk::getNewBufxfSetbufToClient(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedZudkBuffer::SETBUFHOSTIFTOCLIENT, true, reqlen, (txburst) ? 7 : 0, 2, buf));
};

void UntWtedZudk::writeSetbufToClient(
			const unsigned char* data
			, const size_t datalen
			, const bool copy
		) {
	Bufxf* bufxf;

	if (copy) {
		bufxf = getNewBufxfSetbufToClient(datalen, (unsigned char*) data);
		bufxf->setWriteData(data, datalen);
	} else bufxf = getNewBufxfSetbufToClient(datalen, (unsigned char*) data);

	if (!runBufxf(bufxf)) {
		delete bufxf;
		throw DbeException("error running writeSetbufToClient");
	};

	delete bufxf;
};
