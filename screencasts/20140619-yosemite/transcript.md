# Installation de Yosemite dans une machine virtuelle

Bonjour à tous et bienvenue sur Hackademy.
Aujourd'hui nous allons nous intéresser à Yosemite, le nouveau
système d'exploitation d'Apple qui sortira à l'automne.

Chez Synbioz nous étions très curieux de découvrir Yosemite,
pour en découvrir les nouveautés mais aussi et surtout pour Swift,
le nouveau langage présenté par Apple.

Évidemment nous ne pouvons pas nous permettre de mettre à jour
nos machines avec un système d'exploitation en bêta.

Je vais donc vous présenter comment installer Yosemite de façon
sécurisée dans une machine virtuelle.

Tout d'abord voici les pré-requis:

- Il vous faudra forcément une copie du système d'exploitation.
Soit en le téléchargeant sur votre compte développeur Apple,
qui coûte environ 99$ par an, soit en faisant preuve d'un peu d'imagination.
- Il vous faudra aussi une clé USB de 8GO au moins.
- Et enfin VMWare fusion qui est payant mais que vous pouvez
utiliser gratuitement pendant 30J.

## Créer la clé USB

L'étape la plus longue consiste à créer une clé USB bootable pour
installer le système d'exploitation.

Je vais vous guider pas à pas dans ce processus. Ouvrez tout
d'abord le dossier téléchargé correspondant à l'OS.

Si vous l'avez téléchargé depuis l'app store, il vous faut
vous rendre dans le dossier `Applications`, `Install OS X 10.10 Developer Preview`,
et faire un clic droit pour afficher le contenu du paquet.

Dans `Contents/Shared Support`, vous trouverez une image disque
s'appelant `InstallESD.dmg`.

Dans mon cas j'ai déjà copié le dossier sur mon bureau pour
faciliter la présentation.

Nous allons donc monter l'image `InstallESD.dmg`. Le dossier
contient un certain nombre de fichiers cachés dont nous avons besoin.

Nous allons donc lancer une commande en console nous permettant
de les afficher, puis nous relançons le finder.

On aperçoit maintenant les fichiers cachés comme les fichiers `.DS_Store`.
Dans le dossier monté on voit également une image qui s'appelle `BaseSystem.dmg`,
profitons en pour la monter également.

On va maintenant lancer l'utilitaire de disque pour créer la clé USB.
La première étape est de la formater depuis l'onglet effacer.
Il est important d'utiliser le format Mac OS Étendu en mode journalisé.

Maintenant que la clé est effacée, nous nous rendons sur OS X Base System,
onglet restaurer et on va simplement faire glisser la clé dans le champ destination.

On clique sur restaurer et on valide l'effacement de la clé. Il ne nous reste plus
qu'à attendre. Cela prend plus ou moins de temps selon la rapidité de votre disque
et de celui de votre clé.

Une fois la clé restaurée elle affiche automatiquement son contenu. On va se rendre
dans `System/Installation` et supprimer le lien symbolique `Packages`.

Nous allons le remplacer par le dossier original de notre disque d'installation.

Maintenant que les packages sont copiés il ne nous reste plus qu'à copier les fichiers
`BaseSystem.chunklist` et `BaseSystem.dmg` mais cette fois ci à la racine de la clé.

C'est terminé, notre clé USB est maintenant prête à l'emploi.

## Installation de Yosemite avec VMWare Fusion

Nous pouvons maintenant lancer l'installation de Yosemite avec VMWare Fusion.

On va donc créer une nouvelle machine virtuelle customisée. On se rend dans
Plus d'Options, Créer une machine virtuelle personnalisée et on choisit Apple
Mac OS X 10.9.

Ce n'est pas ce qu'on veut mais ce n'est pas gênant.
Pour le reste on peut conserver les réglages par défaut. La machine virtuelle
démarre immédiatement.

On va ouvrir les réglages et indiquer que lorsque la clé USB est connectée,
on la connecte directement à la machine virtuelle.

On voit maintenant qu'on peut booter sur un device USB, c'est ce qu'on choisit.
L'installation est prête à démarrer. Il nous suffit maintenant de dérouler le
processus de façon classique comme pour une installation sur une machine physique.

