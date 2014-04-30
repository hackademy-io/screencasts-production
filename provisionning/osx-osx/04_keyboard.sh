#!/usr/bin/env bash

VOLUME="/Volumes/bepo"
FILE=bepo.dmg
cd /tmp

echo -ne "Fetching file…"
curl http://download.tuxfamily.org/dvorak/macosx/fr-dvorak-bepo-macosx-1.0rc2.dmg -o $FILE

echo -ne "Mounting dmg…"
hdiutil mount $FILE -mountpoint $VOLUME

echo -ne "Copying bundle…"
cp -r "$VOLUME/fr-dvorak-bepo.bundle" "/Library/Keyboard Layouts"

echo -ne "zzzZZZzzz…"
sleep 5

echo -ne "Unmounting $VOLUME…"
umount $VOLUME

echo -ne "Cleaning file…"
rm -f $FILE
