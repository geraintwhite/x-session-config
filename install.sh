#!/bin/sh

sudo apt-get install xmonad xmobar perl cabal-install ruby xsel amixer
sudo gem install gmail
sudo cabal install yeganesh

sudo ln -si ~/.xmonad/clipboard /usr/lib/urxvt/perl/
sudo ln -si ~/.xmonad/xmonad2.desktop /usr/share/xsessions/
ln -si ~/.xmonad/xresources ~/.Xresources
ln -si ~/.xmonad/xresources ~/.Xdefaults
ln -si ~/.xmonad/xsession ~/.xinitrc
ln -si ~/.xmonad/xsession ~/.xsession

echo 'Log off and then into XSession from session selector'