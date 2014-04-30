#!/usr/bin/env bash

echo -ne "Hiding dock…"
osascript -e "tell application \"System Events\" to set the autohide of the dock preferences to true"
# The previous command only work when we are logged in, ensure to return a
# valid state (with echoing something) to avoid blocking next scripts.
echo -ne "All done."
