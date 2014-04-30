#!/bin/bash

LATEST_VERSION=0.3.8

cd /tmp

echo "Installing chruby"

echo "   - getting chruby..."
if [ ! -f "chruby-${LATEST_VERSION}.tar.gz" ]; then
wget -q -O chruby-${LATEST_VERSION}.tar.gz https://github.com/postmodern/chruby/archive/v${LATEST_VERSION}.tar.gz
fi

echo "   - extracting chruby..."
if [ ! -d "chruby-${LATEST_VERSION}" ]; then
tar -xzf chruby-${LATEST_VERSION}.tar.gz
fi
cd chruby-${LATEST_VERSION}

echo "   - copying chruby's files..."
sudo make install

echo "     done"



echo "Configuring chruby"

if [ -n "$BASH_VERSION" ]; then
echo "   - making available via .bashrc"
if ! grep -q "chruby.sh" ~/.bashrc; then
cat >> ~/.bashrc <<EOL
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
EOL
fi
fi

if [ -n "$ZSH_VERSION" ]; then
echo "   - making available via .zshrc"
if ! grep -q "chruby.sh" ~/.zshrc; then
cat >> ~/.zshrc <<EOL
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
EOL
fi
fi

echo "   - making available via /etc/profile.d/chruby.sh"
sudo tee /etc/profile.d/chruby.sh > /dev/null <<EOL
if [ -n "\$BASH_VERSION" ] || [ -n "\$ZSH_VERSION" ]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
fi
EOL

echo "     done"
