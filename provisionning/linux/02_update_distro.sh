#!/bin/bash

echo "Update and upgrade the distibution..."

echo "   - Update the packages list"
apt-get update

echo "   - Upgrade the installed packages"
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
