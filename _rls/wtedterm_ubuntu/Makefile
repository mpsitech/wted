# file Makefile
# make file for Wted interactive terminal, release wtedterm_ubuntu
# copyright: (C) 2023 MPSI Technologies GmbH
# author: Alexander Wirthmueller (auto-generation)
# date created: 30 Jun 2024
# IP header --- ABOVE

BUILDROOT = ${WHIZSDKROOT}/build
LIBROOT = ${WHIZSDKROOT}/lib
BINROOT = ${WHIZROOT}/bin

CPP = g++
CPPFLAGS = -std=c++11 -g -Wall -Os -pthread

LINK = g++
LINKFLAGS =

INCPATH = -I$(BUILDROOT)/ezdevwted
INCPATH += -I${WHIZSDKROOT}/build -I/usr/include/jsoncpp -I/usr/include/libxml2

OBJS = Wtedterm_exe.o

LIBPATH = -L$(LIBROOT)
LIBPATH += -L${WHIZSDKROOT}/lib -L/usr/lib/x86_64-linux-gnu
LIBPATH += -L/lib/x86_64-linux-gnu

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
	mv $(EXE) $(BINROOT)/wtedterm/

clean:
	rm -f *.o
