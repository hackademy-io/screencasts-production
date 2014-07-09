# Présentation

Discourse est une plateforme de discussion 100% open source construite et pensée pour les 10 prochaines années.

Elle peut être utilisée comme

- forum de discussion
- liste de diffusion (mailing list)
- salle de chat "avancé"

Pour en savoir plus sur la philosophie et les objectifs de Discourse, je vous invite à vous rendre sur le site officiel www.discourse.org.

# Pré-requis

## Matériel

Pour faire fonctionner Discourse, il vous suffit d'avoir à disposition un serveur ayant au moins les caractéristiques suivantes

- un processeur double coeur (dual core)
- 2 Go de RAM (cela peut aussi être 1 Go de RAM et 1 Go de swap)
- une distribution linux 64 bits compatible avec Docker

## Services

Un autre point très important avant de commencer l'installation de Discourse est de s´assurer d'avoir sous la main tous les identifiants d'un service mail fonctionnel.

En effet, Discourse utilise les e-mails pour valider la création des nouveaux comptes et envoyer des notifications. Sans un service mail fonctionnel, votre instance ne fonctionnera pas correctement.

Vous pouvez indifférement utiliser le serveur mail de votre société ou bien un service d'email tel que [Mandrill](https://mandrillapp.com/), [Mailgun](http://www.mailgun.com/) ou [Mailjet](http://www.mailjet.com/).

Dans ce screencast, nous utiliserons Mandrill.

# Installation

Une fois tous les pré-requis réunis, nous allons pouvoir commencer l'installation de Discourse.

## Connection au serveur distant

Tout d'abord, il nous faut nous connecter au serveur via ssh.

Pour ceux qui sont sous Windows, je vous recommande d'utiliser [Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html).
Pour ceux qui tournent sous OS X ou Linux, lancer un terminal et exécutez la commande suivante

    ssh root@146.185.186.100

En remplaçant l'adresse IP par celle de votre serveur.

Si vous n'avez qu'1 Go de RAM disponible, c'est le bon moment pour vérifier que votre swap est active et le cas échéant d'en configurer une.

## Pré-requis logiciels

Une fois connecté à votre serveur, il faut installer 2 logiciels : Git et Docker.

Commençons tout d'abord par Git. Je vous conseille d'utiliser celui qui vient avec votre distribution. Pour Ubuntu, un simple `apt-get` suffit

    apt-get install git -y

Pour Docker, c'est un peu différent. Étant donné que Docker est encore en cours de développement, il est fortement recommendé de l'installer à partir des sources plutôt que d'utiliser les packets confectionnés par votre distribution.
En effet, il y a de très fortes chances pour que ces derniers ne soient pas à jours.

Heureusement, l'équipe de Docker à mis en place un script d'installation qui s'occupe de tout.
Pour l'utiliser, il suffit d'exécuter la commande suivante

    wget -qO- https://get.docker.io | sh

Cela va télécharger, via la commande `wget`, le script qui se trouve à l'adresse https://get.docker.io et le transmettre à la commande `sh` qui va ensuite l'exécuter.

## Installation de Discourse

Maintenant que l'on a tout les pré-requis, commençons l'installation de Discourse.

Il nous faut tout d'abord créer le dossier `/var/docker` à l'aide de la commande `mkdir` pour `make directory`

    mkdir /var/docker

Il nous faut ensuite cloner le repository de [l'image officielle de Discourse pour Docker](https://github.com/discourse/discourse_docker) dans le dossier `/var/docker` à l'aide de la commande `git clone`

    git clone https://github.com/discourse/discourse_docker /var/docker

Une fois le repository cloné, il nous faut nous rendre dans ce dossier à l'aide de la commande `cd` pour `change directory`

    cd /var/docker

Pour terminer, il nous faut copier le fichier `samples/standalone.yml` dans le répertoire `containers` en le renommant `app.yml` à l'aide de la commande `cp` pour `copy`

    cp samples/standalone.yml containers/app.yml

## Configuration de Discourse

Le fichier `app.yml` est un fichier qui nous permet de configurer notre instance Discourse.
Il s'agit d'un simple fichier texte que l'on peut éditer avec n'importe quel éditeur de texte.

Nous utilisons `nano` car il fonctionne comme la plupart des éditeurs de texte avec une interface graphique.

    nano containers/app.yml

Si vous n'avez qu'1 Go de RAM, il est fortement recommendé de changer la valeur du paramètre `UNICORN_WORKERS` à 2 afin de minimiser la consommation mémoire.

Assurez-vous de renseigner votre adresse email en modifiant la valeur de `DISCOURSE_DEVELOPER_EMAILS`.
Faites bien attention à ne pas faire de faute de frappe car c'est l'adresse email qui sera utilisée pour identifier le premier administrateur de l'instance Discourse.
Vous pouvez également renseigner plusieurs adresses en les séparant par des virgules.

Le paramètre `DISCOURSE_HOSTNAME` permet quand à lui de renseigner le nom de domaine qui sera utilisé.
Pensez à mettre à jour votre DNS avant de lancer publiquement votre instance.

Enfin, n'oubliez pas de renseigner les informations nécessaire à l'utilisation d'un serveur mail.
Il faut obligatoirement fournir l'adresse du serveur SMTP et accessoirement le port et les identifiants.

Ici, je renseigne les informations qui me sont fournis par mandrill.

N'oubliez pas d'enlever les dieses en début de ligne si vous souhaitez que les informations soient prisent en compte.

Pour sauvegarder les modifications, il faut presser les touches <kbd>CTRL</kbd>+<kbd>O</kbd> puis <kbd>Entrée</kbd>.
Et enfin, presser <kbd>CTRL</kbd>+<kbd>X</kbd> pour fermer nano.


## Démarrer Discourse

### Bootstrap (pre-chauffage)

Maintenant que tout est configuré, nous allons pouvoir pré-chauffer Discourse via la commande suivante

    ./launcher bootstrap app

Cette commande lance l'image docker et configure tous les servers et logiciels nécessaire au bon fonctionnement de Discourse.
Énormément de choses se passent pendant cette étape et cela peut durer jusqu'à 8 minutes en fonction de la puissance de votre serveur.

### Démarrage

Une fois terminé, vous pourrez lancer Discourse avec la commande suivante

    ./launcher start app

Félicitations ! Vous venez d'installer, configurer et lancer votre première instance Discourse.

# Première connection

Par défaut, Discourse est an anglais. Pour changer la langue, il vous faut vous connecter en tant qu'administrateur.

Pour cela, il vous suffit de créer un nouveau compte en utilisant l'adresse email que vous avez renseigné précédement dans le paramètre `DISCOURSE_DEVELOPER_EMAILS`.

Vous recevrez alors un email de confirmation et une fois connecté vous pourrez vous rendre dans la partie d'administration de votre instance Discourse.
Là, selectionnez l'onglet "Settings" puis saisissez "locale" afin de chercher le paramètre correspondant à la langue de Discourse.
Choisissez "fr", validez votre modification et rafraichissez votre navigateur afin d'avoir l'interface en français.
