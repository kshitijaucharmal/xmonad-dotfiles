#! /bin/bash
#
# Writes the title and artist of the song currently being played by MPD or MOC to STDOUT, formatted for xmobar
# If MPD is playing a song or is paused, its information will be written. If not, MOC will be checked similarly.
# If neither are playing a song or are paused, nothing will be written.
# Note: if MPD isn't playing some errors will be written to STDERR; don't worry - xmobar only looks at STDOUT

TCOL="cyan"         # The colour to be used to draw the song title when playing
ACOL="lightblue"    # The colour to be used to draw the song artist when playing
PCOL="darkred"      # The colour to be used to draw both the song title and artist when paused

MPDSTATE=$(mpc | sed -e '2 !d' -e 's/^.*\[//' -e 's/\].*$//')
MOCSTATE=$(mocp --info | head -n 1 | tail -c +8)

if [ $MPDSTATE == "playing" ]; then
  # MPD is playing
  echo "<fc=$ACOL>$(mpc current | sed "s/ - /\<\/fc\> - \<fc=$TCOL>/")</fc>"
elif [ $MPDSTATE == "paused" ]; then
  # MPD is paused
  echo "<fc=$PCOL>$(mpc current)</fc>"
elif [ $MOCSTATE == "PLAY" ]; then
  # MOC is playing
  echo "<fc=$ACOL>$(mocp --info | tail -n +4 | head -n 1 | tail -c +9)</fc> - <fc=$TCOL>$(mocp --info | tail -n +5 | head -n 1 | tail -c +12)</fc>"
elif [ $MOCSTATE == "PAUSE" ]; then
  # MOC is paused
  echo "<fc=$PCOL>$(mocp --info | tail -n +4 | head -n 1 | tail -c +9) - $(mocp --info | tail -n +5 | head -n 1 | tail -c +12)</fc>"
fi
