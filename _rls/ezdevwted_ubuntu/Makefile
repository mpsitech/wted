# file Makefile
# make file for Wted device access library, release ezdevwted_ubuntu
# copyright: (C) 2016-2020 MPSI Technologies GmbH
# author: Alexander Wirthmueller (auto-generation)
# date created: 24 Jul 2024
# IP header --- ABOVE

BUILDROOT = ${WHIZSDKROOT}/build
LIBROOT = ${WHIZSDKROOT}/lib

CPP = g++
CPPFLAGS = -std=c++11 -g -Wall -Os -pthread

STATLIB = ar
STATLIBFLAGS = rcs

INCPATH = -I$(BUILDROOT)
INCPATH += -I${WHIZSDKROOT}/build -I/usr/include/jsoncpp -I/usr/include/libxml2

PCHS = DevWted.h.gch

OBJS = Wted.o
OBJS += UntWtedCleb.o UntWtedCleb_vecs.o CtrWtedClebHostif.o CtrWtedClebIdent.o CtrWtedClebMfsmtrack0.o CtrWtedClebMfsmtrack1.o CtrWtedClebMgptrack.o CtrWtedClebRgbled0.o CtrWtedClebState.o CtrWtedClebTkclksrc.o
OBJS += UntWtedTidk.o UntWtedTidk_vecs.o CtrWtedTidkClient.o CtrWtedTidkDdrif.o CtrWtedTidkHostif.o CtrWtedTidkIdent.o CtrWtedTidkMemrdtrack.o CtrWtedTidkMemwrtrack.o CtrWtedTidkMfsmtrack0.o CtrWtedTidkMfsmtrack1.o CtrWtedTidkMgptrack.o CtrWtedTidkRgbled0.o CtrWtedTidkState.o CtrWtedTidkTkclksrc.o CtrWtedTidkTrafgen.o
OBJS += UntWtedZudk.o UntWtedZudk_vecs.o CtrWtedZudkClient.o CtrWtedZudkDdrif.o CtrWtedZudkHostif.o CtrWtedZudkIdent.o CtrWtedZudkMemrdtrack.o CtrWtedZudkMemwrtrack.o CtrWtedZudkMfsmtrack0.o CtrWtedZudkMfsmtrack1.o CtrWtedZudkMgptrack.o CtrWtedZudkRgbled0.o CtrWtedZudkState.o CtrWtedZudkTkclksrc.o CtrWtedZudkTrafgen.o

LIB = libezdevwted

.SUFFIXES: .h .h.gch .cpp

.h.h.gch :
	$(CPP) $(CPPFLAGS) $(INCPATH) -o $@ -c $<

.cpp.o:
	$(CPP) $(CPPFLAGS) $(INCPATH) -o $@ -c $<

all:	$(LIB)

$(LIB):	$(PCHS) $(OBJS)
	$(STATLIB) $(STATLIBFLAGS) $(LIB).a $(OBJS)
	rm -f *.o

install:
	mv $(LIB).a $(LIBROOT)/

clean: 
	rm -f *.gch
	rm -f *.o
