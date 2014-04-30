# Installer ruby et ruby on rails sur Mac OS X

## Partie 1, la version de ruby par défaut

Bonjour et bienvenue sur Hackademy,

Aujourd'hui nous allons voir comment mettre en place
un environnement ruby et ruby on rails fonctionnel sur OSX.

Notre environnement actuel est vierge et tourne sur Mountain Lion,
c'est à dire Mac OSX 10.8.

À l'heure ou je vous parle la distribution courante est la 10.9, mavericks.
Il n'y a pas de choses particulières à savoir pour Mavericks,
vous pouvez donc dérouler le processus de la même façon.

Chaque système Mac OS X est livré avec sa propre version de ruby.

Nous allons regarder quelle est la version de base de ruby dans notre environnement.
J'utilise iterm par préférence mais vous pouvez utiliser terminal qui est livré avec OSX.

Nous avons donc la version 1.8.7 installée.

Toutefois nous voulons un outil nous permettant de gérer différentes versions de ruby,
de la 1.8 à la 2.1 en passant par les implémentations telles que rubinius et jruby.

Notre outil devra également se situer au niveau utilisateur, de sorte que chaque utilisateur puisse utiliser ses propres versions de ruby.

## Installation de homebrew

Contrairement à des distributions Linux comme Debian, OSX ne
possède pas de gestionnaire de package par défaut.

Comme il serait fastidieux de faire toutes les installations
à la main nous allons en installer un: homebrew.
C'est le système le plus maintenu.

On va donc se rendre sur le site dédié à homebrew et récupérer la commande
d'installation en bas du site.

Une fois la commande copiée, nous lancons un terminal et collons la commande.

  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

Comme vous avez pu le constater cette commande est une commande ruby.
Elle va donc utiliser la version de ruby présente par défaut, la 1.8.7.

Nous pouvons valider les choix par défaut, qui précise ou se fera l'installation.

Une fois celle ci terminée la commande brew devient automatiquement accessible.
brew nous recommande de lancer un brew doctor, ce que nous allons faire
pour nous assurer que tout fonctionne correctement.

À priori cela devrait être le cas puisque nous n'avons rien installé pour le moment.
C'est parfait tout est opérationnel.

### Installation de rbenv

Maintenant que nous disposons d'un système de gestion de paquets, nous allons installer
un outil nous permettant de gérer les différentes versions de ruby.

Nous allons donc installer rbenv.

Rbenv est le système qui va nous permettre de choisir et basculer d'une version
de ruby à l'autre ; de la façon la plus simple possible.

Les consignes d'installation se trouvent sur la page d'installation github.
Elles sont très simples puisque sur mac ils nous conseillent d'utiliser homebrew que nous
venons d'installer.

De retour dans notre terminal nous tapons donc juste

  brew install rbenv

Il a donc récupéré une archive sur github puis procédé à l'installation.
Il nous reste une étape avant d'avoir la commande rbenv directement accessible.

Nous allons ajouter le chemin de la commande directement dans notre fichier bash_profile.
De mon côté je n'utilise pas bash mais zsh, je vais donc directement le mettre dans mon .zshrc.

Nous copions une dernière commande qui initialisera rbenv au lancement du terminal.
Cette commande se mettra dans le bash_profile si vous être sur bash, le système par défaut, ou zshrc si vous utilisez zsh.

Nous ouvrons un nouvel onglet pour nous assurer que cela fonctionne.
Voyons quelles versions de ruby sont disponibles.

Pour le moment seule la version système est présente.


Nous allons maintenant installer un plugin de rbenv qui s'occupera d'installer et compiler les différentes version de ruby, il s'agit de ruby-build.

De la même façon nous utilisons homebrew.

  brew install ruby-build

Pour nous assurer que cela fonctionne nous ouvrons un nouvel onglet.
ruby-build nous permet de lister les définitions disponibles, c'est
à dire celles que l'on peut installer.

Voilà l'ensemble des versions de ruby disponibles. Vous voyez qu'il y
en a un paquet.

Nous allons donc installer la dernière version de ruby disponible, la 2.1.1
ruby-build étant un plugin de rbenv nous pouvons installer les versions de ruby
directement avec une commande rbenv.

Vous vous demandez sans doute comment se fait la mise à jour des définitions.

Pendant que l'installation suit son cours, nous allons simplement mettre à
jour homebrew avec un update.

Une fois les dernières formules des paquets récupérées nous pouvons mettre
à jour le paquet ruby-build avec la commande upgrade.

Étant donné que nous venons de l'installer nous sommes certainement sur la
version la plus à jour, mais c'est cette opération qu'il faudra réaliser
lorsqu'on voudra installer une version plus récente de ruby.

Nous pouvons donc revenir sur l'onglet d'installation de la version 2.1.1 et la laisser
se terminer.

## Changer de version de ruby

Maintenant que ma version de ruby est installée, j'ai ouvert un nouvel onglet afin que nous
découvrions comment l'utiliser.

Il existe deux usages pour définir la version de ruby à utiliser, soit le niveau local,
soit le niveau global.

rbenv me propose à l'heure actuelle deux versions de ruby utilisables.

Le niveau local est propre à un dossier, le niveau global est propre à mon système,
c'est à dire que si je ne suis pas dans un dossier ou une version de ruby est définie,
j'utilise cette version globale.

  rbenv local 2.1.1

La version actuelle sera donc maintenant cette version 2.1.1

Si je déplace dans un autre dossier comme le /tmp, la version utilisée
est la version système, la 1.8.7.

Ce que fait rbenv est très simple, il place un petit fichier .ruby-version
qui indique la version à utiliser dans ce dossier.

## Gem

Chaque version de ruby est livrée avec une commande, gem.
Les gems sont des paquets ruby. Par exemple ruby on rails est une gem.

Nous allons donc maintenant installer ruby on rails.

  gem install rails

## Rails

Rails est maintenant installé, cela a pris un peu de temps.

La commande gem a installé toutes les dépendances de ruby on rails, qui sont également des gems.

Par défaut c'est la dernière version du paquet, ici de rails qui est installée,
mais j'aurai pu préciser une version particulière avec -v.

Une petite subtilité avec rbenv, lorsque nous installons une gem qui va nous
donner accès à une nouvelle commande, nous devons lancer

  rbenv rehash

Maintenant rails est accessible en tant que commande. Le rehash n'est à faire
qu'après l'installation d'une gem qui donne accès à un éxécutable, il n'est pas
nécessaire de le faire à chaque fois.

La commande rails est maintenant disponible, nous pouvons créer notre première application Ruby on Rails:

  rails new hackademy

La commande crée le squelette du projet, et installe les dépendances nécessaires.

Voilà notre application est maintenant prête, je peux me rendre dans son dossier
pour en visualiser la structure.

Mes différents binaires sont accessibles dans le dossier bin. Nous allons pouvoir
lancer notre serveur applicatif avec la commande rails server, abrégée en rails s.

Il nous indique qu'il a démarré un serveur webrick et que l'application est disponible en
local sur le port 3000.

Voilà, notre application rails est bien fonctionnelle.
