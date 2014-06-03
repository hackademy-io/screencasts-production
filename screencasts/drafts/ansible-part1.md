# Introduction à l'administration système avec Ansible

## Présentation générale

Ansible est un outil d'automatisation de tâches d'administration système. Il permet de configurer des machines, installer des logiciels, ou orchestrer des tâches plus avancées comme du déploiement continu ou de la mise à jour sans arrêt de service.
Il s'appuie entièrement sur SSH pour la communication, et sur le langage Python pour l'exécution, ce qui en fait un outil quasi universel dans la mesure où il fonctionne sans agent à préinstaller et que SSH et Python sont des outils livrés en standard sur la plupart des serveurs.

Dans cette première partie du screencast, nous aborderons rapidement l'installation, puis deux notions fondamentales de Ansible : les modules et l'inventaire.

# Installation

Le gestionnaire de packets de votre système vous permet d'installer rapidement ansible.

    $ brew install ansible
    $ apt-get install ansible

Mais vous pouvez opter pour l'[installation via les sources](http://docs.ansible.com/intro_installation.html#running-from-source) pour profiter de la toute dernière version. Ici nous utilisons la version 1.4.4 paquagée avec ubuntu, suffisante pour nos besoins.

Par commodité, nous utiliserons ansible avec authentification via clé SSH. Reportez vous au screencast sur les usages avancés de ssh pour sa mise en place.

    $ cat ~/.ssh/config
    Host webserver
        Hostname ip-123-123-123-123.ec2.internal
        User admin
        IdentityFile ~/.ssh/id_rsa
    Host dbserver
        Hostname ip-234-234-234-234.ec2.internal
        User admin
        IdentityFile ~/.ssh/id_rsa
    $ ssh-copy-id admin@webserver
    $ ssh-copy-id admin@dbserver

Attention toutefois, nous le verrons plus loin, l'utilisation de certains modules de `ansible` nécessitent des droits superutilisateur sur les machines distantes. Il conviendra de positionner correctement les droits `sudo` sur les comptes utilisés pour ces actions.

## Les modules

Ansible exige l'utilisation d'un fichier d'inventaire que nous détaillerons ensuite. Celui-ci référence les systèmes à même d'être administrés. Ajoutons nos 2 machines précédemment définies dans le fichier de configuration local de SSH :

    $ vi /etc/ansible/hosts
    webserver
    dbserver

Vérifions maintenant le fonctionnement de ansible en utilisant un module basique. la commande `ansible` prends en paramètre le nom de la cible définie dans le fichier d'inventaire et le nom du module invoqué, pour renvoyer une réponse au format JSON. Ici, le module `ping` renvoie une réponse "pong".

    $ ansible webserver -m ping
    webserver | success >> {
        "changed": false,
        "ping": "pong"
    }

Notez bien que ces modules sont conçus pour fonctionner de la même manière quel que soit le système d'exploitation ou la version tournant sur la cible (Windows excepté). Les commandes sont les mêmes qu'il s'agisse d'un Ubuntu, d'un RedHat, ou d'un FreeBSD.

Certains modules nécessitent un ou plusieurs arguments, on les précise avec le paramètres `-a`. Nous pouvons par exemple appeler le module `service` sur la cible *webserver* pour s'assurer que le service *nginx* a bien redémarré.

    $ ansible webservers -m service -a "name=nginx state=restarted" --sudo

Ici nous utilisons le paramètres `--sudo` car le module a besoin des accréditations superutilisateur pour redémarrer un service. Les paramètres du modules sont ici *name* et *state*.

L'usage de la commande `ansible est habituellement réservée aux opérations rapides et que nous n'avons forcément besoin de reproduire.

On peut vouloir transférer un fichier pour déployer une nouvelle page avec le module copy qui prends en paramètre en source un fichier local et en destination l'emplacement sur le serveur.

    $ ansible webserver -m copy -a "src=web/contacts.html dest=/var/www/site/contacts.html"

ou corriger un droit mal positionné sur un dossier, en précisant le fichier concerné, le mode, le propriétaire et le groupe. Notez a nouveau l'utilisation de --sudo.

    $ ansible webserver -m file -a "dest=/var/www/tmp mode=0660 owner=www-data group=www-data" --sudo

On peut demander à installer ou supprimer rapidement un paquet avec le module apt, une rare exception à l'universalité des modules puisqu'ici nous appelons un module spécifique à la famille Debian.

    $ ansible webserver -m apt -a "name=php5-ldap state=present" --sudo

Ou encore supprimer un compte utilisateur avec le module user.

    $ ansible dbserver -m user -a "name=sqluser state=absent" --sudo

Le module `setup` est particulier, car il examine la configuration de la cible et renvoie un fichier JSON avec un ensemble des caractéristiques identifiées par ansible.

    $ ansible all -m setup --sudo

Le concept appelés *facts* dans ansible est courant dans le monde des outils d'administration, nous verrons dans le prochain épisode comment en tirer parti.

Vous avez compris le principe des modules de ansible, pour consulter la longue liste de modules disponibles, allez sur la [documentation officielle](http://docs.ansible.com/modules_by_category.html).

## L'inventaire

L'autre notion importante pour bien comprendre l'outil et aller plus loin ensuite, est l'inventaire, et nous allons voir qu'il ne s'agit pas simplement d'une liste et qu'il peut être même utile d'en avoir plusieurs.

Ansible permet par exemple le lancement parallèle sur plusieurs cibles. Il suffit d'utiliser l'alias `all` à la place de la cible pour atteindre toutes les machines déclarées dans l'inventaire.

    $ ansible all -m ping
    webserver | success >> {
       "changed": false,
       "ping": "pong"
    }

    dbserver | success >> {
       "changed": false,
       "ping": "pong"
    }

Le fichier d'inventaire est au format `INI`, on peut ainsi créer des groupes de machines pour catégoriser les cibles en fonction de nos besoins. Pour utiliser un fichier d'inventaire différent, on précise le paramètre `-i`.

   $ cat ansible_groups
   [appservers]
   web-10
   web-11
   $ ansible appservers -i ansible_groups -m ping
   web-10 | success >> {
       "changed": false,
       "ping": "pong"
   }

   web-11 | success >> {
       "changed": false,
       "ping": "pong"
   }

On peut également utiliser des raccourcis par exemple pour répertorier un ensemble de serveurs avec un intervalle :

    $ cat ansible_inter
    [webservers]
    web-[01:19]

    [dbservers]
    mysql-[1:9]
    pgsql-[a:f]

On peut également créer des méta-groupe, par type

    $ cat ansible_children
    [webservers]
    web-[01:19]

    [dbservers]
    mysql-[1:9]
    pgsql-[a:f]
    [servers:children]
    webservers
    dbservers

par répartition géographique,

    $ cat ansible_geo
    [paris]
    web-[01:09]

    [lille]
    web-[10:19]

    [france:children]
    paris
    lille

ou n'importe quelle combinaison qui trouve son intérêt dans l'utilisation des modules.

Cette façon de renseigner l'inventaire permet d'utiliser la commande ansible avec des *patterns*.

Rappel de la syntaxe de la commande ansible :

    ansible <pattern> -m <nom_du_module_name> -a "<arguments>" [--sudo]

*pattern* peut être une machine donc ou l'alias spécial `all`, mais aussi un groupe ou encore une expression. Pour donner un exemple plus complexe, ici on efface le fichier /var/www/contacts.hml sur tous les serveurs web à l'exception de ceux du groupe `paris` et web-10 à lille.

    $ ansible france:\!paris:\!web-10 -i ansible_geo -m file -a "dest=/var/www/contacts.html state=absent"

On commence à esquisser l'intérêt d'un tel outil pour effectuer des opératation sur tout ou parite d'une architecture.

Il y a de nombreux format de *pattern* permettant l'intersection, l'exclusion, ou l'utilisation d'expressions rationnelles. [Consultez la documentation](http://docs.ansible.com/intro_patterns.html) pour plus de détails.

# Conclusion

Nous n'avons exploré qu'une toute petite partie des possibilités de Ansible. Ces deux éléments que sont l'inventaire et les modules sont les fondations des *playbooks* qui permettent une véritable orchestration à l'aide des variables, et des *facts* issus du module `setup`.

Nous aborderons tout cela dans le prochain screencast. Merci d'avoir suivi celui-ci et à la prochaine fois.
