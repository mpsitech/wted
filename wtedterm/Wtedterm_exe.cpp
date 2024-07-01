/**
	* \file Wtedterm_exe.cpp
	* interactive terminal for Wted version 0.1.0 (implementation)
	* \copyright (C) 2023 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 30 Jun 2024
	*/
// IP header --- ABOVE

#include "Wtedterm_exe.h"

using namespace std;
using namespace Sbecore;
using namespace Dbecore;

/******************************************************************************
 main program
 ******************************************************************************/

int main(
			int argc
			, char** argv
		) {
	string untshort;
	vector<string> untargs;

	map<string, size_t> unts = {{"cleb", 3}, {"tidk", 1}, {"zudk", 1}}; // IP unts --- RLINE

	bool valid = (argc >= 2);

	if (valid) {
		untshort = argv[1];
		for (int i = 2; i < argc; i++) untargs.push_back(argv[i]);

		auto it = unts.find(untshort);

		valid = (it != unts.end());

		if (valid) valid = (untargs.size() == it->second);
		else untshort = "";
	};

	if (!valid) {
		if (untshort == "") cout << "\tusage: './Wtedterm <unit cleb|tidk|zudk> <unit arg 1> ... <unit arg N>'" << endl;
		else {
			cout << "\tusage: './Wtedterm " << untshort;

			// IP usage2 --- RBEGIN
			if (untshort == "cleb") cout << " <path> <bpsRx> <bpsTx>";
			else if (untshort == "tidk") cout << " <path>";
			else if (untshort == "zudk") cout << " <path>";
			// IP usage2 --- REND

			cout << "'" << endl;
		};

		return 1;
	};

	UntWted* hw = NULL;
	string untsref;

	bool connected = false;

	Cmd* cmd = NULL;

	Bufxf* bufxf = NULL;
	bool pollNotXfer;

	size_t reqlen, avllen;

	string path;

	ifstream infile;
	ofstream outfile;

	time_t now;

	unsigned char* buf = NULL;
	size_t buflen;

	Feed feedFCtr;

	Feed feedFCmd;
	Feed feedFBuf;

	Feeditem* fi = NULL;
	Feeditem* fi2 = NULL;

	bool cmdDevNotInt;
	bool moreNotLast;

	vector<string> clcs;
	string clc;

	vector<string> ss;
	string s;

	char linebuf[1048576];
	size_t ptr;

	vector<string> hist;
	bool truncated;

	if (untshort == "cleb") {hw = new UntWtedCleb(); untsref = "UntWtedCleb";}
	else if (untshort == "tidk") {hw = new UntWtedTidk(); untsref = "UntWtedTidk";}
	else if (untshort == "zudk") {hw = new UntWtedZudk(); untsref = "UntWtedZudk";};

	// welcome message
	cout << "Welcome to the interactive terminal for Wted version 0.1.0, unit " << untsref << "!" << endl;

	hw->histNotDump = false;

	hw->fillFeedFController(feedFCtr);
	hw->fillFeedFBuffer(feedFBuf);

	try {
		while (clc != "quit") {
			cout << untsref;
			if (!connected) cout << " [disconnected]";
			cout << " >> ";

			clcs.clear();
			cmdDevNotInt = false;

			for (unsigned int i = 0; true; i++) {
				getline(cin, s);

				s = StrMod::spcex(s);
				if (s == "") break;

				if (i == 0) cmdDevNotInt = (s[s.length() - 1] == ')') || (s[s.length() - 1] == '\\');

				if (!cmdDevNotInt) {
					StrMod::stringToVector(s, clcs, ' ');
					moreNotLast = false;

				} else {
					moreNotLast = (s[s.length() - 1] == '\\');
					if (moreNotLast) s = StrMod::spcex(s.substr(0, s.length() - 1));

					clcs.push_back(s);
				};

				if (!moreNotLast) break;
			};

			if (clcs.size() < 1) continue;
			clc = clcs[0];

			if (!cmdDevNotInt) {
				if (clc == "cmdset") {
					cout << "\tconnect" << endl;
					cout << "\tdisconnect" << endl;
					cout << endl;

					cout << "\tshowCtrs" << endl;
					cout << "\tshowCmds [ctr]" << endl;
					cout << endl;

					cout << "\tshowBufxfs" << endl;
					cout << endl;

					cout << "\tshowRxtx" << endl;
					cout << "\thideRxtx" << endl;
					cout << endl;

					cout << "\t(or any of the device commands or buffer transfers)" << endl;
					cout << endl;

					cout << "\tquit" << endl;

				} else if (clc == "connect") {
					if (!connected) {
						// IP init --- RBEGIN
						if (untshort == "cleb") ((UntWtedCleb*) hw)->init(untargs[0], atoi(untargs[1].c_str()), atoi(untargs[2].c_str()));
						else if (untshort == "tidk") ((UntWtedTidk*) hw)->init(untargs[0]);
						else if (untshort == "zudk") ((UntWtedZudk*) hw)->init(untargs[0]);
						// IP init --- REND

						connected = true;
					};

				} else if (clc == "disconnect") {
					if (connected) {
						if (untshort == "cleb") ((UntWtedCleb*) hw)->term();
						else if (untshort == "tidk") ((UntWtedTidk*) hw)->term();
						else if (untshort == "zudk") ((UntWtedZudk*) hw)->term();

						connected = false;
					};

				} else if (clc == "showCtrs") {
					for (unsigned int i = 0; i < feedFCtr.size(); i++) {
						fi = feedFCtr.getByNum(i + 1);
						cout << "\t" << fi->sref << endl;
					};

				} else if (clc == "showCmds") {
					feedFCmd.clear();

					if (clcs.size() == 2) {
						fi = feedFCtr.getByNum(feedFCtr.getNumBySref(clcs[1]));

						if (fi) {
							hw->fillFeedFCommand(fi->ix, feedFCmd);

							for (unsigned int j = 0; j < feedFCmd.size(); j++) {
								fi2 = feedFCmd[j];
								if (fi2) cout << "\t" << hw->getCmdTemplate(fi->ix, fi2->ix, true) << endl;
							};
						};

					} else {
						for (unsigned int i = 0; i < feedFCtr.size(); i++) {
							fi = feedFCtr[i];

							hw->fillFeedFCommand(fi->ix, feedFCmd);

							for (unsigned int j = 0; j < feedFCmd.size(); j++) {
								fi2 = feedFCmd[j];
								if (fi2) cout << "\t" << hw->getCmdTemplate(fi->ix, fi2->ix, true) << endl;
							};
						};
					};

				} else if (clc == "showBufxfs") {
					for (unsigned int i = 0; i < feedFBuf.size(); i++) {
						fi = feedFBuf.getByNum(i + 1);

						bufxf = hw->getNewBufxf(fi->ix, 0, NULL);

						if (bufxf) {
							cout << "\t(avllen[uint32]) = " << fi->sref << ".poll()" << endl;
							if (!bufxf->writeNotRead) cout << "\t(file) = " << fi->sref << ".read(reqlen[uint32])" << endl;
							else cout << "\t" << fi->sref << ".write(reqlen[uint32]) with file=./" << fi->sref << ".{bin/hex}" << endl;
						};

						delete bufxf;
					};

				} else if (clc == "showRxtx") {
					hw->rxtxdump = true;

				} else if (clc == "hideRxtx") {
					hw->rxtxdump = false;

				} else if (clc == "quit") {

				} else {
					cout << "\tinvalid command!" << endl;
				};

			} else {
				for (unsigned int i = 0; i < clcs.size(); i++) {
					clc = clcs[i];

					cmd = NULL;
					hw->parseCmd(clc, cmd);

					if (cmd) {
						s = cmd->getInvText(true, &truncated);
						cout << "\t" << hw->getCmdsref(256 * cmd->tixVController + cmd->tixVCommand) << "(" << s << ")" << endl;

						hw->clearHist();
						hw->runCmd(cmd);

						for (auto it = hw->hist.begin(); it != hw->hist.end(); it++) cout << "\t\t" << *it << endl;

						s = cmd->getRetText(true, &truncated);
						cout << "\t = (" << s << ")" << endl;

						delete cmd;

					} else {
						bufxf = NULL;
						hw->parseBufxf(clc, bufxf);

						if (bufxf) {
							pollNotXfer = (bufxf->reqlen == 0);

							if (!pollNotXfer && bufxf->writeNotRead) {
								buf = new unsigned char[bufxf->reqlen];
								memset(buf, 0, bufxf->reqlen);

								if (bufxf->reqlen > 0) {
									path = "./" + hw->getSrefByTixVBuffer(bufxf->tixVBuffer) + ".hex";
									infile.open(path.c_str(), ifstream::in);
									
									if (!infile.fail()) {
										ptr = 0;

										while (infile.good() && !infile.eof()) {
											s = StrMod::readLine(infile, linebuf, 1048576);

											for (size_t ptr2 = 0; (ptr2+1) < s.length(); ptr2 += 2) {
												buf[ptr++] = Dbe::hexToBin(s.substr(ptr2, 2));
												if (ptr == bufxf->reqlen) break;
											};

											if (ptr == bufxf->reqlen) break;
										};

										infile.close();

									} else {
										path = "./" + hw->getSrefByTixVBuffer(bufxf->tixVBuffer) + ".bin";
										infile.open(path.c_str(), ifstream::binary);

										if (!infile.fail()) {
											infile.seekg(0, infile.end);
											reqlen = infile.tellg();
											infile.seekg(0, infile.beg);

											infile.read((char*) buf, min(reqlen, bufxf->reqlen));

											infile.close();

										} else path = "";
									};
								};

								bufxf->setWriteData(buf, bufxf->reqlen);

								delete[] buf;
							};

							cout << "\t" << hw->getSrefByTixVBuffer(bufxf->tixVBuffer) << ".";
							if (!pollNotXfer) {
								if (!bufxf->writeNotRead) cout << "read";
								else cout << "write";
							} else cout << "poll";
							
							cout <<  "(";
							if (!pollNotXfer) {
								cout << "reqlen=" << (int) bufxf->reqlen;
								if (bufxf->writeNotRead) {
									cout << ",file=";
									if (path != "") cout << path;
									else cout << "<not found>";
								};
							};
							cout << ")" << endl;

							hw->clearHist();
							
							if (!pollNotXfer) hw->runBufxf(bufxf);
							else avllen = hw->pollBufxf(bufxf);

							for (auto it = hw->hist.begin(); it != hw->hist.end(); it++) cout << "\t\t" << *it << endl;

							if (!pollNotXfer) {
								if  (!bufxf->writeNotRead) {
									buf = bufxf->getReadData();
									buflen = bufxf->getReadDatalen();

									time(&now);

									path = "./" + hw->getSrefByTixVBuffer(bufxf->tixVBuffer) + "_" + to_string(now) + ".hex";
									outfile.open(path.c_str(), ios::out);

									for (unsigned int i = 0; i < buflen; i++) {
										outfile << Dbe::binToHex(buf[i]);
										if (((i%32) == 31) || ((i+1) == buflen)) outfile << endl;
									};

									outfile.close();

									path = "./" + hw->getSrefByTixVBuffer(bufxf->tixVBuffer) + "_" + to_string(now) + ".bin";
									outfile.open(path.c_str(), ios::out | ios::binary);

									outfile.write((const char*) buf, buflen);

									outfile.close();

									delete[] buf;

									cout << "\t = (file={" << path.substr(0, path.length()-4) << ".hex," << path.substr(0, path.length()-4) << ".bin})" << endl;

								} else {
									cout << "\t = ()" << endl;
								};

							} else if (pollNotXfer) {
								cout << "\t = (avllen=" << (int) avllen << ")" << endl;
							};

							delete bufxf;

						} else cout << "\tinvalid device comand or buffer transfer in line " << (i+1) << endl;
					};
				};
			};
		};

	} catch (DbeException e) {
		cout << e.err << endl;
		throw;
	};

	return 0;
};
