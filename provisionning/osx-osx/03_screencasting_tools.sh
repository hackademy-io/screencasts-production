#!/usr/bin/env bash

echo -ne "Checking for ffmpeg…"
if [ $(which ffmpeg) ] ; then
  echo "ffmpeg is already installed."
else
  echo "Installing ffmpeg…"
  brew install ffmpeg
fi
