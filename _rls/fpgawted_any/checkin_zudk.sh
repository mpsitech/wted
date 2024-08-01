#!/bin/bash
# file checkin.sh
# checkin script for Avnet Zynq UltraScale+ MPSoC development kit unit of Wted embedded system code, release fpgawted_any
# copyright: (C) 2017-2020 MPSI Technologies GmbH
# author: Alexander Wirthmueller (auto-generation)
# date created: 24 Jul 2024
# IP header --- ABOVE

if [ -z ${WHIZROOT+x} ]; then
	echo "WHIZROOT is not defined. It looks as if you didn't run a Whiznium initialization script beforehand."
	exit 1
fi

export set REPROOT=${WHIZDEVROOT}/rep

cp zudk.srcs/constrs_1/imports/zudk/*.xdc $REPROOT/wted/wted/zudk/
cp zudk.srcs/sources_1/imports/zudk/*.vhd $REPROOT/wted/wted/zudk/
