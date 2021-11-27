#!/bin/sh

die() { echo "$*" >&2; exit 2; }
needs_arg() { if [ -z "$2" ]; then die "No arg for $1"; fi; }

if [ ! $(pgrep "spotifyd") ]; then
	nohup spotifyd --no-daemon &>/tmp/null &
fi

function _CommandHelp() {
	echo -e "\nSpotify script commands:"
	echo "    t, toggle              Pause/Resume the song"
	echo "    n, next [number]       Next song, can use \"nnnnnn\" instead of \"n 6\""
	echo "    p, previous [number]   Previous song, can use \"ppp\" instead of \"p 3\""
	echo "    shuffle                Toggles shuffle mode"
	echo "    repeat                 Switches between repeat modes"
	echo "    like                   Likes the current song if possible"
	echo "    dislike                Dislike the current song if possible"
	echo "    album                  Prints the album url"
	echo "    link                   Prints the song url"
	echo "    now                    Prints the status of the current song"
	echo "    stop                   Stops the spotifyd daemon"
}

function _repeatParam() {
	if [ -z "${2//[0-9]}" ]; then
		result=$(printf "%${2}s" ' ')
		spt pb "-${result// /$1}"
	else
		die "Invalid argument for $1"
	fi
}

function _getTrackID() {
	_TRACK_ID=$(grep -m 1 -oP "track[:|/]\K([a-zA-Z0-9]{22})" <<< $1)
}

if [ ! -z "$1" ]; then
	case "$1" in
		-h | --help | help)
			spt $@
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
			_getTrackID $2
			if [ ! -z "$_TRACK_ID" ]; then
				spt play --uri "spotify:track:${_TRACK_ID}"
			else
				spt play $@
			fi;;
		$(awk "/^(n{2,}|p{2,})$/" <<<${1}))
			spt pb -$1;;
		n | next)
			_repeatParam n $2;;
		p | previous)
			_repeatParam p $2;;
		v | volumne)
			needs_arg "volume" $2;
			spt pb -v $2;;
		now)
			spt pb -s;;
		*)
			spt $@;;
	esac
else
	spt $@
fi
