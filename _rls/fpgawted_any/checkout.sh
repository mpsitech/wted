#!/bin/bash
# file checkout.sh
# checkout script for Wted embedded system code, release fpgawted_any
# copyright: (C) 2017-2020 MPSI Technologies GmbH
# author: Alexander Wirthmueller (auto-generation)
# date created: 30 Jun 2024
# IP header --- ABOVE

if [ -z ${FPGAROOT+x} ]; then
	echo "FPGAROOT is not defined. It looks as if you didn't run a Whiznium initialization script beforehand."
	exit 1
fi

if [ $? -ne 0 ]; then
	exit
fi

if [ "$1" = "all" ]; then
	unts=("cleb" "tidk" "zudk")
else
	unts=("$@")
fi;

for var in "${unts[@]}"
do
	cp checkin_"$var".sh $FPGAROOT/"$var"/checkin.sh
	if [ 0 == 1 ]; then
		cp ../../wted/"$var"/*.ucf $FPGAROOT/"$var"/
		cp ../../wted/"$var"/*.vhd $FPGAROOT/"$var"/
	else
		cp ../../wted/"$var"/*.xdc $FPGAROOT/"$var"/"$var".srcs/constrs_1/imports/"$var"/
		cp ../../wted/"$var"/*.vhd $FPGAROOT/"$var"/"$var".srcs/sources_1/imports/"$var"/
	fi
done
