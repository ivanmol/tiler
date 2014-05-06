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

# Check if ImageMagick is installed.
imcheck

# Create temporary directory for the unfinished stitchings.
mkdir "_maptmp_"$BASENAME"_"$LOD""

# Create the vertical stitchings based on input $XTILES .
while [[ $XCOUNT -le $XTILES ]]; do
	for (( i = 0; i < "$YTILES"; i++ )); do
    # Add to array containing commands to be run.
    # Looking for a better/cleaner alternative *help appreciated*.
		YCOMMANDSARRAY[i]="""$BASENAME"_"$LOD"_"$XCOUNT"_$(($i + 1))."$FILEFORMAT"""
	done
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

# Combine the vertical slices.
convert "${XCOMMANDSARRAY[@]}" +append _maptmp_"$BASENAME"_"$LOD"/comb."$FILEFORMAT"

# Move the output file and clean up temporary directories.
cp "_maptmp_"$BASENAME"_"$LOD"/comb."$FILEFORMAT"" ""$BASENAME"_"$LOD"_FINAL."$FILEFORMAT""
rm -r "_maptmp_"$BASENAME"_"$LOD""
echo "Finished!"


## FUNCTIONS

# Ensure the *convert* module of ImageMagick is installed.
function imcheck {
  IMINS="$(which convert)"
  if [ "$IMINS" = "" ]; then
    echo "IMAGEMAGICK/convert not installed! "
    echo "Set IMAGEMAGICK location: "
    read -e IM
    export MAGICK_HOME="$IM"
    export PATH="$MAGICK_HOME/bin:$PATH"
    export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"
    echo "SET TO: $IM "
  else
    echo "IMAGEMAGICK CONVERT detected at $IMINS"
  fi
}
