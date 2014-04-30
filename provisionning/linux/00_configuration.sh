#!/bin/bash

echo "Configure \$PATH to include '/vagrant_bin'..."

if grep -q "vagrant_bin" /etc/bash.bashrc ; then
  echo "   - The '/etc/bash.bashrc' file already includes '/vagrant_bin'."
else
  echo "   - Add '/vagrant_bin' to '/etc/bash.bashrc'."
  echo "export PATH=\$PATH:/vagrant_bin" >> /etc/bash.bashrc
fi


echo "Configure prompt colors..."

if grep -q "vagrant_scripts/color-prompt.sh" /etc/bash.bashrc ; then
  echo "   - The '/etc/bash.bashrc' file already includes 'color-prompt'."
else
  echo "   - Add color-prompt to '/etc/bash.bashrc'."
  echo "source /vagrant_scripts/color-prompt.sh" >> /etc/bash.bashrc
fi

if grep -q "vagrant_scripts/color-prompt.sh" /home/vagrant/.bashrc ; then
  echo "   - The '/home/vagrant/.bashrc' file already includes 'color-prompt'."
else
  echo "   - Add color-prompt to '/home/vagrant/.bashrc'."
  echo "source /vagrant_scripts/color-prompt.sh" >> /home/vagrant/.bashrc
fi


echo "Configure locale to $locale..."

locale=${1:-fr_oss}
keyboard_tmpl=/vagrant_prov/keyboard_configs/$locale
keyboard_file=/etc/default/keyboard
initramfs_file=/etc/initramfs-tools/initramfs.conf

echo "   - Rewrite the /etc/default keyboard file with $locale."
cp $keyboard_file{,.backup}
rm $keyboard_file
cat $keyboard_tmpl > $keyboard_file

if grep -q "^KEYMAP=" $initramfs_file ; then
  echo "   - initramfs is already loading the keyboard layout."
else
  echo "   - Add a line to the $initramfs_file to load the keymap."
  echo "KEYMAP=y" >> $initramfs_file
  update-initramfs -u
fi

