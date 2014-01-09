#!/usr/bin/env bash

# Configure PATH so that we can access our scripts below
PATH=$PATH:~/.cabal/bin:~/.xmonad/bin

# Configure X
xrdb -merge ~/.Xresources &
xrandr --output CRT2 --mode 1920x1080 --pos 1920x0 --rotate normal --output CRT1 --mode 1920x1080 --pos 0x0 --rotate normal &
display -window root ~/Pictures/Wallpapers/mnml.png &
xsetroot -cursor_name left_ptr &

# Start apps
pidgin &
dropbox start &
skype &
mumble mumble://grit96@raspberrypi.local/ &
nuvolaplayer &
subl &
google-musicmanager &
owncloud &
google-chrome &
urxvt &

# Start screensaver
# Kill gnome-screensaver if started by default
killall gnome-screensaver &
xscreensaver -no-splash &

# Start sound server
pulseaudio --start &

# Fix gnome-settings-daemon
dconf write /org/gnome/settings-daemon/plugins/xrandr/active false
dconf write /org/gnome/settings-daemon/plugins/media-keys/active false

exec xmonad
