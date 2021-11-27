Start (and stop) the [spotifyd](https://github.com/Spotifyd/spotifyd) daemon with [spotify-tui](https://github.com/Rigellute/spotify-tui).  
\+ Shortcut commands and handling spotify's URLs for command `play`

## First steps

**Clone it in the directory of your choice**  
You could also just download the .sh file, but you can keep it up to date by doing a `git pull`  
`gcl https://github.com/emmanuelvlad/spotifyd-tui.sh.git $HOME/Documents/scripts`

**Make the script executable**  
`chmod +x $HOME/Documents/scripts/spotifyd-tui.sh/spotify.sh`

**Create an alias to the script**  
Add this in your $HOME/.zshrc or .bashrc  
`alias sptf=$HOME/Documents/scripts/spotifyd-tui.sh/spotify.sh`

## Usage
  
`sptf`      Starts the daemon with spt  

**Available commands**  
```
sptf t, toggle              Pause/Resume the song  
sptf n, next [number]       Next song, can use \"nnnnnn\" instead of \"n 6\"  
sptf p, previous [number]   Previous song, can use \"ppp\" instead of \"p 3\"  
sptf shuffle                Toggles shuffle mode  
sptf repeat                 Switches between repeat modes  
sptf like                   Likes the current song if possible  
sptf dislike                Dislike the current song if possible  
sptf album                  Prints the album url  
sptf link                   Prints the song url  
sptf now                    Prints the status of the current song  
sptf stop                   Stops the spotifyd daemon  
sptf play <uri|name> [opts] Plays from a valid URI or calls `spt` to handle it
```
