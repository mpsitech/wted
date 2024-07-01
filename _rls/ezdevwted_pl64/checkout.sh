# file checkout.sh
# checkout script for Wted device access library sources, release ezdevwted_pl64 (ubuntu cross-compilation)
# copyright: (C) 2017-2020 MPSI Technologies GmbH
# author: Alexander Wirthmueller (auto-generation)
# date created: 30 Jun 2024
# IP header --- ABOVE

if [ -z ${WHIZROOT+x} ]; then
	echo "WHIZROOT is not defined. It looks as if you didn't run a Whiznium initialization script beforehand."
	exit 1
fi

export set BUILDROOT=${SYSROOT}${WHIZSDKROOT}/build

mkdir $BUILDROOT/ezdevwted

cp makeall.sh $BUILDROOT/ezdevwted/

cp Makefile $BUILDROOT/ezdevwted/

cp ../../ezdevwted/*.h $BUILDROOT/ezdevwted/
cp ../../ezdevwted/*.cpp $BUILDROOT/ezdevwted/

cp ../../ezdevwted/UntWtedCleb/*.h $BUILDROOT/ezdevwted/
cp ../../ezdevwted/UntWtedCleb/*.cpp $BUILDROOT/ezdevwted/

cp ../../ezdevwted/UntWtedTidk/*.h $BUILDROOT/ezdevwted/
cp ../../ezdevwted/UntWtedTidk/*.cpp $BUILDROOT/ezdevwted/

cp ../../ezdevwted/UntWtedZudk/*.h $BUILDROOT/ezdevwted/
cp ../../ezdevwted/UntWtedZudk/*.cpp $BUILDROOT/ezdevwted/
