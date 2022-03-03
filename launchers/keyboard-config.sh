#!/usr/bin/sh
setxkbmap -layout "us,ru" -variant "dvorak," -option "grp:alt_shift_toggle,ctrl:nocaps,altwin:swap_lalt_lwin"

killall xcape
xcape -e 'Control_L=Escape;Shift_L=Super_L|bracketleft;Shift_R=Super_L|bracketright' -t 200
