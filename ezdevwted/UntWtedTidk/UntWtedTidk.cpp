/**
	* \file UntWtedTidk.cpp
	* Efinix Titanium Ti180 development kit unit (implementation)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "UntWtedTidk.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

UntWtedTidk::UntWtedTidk() : UntWted() {
	// IP constructor --- IBEGIN
	fd = 0;

	histNotDump = false;
	// IP constructor --- IEND
};

UntWtedTidk::~UntWtedTidk() {
	if (initdone) term();
};

// IP init.hdr --- RBEGIN
void UntWtedTidk::init(
			const string& _path
		) {
// IP init.hdr --- REND
	client = new CtrWtedTidkClient(this);
	ddrif = new CtrWtedTidkDdrif(this);
	hostif = new CtrWtedTidkHostif(this);
	ident = new CtrWtedTidkIdent(this);
	memrdtrack = new CtrWtedTidkMemrdtrack(this);
	memwrtrack = new CtrWtedTidkMemwrtrack(this);
	mfsmtrack0 = new CtrWtedTidkMfsmtrack0(this);
	mfsmtrack1 = new CtrWtedTidkMfsmtrack1(this);
	mgptrack = new CtrWtedTidkMgptrack(this);
	rgbled0 = new CtrWtedTidkRgbled0(this);
	state = new CtrWtedTidkState(this);
	tkclksrc = new CtrWtedTidkTkclksrc(this);
	trafgen = new CtrWtedTidkTrafgen(this);

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

void UntWtedTidk::term() {
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
	delete memrdtrack;
	delete memwrtrack;
	delete mfsmtrack0;
	delete mfsmtrack1;
	delete mgptrack;
	delete rgbled0;
	delete state;
	delete tkclksrc;
	delete trafgen;

	initdone = false;
};

bool UntWtedTidk::rx(
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

bool UntWtedTidk::tx(
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

void UntWtedTidk::flush() {
	// IP flush --- INSERT
};

uint8_t UntWtedTidk::getTixVControllerBySref(
			const string& sref
		) {
	return VecVWtedTidkController::getTix(sref);
};

string UntWtedTidk::getSrefByTixVController(
			const uint8_t tixVController
		) {
	return VecVWtedTidkController::getSref(tixVController);
};

void UntWtedTidk::fillFeedFController(
			Feed& feed
		) {
	VecVWtedTidkController::fillFeed(feed);
};

uint8_t UntWtedTidk::getTixVBufferBySref(
			const string& sref
		) {
	return VecVWtedTidkBuffer::getTix(sref);
};

string UntWtedTidk::getSrefByTixVBuffer(
			const uint8_t tixVBuffer
		) {
	return VecVWtedTidkBuffer::getSref(tixVBuffer);
};

void UntWtedTidk::fillFeedFBuffer(
			Feed& feed
		) {
	VecVWtedTidkBuffer::fillFeed(feed);
};

uint8_t UntWtedTidk::getTixVCommandBySref(
			const uint8_t tixVController
			, const string& sref
		) {
	uint8_t tixVCommand = 0xFF;

	if (tixVController == VecVWtedTidkController::CLIENT) tixVCommand = VecVWtedTidkClientCommand::getTix(sref);
	else if (tixVController == VecVWtedTidkController::DDRIF) tixVCommand = VecVWtedTidkDdrifCommand::getTix(sref);
	else if (tixVController == VecVWtedTidkController::HOSTIF) tixVCommand = VecVWtedTidkHostifCommand::getTix(sref);
	else if (tixVController == VecVWtedTidkController::IDENT) tixVCommand = VecVWtedTidkIdentCommand::getTix(sref);
	else if (tixVController == VecVWtedTidkController::MEMRDTRACK) tixVCommand = VecVWtedTidkMemrdtrackCommand::getTix(sref);
	else if (tixVController == VecVWtedTidkController::MEMWRTRACK) tixVCommand = VecVWtedTidkMemwrtrackCommand::getTix(sref);
	else if (tixVController == VecVWtedTidkController::MFSMTRACK0) tixVCommand = VecVWtedTidkMfsmtrack0Command::getTix(sref);
	else if (tixVController == VecVWtedTidkController::MFSMTRACK1) tixVCommand = VecVWtedTidkMfsmtrack1Command::getTix(sref);
	else if (tixVController == VecVWtedTidkController::MGPTRACK) tixVCommand = VecVWtedTidkMgptrackCommand::getTix(sref);
	else if (tixVController == VecVWtedTidkController::RGBLED0) tixVCommand = VecVWtedTidkRgbled0Command::getTix(sref);
	else if (tixVController == VecVWtedTidkController::STATE) tixVCommand = VecVWtedTidkStateCommand::getTix(sref);
	else if (tixVController == VecVWtedTidkController::TKCLKSRC) tixVCommand = VecVWtedTidkTkclksrcCommand::getTix(sref);
	else if (tixVController == VecVWtedTidkController::TRAFGEN) tixVCommand = VecVWtedTidkTrafgenCommand::getTix(sref);

	return tixVCommand;
};

string UntWtedTidk::getSrefByTixVCommand(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	string sref;

	if (tixVController == VecVWtedTidkController::CLIENT) sref = VecVWtedTidkClientCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedTidkController::DDRIF) sref = VecVWtedTidkDdrifCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedTidkController::HOSTIF) sref = VecVWtedTidkHostifCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedTidkController::IDENT) sref = VecVWtedTidkIdentCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedTidkController::MEMRDTRACK) sref = VecVWtedTidkMemrdtrackCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedTidkController::MEMWRTRACK) sref = VecVWtedTidkMemwrtrackCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedTidkController::MFSMTRACK0) sref = VecVWtedTidkMfsmtrack0Command::getSref(tixVCommand);
	else if (tixVController == VecVWtedTidkController::MFSMTRACK1) sref = VecVWtedTidkMfsmtrack1Command::getSref(tixVCommand);
	else if (tixVController == VecVWtedTidkController::MGPTRACK) sref = VecVWtedTidkMgptrackCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedTidkController::RGBLED0) sref = VecVWtedTidkRgbled0Command::getSref(tixVCommand);
	else if (tixVController == VecVWtedTidkController::STATE) sref = VecVWtedTidkStateCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedTidkController::TKCLKSRC) sref = VecVWtedTidkTkclksrcCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedTidkController::TRAFGEN) sref = VecVWtedTidkTrafgenCommand::getSref(tixVCommand);

	return sref;
};

void UntWtedTidk::fillFeedFCommand(
			const uint8_t tixVController
			, Feed& feed
		) {
	feed.clear();

	if (tixVController == VecVWtedTidkController::CLIENT) VecVWtedTidkClientCommand::fillFeed(feed);
	else if (tixVController == VecVWtedTidkController::DDRIF) VecVWtedTidkDdrifCommand::fillFeed(feed);
	else if (tixVController == VecVWtedTidkController::HOSTIF) VecVWtedTidkHostifCommand::fillFeed(feed);
	else if (tixVController == VecVWtedTidkController::IDENT) VecVWtedTidkIdentCommand::fillFeed(feed);
	else if (tixVController == VecVWtedTidkController::MEMRDTRACK) VecVWtedTidkMemrdtrackCommand::fillFeed(feed);
	else if (tixVController == VecVWtedTidkController::MEMWRTRACK) VecVWtedTidkMemwrtrackCommand::fillFeed(feed);
	else if (tixVController == VecVWtedTidkController::MFSMTRACK0) VecVWtedTidkMfsmtrack0Command::fillFeed(feed);
	else if (tixVController == VecVWtedTidkController::MFSMTRACK1) VecVWtedTidkMfsmtrack1Command::fillFeed(feed);
	else if (tixVController == VecVWtedTidkController::MGPTRACK) VecVWtedTidkMgptrackCommand::fillFeed(feed);
	else if (tixVController == VecVWtedTidkController::RGBLED0) VecVWtedTidkRgbled0Command::fillFeed(feed);
	else if (tixVController == VecVWtedTidkController::STATE) VecVWtedTidkStateCommand::fillFeed(feed);
	else if (tixVController == VecVWtedTidkController::TKCLKSRC) VecVWtedTidkTkclksrcCommand::fillFeed(feed);
	else if (tixVController == VecVWtedTidkController::TRAFGEN) VecVWtedTidkTrafgenCommand::fillFeed(feed);
};

Bufxf* UntWtedTidk::getNewBufxf(
			const uint8_t tixVBuffer
			, const size_t reqlen
			, unsigned char* buf
		) {
	Bufxf* bufxf = NULL;

	if (tixVBuffer == VecVWtedTidkBuffer::CNTBUFMFSMTRACK1TOHOSTIF) bufxf = getNewBufxfCntbufFromMfsmtrack1(reqlen, buf);
	else if (tixVBuffer == VecVWtedTidkBuffer::CNTBUFMFSMTRACK0TOHOSTIF) bufxf = getNewBufxfCntbufFromMfsmtrack0(reqlen, buf);
	else if (tixVBuffer == VecVWtedTidkBuffer::FSTOCCBUFMFSMTRACK1TOHOSTIF) bufxf = getNewBufxfFstoccbufFromMfsmtrack1(reqlen, buf);
	else if (tixVBuffer == VecVWtedTidkBuffer::FSTOCCBUFMFSMTRACK0TOHOSTIF) bufxf = getNewBufxfFstoccbufFromMfsmtrack0(reqlen, buf);
	else if (tixVBuffer == VecVWtedTidkBuffer::GETBUFCLIENTTOHOSTIF) bufxf = getNewBufxfGetbufFromClient(reqlen, buf);
	else if (tixVBuffer == VecVWtedTidkBuffer::SEQBUFMFSMTRACK1TOHOSTIF) bufxf = getNewBufxfSeqbufFromMfsmtrack1(reqlen, buf);
	else if (tixVBuffer == VecVWtedTidkBuffer::SEQBUFMEMWRTRACKTOHOSTIF) bufxf = getNewBufxfSeqbufFromMemwrtrack(reqlen, buf);
	else if (tixVBuffer == VecVWtedTidkBuffer::SEQBUFMEMRDTRACKTOHOSTIF) bufxf = getNewBufxfSeqbufFromMemrdtrack(reqlen, buf);
	else if (tixVBuffer == VecVWtedTidkBuffer::SEQBUFMFSMTRACK0TOHOSTIF) bufxf = getNewBufxfSeqbufFromMfsmtrack0(reqlen, buf);
	else if (tixVBuffer == VecVWtedTidkBuffer::SEQBUFMGPTRACKTOHOSTIF) bufxf = getNewBufxfSeqbufFromMgptrack(reqlen, buf);
	else if (tixVBuffer == VecVWtedTidkBuffer::SETBUFHOSTIFTOCLIENT) bufxf = getNewBufxfSetbufToClient(reqlen, buf);

	return bufxf;
};

Cmd* UntWtedTidk::getNewCmd(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVController == VecVWtedTidkController::CLIENT) cmd = CtrWtedTidkClient::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedTidkController::DDRIF) cmd = CtrWtedTidkDdrif::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedTidkController::HOSTIF) cmd = CtrWtedTidkHostif::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedTidkController::IDENT) cmd = CtrWtedTidkIdent::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedTidkController::MEMRDTRACK) cmd = CtrWtedTidkMemrdtrack::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedTidkController::MEMWRTRACK) cmd = CtrWtedTidkMemwrtrack::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedTidkController::MFSMTRACK0) cmd = CtrWtedTidkMfsmtrack0::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedTidkController::MFSMTRACK1) cmd = CtrWtedTidkMfsmtrack1::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedTidkController::MGPTRACK) cmd = CtrWtedTidkMgptrack::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedTidkController::RGBLED0) cmd = CtrWtedTidkRgbled0::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedTidkController::STATE) cmd = CtrWtedTidkState::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedTidkController::TKCLKSRC) cmd = CtrWtedTidkTkclksrc::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedTidkController::TRAFGEN) cmd = CtrWtedTidkTrafgen::getNewCmd(tixVCommand);

	return cmd;
};

Bufxf* UntWtedTidk::getNewBufxfCntbufFromMfsmtrack1(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedTidkBuffer::CNTBUFMFSMTRACK1TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedTidk::readCntbufFromMfsmtrack1(
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

Bufxf* UntWtedTidk::getNewBufxfCntbufFromMfsmtrack0(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedTidkBuffer::CNTBUFMFSMTRACK0TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedTidk::readCntbufFromMfsmtrack0(
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

Bufxf* UntWtedTidk::getNewBufxfFstoccbufFromMfsmtrack1(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedTidkBuffer::FSTOCCBUFMFSMTRACK1TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedTidk::readFstoccbufFromMfsmtrack1(
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

Bufxf* UntWtedTidk::getNewBufxfFstoccbufFromMfsmtrack0(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedTidkBuffer::FSTOCCBUFMFSMTRACK0TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedTidk::readFstoccbufFromMfsmtrack0(
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

Bufxf* UntWtedTidk::getNewBufxfGetbufFromClient(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedTidkBuffer::GETBUFCLIENTTOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedTidk::readGetbufFromClient(
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

Bufxf* UntWtedTidk::getNewBufxfSeqbufFromMfsmtrack1(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedTidkBuffer::SEQBUFMFSMTRACK1TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedTidk::readSeqbufFromMfsmtrack1(
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

Bufxf* UntWtedTidk::getNewBufxfSeqbufFromMemwrtrack(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedTidkBuffer::SEQBUFMEMWRTRACKTOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedTidk::readSeqbufFromMemwrtrack(
			const size_t reqlen
			, unsigned char*& data
			, size_t& datalen
		) {
	Bufxf* bufxf = getNewBufxfSeqbufFromMemwrtrack(reqlen, data);

	if (runBufxf(bufxf)) {
		if (!data) data = bufxf->getReadData();
		datalen = bufxf->getReadDatalen();

	} else {
		datalen = 0;

		delete bufxf;
		throw DbeException("error running readSeqbufFromMemwrtrack");
	};

	delete bufxf;
};

Bufxf* UntWtedTidk::getNewBufxfSeqbufFromMemrdtrack(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedTidkBuffer::SEQBUFMEMRDTRACKTOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedTidk::readSeqbufFromMemrdtrack(
			const size_t reqlen
			, unsigned char*& data
			, size_t& datalen
		) {
	Bufxf* bufxf = getNewBufxfSeqbufFromMemrdtrack(reqlen, data);

	if (runBufxf(bufxf)) {
		if (!data) data = bufxf->getReadData();
		datalen = bufxf->getReadDatalen();

	} else {
		datalen = 0;

		delete bufxf;
		throw DbeException("error running readSeqbufFromMemrdtrack");
	};

	delete bufxf;
};

Bufxf* UntWtedTidk::getNewBufxfSeqbufFromMfsmtrack0(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedTidkBuffer::SEQBUFMFSMTRACK0TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedTidk::readSeqbufFromMfsmtrack0(
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

Bufxf* UntWtedTidk::getNewBufxfSeqbufFromMgptrack(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedTidkBuffer::SEQBUFMGPTRACKTOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedTidk::readSeqbufFromMgptrack(
			const size_t reqlen
			, unsigned char*& data
			, size_t& datalen
		) {
	Bufxf* bufxf = getNewBufxfSeqbufFromMgptrack(reqlen, data);

	if (runBufxf(bufxf)) {
		if (!data) data = bufxf->getReadData();
		datalen = bufxf->getReadDatalen();

	} else {
		datalen = 0;

		delete bufxf;
		throw DbeException("error running readSeqbufFromMgptrack");
	};

	delete bufxf;
};

Bufxf* UntWtedTidk::getNewBufxfSetbufToClient(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedTidkBuffer::SETBUFHOSTIFTOCLIENT, true, reqlen, (txburst) ? 7 : 0, 2, buf));
};

void UntWtedTidk::writeSetbufToClient(
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
