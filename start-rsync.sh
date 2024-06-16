#!/bin/bash
#
# Author: harvald
#
## This script automatically backup desired files to an rsync remote location
#
# Change remote server and destination folder here.
remoteServer="exposedlan@192.168.1.138"
destinationFolder="/mnt/backups"

in="$(pwd)/directories.txt"
sshKey="/bin/ssh -i '$HOME'/.ssh/id_rsa" # Add -p <port> to change port
computer=$(hostnamectl hostname)

# checks if rsync is installed
if ! rsync --version; then
    echo please install rsync first.; exit
fi

ssh $remoteServer "mkdir -p $destinationFolder/$computer/"
# iterate through each line of directory.txt
while IFS= read -r file
do
	if [[ $file = \#* ]] || [[ $file = "" ]]; then continue; fi	## check if line is empty or commented, if so, skip it
	echo "Working on $file ..."
	echo ""
	bash -c "rsync -rztuO -e ""$sshKey"" --delay-updates --exclude 'id_rsa' $file $remoteServer:$destinationFolder/$computer/$(basename "$file")"	# args: Recursive, Compress, preserve Time, only Update newer files, Omit dir times, Copy files to temp dir before moving to end folder
done < "${in}"
