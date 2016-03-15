# Installer Ruby on Rails et créer un squelette d'application #

Bienvenue dans cette première vidéo de la série dédiée à la découverte de Ruby on Rails.

Ruby on Rails est un framework web dont le but est de cadrer le développement d'applications web et de fournir tous les outils nécessaires à cette tâche.

Ruby on Rails est comme vous pouvez l'imaginer écrit en Ruby et est architecturé autour du concept de modèle, vue, contrôleur. Nous découvrirons ce concept en détail plus tard mais sachez que c'est ce qui permet de faire en sorte que chaque morceau de code ait une place précise dans l'arborescence de l'application.

Aujourd'hui nous allons voir comment installer Ruby on Rails, créer notre premier squelette d'application et explorer l'arborescence. Vous verrez que Rails essaie un maximum de vous éviter la duplication de code et met en place des conventions, de nommage par exemple, qui vous évitent du travail de configuration souvent obligatoire dans d'autres frameworks notamment en Java.

## Installer Ruby on Rails ##

Au cours des différentes vidéos de cette série, nous utiliserons Ruby 2.3 et Rails 4.2.

Commençons donc par installer Rails:

``` shell
$ gem install rails
```

Cette commande installe la gem principale `rails` mais aussi toutes ses dépendances avec notamment `activesupport`, `actionview`, `actionpack`, `activemodel` et `activerecord`.

En effet, chaque brique logique de Rails est encapsulée dans sa propre gem ce qui permet potentiellement de l'utiliser en isolation ou d'en remplacer une par une autre.

## Création d'un squelette d'application ##

Maintenant que nous avons le nécessaire, créons notre première application. Rails met une commande à notre disposition un commande pour générer la structure de base de notre application :

``` ruby
$ rails new demo
```

Cette commande crée un répertoire `demo` et tout un tas de sous-répetoires.

On voit aussi que la commande va lancer un `bundle install` pour installer les dépendances de l'application.

Voyons à quoi ressemble l'arborescence :

``` shell
$ cd demo
$ ls -p
```

Les répertoires principaux sont `app` dans lequel vous passerez la plupart de votre temps et le répertoire `config` qui contiendra les paramètres de votre application comme par exemple la base de donnée utilisée et ses informations de connexion ou encore la liste des URL connues de l'application.

On remarque également le répertoire `log` qui contiendra l'ensemble de vos logs applicatif. C'est donc ici que vous regarderez quand vous serez confronté à une erreur ou que vous voudrez voir par où passe l'application et le temps que prend chaque action.

Finalement le répertoire `test` contiendra tous vos tests automatisés pour votre application. C'est une partie à ne pas négliger. En effet, la bonne pratique est que pour chaque partie de votre code fonctionnel vous ayez des tests associés. De cette manière vous vous assurez que votre code fonctionne comme vous l'entendez et qu'il n'y aura pas de régression.

Les fichiers notables à la racine sont `Gemfile` qui liste l'ensemble des dépendances de votre application. C'est donc ici que vous en ajouterez si vous voulez par exemple un système d'identification. Il y a également le fichier `README` qui est censé contenir toutes les informations indispensables au démarrage de l'application comme la liste des dépendances, les éléments configurables, comment lancer les services, déployer l'application, etc. C'est le point d'entrée pour les développeurs qui arrivent sur l'application et qui souhaite commencer à y contribuer. C'est donc important d'avoir des instructions claires et complètes.

## Lancer l'application ##

On peut d'ores et déjà lancer l'application et y accéder :

``` shell
$ bin/rails server
```

La commande nous indique que l'application a démarrée en mode développement et qu'elle est disponible sur le port 3000.

Essayons d'y accéder.

On se retrouve sur un page qui nous indique les bases pour commencer le développement et quelques liens vers de la documentation.

Si on regarde le terminal, on voit que des informations à propos de la requête ont été imprimées. Ça nous indique l'url contactée avec l'heure, on voit également le contrôleur et l'action qui ont généré la réponse ainsi que le format.

Ici c'est un contrôleur fournit par défaut par Rails `Rails::WelcomeController` sur lequel on appelle son action `index` au format `HTML`.

Pour finir, les logs nous indiquent aussi le code de réponse de la requête et le temps passé en rendu de la vue et dans la base de données.

On a donc une application fonctionnelle sans avoir écrit la moindre ligne de code ou de configuration.

## le répertoire app ##

Intéressons nous de plus près au répertoire clé d'une application Rails, le répertoire `app` :

``` shell
$ tree app
```

### assets ###

Le répertoire `assets` contient tous les fichiers statiques qui seront utilisés dans l'application, on y trouvera les images, les fichiers javascript et css. Pourquoi avoir un répertoire dédié pour ça ? Pourquoi ne pas les mettre dans "public" par exemple ? Pour une raison toute simple, les fichiers qu'on placera dans assets pourront être optimisé par l'asset pipeline qui est un système fourni par Rails dont le rôle est de compresser et concaténer les fichiers lors du déploiement en production pour obtenir de meilleures performances.

Le serveur pourra donc servir des images compressées ou encore ne fournir qu'un seul fichier CSS même si de notre côté on a dispatcher nos règles dans plusieurs fichiers.

L'autre intérêt est qu'on pourra utiliser des pré-processeurs comme SCSS ou CoffeeScript pour faciliter l'écriture des CSS et javascripts. En changeant l'extension de nos fichier l'opération sera complètement transparente.

### models ###

Le répertoire `models` contient toutes les entités qui régissent les données, souvent stockées en base. Chaque fichier de modèle correspondra à une table de la base de données et permettra de représenter chaque ligne de données sous forme d'un objet Ruby facilement manipulable.

Pour une table `users`, on aura un modèle `User`.

Une instance de la classe `User` aura automatiquement des méthodes pour récupérer et modifier les valeurs de chaque colonne. Le modèle permettra aussi de simplifier la communication avec la base de données pour par exemple récupérer une liste d'éléments filtrés par des conditions, en ajouter, les mettre à jour ou encore en supprimer.

Le rôle du modèle est donc vous fournir des objets Ruby à partir d'enregistrements de la base de données et de vous éviter d'avoir à écrire du SQL.

C'est l'une des parties la plus importante de votre application car c'est elle qui régit toute la logique métier.

Le modèle décrira ses relations avec les autres modèles, les contraintes à appliquer sur chaque champ (présence, longueur, format, etc) et encore bien d'autres choses que nous verrons par la suite.

### controllers ###

Nous avons ensuite le répertoire `controllers` qui contiendra tous nos contrôleurs. Un contrôleur est un peu comme une tour de contrôle. C'est lui qui va faire le pont entre les modèles et les vues. Son rôle est de répondre à une requête pour une url donnée, interpréter les différents paramètres puis interroger un ou plusieurs modèles pour récupérer ou écrire des informations et finalement demander le rendu d'une vue en lui passant les informations nécessaires à l'affichage.

Si nous voulions gérer des utilisateurs, nous aurions sûrement un contrôleur dédié `users`, on pourrait en avoir un autre pour gérer des actualités avec un contrôleur `news` etc.

### views ###

Une fois le travail du contrôleur fini, il passe la main à une vue dont le rôle est typiquement de générer de l'HTML. Le contrôleur aura pris soin de préparer les données utiles à la vue sous forme de variables d'instance.

On aura donc accès à un langage de templating qui nous facilitera la génération de l'HTML.

Vous aurez peut-être remarqué que le répertoire `views` contient un sous-répertoire `layouts`. Bien qu'une vue puisse faire à elle seule tout le rendu d'une page HTML, avec le head, le body, etc, dans la plupart des cas vous aurez une base commune à toutes vos pages ou presque. C'est ce qu'on appelle le layout. Plutôt que de le ré-écrire dans chaque vue, on va préférer le mutualiser dans un fichier dédié. À chaque rendu de vue, on utilisera donc ce layout dans lequel on insérera la partie variable générée par la vue.

### les autres répertoires ###

Dans notre liste de répertoires il reste `helpers` qui servira à mutualiser du code utilisés dans les vues et ayant une logique trop complexe pour y avoir sa place. On écrira par exemple un helper pour générer des boutons vers les réseaux sociaux, gérer des classes CSS en fonction des propriétés d'un objet donné, etc.

Rails met d'ailleurs à notre disposition tout un tas d'helpers qui simplifieront les tâches communes comme la génération de liens, la manipulation des dates, la traduction, la création de formulaire, etc.

Pour finir, il y a le répertoire `mailers` qui permettra de gérer l'envoie d'email depuis l'application. C'est un besoin assez commun, par exemple pour envoyer un email de validation de compte, un lien de récupération de mot-de-passe ou encore envoyer une notification lorsqu'un nouvel article est publié.

La gestion d'envoi d'email (et de réception aussi d'ailleurs) est intégrée à Rails. Là encore ça se traduira par des classes Ruby qui encapsuleront toute la logique de gestion des emails.

## Premier exemple ##

Pour finir sur cette introduction, créons notre première route avec son controller contenant une action et sa vue associée.

Nous ferons très simple avec l'affichage d'un texte, un peu de templating et la manipulation d'une date.

### Ajout de la route ###

Avant toute chose nous allons déclarer une route par défaut qui indiquera à Rails l'action à exécuter pour la page d'accueil de l'application :

config/routes.rb

``` ruby
root "welcome#index"
```

On vient d'indiquer que la page d'accueil de l'application utilisera le contrôleur `welcome` et son action `index`.

### Le contrôleur ###

Nous pouvons maintenant créer ce contrôleur. On pourrait le faire à la main mais Rails met des générateurs à notre disposition pour nous éviter ça et créer tous les fichiers connexes :

``` shell
$ bin/rails generate controller welcome index
```

Le générateur a créé plusieurs choses pour nous :

- un nouveau fichier dans le répertoire controllers
- une route
- un répertoire welcome et un fichier index.html.erb dans les vues
- un fichier d'helpers
- un fichier javascript dédié
- un fichier css dédié
- un fichier de test

Cette architecture encourage le découpage de votre application pour que chaque chose ait sa place et que n'importe qui puisse facilement s'y retrouver. Quand on connaît la structuration d'une application Rails et qu'on s'y tient, alors on connaît la structuration de n'importe quelle application Rails qui respecte ces conventions.

Jetons un coup d'œil au code du controller.

On a donc une classe WelcomeController qui hérite de ApplicationController. Dedans nous avons une méthode index qui sera appelée quand on visitera la page d'accueil du site. Cette action ne fait rien pour le moment.

Si on regarde maintenant la vue générée, on voit qu'elle contient uniquement de l'HTML qui décrit son emplacement dans l'arborescence.

On peut visiter la page pour constater le résultat

### Modification de l'existant ###

Nous allons maintenant modifier l'existant pour afficher un message de bienvenue et l'heure qu'il sera dans une heure.

La logique applicative ne dois jamais se retrouver dans la vue. Nous allons donc calculer l'heure dans le contrôleur et on fournira cette information à la vue :

``` ruby
@time = 1.hour.form_now
```

On va maintenant utiliser cette donnée dans la vue :

``` html+erb
<h1>Bonjour à toi visiteur !</h1>
<p>Dans une heure il sera <%= @time %></p>
```

On a du texte statique et un petit morceau d'erb qui est ni plus, ni moins que du code Ruby qui sera interprété avant d'être rendu sur la page. Dans ce morceau d'erb, on affiche simplement le contenu de la variable d'instance que nous avons préparé dans le contrôleur.

Toutes les variables d'instance créées dans le contrôleur sont automatiquement transmise à la vue.

On a donc créé notre première page Rails dynamique !

Ici l'heure affichée est en UTC car nous n'avons pas précisé le fuseau horaire dans lequel nous nous trouvons.

## Conclusion ##

Nous avons donc survolé la structure de base d'un squelette d'une application Rails et créé notre première page dynamique en ajoutant une route, un contrôleur et une vue.

Dans la prochaine vidéo nous commencerons l'écriture d'une application réaliste que nous utiliserons tout au long de cette série sur la découverte de Rails.
