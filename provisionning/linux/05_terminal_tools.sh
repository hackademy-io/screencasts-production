#!/bin/bash

echo "Installing vim"

echo "   - Update the repository"
apt-get update -qq

echo "   - Install the required packages"
apt-get install -y vim vim-runtime

echo "   - Install git in order to fetch vim packages"
apt-get install -y git
su vagrant -c 'echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config'

echo "   - Loading the vim configuration"
su vagrant -c 'mkdir -p ~/.vim/bundle ~/.vim/tmp ~/.vim/backup'
su vagrant -c 'git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle'
su vagrant -c 'cp -f /vagrant_scripts/dotfiles/.vimrc ~/.vimrc'
su vagrant -c 'cp -r /vagrant_scripts/dotfiles/.vim/colors ~/.vim/colors'
su vagrant -c 'vim +PluginInstall +qall'

echo "   - Install a patched font for powerline"
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8
su vagrant -c 'git clone https://github.com/Lokaltog/powerline-fonts.git /tmp/powerline-fonts'
su vagrant -c 'cp /tmp/powerline-fonts/SourceCodePro/*.otf ~/.fonts/.'
su vagrant -c 'fc-cache -vf ~/.fonts'


echo "Installing tmux & screen"

echo "   - Install the tmux package"
apt-get install -y tmux

echo "   - Loading the tmux configuration"
su vagrant -c 'cp -f /vagrant_scripts/dotfiles/.tmux.conf ~/.tmux.conf'

echo "   - Install the screen package"
apt-get install -y screen

