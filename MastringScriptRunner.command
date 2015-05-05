#!/bin/bash
# Script that continuosly checks for new files in specified folders and runs the corespoding
# mastring-script on them.

# variables
	# scripts to run
	farmersInputScript="$( dirname "$0" )"/scripts/farmersEdlImport.sh
	farmersOutputScript="$( dirname "$0" )"/scripts/farmersEdlExport.sh
	# Where to look for files
	farmersInputFolder="~/Desktop/Edl_To_farmers"
	farmersOutputFolder="~/Desktop/Edl_To_FCP"
	# how often to check for new files
	repeatSeconds=2

# startup file/folder-checks
	# Check if the scripts exist
	if [[ ! -e "$farmersInputScript"  ]] || [[ ! -e "$farmersOutputScript" ]] ; then
		#if not, exit
		echo "Could not locate one or more scripts, exiting"
		exit 1 
	fi
	# Check for the folders to run with exist
	if [[ ! -d "$farmersInputFolder" ]] || [[ ! -d "$farmersOutputFolder" ]] ; then
		#create them if they are missing
		mkdir -p "$farmersInputFolder" "$farmersOutputFolder" 
	fi

# main loop
	# every x-seconds, look for new files in the folder
	while true 
	do
		# first we check for edl:s to farmers - ignore those marked converted
		for file in "$farmersInputFolder*" ; do
			if [[ ! $( echo "$file" | grep -q converted* )  ]] ; then
				echo "Converting "$(basename "$file")" from FCP to Farmers..."
				"$farmersInputScript" "$file"
				clear
			fi
		done

		# then we check for edl:s from farmers - ignore those marked converted
		for file in "$farmersOutputFolder*" ; do
			if [[ ! $( echo "$file" | grep -q converted* )  ]] ; then
				echo "Converting "$(basename "$file")" from Farmers to FCP..."
				"$farmersOutputScript" "$file"
				clear
			fi
		done

		# wait before checking again
		sleep "$repeatSeconds"
	done 

#done
