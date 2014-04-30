#!/bin/bash

# Set root instructions here.
FILE="iTerm2_v1_0_0.zip"

echo -ne "Installing iTerm…"
cd /tmp
curl -O http://www.iterm2.com/downloads/stable/$FILE
unzip $FILE
mv iTerm.app /Applications
rm $FILE
