Custom X Session
================

Based on the tiling window manager xmonad, this X session config is designed to give the maximum productivity and limit the need to use a mouse.

Packages used:
- xmonad
- xmobar
- menu
- trayer
- urxvt
- scrot

Features:
- xmonad tiling window manager
- xmobar setup for dual 1920x1080 monitors
- trayer system tray
- dmenu with yeganesh extension
- custom urxvt theme with clipboard
- custom scrot screenshot script

Installation:

```
mkdir ~/.xmonad
cd ~/.xmonad
sh install.sh
```

Configuration:

All configuration files needed are within ~/.xmonad and are symlinked to appropriate locations.

- xmonad.hs contains window manager config, including key bindings and workspaces
- xmobar-(left|right).hs contains the taskbar config, including the gmail checker script
- xresources contains the urxvt theme
- xsession contains startup programs applications and scripts
- gmail_checker.rb contains your gmail credentials
