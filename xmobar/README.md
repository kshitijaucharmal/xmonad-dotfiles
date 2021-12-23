xmobar-tools
============

A collection of scripts which give xmobar-formatted output. Useful for displaying status information in your xmobar.

Synopsis
--------

The functions of the various scripts outlined are below.  Note that some of them require setup. The scripts are very simple and should be straightforward to modify.

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>battery</td>
      <td>Uses the <code>acpi</code> command to generate a battery percentage. Green is normal, red is less than 10% remaining, and yellow is charging. No setup required.</td>
    </tr>
    <tr>
      <td>mail_check</td>
      <td>Displays the number of unread messages stored in a local Maildir, or a number of Maildirs. Intended for use with tools like <code>offlineimap</code> and <code>mutt</code>. Note: The script needs to be pointed to the maildirs.</td>
    </tr>
    <tr>
      <td>music</td>
      <td>Gets the currently playing song from either MPD or MOC. Requires the <code>mpc</code> and <code>mocp</code> commands to work with MPD and MOC respectively. Blue is playing, red is paused, and nothing is displayed when music is stopped. No setup is required.</td>
    </tr>
    <tr>
      <td>volume</td>
      <td>Extracts volume information from <code>amixer</code> and /proc. Green is normal, red is muted. Note: you will have to tell the script where in /proc to find the mute status of the relevant sound card. In a future version it will all be done with amixer.</td>
    </tr>
  </tbody>
</table>


Usage
-----

To use a script, simply add an entry to the "commands" array of your .xmobarrc which looks something like `Run Com "/path/to/script" [] "entry_name" 10` and add `%entry_name%` somewhere in the template string (assuming you're using '%' as a delimiter). An example .xmobarrc follows:

    Config { font = "xft:terminus:size=9:antialias=true"
           , bgColor = "black"
           , fgColor = "grey"
           , position = TopSize L 90 17
           , lowerOnStart = True
           , commands = [ Run StdinReader
                        , Run Cpu ["-L","3","-H","50","--low","green","--normal","green","--high","red"] 10
                        , Run Com "battery" [] "battery" 10
                        , Run Com "volume" [] "volume" 10
                        , Run Com "dropbox" ["status"] "dropbox" 50
                        , Run Com "mail_check" [] "mail" 50
                        , Run Com "music" [] "music" 10
                        , Run Date "%a %b %_d %l:%M" "date" 50
                        ]
           , sepChar = "&"
           , alignSep = "}{"
           , template = "&StdinReader& } &music& { &cpu& | Bat: &battery& | Vol: &volume&   <fc=lightblue>&dropbox& | Unread: &mail&</fc>   <fc=orange>&date&</fc>  "
           }


License
-------

> This program is free software: you can redistribute it and/or modify
> it under the terms of the GNU General Public License as published by
> the Free Software Foundation, either version 3 of the License, or
> (at your option) any later version.
>
> This program is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU General Public License for more details.
>
> You should have received a copy of the GNU General Public License
> along with this program.  If not, see <http://www.gnu.org/licenses/>


Authors
-------

- Alex Sayers (<alex.sayers@gmail.com>)
