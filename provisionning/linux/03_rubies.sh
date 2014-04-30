#!/bin/bash
cd /tmp

echo "Installing chruby"

LATEST_VERSION=0.3.8

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
make install &> install.log

echo "     done"



echo "Configuring chruby"

echo "   - making available via bash"
if ! grep -q "chruby.sh" /etc/bash.bashrc; then
cat >> /etc/bash.bashrc <<EOL
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
EOL
fi

echo "   - making available via /etc/profile.d/chruby.sh"
sudo tee /etc/profile.d/chruby.sh > /dev/null <<EOL
if [ -n "\$BASH_VERSION" ] || [ -n "\$ZSH_VERSION" ]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
fi
EOL

echo "     done"



cd /tmp

echo "Installing ruby-install"

LATEST_VERSION=0.4.1

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
make install &> install.log

echo "     done"



cd /tmp

echo "Installing the MRI stable release..."

echo "   - installing ruby stable and its dependencies"
if ! ls -1 /opt/rubies | grep -q 'ruby' ; then
ruby-install ruby &> ruby-install.log
fi
echo "     done"
