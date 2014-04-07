#!/bin/bash

# stitch.sh
# Created by Ivan Molina.
# Copyright (c) 2014 Ivan Molina. Under MIT Licence.

# Requires ImageMagick.

# USAGE: stitch.sh <basename> <levelsofdetail> <xtiles> <ytiles> <format>
# example: stitch.sh map_1 50000 20 14 png
# 		   for files following convention: map_1_50000_2_14.png

BASENAME=$1
LOD=$2
XTILES=$3
YTILES=$4
FILEFORMAT=$5
XCOUNT=1
YCOUNT=1
XARRAY=`seq 1 "$XTILES"`
YARRAY=`seq 1 "$YTILES"`
XCOMMANDSARRAY=0
YCOMMANDSARRAY=0
programname=$0

function usage {
    echo "usage: $programname <basename> <levelsofdetail> <xtiles> <ytiles> <format>"
    echo "	example: stitch.sh map_1 50000 20 14 png"
    echo "	for files following convention: map_1_50000_2_14.png"
    exit 1
}

# ImageMagick check
IMINS="$(which convert)"
if [ "$IMINS" = "" ]; then
	echo "IMAGEMAGICK not installed! "
	echo "Set IMAGEMAGICK location: "
	read -e IM
	export MAGICK_HOME="$IM"
	export PATH="$MAGICK_HOME/bin:$PATH"
	export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"
	echo "SET TO: $IM "
else
	echo "IMAGEMAGICK CONVERT detected at $IMINS"
fi

# Expression check

# Prompts

# main
mkdir "_maptmp_"$BASENAME"_"$LOD""
while [[ $XCOUNT -le $XTILES ]]; do
	for (( i = 0; i < "$YTILES"; i++ )); do
		YCOMMANDSARRAY[i]="""$BASENAME"_"$LOD"_"$XCOUNT"_$(($i + 1))."$FILEFORMAT"""
	done
	# echo "${YCOMMANDSARRAY[@]}"
	# sleep 1
	convert "${YCOMMANDSARRAY[@]}" -append _maptmp_"$BASENAME"_"$LOD"/append_"$XCOUNT"."$FILEFORMAT"
	echo "append_"$XCOUNT""
	((XCOUNT++))
done
echo "XTILES: "$XTILES
echo "XCOUNT: "$XCOUNT
echo "YTILES: "$YTILES
echo "YCOUNT: "$YCOUNT
for (( i = 0; i < "$XTILES"; i++ )); do
		XCOMMANDSARRAY[i]=""_maptmp_"$BASENAME"_"$LOD"/append_$(($i + 1))."$FILEFORMAT"""
done
# echo "${XCOMMANDSARRAY[@]}"
convert "${XCOMMANDSARRAY[@]}" +append _maptmp_"$BASENAME"_"$LOD"/comb."$FILEFORMAT"
echo "Appending done. Check temp folder"
#sleep 10
cp "_maptmp_"$BASENAME"_"$LOD"/comb."$FILEFORMAT"" ""$BASENAME"_"$LOD"_FINAL."$FILEFORMAT""
rm -r "_maptmp_"$BASENAME"_"$LOD""
echo "Finished!"