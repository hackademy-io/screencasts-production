Liste des commandes
===================

Bonjour à tous,

Dans ce screencast, on va installer Ruby sur une distribution Linux :
Ubuntu 12.04 LTS.

Pour avoir une version la plus à jour possible on ne passera pas par
le système de paquets classiques mais par deux outils qui sont
change-ruby et ruby-install.

En plus de vous mettre à disposition les dernières versions de Ruby,
ces deux outils vous permettront aussi de faire cohabiter sur la même
machine plusieurs implémentations et de passer de l'une à l'autre
facilement.

Pour vous faciliter l'installation, j'ai préparé deux scripts qui
reprennent les étapes décrites sur la page Githib de change-ruby et de
ruby-install. Attention car ces scripts utilisent parfois sudo et votre mot
de passe root vous sera probablement demandé.

$ ./scripts/chruby.sh

Lors de l'exécution de ce script, change-ruby est récupéré puis installé
sur la machine. Deux lignes sont également ajoutées dans votre bashrc
afin de rendre disponible change-ruby dans le terminal.

À présent, je vais faire de même avec ruby-install.

$ ./scripts/ruby-install.sh

=========================================================================

Pour utiliser la commande chruby, on peut lancer un autre terminal, ouvrir
un nouvel onglet ou bien recharger le .bashrc. C'est cette dernière solution
que je choisis.

$ source .bashrc

On peut maintenant utiliser chruby.

$ chruby

Sans argument la commande liste les versions de Ruby détectés. Dans notre cas,
il n'y en a aucunes donc la commande n'affiche rien.

Ruby-install a un comportement similaire, exécuté sans argument, il retourne la
liste des versions de ruby disponibles.

$ ruby-install

On peu voir différentes implémentations de Ruby comme JRuby, Rubinius ainsi que
différente versions pour chacune des implémentations disponibles.

J'installe maintenant la dernière version stable de Ruby. Attention, je fais ça
en tant que super utilisateur.

$ sudo ruby-install ruby
$ sudo ruby-install ruby 2.0.0
$ source .bashrc
$ chruby

Les deux versions que j'ai installé vont maintenant être affichées. Pour choisir
une des versions, j'utilise chruby avec un argument et cet argument sera le nom
de la version que je souhaite utiliser.

$ chruby ruby-2.1.1
$ chruby

Ensuite lorsque chruby liste les versions, il ajoute un asterisk à coté de la
version utilisée.

On peut vérifier que c'est bien la bonne version qui est utilisée en tapant :

$ ruby -v

On vient de voir que l'on pouvait passer d'une version de Ruby à une autre
facilement.

Un autre aspect intéressant dans chruby c'est que l'on va pouvoir faire ce
changement automatiquement en fonction du répertoire dans lequel on se trouve.

Pour ça, je vais créer un répertoire de démonstration :

$ mkdir demo

À l'intérieur de ce répertoire, je vais créer un fichier :

$ touch .ruby-version

Et, à l'intérieur de ce fichier je vais mettre la version de Ruby que je souhaite
utiliser dans ce répertoire ainsi que dans ces sous-répertoires, ici : 2.1.1. Il y a
plusieurs syntaxes qui fonctionnent, on peut aussi écrire ruby-2.1.1.

Ensuite je demande à chruby de lister les versions de Ruby.

$ chruby

On voit que la version utilisée est la version 2.1.1.

Si je retourne dans le répertoire parent et que je demande a chruby de lister les
versions, on voit qu'aucune des version n'est utilisé.

$ chruby

On fait le test, je retourne dans le répertoire de démonstration.

$ cd demo

J'affiche la liste des versions de Ruby, et là, la version que j'utilise est bien la
version 2.1.1.

$ chruby

Je vous remercie d'avoir suivi ce screencast et à très bientôt sur Hackademy
