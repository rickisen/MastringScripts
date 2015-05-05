#!/bin/bash
# Script that continuosly checks for new files in specified folders and runs the corespoding
# mastring-script on them.

# variables
	# scripts to run
	farmersInputScript="$( dirname "$0" )"/scripts/farmersEdlImport.sh
	farmersOutputScript="$( dirname "$0" )"/scripts/farmersEdlExport.sh
	# Where to look for files
	farmersInputFolder=~/Desktop/Edl_To_farmers/
	farmersOutputFolder=~/Desktop/Edl_To_FCP/
	# how often to check for new files
	repeatSeconds=2

# startup file/folder-checks
	# Check if the scripts exist
	if [[ -e "$farmersInputScript"  ]] || [[ -e "$farmersOutputScript" ]] ; then
		echo "Found all scripts"
	else
		#if not, exit
		echo "Could not locate one or more scripts, exiting"
		exit 1 
	fi
	# Check for the folders to run with exist
	if  [[  -d "$farmersInputFolder" ]] || [[  -d "$farmersOutputFolder" ]] ; then
		echo "Found all folders"
	else
		#create them if they are missing
		mkdir -p "$farmersInputFolder" "$farmersOutputFolder" 
	fi

# functions
function runScriptOnFolder(){
	local script=$1
	local folder=$2
	# don't try if it's empty
	if [[ $(ls "$folder") != "" ]] ; then 
		for file in "$folder"*.edl ; do
			if $( echo "$file" | grep -q converted ) ; then
				echo "ignoring $file"
			else
				echo "Converting "$(basename "$file")"..."
				"$script" "$file"
				clear
			fi
		done
	fi
	}

# main loop
	# every x-seconds, look for new files in the folder
	while true 
	do
		runScriptOnFolder "$farmersInputScript" "$farmersInputFolder" 
		runScriptOnFolder "$farmersOutputScript" "$farmersOutputFolder" 
		
		# wait before checking again
		sleep "$repeatSeconds"
	done 

#done
