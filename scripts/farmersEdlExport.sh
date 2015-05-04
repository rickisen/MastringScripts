#!/bin/bash
# Script that converts an edl from farmers wife, so taht it can be 
# opened problem free in finalcut 7, also cleans up some bad characters.
#
# variables
	sourceEdl="$1"
	tempEDL=/tmp/tempFarmersEDL.txt
	tempSourceEDL=/tmp/tempFarmersSourceEDL.txt
	edlTitle=$(basename "$sourceEdl")

	if [[ -z "$2" ]] ; then
		destinationEdl="$1"
	else 
		destinationEdl="$2"
	fi

# input validation
	# what input did we recieve?
	if [[ -z "$1" ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]
	then 
		echo ""
		echo "./scriptname.sh path/to/sourceEdl.edl path/to/newEdl.edl "
		echo ""
		echo "To simply convert and destroy the original run this:"
		echo "./scriptname.sh path/to/sourceEdl.edl "
		exit 1
	fi

# exec prepairation
	# remove and recreate the temporary file
	rm "$tempEDL" "$tempSourceEDL" &>/dev/null
	touch "$tempEDL" "$tempSourceEDL"

	#copy the source edl. 
	cp "$sourceEdl" "$tempSourceEDL" &>/dev/null

	# if we were only supplied one file, we are converting it, so delete it first
	if [[ "$sourceEdl" == "$destinationEdl" ]] ; then
		rm "$sourceEdl" # because we are converting the original
	fi

# main execution
	echo "TITLE: "$edlTitle"" > "$tempEDL" # Generate a new title, otherwise fcp crashes.
	cat "$tempSourceEDL" | sed -e 's/Title: /From Clip Name:  /' -e 's/ä/a/g' -e 's/å/a/g' \
			           -e 's/ö/o/g' -e s?"\""?""?g -e s?"´"?""?g -e s?"Ä"?"A"?g \
			           -e s?"!"?""?g -e s?"&"?" and "?g -e s?"Ö"?"O"?g \
			           -e s?"Å"?"A"?g -e s?"é"?"e"?g -e s?"ö"?"o"?g \
			           -e s?"_"?" "?g 		>> "$tempEDL"
            
# copy result
cp "$tempEDL" "$(dirname "$destinationEdl")"/converted-"$(basename "$destinationEdl")"

# cleanup
	# remove temporaryfiles
	rm "$tempEDL" "$tempSourceEDL"
