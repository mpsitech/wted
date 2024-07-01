/**
	* \file UntWtedCleb.cpp
	* Lattice CrossLink-NX Evaluation Board unit (implementation)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "UntWtedCleb.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

UntWtedCleb::UntWtedCleb() : UntWted() {
	// IP constructor --- IBEGIN
	bpsRx = 0;
	bpsTx = 0;

	fd = 0;
	// IP constructor --- IEND
};

UntWtedCleb::~UntWtedCleb() {
	if (initdone) term();
};

// IP init.hdr --- RBEGIN
void UntWtedCleb::init(
			const string& _path
			, const unsigned int _bpsRx
			, const unsigned int _bpsTx
		) {
// IP init.hdr --- REND
	hostif = new CtrWtedClebHostif(this);
	ident = new CtrWtedClebIdent(this);
	mfsmtrack0 = new CtrWtedClebMfsmtrack0(this);
	mfsmtrack1 = new CtrWtedClebMfsmtrack1(this);
	mgptrack = new CtrWtedClebMgptrack(this);
	rgbled0 = new CtrWtedClebRgbled0(this);
	state = new CtrWtedClebState(this);
	tkclksrc = new CtrWtedClebTkclksrc(this);

	// IP init.cust --- IBEGIN
	path = _path;
	bpsRx = _bpsRx;
	bpsTx = _bpsTx;

	NRetry = 3;
	timeoutRx = 25000; // in us; used in rx read() regardless of device configuration
	timeoutRxWord = (10 * 1000000) / bpsRx; // 10 bits per word

	rxbuf = new unsigned char[sizeRxbuf];
	txbuf = new unsigned char[sizeTxbuf];
	parbuf = new unsigned char[sizeParbuf];

#ifdef __linux__
	// open character device
	fd = open(path.c_str(), O_RDWR | O_NOCTTY);
	if (fd == -1) {
		fd = 0;
		throw DbeException("error opening device " + path + "");
	};

	speed_t speed;

	termios term;
	serial_struct ss;

	memset(&term, 0, sizeof(term));
	if (tcgetattr(fd, &term) != 0) throw DbeException("error getting terminal attributes");

	// 8N1, no flow control, read blocking with 100ms timeout
	cfmakeraw(&term);

	switch (bpsRx) { // ignore bpsTx
		case 300: speed = B300; break;
		case 600: speed = B600; break;
		case 1200: speed = B1200; break;
		case 2400: speed = B2400; break;
		case 4800: speed = B4800; break;
		case 9600: speed = B9600; break;
		case 19200: speed = B19200; break;
		case 57600: speed = B57600; break;
		case 115200: speed = B115200; break;
		default: speed = B38400; // used in FTDI driver for higher baud rates
	};

	cfsetispeed(&term, speed);
	cfsetospeed(&term, speed);

	term.c_iflag = 0;
	term.c_oflag = 0;

	term.c_cflag &= ~(CRTSCTS | CSIZE | CSTOPB);
	term.c_cflag |= (CLOCAL | CREAD | CS8);

	//term.c_lflag = 0;

	term.c_cc[VMIN] = 1;
	term.c_cc[VTIME] = 1;

	tcflush(fd, TCIOFLUSH);
	if (tcsetattr(fd, TCSANOW, &term) != 0) throw DbeException("error setting terminal attributes");

	if (speed == B38400) {
		if (ioctl(fd, TIOCGSERIAL, &ss) == -1) throw DbeException("error getting serial struct");

		//cout << "ss.baud_base=" << ss.baud_base << endl; // should be 60'000'000

		ss.flags &= ~ASYNC_SPD_MASK;
		ss.flags |= ASYNC_SPD_CUST;

		int div = ss.baud_base / bpsRx; // down to 12 or up to 5MHz works
		ss.custom_divisor = div; // set to 10Mbps or 1MByte/s ; for 640*480*14/8=537.6kByte/s FLIR => more than 1 image per second

		if (ioctl(fd, TIOCSSERIAL, &ss) == -1) throw DbeException("error setting serial struct");
	};
#endif
	// IP init.cust --- IEND

	initdone = true;
};

void UntWtedCleb::term() {
	// IP term.cust --- IBEGIN
#ifdef __linux__
	if (fd) {
		close(fd);
		fd = 0;
	};
#endif
	// IP term.cust --- IEND

	delete hostif;
	delete ident;
	delete mfsmtrack0;
	delete mfsmtrack1;
	delete mgptrack;
	delete rgbled0;
	delete state;
	delete tkclksrc;

	initdone = false;
};

bool UntWtedCleb::rx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: receive data from device observing history / rxtxdump settings

	// IP rx --- IBEGIN
#ifdef __linux__
	if (reqlen != 0) {
		fd_set fds;

		timeval timeout, timeout_save;

		int s;

		size_t nleft;
		int n;

		int en;

		string msg;

		FD_ZERO(&fds);
		FD_SET(fd, &fds);

		timeout_save.tv_sec = (timeoutRx + timeoutRxWord * reqlen) / 1000000;
		timeout_save.tv_usec = (timeoutRx + timeoutRxWord * reqlen) % 1000000; // timeout includes the transfer itself!

		if (rxtxdump) {
			if (!histNotDump) cout << "rx ";
			else appendToHist("rx ");
		};

		nleft = reqlen;
		en = 0;

		while (nleft > 0) {
			timeout = timeout_save;
			s = select(fd+1, &fds, NULL, NULL, &timeout);

			if (s > 0) {
				n = read(fd, &(buf[reqlen-nleft]), nleft);
				if (n >= 0) nleft -= n;
				else {
					en = errno;
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
			else appendToLastInHist(msg);
		};
	};
#endif
	// IP rx --- IEND

	return retval;
};

bool UntWtedCleb::tx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: transmit data to device observing history / rxtxdump settings

	// IP tx --- IBEGIN
	timespec deltat;

#ifdef __linux__
	if (reqlen != 0) {
		size_t nleft;
		int n;

		string msg;

		if (rxtxdump) {
			if (!histNotDump) cout << "tx ";
			else appendToHist("tx ");
		};

		nleft = reqlen;
		n = 0;

		while (nleft > 0) {
			n = write(fd, &(buf[reqlen-nleft]), nleft);

			if (n >= 0) nleft -= n;
			else break;
		};

		retval = (nleft == 0);

		if (nleft == 0) {
			// write() is non-blocking but on hw level ongoing at this stage; make sure subsequent rx() doesn't time out
			deltat.tv_sec = 0;
			deltat.tv_nsec = ((long) 1000000000) * 10 * reqlen / 9600;

			nanosleep(&deltat, NULL);
		};

		if (rxtxdump) {
			if (nleft == 0) msg = "0x" + Dbe::bufToHex(buf, reqlen, true);
			else msg = string(strerror(n));

			if (!histNotDump) cout << msg << endl;
			else appendToLastInHist(msg);
		};
	};
#endif
	// IP tx --- IEND

	return retval;
};

void UntWtedCleb::flush() {
	tcflush(fd, TCIOFLUSH); // IP flush --- ILINE
};

uint8_t UntWtedCleb::getTixVControllerBySref(
			const string& sref
		) {
	return VecVWtedClebController::getTix(sref);
};

string UntWtedCleb::getSrefByTixVController(
			const uint8_t tixVController
		) {
	return VecVWtedClebController::getSref(tixVController);
};

void UntWtedCleb::fillFeedFController(
			Feed& feed
		) {
	VecVWtedClebController::fillFeed(feed);
};

uint8_t UntWtedCleb::getTixVBufferBySref(
			const string& sref
		) {
	return VecVWtedClebBuffer::getTix(sref);
};

string UntWtedCleb::getSrefByTixVBuffer(
			const uint8_t tixVBuffer
		) {
	return VecVWtedClebBuffer::getSref(tixVBuffer);
};

void UntWtedCleb::fillFeedFBuffer(
			Feed& feed
		) {
	VecVWtedClebBuffer::fillFeed(feed);
};

uint8_t UntWtedCleb::getTixVCommandBySref(
			const uint8_t tixVController
			, const string& sref
		) {
	uint8_t tixVCommand = 0xFF;

	if (tixVController == VecVWtedClebController::HOSTIF) tixVCommand = VecVWtedClebHostifCommand::getTix(sref);
	else if (tixVController == VecVWtedClebController::IDENT) tixVCommand = VecVWtedClebIdentCommand::getTix(sref);
	else if (tixVController == VecVWtedClebController::MFSMTRACK0) tixVCommand = VecVWtedClebMfsmtrack0Command::getTix(sref);
	else if (tixVController == VecVWtedClebController::MFSMTRACK1) tixVCommand = VecVWtedClebMfsmtrack1Command::getTix(sref);
	else if (tixVController == VecVWtedClebController::MGPTRACK) tixVCommand = VecVWtedClebMgptrackCommand::getTix(sref);
	else if (tixVController == VecVWtedClebController::RGBLED0) tixVCommand = VecVWtedClebRgbled0Command::getTix(sref);
	else if (tixVController == VecVWtedClebController::STATE) tixVCommand = VecVWtedClebStateCommand::getTix(sref);
	else if (tixVController == VecVWtedClebController::TKCLKSRC) tixVCommand = VecVWtedClebTkclksrcCommand::getTix(sref);

	return tixVCommand;
};

string UntWtedCleb::getSrefByTixVCommand(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	string sref;

	if (tixVController == VecVWtedClebController::HOSTIF) sref = VecVWtedClebHostifCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedClebController::IDENT) sref = VecVWtedClebIdentCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedClebController::MFSMTRACK0) sref = VecVWtedClebMfsmtrack0Command::getSref(tixVCommand);
	else if (tixVController == VecVWtedClebController::MFSMTRACK1) sref = VecVWtedClebMfsmtrack1Command::getSref(tixVCommand);
	else if (tixVController == VecVWtedClebController::MGPTRACK) sref = VecVWtedClebMgptrackCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedClebController::RGBLED0) sref = VecVWtedClebRgbled0Command::getSref(tixVCommand);
	else if (tixVController == VecVWtedClebController::STATE) sref = VecVWtedClebStateCommand::getSref(tixVCommand);
	else if (tixVController == VecVWtedClebController::TKCLKSRC) sref = VecVWtedClebTkclksrcCommand::getSref(tixVCommand);

	return sref;
};

void UntWtedCleb::fillFeedFCommand(
			const uint8_t tixVController
			, Feed& feed
		) {
	feed.clear();

	if (tixVController == VecVWtedClebController::HOSTIF) VecVWtedClebHostifCommand::fillFeed(feed);
	else if (tixVController == VecVWtedClebController::IDENT) VecVWtedClebIdentCommand::fillFeed(feed);
	else if (tixVController == VecVWtedClebController::MFSMTRACK0) VecVWtedClebMfsmtrack0Command::fillFeed(feed);
	else if (tixVController == VecVWtedClebController::MFSMTRACK1) VecVWtedClebMfsmtrack1Command::fillFeed(feed);
	else if (tixVController == VecVWtedClebController::MGPTRACK) VecVWtedClebMgptrackCommand::fillFeed(feed);
	else if (tixVController == VecVWtedClebController::RGBLED0) VecVWtedClebRgbled0Command::fillFeed(feed);
	else if (tixVController == VecVWtedClebController::STATE) VecVWtedClebStateCommand::fillFeed(feed);
	else if (tixVController == VecVWtedClebController::TKCLKSRC) VecVWtedClebTkclksrcCommand::fillFeed(feed);
};

Bufxf* UntWtedCleb::getNewBufxf(
			const uint8_t tixVBuffer
			, const size_t reqlen
			, unsigned char* buf
		) {
	Bufxf* bufxf = NULL;

	if (tixVBuffer == VecVWtedClebBuffer::CNTBUFMFSMTRACK0TOHOSTIF) bufxf = getNewBufxfCntbufFromMfsmtrack0(reqlen, buf);
	else if (tixVBuffer == VecVWtedClebBuffer::CNTBUFMFSMTRACK1TOHOSTIF) bufxf = getNewBufxfCntbufFromMfsmtrack1(reqlen, buf);
	else if (tixVBuffer == VecVWtedClebBuffer::FSTOCCBUFMFSMTRACK0TOHOSTIF) bufxf = getNewBufxfFstoccbufFromMfsmtrack0(reqlen, buf);
	else if (tixVBuffer == VecVWtedClebBuffer::FSTOCCBUFMFSMTRACK1TOHOSTIF) bufxf = getNewBufxfFstoccbufFromMfsmtrack1(reqlen, buf);
	else if (tixVBuffer == VecVWtedClebBuffer::SEQBUFMFSMTRACK0TOHOSTIF) bufxf = getNewBufxfSeqbufFromMfsmtrack0(reqlen, buf);
	else if (tixVBuffer == VecVWtedClebBuffer::SEQBUFMFSMTRACK1TOHOSTIF) bufxf = getNewBufxfSeqbufFromMfsmtrack1(reqlen, buf);

	return bufxf;
};

Cmd* UntWtedCleb::getNewCmd(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVController == VecVWtedClebController::HOSTIF) cmd = CtrWtedClebHostif::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedClebController::IDENT) cmd = CtrWtedClebIdent::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedClebController::MFSMTRACK0) cmd = CtrWtedClebMfsmtrack0::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedClebController::MFSMTRACK1) cmd = CtrWtedClebMfsmtrack1::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedClebController::MGPTRACK) cmd = CtrWtedClebMgptrack::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedClebController::RGBLED0) cmd = CtrWtedClebRgbled0::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedClebController::STATE) cmd = CtrWtedClebState::getNewCmd(tixVCommand);
	else if (tixVController == VecVWtedClebController::TKCLKSRC) cmd = CtrWtedClebTkclksrc::getNewCmd(tixVCommand);

	return cmd;
};

Bufxf* UntWtedCleb::getNewBufxfCntbufFromMfsmtrack0(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedClebBuffer::CNTBUFMFSMTRACK0TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedCleb::readCntbufFromMfsmtrack0(
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

Bufxf* UntWtedCleb::getNewBufxfCntbufFromMfsmtrack1(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedClebBuffer::CNTBUFMFSMTRACK1TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedCleb::readCntbufFromMfsmtrack1(
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

Bufxf* UntWtedCleb::getNewBufxfFstoccbufFromMfsmtrack0(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedClebBuffer::FSTOCCBUFMFSMTRACK0TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedCleb::readFstoccbufFromMfsmtrack0(
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

Bufxf* UntWtedCleb::getNewBufxfFstoccbufFromMfsmtrack1(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedClebBuffer::FSTOCCBUFMFSMTRACK1TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedCleb::readFstoccbufFromMfsmtrack1(
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

Bufxf* UntWtedCleb::getNewBufxfSeqbufFromMfsmtrack0(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedClebBuffer::SEQBUFMFSMTRACK0TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedCleb::readSeqbufFromMfsmtrack0(
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

Bufxf* UntWtedCleb::getNewBufxfSeqbufFromMfsmtrack1(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecVWtedClebBuffer::SEQBUFMFSMTRACK1TOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWtedCleb::readSeqbufFromMfsmtrack1(
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
