# Vagrant

## Accèder à la machine virtuelle

  vagrant up
  package
  provision
  gui

  vagrant ssh
  cd /vagrant

  Accès au dossier de l'hôte ou se trouve le Vagrantfile

## Provisionner la machine virtuelle

- Avec des scripts shell
- Chef
- Puppet

## Le système de plugin de vagrant

berkshelf, vmware

## Partie 6, avancé

Écrire une application et l'éxécuter dans la VM
Créer sa propre box, packer

Définir plusieurs machines virtuelles avec des sections

  Vagrant::Config.run do |database|
    database.vm.forward_port 3306, 3306
  end
