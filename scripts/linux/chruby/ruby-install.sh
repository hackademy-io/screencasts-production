#!/bin/bash

LATEST_VERSION=0.4.1

cd /tmp

echo "Installing ruby-install"

echo "   - getting ruby-install..."
if [ ! -f "ruby-install-${LATEST_VERSION}.tar.gz" ]; then
wget -q -O ruby-install-${LATEST_VERSION}.tar.gz https://github.com/postmodern/ruby-install/archive/v${LATEST_VERSION}.tar.gz
fi

echo "   - extracting ruby-install..."
if [ ! -d "ruby-install-${LATEST_VERSION}" ]; then
tar -xzf ruby-install-${LATEST_VERSION}.tar.gz
fi
cd ruby-install-${LATEST_VERSION}/

echo "   - copying ruby-install's files..."
sudo make install

echo "     done"
