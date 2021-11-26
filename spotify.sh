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
	param=$1
	if [ -z "${2//[0-9]}" ]; then
		result=$(printf "%${2}s" ' ')
		spt pb "-${result// /$param}"
	else
		die "Invalid argument for $1"
	fi
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
		$(awk "/^-(n{2,}|p{2,})$/" <<<${1}))
			echo "prout $1"
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
