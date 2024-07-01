/**
	* \file Wted.cpp
	* Wted global functionality and unit/controller exchange (implementation)
	* \copyright (C) 2016-2023 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "Wted.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class UntWted
 ******************************************************************************/

UntWted::UntWted()
		:
			mAccess("mAccess", "UntWted", "UntWted")
			, rwmHist("rwmHist", "UntWted", "UntWted")
		{
	initdone = false;;

	txburst = false;

	rxtxdump = false;
	histNotDump = false;
	histlimit = 100;

	NRetry = 3;

	wordlen = 1;

	timeoutDev = 10000;

	timeoutRx = 1000;
	timeoutRxWord = 1;

	rxbuf = NULL;
	txbuf = NULL;
	parbuf = NULL;
};

UntWted::~UntWted() {
	if (rxbuf) delete[] rxbuf;
	if (txbuf) delete[] txbuf;
	if (parbuf) delete[] parbuf;

	mAccess.lock("UntWted", "~UntWted");
	mAccess.unlock("UntWted", "~UntWted");
};

void UntWted::lockAccess(
			const string& who
		) {
	mAccess.lock(who);
};

void UntWted::unlockAccess(
			const string& who
		) {
	mAccess.unlock(who);
};

void UntWted::reset() {
	Cmd* cmd = new Cmd(0x00, 0x00, Cmd::VecVRettype::VOID);

	if (runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running reset");
	};

	delete cmd;
};

bool UntWted::runBufxf(
			Bufxf* bufxf
		) {
	bool success = false;

	timespec deltat;

	// single try: invoke status command on failure
	if (bufxf->writeNotRead) success = runBufxfToBuf(bufxf);
	else success = runBufxfFromBuf(bufxf);

	if (!success) {
		// wait for device to time out
		deltat.tv_sec = 0;
		deltat.tv_nsec = 1000 * timeoutDev;

		nanosleep(&deltat, NULL);
	};

	return success;
};

bool UntWted::runBufxfFromBuf(
			Bufxf* bufxf
		) {
	bool success = false;

	if (!initdone) return false;
	lockAccess("runBufxfFromBuf");

	Crc crc(0x8005, false);

	flush();

	// tx 1
	setBuffer(bufxf->tixVBuffer);
	setController(0x00);
	setBufxfop(VecDbeVBufxfop::XFER);
	setLength(bufxf->reqlen);

	crc.reset();
	crc.includeBytes(txbuf, 7);
	crc.finalize();
	setCrc(crc.crc);

	success = tx(txbuf, 9);

	// rx 1 (ack)
	if (success) success = rx(rxbuf, 1);

	if (success) success = (rxbuf[0] == 0x55); // will be 0xAA if reqlen != avllen

	// rx 2
	if (success) success = rx(bufxf->data, bufxf->reqlen+2);

	if (success) {
		crc.reset();
		crc.includeBytes(bufxf->data, bufxf->reqlen+2);
		crc.finalize();

		success = (crc.crc == 0x0000);

		if (success) bufxf->ptr = bufxf->reqlen;

		// tx 2 (ack)
		if (success) txbuf[0] = 0x55;
		else txbuf[0] = 0xAA;

		tx(txbuf, 1);
	};

	unlockAccess("runBufxfFromBuf");

	return success;
};

bool UntWted::runBufxfToBuf(
			Bufxf* bufxf
		) {
	bool success = false;

	if (!initdone) return false;
	lockAccess("runBufxfToBuf");

	Crc crc(0x8005, false);

	flush();

	// tx 1
	setBuffer(bufxf->tixVBuffer);
	setController(0x00);
	setBufxfop(VecDbeVBufxfop::XFER);
	setLength(bufxf->reqlen);

	crc.reset();
	crc.includeBytes(txbuf, 7);
	crc.finalize();
	setCrc(crc.crc);

	success = tx(txbuf, 9);

	// rx 1 (ack)
	if (success) success = rx(rxbuf, 1);

	if (success) success = (rxbuf[0] == 0x55); // will be 0xAA if reqlen > avllen

	if (success) {
		// tx 2
		crc.reset();
		crc.includeBytes(bufxf->data, bufxf->reqlen);
		crc.finalize();
		setCrc(crc.crc, &(bufxf->data[bufxf->reqlen]));

		success = tx(bufxf->data, bufxf->reqlen+2);
	};

	// rx 2 (ack)
	if (success) success = rx(rxbuf, 1);

	if (success) success = (rxbuf[0] == 0x55);

	unlockAccess("runBufxfToBuf");

	return success;
};

size_t UntWted::pollBufxf(
			Bufxf* bufxf
		) {
	bool success = false;

	uint32_t _length = 0;

	if (!initdone) return 0;
	lockAccess("pollBufxf");

	Crc crc(0x8005, false);

	flush();

	// tx 1
	setBuffer(bufxf->tixVBuffer);
	setController(0x00);
	setBufxfop(VecDbeVBufxfop::POLL);
	setLength(4);
	
	crc.reset();
	crc.includeBytes(txbuf, 7);
	crc.finalize();
	setCrc(crc.crc);

	success = tx(txbuf, 9);

	// rx 1 (ack)
	if (success) success = rx(rxbuf, 1);

	if (success) success = (rxbuf[0] == 0x55);

	// rx 2
	if (success) success = rx(rxbuf, 6);

	if (success) {
		crc.reset();
		crc.includeBytes(rxbuf, 6);
		crc.finalize();

		success = (crc.crc == 0x0000);

		if (success) _length = getBufxfLength();

		if (success) txbuf[0] = 0x55;
		else txbuf[0] = 0xAA;

		// tx 2 (ack)
		tx(txbuf, 1);
	};

	unlockAccess("pollBufxf");

	return _length;
};

bool UntWted::runCmd(
			Cmd* cmd
		) {
	bool success = false;

	timespec deltat;

	size_t buflen;

	if (!initdone) return false;
	lockAccess("runCmd");

	Crc crc(0x8005, false);

	size_t invBuflen = cmd->getInvBuflen();
	size_t retBuflen = cmd->getRetBuflen();

	cmd->parsInvToBuf(&parbuf, buflen);

	for (unsigned int i = 0; i < NRetry; i++) {
		flush();

		// - invoke

		// tx 1
		setBuffer(0x01); // hostifToCmdinv
		setController(cmd->tixVController);
		setCommand(cmd->tixVCommand);
		setLength(invBuflen);

		crc.reset();
		crc.includeBytes(txbuf, 7);
		crc.finalize();
		setCrc(crc.crc);

		success = tx(txbuf, 9);

		// rx 1 (ack)
		if (success) success = rx(rxbuf, 1);

		if (success) success = (rxbuf[0] == 0x55);

		if (success && !cmd->parsInv.empty() && (buflen != 0)) {
			// tx 2
			crc.reset();
			crc.includeBytes(parbuf, invBuflen);
			crc.finalize();

			memcpy(txbuf, parbuf, buflen);
			setCrc(crc.crc, &(txbuf[invBuflen]));

			success = tx(txbuf, invBuflen+2);

			// rx 2 (ack)
			if (success) success = rx(rxbuf, 1);

			if (success) success = (rxbuf[0] == 0x55);
		};

		if (success & !cmd->parsRet.empty()) {
			// - return

			// tx 3
			setBuffer(0x00); // cmdretToHostif
			setController(0x00);
			setBufxfop(VecDbeVBufxfop::POLL);
			setLength(4);

			crc.reset();
			crc.includeBytes(txbuf, 7);
			crc.finalize();
			setCrc(crc.crc);

			success = tx(txbuf, 9);

			// rx 3 (ack)
			if (success) success = rx(rxbuf, 1);

			if (success) success = (rxbuf[0] == 0x55);

			// rx 4
			if (success) success = rx(rxbuf, 6);

			if (success) {
				crc.reset();
				crc.includeBytes(rxbuf, 6);
				crc.finalize();

				success = true;//(crc.crc == 0x0000);

				if (success) success = (getCmdController() == cmd->tixVController);
				if (success) success = (getCmdCommand() == cmd->tixVCommand);
				if (success) success = (getCmdLength() == retBuflen);

				if (success) txbuf[0] = 0x55;
				else txbuf[0] = 0xAA;

				// tx 4 (ack)
				tx(txbuf, 1);
			};

			// rx 5
			if (success) success = rx(rxbuf, retBuflen+2);

			if (success) {
				crc.reset();
				crc.includeBytes(rxbuf, retBuflen+2);
				crc.finalize();

				success = true;//(crc.crc == 0x0000);

				if (success) cmd->bufToParsRet(rxbuf, retBuflen);

				// tx 5 (ack)
				if (success) txbuf[0] = 0x55;
				else txbuf[0] = 0xAA;

				tx(txbuf, 1);
			};
		};

		if (success) break;

		// wait for device to time out
		deltat.tv_sec = 0;
		deltat.tv_nsec = 1000 * timeoutDev;

		nanosleep(&deltat, NULL);
	};

	unlockAccess("runCmd");

	return success;
};

timespec UntWted::calcTimeout(
			const size_t length
		) {
	unsigned long us;
	timespec deltat;

	us = (length * timeoutRxWord) / wordlen + timeoutRx;

	deltat.tv_sec = us / 1000000;
	deltat.tv_nsec = 1000 * (us%1000000);

	return deltat;
};

void UntWted::setBuffer(
			const uint8_t tixVBuffer
		) {
	// txbuf byte 0
	txbuf[0] = tixVBuffer;
};

void UntWted::setController(
			const uint8_t tixVController
		) {
	// txbuf byte 1
	txbuf[1] = tixVController;
};

void UntWted::setCommand(
			const uint8_t tixVCommand
		) {
	// txbuf byte 2
	txbuf[2] = tixVCommand;
};

void UntWted::setCmdop(
			const uint8_t tixVCmdop
		) {
	// txbuf byte 2
	txbuf[2] = tixVCmdop;
};

void UntWted::setBufxfop(
			const uint8_t tixVBufxfop
		) {
	// txbuf byte 2
	txbuf[2] = tixVBufxfop;
};

void UntWted::setLength(
			const size_t length
		) {
	// txbuf bytes 3..6
	uint32_t _length = length;

	unsigned char* ptr = (unsigned char*) &_length;

	const size_t ofs = 3;

	if (Dbe::bigendian()) for (unsigned int i = 0; i < 4; i++) txbuf[ofs+i] = ptr[i];
	else for (unsigned int i = 0; i < 4; i++) txbuf[ofs+i] = ptr[4-i-1];
};

void UntWted::setCrc(
			const uint16_t crc
			, unsigned char* ptr
		) {
	// txbuf bytes 7..8 by default
	if (!ptr) ptr = &(txbuf[7]);

	unsigned char* crcptr = (unsigned char*) &crc;

	if (Dbe::bigendian()) for (unsigned int i = 0; i < 2; i++) ptr[i] = crcptr[i];
	else for (unsigned int i = 0; i < 2; i++) ptr[i] = crcptr[2-i-1];
};

uint8_t UntWted::getCmdController() {
	// rxbuf byte 0
	return rxbuf[0];
};

uint8_t UntWted::getCmdCommand() {
	// rxbuf byte 1
	return rxbuf[1];
};

size_t UntWted::getCmdLength() {
	// rxbuf bytes 2..3
	uint16_t _length = 0;

	unsigned char* lengthptr = (unsigned char*) &_length;

	const size_t ofs = 2;

	if (Dbe::bigendian()) for (unsigned int i = 0; i < 2; i++) lengthptr[i] = rxbuf[ofs+i];
	else for (unsigned int i = 0; i < 2; i++) lengthptr[2-i-1] = rxbuf[ofs+i];

	return _length;
};

size_t UntWted::getBufxfLength() {
	// rxbuf bytes 0..3
	uint32_t _length = 0;

	unsigned char* lengthptr = (unsigned char*) &_length;

	if (Dbe::bigendian()) for (unsigned int i = 0; i < 4; i++) lengthptr[i] = rxbuf[i];
	else for (unsigned int i = 0; i < 4; i++) lengthptr[4-i-1] = rxbuf[i];

	return _length;
};

bool UntWted::rx(
			unsigned char* buf
			, const size_t reqlen
		) {
	return false;
};

bool UntWted::tx(
			unsigned char* buf
			, const size_t reqlen
		) {
	return false;
};

void UntWted::flush() {
};

uint8_t UntWted::getTixVControllerBySref(
			const string& sref
		) {
	return 0xFF;
};

string UntWted::getSrefByTixVController(
			const uint8_t tixVController
		) {
	return("");
};

void UntWted::fillFeedFController(
			Feed& feed
		) {
};

uint8_t UntWted::getTixVBufferBySref(
			const string& sref
		) {
	return 0xFF;
};

string UntWted::getSrefByTixVBuffer(
			const uint8_t tixVBuffer
		) {
	return("");
};

void UntWted::fillFeedFBuffer(
			Feed& feed
		) {
};

uint8_t UntWted::getTixVCommandBySref(
			const uint8_t tixVController
			, const string& sref
		) {
	return 0xFF;
};

string UntWted::getSrefByTixVCommand(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	return("");
};

void UntWted::fillFeedFCommand(
			const uint8_t tixVController
			, Feed& feed
		) {
};

Bufxf* UntWted::getNewBufxf(
			const uint8_t tixVBuffer
			, const size_t reqlen
			, unsigned char* buf
		) {
	return NULL;
};

Cmd* UntWted::getNewCmd(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	return NULL;
};

void UntWted::parseBufxf(
			string s
			, Dbecore::Bufxf*& bufxf
		) {
	// ex. pvwabufCamacqToHostif.read(reqlen=1234)

	bool valid;

	utinyint tixVBuffer;

	string action;

	size_t reqlen = 0;

	if (bufxf) delete bufxf;
	bufxf = NULL;

	size_t ptr, ptr2;

	ptr = s.find(' ');
	while (ptr != string::npos) {
		s = s.substr(0, ptr) + s.substr(ptr+1);
		ptr = s.find(' ');
	};

	valid = (s.length() >  0);

	if (valid) valid = s[s.length()-1] == ')';

	if (valid) {
		ptr = s.find('.');
		valid = (ptr != string::npos);
	};

	if (valid) {
		tixVBuffer = getTixVBufferBySref(s.substr(0, ptr));
		valid = (tixVBuffer != 0);
	};

	if (valid) {
		ptr2 = s.find('(');
		valid = (ptr2 != string::npos);
	};

	if (valid) {
		action = s.substr(ptr+1, ptr2-ptr-1);
		valid = ((action == "read") || (action == "write") || (action == "poll"));
	};

	if (valid && ((action == "read") || (action == "write"))) {
		ptr = s.find("reqlen=");

		if (ptr != string::npos) {
			reqlen = atol(s.substr(ptr+7).c_str());

		} else valid = false;
	};

	if (valid) bufxf = getNewBufxf(tixVBuffer, reqlen, NULL);
};

string UntWted::getCmdTemplate(
			const uint8_t tixVController
			, const uint8_t tixVCommand
			, const bool invretNotInv
		) {
	string retval;

	Cmd* cmd = getNewCmd(tixVController, tixVCommand);

	if (cmd) {
		if (invretNotInv) {
			retval = cmd->parsToTemplate(true);
			if (retval != "") retval = "(" + retval + ") = ";
		};

		retval += getSrefByTixVController(tixVController);
		if (retval != "") retval += ".";
		retval += getSrefByTixVCommand(tixVController, tixVCommand);

		retval += "(" + cmd->parsToTemplate(false) + ")";

		delete cmd;
	};

	return retval;
};

void UntWted::parseCmd(
			string s
			, Dbecore::Cmd*& cmd
		) {
	string cmdsref;
	uint cmdix;

	utinyint tixVController;
	utinyint tixVCommand;

	if (cmd) delete cmd;
	cmd = NULL;

	size_t ptr;

	if (s.length() == 0) return;
	if (s[s.length()-1] != ')') return;
	s = s.substr(0, s.length()-1);
	ptr = s.find('(');
	if (ptr == string::npos) return;

	cmdix = getCmdix(s.substr(0, ptr));
	tixVController = (cmdix >> 8);
	tixVCommand = (cmdix & 0xFF);
	s = s.substr(ptr+1);

	cmd = getNewCmd(tixVController, tixVCommand);
	if (cmd) cmd->parlistToParsInv(s);
};

uint UntWted::getCmdix(
			const string& cmdsref
		) {
	utinyint tixVController = 0;
	utinyint tixVCommand = 0;

	size_t ptr;

	ptr = cmdsref.find('.');

	if (ptr != string::npos) {
		tixVController = getTixVControllerBySref(cmdsref.substr(0, ptr));
		tixVCommand = getTixVCommandBySref(tixVController, cmdsref.substr(ptr+1));

		return((tixVController << 8) + tixVCommand);

	} else return 0;
};

string UntWted::getCmdsref(
			const uint cmdix
		) {
	string cmdsref;

	utinyint tixVController = (cmdix >> 8);
	utinyint tixVCommand = (cmdix & 0xFF);

	cmdsref = getSrefByTixVController(tixVController);
	cmdsref += ".";
	cmdsref += getSrefByTixVCommand(tixVController, tixVCommand);

	return cmdsref;
};

void UntWted::clearHist() {
	rwmHist.wlock("UntWted", "clearHist");

	hist.clear();

	rwmHist.wunlock("UntWted", "clearHist");
};

void UntWted::appendToHist(
			const string& s
		) {
	rwmHist.wlock("UntWted", "appendToHist");

	while (hist.size() > histlimit) hist.pop_front();
	hist.push_back(s);

	rwmHist.wunlock("UntWted", "appendToHist");
};

void UntWted::appendToLastInHist(
			const string& s
		) {
	rwmHist.wlock("UntWted", "appendToLastInHist");

	if (!hist.empty()) hist.back() += s;

	rwmHist.wunlock("UntWted", "appendToLastInHist");
};

void UntWted::copyHist(
			vector<string>& vec
			, const bool append
		) {
	rwmHist.rlock("UntWted", "copyHist");

	if (!append) vec.clear();
	for (auto it = hist.begin(); it != hist.end(); it++) vec.push_back(*it);

	rwmHist.runlock("UntWted", "copyHist");
};

/******************************************************************************
 class CtrWted
 ******************************************************************************/

CtrWted::CtrWted(
			UntWted* unt
		) {
	this->unt = unt;
};

CtrWted::~CtrWted() {
};
