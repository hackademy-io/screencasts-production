# Présentation de vagrant

Bonjour à tous, aujourd'hui je vais vous presenter Vagrant.

Vagrant est un outil permettant de simplifier et d'automatiser la gestion de machines virtuelles.

## Qu'est ce que la virtualisation ?

C'est très bien mais qu'est ce qu'une machine virtuelle ?

Le principe d'une machine virtuelle est de récréer un environnement indépendant, qu'il soit logiciel ou matériel, en utilisant les ressources d'un environnement hôte.

Je peux par exemple demander à ma machine avec 2 processeurs et 4 go de RAM
d'en émuler une avec 1 processeur et 1GO de RAM.

Dans les faits il existe 3 niveaux d'émulation:

- L'émulation complète, d'un ordinateur complet, dans ce cas on peut émuler une architecture
différente du host. Par exemple je peux émuler un processeur ARM (qui est par exemple utilisé
sur des consoles de jeu) alors que j'ai un processeur Intel.
C'est très intéressant et ça peut être faite avec QEMU, par contre c'est lent.
- Ensuite on a la virtualisation, c'est elle qui nous intéresse. Il s'agit d'émuler un ordinateur du même type que l'hôte.
L'intérêt est par exemple de virtualiser un environnement linux alors qu'on utilise un environnement OSX.
C'est rapide et c'est sécurisé car l'hôte et le système virtuel sont distincts. Ça peut être fait avec
Virtualbox par exemple.
- Enfin on a les containers qui consiste à émuler un ou plusieurs environnements sur un même hôte.
Ce sont des environnements applicatifs plutôt que des systèmes complets.
Cela pourrait par exemple être utile pour faire tourner une application ruby on rails qui accède à une base de données.
Les environnements sont cloisonnés entre eux mais on est dépendant de l'hôte.
Par exemple on ne peut pas faire tourner un programme windows si l'hôte est un linux.
C'est par contre encore plus rapide qu'une virtualisation. À noter quand même qu'il n'existe pas de container sous Windows.
Cette solution peut être mise en place avec docker.

## Pourquoi utiliser des machines virtuelles ?

Maintenant vous vous demandez sans doute pourquoi utiliser la virtualisation, et
est ce qu'elle est adaptée à votre cas ?

Voici quelques un des usages pour lesquels la virtualisation est très pratique:

- Je veux mettre facilement à disposition un environnement à un collègue.
Par exemple, je veux mettre à disposition une application web à mon intégrateur pour qu'il puisse y effectuer des modifications.
Plutôt que de lui demander d'installer l'application et toutes ses dépendances, je peux lui fournir une machine virtuelle prête à l'emploi
de telle sorte qu'il puisse commencer à y travailler dans les 5 minutes.
- Je peux vouloir tester un comportement dans un environnement particulier. Par exemple, pour visualiser le rendu
de mon site sur Internet Explorer alors que je suis sur Mac.
- C'est également une bonne idée d'essayer de reproduire les conditions de l'environnement de production d'une application en situation de développement.
Si j'ai une application avec des dépendances un peu complexes, plutôt que des les éviter quand je suis en développement,
je peux utiliser une machine virtuelle où tout est déjà configuré.
- La virtualisation est également un moyen de mieux utiliser les ressources physiques à disposition et cloisonner les services.
Par exemple, je peux héberger plusieurs services ou applications différentes sur un même serveur physique qui dispose de ressources importantes.
- C'est également un moyen d'éviter les effets de bord d'une application installée en local, et donc le fameux «ça marche chez moi».
- Enfin, la virtualisation permet de mettre en place une configuration reproductible de façon automatisée.
C'est tout l'intérêt de vagrant, et c'est ce que nous allons voir aujourd'hui.

## Installation de virtualbox

À la base Vagrant allait de paire avec Virtualbox mais il supporte maintenant plusieurs providers notamment VMware…

Pour notre exemple nous allons utiliser Virtualbox et l'installer.

C'est très simple, il suffit d'aller sur le site, récupérer le package qui va bien et l'installer.

Une fois que c'est fait on peut lancer virtualbox.
Virtualbox va me permettre de créer mon système en choisissant ma configuration.

L'inconvénient c'est que pour chaque installation je dois réinstaller le système
virtuel comme si j'installais une machine physique.

Avec vagrant je vais rapidement pouvoir mettre en place une machine virtuelle sans passer par ces étapes.

## Installation de vagrant

Vagrant est un outil écrit en ruby qui permet d'automatiser la création et la gestion
de mes machines virtuelles.

Précédemment vagrant était disponible sous forme de Gem, c'est à dire de paquet ruby,
mais cette méthode d'installation est maintenant dépréciée.

Installons donc le paquet à disposition sur le site.

J'ai uniquement à choisir la plateforme que j'utilise et j'installe le paquet.

Vagrant s'est installé dans mon dossier Applications et le binaire dans un sous dossier
bin.

La plupart du temps nous allons utiliser vagrant depuis la ligne de commande.
Pour éviter d'avoir à saisir le chemin complet vers le binaire, l'installateur a directement
fait un lien de /usr/bin/vagrant vers /Applications/vagrant/bin/vagrant

Je peux donc vérifier en console que tout fonctionne correctement

  vagrant -v

## Mettre en place sa première machine virtuelle

Maintenant que tout fonctionne correctement, nous allons voir comment mettre en
place notre première machine virtuelle avec vagrant.

Je vais commencer par créer un dossier vms dans mon répertoire personnel.

  mkdir vms
  cd vms

Contrairement à l'utilisation de virtualbox je n'ai pas besoin de créer
ma propre machine virtuelle et de la configurer avant de l'utiliser.

En effet, il existe des modèles de machines virtuelles prêts à l'emploi sur Internet.
Ces modèles de machines virtuelles décompressées sont appelées box.

Pour mon exemple je vais utiliser une ubuntu 14.04 qui utilise virtualbox comme provider.
Il s'agit donc de ce lien que j'ai déjà téléchargé en local.

  https://github.com/ffuenf/vagrant-boxes

Vagrant fonctionne avec un seul fichier de configuration, le fichier Vagrantfile, qui est
généré à l'initialisation.

Pour initialiser ce fichier, je peux soit utiliser vagrant init seul soit avec des options.

  vagrant init -h

L'option name me permet de donner un nom à ma machine virtuelle et l'option url me
permet de préciser l'url de la box à ajouter.

  vagrant init -h

Je vais donc initialiser une machine virtuelle qui s'appelera ubuntu et utiliser
mon fichier box que j'ai récupéré en local.

  vagrant init ubuntu ~/tmp/ubuntu-14.04-server-amd64_virtualbox.box

J'utilise un chemin local car j'ai rapatrié le fichier box avant de l'utiliser
mais j'aurai pu passer directement l'adresse http comme argument.

Vagrant a donc créé un fichier Vagrantfile.
Je peux maintenant lancer ma machine virtuelle avec vagrant up.

La machine virtuelle est entrain d'être configurée, nous n'avons rien à faire de plus.
On peut en profiter pour jeter un œil à notre fichier Vagrantfile.

Il s'agit donc d'un fichier qui est écrit en ruby. Pour le moment les deux seules options
qui nous intéressent et que nous avons passé en ligne de commande sont les deux premières,
box et box_url mais il en existe d'autres que nous verrons plus tard.

Ça y est notre notre machine virtuelle est initialisée et on peut donc s'y connecter
directement en SSH avec :

  vagrant ssh

Vagrant a configuré pour nous les clés SSH ainsi qu'un accès sudo sans mot de passe.
Vagrant a également configuré par défaut un partage de fichier entre l'hôte et la machine virtuelle.

Sur la machine virtuelle on retrouve ce dossier partagé dans /vagrant.
Je peux me déplacer dans ce dossier et créer un fichier, ce fichier sera créé sur l'hôte
dans le dossier ou se trouve notre fichier Vagrantfile.

C'est très pratique si vous voulez travaillez sur le code d'une application sur l'hôte en
l'exécutant dans la machine virtuelle.

  cd /vagrant
  touch file


Une fois que nous avons terminé nous pouvons nous déconnecter.
  exit

En listant les fichiers sur l'hôte on voit qu'il a bien créé le fichier file.
  ls -la

Nous pouvons maintenant éteindre la machine virtuelle avec

  vagrant halt

Étant donné que notre machine virtuelle est démarrée sans interface graphique par défaut
il se peut qu'on se demande quel est le status courant de la machine virtuelle.
On utilise pour cela:

  vagrant status

Vous vous demandez sans doute ou se trouve notre machine virtuelle et comment elle est lancée.
C'est en fait virtualbox qui fait le travail de manière silencieuse.

Si on regarde dans virtualbox on s'aperçoit que la machine virtuelle est bien listée.

Au niveau du système de fichiers la machine virtuelle est stockée dans le dossier VirtualBox VMs
dans notre home.

Il faut bien comprendre que si je fais des modifications dans ma machine virtuelle, par exemple
en installant un paquet, ce n'est pas mon fichier box qui va être modifié mais bien ma machine
virtuelle stockée dans ce dossier.

Maintenant que j'ai terminé je vais supprimer ma machine virtuelle:

  vagrant destroy

On voit bien que celle ci a disparu de la liste des machines virtuelles de virtual box.

C'est tout pour cette présentation de vagrant, par la suite nous verrons comment provisionner
une machine virtuelle, c'est à dire installer un certain nombre de logiciels par défaut.

Nous verrons également comment créer notre propre box et comment utiliser une machine virtuelle
pour faire tourner une application que l'on écrit depuis le host.
