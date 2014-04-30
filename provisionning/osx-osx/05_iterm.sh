#!/usr/bin/env bash

DOMAIN="com.googlecode.iterm2"


if [ -f ~/Library/Preferences/com.googlecode.iterm2.plist ] ; then defaults delete $DOMAIN; fi

defaults write $DOMAIN PromptOnQuit -bool false

# TODO: disable autoupdate check
# defaults write $DOMAIN ??? -bool false

# Keep an exemple of nested key setting
# defaults write com.googlecode.iterm2 Displays -dict-add Dark\ Background '{ "Font" = "Monaco 24";}'

HACKADEMY='{
    "Ansi 0 Color" =         {
        "Blue Component" = 0.3097887;
        "Green Component" = 0.3097887;
        "Red Component" = 0.3097887;
    };
    "Ansi 1 Color" =         {
        "Blue Component" = 0.3764706;
        "Green Component" = 0.4235294;
        "Red Component" = 1;
    };
    "Ansi 10 Color" =         {
        "Blue Component" = 0.6727703;
        "Green Component" = 1;
        "Red Component" = 0.8094148;
    };
    "Ansi 11 Color" =         {
        "Blue Component" = 0.7996491;
        "Green Component" = 1;
        "Red Component" = 1;
    };
    "Ansi 12 Color" =         {
        "Blue Component" = 0.9982605;
        "Green Component" = 0.8627756;
        "Red Component" = 0.7116503;
    };
    "Ansi 13 Color" =         {
        "Blue Component" = 0.9965209;
        "Green Component" = 0.6133059;
        "Red Component" = 1;
    };
    "Ansi 14 Color" =         {
        "Blue Component" = 0.9970397;
        "Green Component" = 0.8763103;
        "Red Component" = 0.8759136;
    };
    "Ansi 15 Color" =         {
        "Blue Component" = 1;
        "Green Component" = 1;
        "Red Component" = 1;
    };
    "Ansi 2 Color" =         {
        "Blue Component" = 0.3764706;
        "Green Component" = 1;
        "Red Component" = 0.6588235;
    };
    "Ansi 3 Color" =         {
        "Blue Component" = 0.7137255;
        "Green Component" = 1;
        "Red Component" = 1;
    };
    "Ansi 4 Color" =         {
        "Blue Component" = 0.9960784;
        "Green Component" = 0.7960784;
        "Red Component" = 0.5882353;
    };
    "Ansi 5 Color" =         {
        "Blue Component" = 0.9921569;
        "Green Component" = 0.4509804;
        "Red Component" = 1;
    };
    "Ansi 6 Color" =         {
        "Blue Component" = 0.9960784;
        "Green Component" = 0.772549;
        "Red Component" = 0.7764706;
    };
    "Ansi 7 Color" =         {
        "Blue Component" = 0.9335317;
        "Green Component" = 0.9335317;
        "Red Component" = 0.9335317;
    };
    "Ansi 8 Color" =         {
        "Blue Component" = 0.4862745;
        "Green Component" = 0.4862745;
        "Red Component" = 0.4862745;
    };
    "Ansi 9 Color" =         {
        "Blue Component" = 0.6901961;
        "Green Component" = 0.7137255;
        "Red Component" = 1;
    };
    "Anti Alias" = 1;
    "Background Color" =         {
        "Blue Component" = 0;
        "Green Component" = 0;
        "Red Component" = 0;
    };
    Blur = 1;
    "Bold Color" =         {
        "Blue Component" = 0.5067359;
        "Green Component" = 0.5067359;
        "Red Component" = 0.9909502;
    };
    Columns = 120;
    "Cursor Color" =         {
        "Blue Component" = 0.3764706;
        "Green Component" = 0.6470588;
        "Red Component" = 1;
    };
    "Cursor Text Color" =         {
        "Blue Component" = 1;
        "Green Component" = 1;
        "Red Component" = 1;
    };
    "Disable Bold" = 0;
    Font = "Monaco 16";
    "Foreground Color" =         {
        "Blue Component" = 1;
        "Green Component" = 1;
        "Red Component" = 1;
    };
    "Horizontal Character Spacing" = 1;
    NAFont = "Monaco 16";
    Rows = 24;
    "Selected Text Color" =         {
        "Blue Component" = 0.9476005;
        "Green Component" = 0.9476005;
        "Red Component" = 0.9476005;
    };
    "Selection Color" =         {
        "Blue Component" = 0.5153061;
        "Green Component" = 0.2224857;
        "Red Component" = 0.2099074;
    };
    Transparency = 0.1;
    "Vertical Character Spacing" = 1;
}'

BOOKMARK='{
    Data =     {
    };
    Entries =     (
                {
            Data =             {
                Command = "login -fp vagrant";
                "Default Bookmark" = Yes;
                Description = "login -fp vagrant";
                "Display Profile" = "Hackademy";
                "Keyboard Profile" = Global;
                Name = Default;
                "Terminal Profile" = Default;
                "Working Directory" = "/Users/vagrant";
            };
            Entries =             (
            );
        }
    );
    "Group Node" = Yes;
}'

echo -ne "Adding Hackademy profile…"
defaults write $DOMAIN Displays -dict-add Hackademy "$HACKADEMY"

echo -ne "Adding Hackademy bookmark…"
defaults write com.googlecode.iterm2 Bookmarks "$BOOKMARK"
