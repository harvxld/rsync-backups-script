### Simple script to backup folders using Rsync
To use it, simply change you server details (ip, port and destination folder) within `start-rsync.sh`
List all directories you want to backup in `directory.txt` file.
**Must be one per line**
then just
`./start-rsync.sh`

This script is meant to be run with crontab or other automation tools.