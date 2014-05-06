# Enregistrer une vidéo avec la machine virtuelle sous linux

Vous pouvez utiliser la machine virtuelle linux que votre hôte soit
sous Mac OS X ou sur Linux (windows non testé).

## Installation

Il s'agit de la machine de base à utiliser pour réaliser les screencasts.

Bien sur il vous faudra installer vagrant et virtualbox (y compris le *extension
pack*). Rendez vous ici pour télécharger ces deux logiciels :

* https://www.virtualbox.org/wiki/Downloads
* http://www.vagrantup.com/downloads.html

Avant de commencer, il vous faut récuperer et installer la box de base:

    $ wget http://public.synbioz.com/gui-precise32.box -o /tmp/gui-precise32.box
    $ vagrant box add gui-precise32 /tmp/gui-precise32.box

Quelques box de base sont à disposition au même endroit afin de faciliter le
provisionning initial. Voici la liste des box disponibles :

* [gui-precise32.box](http://public.synbioz.com/gui-precise32.box)
* [hackademy-02.box](http://public.synbioz.com/hackademy-02.box)

Le prefixe « 02 » dans l'exemple précédent indique que le provisionning à été
fait jusqu'au script de provisionning lui même préfixé par « 02 » (inclus).

On va utiliser un plugin afin de synchroniser la version des *guest additions*
avec la version de Virtualbox afin de maximiser la compatibilité. Attention, il
y a un [bug référencé](https://github.com/mitchellh/vagrant/issues/3341) sur
vagrant lié à la version 4.3.10 des *guest additions*, veuillez vous reporter à
la solution exposée le cas échéant.

    $ vagrant plugin install vagrant-vbguest

Ensuite placez-vous dans le répertoire de configuration adapté (linux-linux,
osx-linux ou osx-osx) là ou se trouve le fichier de configuration `Vagrantfile`.
Il est maintenant possible de lancer la machine avec la commande :

    $ vagrant up

## Provisionning

Il y a quelques variables d'environnement à connaitre lors du provisionning :

- `KB_CONFIG=<keyboard_config_file>`

keyboard_config_file est le nom d'un fichier contenu dans le dossier
`"./provisionning/keyboard_configs/"`.

## Usage

Une fois la VM lancée, vous pouvez démarrer un screencast à l'aide du raccourci
clavier « `<Ctrl><Alt>p` ». Un screencast sera alors enregistré dans le dossier
« ./screencasts » sur l'hôte.

Au moment de démarrer un screencast, il faut choisir une zone de l'écran (une
fenêtre) à enregistrer. Pour cela, il suffit de cliquer sur la fenêtre choisie.

Pour terminer un enregistrement on reproduit la combinaison « `<Ctrl><Alt>p` ».

## Enregistrement de l'audio

Une fois la vidéo enregistrée, le script `screencasts/audio` permet d'enregister
une piste audio.
