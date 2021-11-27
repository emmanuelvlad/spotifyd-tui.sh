#!/bin/sh

die() { echo "$*" >&2; exit 2; }
needs_arg() { if [ -z "$2" ]; then die "No arg for $1"; fi; }

if [ ! "$(pgrep "spotifyd")" ]; then
	nohup spotifyd --no-daemon >/tmp/null 2>&1 &
fi

_CommandHelp() {
	printf "\nSpotify script commands:"
	echo "    t, toggle              Pause/Resume the song"
	echo "    n, next [number]       Next song, can use \"nnnnnn\" instead of \"n 6\""
	echo "    p, previous [number]   Previous song, can use \"ppp\" instead of \"p 3\""
	echo "    v, volume <number>     Adjust volume"
	echo "    shuffle                Toggles shuffle mode"
	echo "    repeat                 Switches between repeat modes"
	echo "    like                   Likes the current song if possible"
	echo "    dislike                Dislike the current song if possible"
	echo "    album                  Prints the album url"
	echo "    link                   Prints the song url"
	echo "    now                    Prints the status of the current song"
	echo "    stop                   Stops the spotifyd daemon"
	echo "    play <uri|name> [opts] Plays from a valid URI or calls \`spt\` to handle it"
}

_repeatParam() {
	if [ -z "$(printf "%s" "$2" | sed -r "s/[0-9]//g")" ]; then
		_repeatedCommand=$(printf "%${2}s" " " | sed -r "s/ /$1/g")
		spt pb "-${_repeatedCommand}"
	else
		die "Invalid argument for $1"
	fi
}

_getURI() {
	_sptfTypes="(track|album|episode|playlist|show)"
	_matchedParam=$(echo "$1" | grep -m 1 -oP "${_sptfTypes}[:/][a-zA-Z0-9]{22}")
	if [ -n "$_matchedParam" ]; then
		_URI_ID=$(echo "$_matchedParam" | sed -r "s/(.*)[:\/]//g")
		_URI_TYPE=$(echo "$_matchedParam" | sed -r "s/[:\/](.*)//g")
	fi
}

if [ -n "$1" ]; then
	case "$1" in
		-h | --help | help)
			spt "$@"
			_CommandHelp;;
		stop)
			killall spotifyd;;
		t | toggle)
			spt pb -t;;
		like)
			spt pb --like;;
		dislike)
			spt pb --dislike;;
		link)
			spt pb --share-track;;
		album)
			spt pb --share-album;;
		shuffle)
			spt pb --shuffle;;
		repeat)
			spt pb --repeat;;
		play)
			_getURI "$2"
			if [ -n "$_URI_ID" ]; then
				spt play --uri "spotify:${_URI_TYPE}:${_URI_ID}" $(echo "$@" | cut -d\  -f 3)
			else
				spt "$@"
			fi;;
		"$(echo "$1" | awk "/^(n{2,}|p{2,})$/")")
			spt pb "-$1";;
		n | next)
			_repeatParam n "$2";;
		p | previous)
			_repeatParam p "$2";;
		v | volumne)
			needs_arg "volume" "$2";
			spt pb -v "$2";;
		now)
			spt pb -s;;
		*)
			spt "$@";;
	esac
else
	spt "$@"
fi
