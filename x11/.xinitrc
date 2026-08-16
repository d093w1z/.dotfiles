#!/bin/sh

# /etc/X11/xinit/xinitrc
#
# global xinitrc file, used by all X sessions started by xinit (startx)

# invoke global X session script
#

#exec xterm
. /etc/X11/Xsession
xset +fp /home/d093w1z/.local/share/fonts
xset fp rehash
sxhkd &
exec bspwm 2>~/.bspwm.err > ~/.bspwm.out
