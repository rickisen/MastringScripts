#!/bin/bash

# script for converting a edl from Final cut Pro 7 (cmx3600, with clipnames as comments) 
# to a format suitable for farmers wife to read in to a new mastertape

# variables
	sourceEdl="$1"
	tempEDL=/tmp/tempEDL.txt
	tempSourceEDL=/tmp/tempSourceEDL.txt

	if [[ -z "$2" ]] ; then
		destinationEdl="$1"
	else 
		destinationEdl="$2"
	fi

# input validation
	# are they empty?
	if [[ -z "$1" ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]
	then 
		echo ""
		echo "./scriptname.sh path/to/sourceEdl.edl path/to/newEdl.edl "
		echo ""
		echo "To simply convert and destroy the original run this:"
		echo "./scriptname.sh path/to/sourceEdl.edl "
		exit 1
	fi

# loop prepairation
	# remove and recreate the temporary file
	rm "$tempEDL" "$tempSourceEDL" &>/dev/null
	touch "$tempEDL" "$tempSourceEDL"

	#copy and tidy up the source edl. 
	cat "$sourceEdl" | tr '\r' '\n' >> "$tempSourceEDL"

	# if we were only supplied one file, we are converting it, so delete it first
	if [[ "$sourceEdl" == "$destinationEdl" ]] ; then
		rm "$sourceEdl" # because we are converting the original
	fi

	# fix destination-name prefix
	destinationEdl="$( dirname "$destinationEdl")"/converted-"$(basename "$destinationEdl" )"

	touch "$destinationEdl"
	
# main loop
	# loop through each line in the source 
	while read line
	do
		# if the line is either a time code line, 
		# or a filename description, let it pass to the output
		if $( echo "$line" | grep -q "FROM CLIP NAME"  )
		then
			echo "$line" >> "$tempEDL"
			echo "" >> "$tempEDL"
		elif $( echo "$line" | awk '{print $1}' | grep -q '[0-9][0-9]') 
		then
			echo "$line" >> "$tempEDL"
		fi
	done < "$tempSourceEDL"

# tidy up the resulting file
	# remove From clip name field and stylize the output some
	# and output to destination
	cat "$tempEDL" | sed -e s?"* FROM CLIP NAME:  "?""?g 		\
			     -e s?".MOV"?""?g		     	 	\
			     -e s?"_"?" "?g 		     	 	\
			     -e s?"PRORES4444"?""?g 	     	 	\
			     -e s?"PRORES422HQ"?""?g 	     	 	\
			     -e s?"[0-9][0-9][0-9][0-9][0-9]"?""?g	\
			     -e s?"[0-9][0-9][0-9][0-9][0-9][0-9]"?""?g	\
			     -e s?"V[0-9][0-9][0-9]"?""?g 		\
	       			 >> "$destinationEdl"

# cleanup
	# remove temporaryfiles
	rm "$tempEDL"

echo "$destinationEdl"

