# file Makefile
# make file for Wted interactive terminal, release wtedterm_riscv32 (ubuntu cross-compilation)
# copyright: (C) 2023 MPSI Technologies GmbH
# author: Alexander Wirthmueller (auto-generation)
# date created: 30 Jun 2024
# IP header --- ABOVE

BUILDROOT = ${WHIZSDKROOT}/build
LIBROOT = ${WHIZSDKROOT}/lib
BINROOT = ${WHIZROOT}/bin

CPP = ${TCHROOT}/riscv32-buildroot-linux-gnu-g++
CPPFLAGS = --sysroot=${SYSROOT} -std=c++11 -fstack-protector-strong -g -Wall -Os -pthread

LINK = ${TCHROOT}/riscv32-buildroot-linux-gnu-g++
LINKFLAGS = --sysroot=${SYSROOT}

INCPATH = -I=$(BUILDROOT)/ezdevwted
INCPATH += -I=${WHIZSDKROOT}/build -I=/usr/include -I=/usr/include/libxml2

OBJS = Wtedterm_exe.o

LIBPATH = -L=$(LIBROOT)
LIBPATH += -L=${WHIZSDKROOT}/lib -L=/usr/lib
LIBPATH += -L=/lib

LIBS += -lezdevwted
LIBS += -ldbecore
LIBS += -lsbecore_plus
LIBS += -lsbecore
LIBS += -ljsoncpp -lxml2
LIBS += -lpthread

EXE = Wtedterm

.SUFFIXES:	.cpp

.cpp.o :
	$(CPP) $(CPPFLAGS) $(INCPATH) -o $@ -c $<

$(EXE):	$(OBJS)
	$(LINK) $(LINKFLAGS) $(OBJS) $(LIBPATH) $(LIBS) -o $(EXE)

all:	$(EXE)
install:
	mv $(EXE) ${SYSROOT}$(BINROOT)/wtedterm/

clean:
	rm -f *.o
