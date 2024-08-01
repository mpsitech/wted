#include <fcntl.h>
#include <string.h>
#include <sys/mman.h>

#include <dbecore/Track.h>

#include "DevWted.h"

/**
	* TrackCleb
	*/
class TrackCleb {

};

/**
	* TrackTidk
	*/
class TrackTidk {

};

/**
	* TrackZudk
	*/
class TrackZudk {

public:
	static std::string pathHw;

	constexpr static double fMclk = 100e6;
	constexpr static double fMemclk = 300e6;

	UntWtedZudk hw;

	double t0;

	bool initdone;

public:
	TrackZudk();
	~TrackZudk();

public:
	void runDebounce();
	void runCpuFpga();
	void runDdrAccess();

	void clientStoreThenLoad();

	double getNow();
	double tkstToT(const uint32_t tkst);
};
