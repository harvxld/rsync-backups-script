#!/bin/bash
#
# Author: harvald
#
## This script automatically backup desired files to an rsync remote location

in="$(pwd)/directories.txt"
sshKey="/bin/ssh -i '$HOME'/.ssh/id_rsa" # Add -p <port> to change port
computer=$(hostnamectl hostname)
# Change remote server and destination folder.
remoteServer="exposedlan@192.168.1.138"
destinationFolder="/mnt/backups"

# checks if rsync is installed
if ! rsync --version; then
    echo please install rsync first.; exit
fi

ssh $remoteServer "mkdir -p $destinationFolder/$computer/"
# checks directories.txt and backups each directory listed
while IFS= read -r file
do
	## check if line is empty or commented, if so, skip it
	if [[ $file = \#* ]] || [[ $file = "" ]]; then continue; fi
	echo "Working on $file ..."
	echo ""
	bash -c "rsync -rztuO -e ""$sshKey"" --delay-updates --exclude 'id_rsa' $file $remoteServer:$destinationFolder/$computer/$(basename "$file")"	# args: Recursive, Compress, preserve Time, only Update newer files, Omit dir times, Copy files to temp dir before moving to end folder
done < "${in}"
