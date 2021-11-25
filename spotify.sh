#!/bin/sh

if [ ! $(pgrep "spotifyd") ]; then
	nohup spotifyd --no-daemon &>/tmp/null &
fi

function _CommandHelp() {
	echo -e "\nSpotify script commands:"
	echo "stop   - Stop the spotifyd daemon"
}

if [[ $1 == "stop" ]]; then
	killall spotifyd
else
	spt $@
	if [[ $1 == "--help" || $1 == "-h" ]]; then
		_CommandHelp
	fi
fi

