#!/bin/bash

echo -ne "Checking for ffmpeg..."
if [ -e /usr/bin/ffmpeg ] ; then
  echo " ffmpeg is already installed."
else
  echo " installing ffmpeg."
  echo "   - Add the ppa"
  add-apt-repository ppa:jon-severinsson/ffmpeg
  echo "   - Update the package list"
  apt-get update -qq
  echo "   - Install ffmpeg"
  apt-get install -y ffmpeg
fi

echo "Binding « Ctrl + Alt + p » to the screencasting script for the vagrant user ONLY."
su vagrant -c "gconftool -t string -s /desktop/gnome/keybindings/custom99/name \"screencast start/stop\""
su vagrant -c "gconftool -t string -s /desktop/gnome/keybindings/custom99/action \"/vagrant_bin/screencast\""
su vagrant -c "gconftool -t string -s /desktop/gnome/keybindings/custom99/binding \"<Primary><Alt>p\""
