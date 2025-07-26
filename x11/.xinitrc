#!/bin/sh

# /etc/X11/xinit/xinitrc
#
# global xinitrc file, used by all X sessions started by xinit (startx)

# invoke global X session script
#

#exec xterm
. /etc/X11/Xsession

sxhkd &
exec bspwm 2>~/.bspwm.err > ~/.bspwm.out
