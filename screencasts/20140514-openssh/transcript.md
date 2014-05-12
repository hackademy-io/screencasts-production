# Usages avancés de SSH

OpenSSH est un formidable outil. Son principal usage est de se connecter de manière sécurisée à un serveur distant en ligne de commande.

Ici, j'appelle la commande `ssh` pour me connecter avec l'utilisateur `bob` sur la machine `server`, qui me demande un mot de passe :

    $ ssh bob@server
    bob@server's password:
    Welcome to Ubuntu 14.04 LTS (GNU/Linux 3.13.0-24-generic x86_64)

     * Documentation:  https://help.ubuntu.com/
    Last login: Wed May  7 11:26:59 2014 from 172.17.42.1
    bob@server:~$

Nous allons voir dans ce screencast les nombreuses options de SSH qui permettent d'améliorer ce flux de travail.

## Utilisation des clés publiques

SSH autorise l'usage de clés de chiffrement asymétriques et permet d'augmenter la sécurité des connections car ni le mot de passe du compte distant ni celui de la clé privé ne sont transmis. Le déblocage local de la partie privé de la clé permet la génération d'un jeton signé qui est envoyée et vérifié avec la clé publique stockée sur le serveur.

Si vous ne possédez encore de clé il est possible d'en générer une avec la commande ssh-keygen.

    $ ssh-keygen
    Generating public/private rsa key pair.
    Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in /home/vagrant/.ssh/id_rsa.
    Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub.
    The key fingerprint is:
    da:21:b7:c9:ef:81:76:de:80:02:54:51:06:03:17:25 vagrant@precise32
    The key's randomart image is:
    +--[ RSA 2048]----+
    |    ..E*+        |
    |     o +         |
    |    .            |
    |   .             |
    |    . . S        |
    |     . * *       |
    |      o O +      |
    |       o + +     |
    |         .+ .    |
    +-----------------+

Une paire de clé est générée à l'endroit indiqué et le programme vous demande un mot de passe pour protéger la partie privé. Il est recommandé d'utiliser une passphrase, bien plus robuste et [souvent plus facile à retenir](http://xkcd.com/936).

Comme nous l'avons vu, pour permettre la vérification du jeton d'authentification envoyé au serveur, ce dernier aura besoin de votre clé publique. Bien qu'il soit tout à fait possible d'effectuer cette manipulation à la main, il est recommandé d'utiliser la commande `ssh-copy-id`.

    $ brew install ssh-copy-id  # si vous être sous OSX
    $ ssh-copy-id bob@server
    bob@server's password:
    Now try logging into the machine, with "ssh 'bob@server'", and check in:

      ~/.ssh/authorized_keys

    to make sure we haven't added extra keys that you weren't expecting.

Dès lors, l'accès à ce serveur est autorisé avec la clé SSH envoyée. Cependant, il ne demande plus le mot de passe du compte distant, mais la passphrase de la clé privée.

    $ ssh bob@server
    Welcome to Ubuntu 14.04 LTS (GNU/Linux 3.13.0-24-generic x86_64)

     * Documentation:  https://help.ubuntu.com/
    Last login: Thu May  8 14:27:06 2014 from 172.17.42.1
    bob@server:~$ ls -la .ssh
    total 12
    drwx------ 2 bob bob 4096 mai    8 14:34 .
    drwxr-xr-x 4 bob bob 4096 mai    8 14:34 ..
    -rw------- 1 bob bob  399 mai    8 14:34 authorized_keys

Le contenu du dossier `.ssh` du compte de l'utilisateur distant montre bien un fichier `authorized_keys`. Son contenu indique bien la clé SSH que nous avons autorisée.:w


    bob@server:~$ cat .ssh/authorized_keys
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDf1Ar9xpy/VmtoH1Ar7k9wx2vfT31+DN89ROl75oqHbC8F3UEk/GjUr2CP3nO3pr1URtiIKHf79dk2Je+ZVefYPWHKC/Or4SGl8Dg/UlRmKK5og5V0gzBnN6kab2NbbwZSxrcw32L84KKcxXcRH30/gZe21IMYMVOvUA649u2mnJ02g6CN7VgNoRw2Tlxc3uuEgsbzkWTznhKEja+zSMZGeV9PyVdSbNJWzgtttaBnpXkVx0UcFp3nsrMHEdTaYVIxk57nx8DADN1VT8ClbpcT6FGxu8BdTSejPcYK2NFnl1CmGtCPq0qrXporbrlhaDnBvHxeqrCmHjsU2e5w3WJ3 vagrant@precise32

## Exploitation de l'agent SSH

La demande de saisie de la passphrase est déclenchée par l'agent SSH. Celui ci stocke en mémoire vive les clés privées débloquées ce qui permet d'éviter de retaper systématiquement la passphrase. La plupart des unix modernes fournissent cet agent sous la forme d'un trousseau de clé au niveau du système (keychain pour OSX ou seahorse pour Ubuntu par exemple) qui ajoutent les clés à l'agent lorsqu'elle sont débloquées.

Si ce n'est pas le cas la commande `ssh-add` permet de forcer le chargement.

    $ ssh-add
    Enter passphrase for /home/bob/.ssh/id_dsa:
    Identity added: /home/bob/.ssh/id_dsa (/home/bob/.ssh/id_dsa)

L'option `-l` permet de lister les clés chargées en mémoire.

    $ ssh-add -l
    2048 fa:65:dd:f9:1d:90:8e:6b:e3:5b:af:fc:46:4b:96:f2 bob@hackademy (RSA)

La connexion au serveur précédent s'effectue sans demande du mot de passe distant, ni celui de la passphrase.

    $ ssh bob@server
    bob@server $

## Exécuter une commande à distance

La commande `ssh` autorise un paramètre optionnel final comme ligne de commande à exécuter sur la machine distante. C'est un raccourci pratique qui évite quelques frappes parfois inutiles.

    $ ssh bob@server cat /etc/hostname
    server

## Configurations spécifiques à un serveur

Pour aller encore un peu plus loin et toujours un peu plus vite, il est possible d'utiliser le fichier de configuration local de SSH : `~/.ssh/config`. On peut y indiquer des paramètres spécifiques pour chaque machine distante. Par exemple pour un serveur appelé `the-really-long-app-server-name`, pour lequel nous utilisons toujours l'utilisateur `deploy` avec une clé SSH dédiée, on peut spécifier une configuration raccourcie appelée `webserver`.

    $ cat ~/.ssh/config
    Host webserver
        Hostname the-really-long-app-server-name
        User deploy
        IdentityFile ~/.ssh/deploykey

Je peux alors me connecter sur ce serveur en utilisant l'alias défini, sans spécifier l'utilisateur, ni la clé SSH à utiliser. L'agent SSH fait aussi son travail et me donne accès très rapidement au serveur.

    $ ssh webserver
    deploy@the-really-long-app-server-name:~$

L'intérêt de ce fichier `~/.ssh/config` est aussi qu'il fonctionne avec les autres commandes de la suite SSH, comme pour les copies de fichier.

   $ scp myfile webserver:
   $ ssh webserver
   deploy@the-really-long-app-server-name:~$ ls myfile
   myfile

## Éditer un fichier distant

Si désormais je souhaite mettre à jour ce fichier distant, je peux le modifier en local et le renvoyer à l'aide de la commande `scp`. Cependant, il est possible de l'éditer à distance avec :

    $ vim scp://webserver/myfile

L'édition se fait en local, mais vim prends en charge la synchronisation. Vérifiez que votre éditeur favori prend en charge ce protocole (pour emacs, c'est `//user@host:/file`).

## Monter un système de fichier distant

Une autre solution est de monter un système de fichier distant sur un répertoire local. À l'aide de la commande `sshfs`, je relie le répertoire `remote-app` au dossier `myapp` de la machine `server`. Comme pour les autres commandes SSH, sshfs utilise le fichier `~/.ssh/config`. Je peux lister ou modifier les fichiers de mon serveur pour par exemple redémarrer une application gérée par Passenger. Utiliser `fusermount -u` pour démonter le dossier.

    $ sudo apt-get install sshfs -y
    $ mkdir remote-app
    $ sshfs server:apps/myapp remote-app
    $ touch remote-app/tmp/restart.txt
    $ fusermount -u remote-app

## Proxy léger pour utiliser des ports protégés

Nous avons vu comment accéder à des fichiers, mais qu'en est-il de logiciels ? SSH permet d'établir un tunnel sécurisé sur un port applicatif à travers une connection classique. Reprenons notre serveur qui pour faciliter le fonctionnement d'applications web fait tourner un serveur MySQL accessible uniquement en *localhost* sur le port 3306. Nous souhaitons pourtant manipuler les tables d'une base à l'aide d'un éditeur graphique sur notre machine locale, ou directement en mode console.

    $ ssh -N -f -L 3306:localhost:3306 server
    $ mysql -u user -D dbname -p
    Enter password:
    mysql >

On crée ici un tunnel entre le port local 3306 et le port 3306 du serveur distant avec l'option `-L`, `-f` met ssh en tâche de fond et `-N` spécifie à ssh de n'exécuter aucune commande sur le serveur.

Je peux utiliser la commande mysql sur ma machine locale qui va, via ssh, accéder au serveur mysql distant. Utiliser `killall ssh` pour fermer le tunnel.

## Rebondir sur un autre serveur

Dans la plupart des architectures serveur modernes, les applications souvent isolées derriere un pare-feu pour des raisons de sécurité et accessible uniquement au travers d'un *reverse proxy*.

Nous allons utiliser une option du fichier configuration local pour utiliser notre serveur frontal en tant que relai.

    $ cat ~/.ssh/config
    Host reverseproxy
        User bob
        ForwardAgent yes
    Host appserver
        Hostname 172.17.0.3
        User deploy
        ProxyCommand ssh reverseproxy -q -W %h:%p

La directive `ForwardAgent yes` permet de transférer notre agent SSH local sur le reverseproxy distant afin de pouvoir s'en servir pour le rebond. La directive `ProxyCommand` va exécuter la commande spécifiée, ici ssh avec le paramètre `-W` qui transfère les entrées/sorties du client vers le host et le port `%h:%p` défini par l'entrée `Hostname`. Ici on utilise l'adresse IP interne, accessible uniquement depuis le reverproxy pour accéder à `appserver`.

Avec cette configuration, je peux simplement aller sur le serveur d'application en tapant :

    $ ssh appserver

et SSH me fais redondir via le *reverse proxy* de manière complètement transparente.

## Conclusion

Nous avons vu un certain nombre d'usages de SSH, mais il en existe évidemment bien d'autres. Couplé à des outils d'administation ou d'orchestration, l'usage de la ligne de commande se révèle être d'une incroyable efficacité. Apprenez à l'utiliser.
