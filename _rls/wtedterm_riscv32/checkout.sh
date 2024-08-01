# file checkout.sh
# checkout script for Wted interactive terminal sources, release wtedterm_riscv32 (ubuntu cross-compilation)
# copyright: (C) 2023 MPSI Technologies GmbH
# author: Alexander Wirthmueller (auto-generation)
# date created: 24 Jul 2024
# IP header --- ABOVE

if [ -z ${WHIZROOT+x} ]; then
	echo "WHIZROOT is not defined. It looks as if you didn't run a Whiznium initialization script beforehand."
	exit 1
fi

export set BUILDROOT=${SYSROOT}${WHIZSDKROOT}/build

mkdir $BUILDROOT/wtedterm

cp Makefile $BUILDROOT/wtedterm/

cp ../../wtedterm/*.h $BUILDROOT/wtedterm/
cp ../../wtedterm/*.cpp $BUILDROOT/wtedterm/
