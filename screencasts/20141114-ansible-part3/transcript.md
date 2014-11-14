# Orchestration Ansible avec des rôles

Dans cette dernière partie de la série, nous allons pousser le concept des playbooks avec les rôles Ansible, qui va permettre une orchestration à un niveau supérieur.

## Qu'est-ce qu'un rôle

Un rôle est finalement un playbook structuré pour répondre à un usage plus large **et** réutilisable, tel que l'installation d'une suite logicielle ou le paramétrage complet d'un système en fonction d'un usage.

## Création d'un rôle *from scratch*

Ansible fournit [un hub](https://galaxy.ansible.com) qui centralise les rôles créés par les utilisateurs. C'est d'ailleurs un très bon moyen d'apprendre à en créer, et évidement de trouver des rôles prêt à utiliser. Afin d'avoir une cohérence dans la structure, l'outil `ansible-galaxy` permet de créer un rôle standard vide.

    $ ansible-galaxy init nouveau_role

    $ ls -R nouveau_role
    .:
    defaults  files  handlers  meta  README.md  tasks  templates  vars

    ./defaults:
    main.yml

    ./files:

    ./handlers:
    main.yml

    ./meta:
    main.yml

    ./tasks:
    main.yml

    ./templates:

    ./vars:
    main.yml

Les dossiers créés sont assez équivoques, le dossier `meta` sert à spécifier des metadonnées lorsque l'on publie un rôle sur le hub. Autrement, on y retrouve la base du playbook dans les dossiers `tasks/main.yml` et `handlers/main.yml`, la gestion des variables dans les dossiers `vars` et `defaults`, ainsi que les fichiers et templates dans les répertoires correspondants. Les différentes composantes d'un rôle étant dans des dossiers, il est possible de séparer logiquement les différents éléments, de faire des *includes*, et de référencer directement des fichiers et des templates de manière relatives aux rôles, sans préciser leur chemin complet.

Un rôle s'utilise dans un playbook général, dans lequel on se contente de préciser le rôle que l'on souhaite affecter à la cible du playbook.

    $ cat site.yml
    ---
    - hosts: all
      roles: nouveau_role

## Construction et utilisation de rôles

Dans une approche meta, la mise en place de la structure de serveurs des précédentes parties a été effectuée en partie avec Ansible. Je vous propose d'étudier la démarche pour illustrer un cas concret.

L'objectif était d'avoir à disposition un trio de serveurs correctement configurés pour fournir une architecture *3-tier* reverseproxy-webserver-dbserver et y déployer un application web PHP/mySQL.

N'ayant pas ces serveurs à disposition, je me suis appuyé sur un fournisseur de VPS dans le cloud, qui dispose d'une API supportée par Ansible. Ce qui m'a amené à écrire un playbook dédié, qui fera l'objet d'un screencast bonus.

Ces serveurs étant à disposition, je souhaitais définir un rôle par type de serveur, ainsi qu'un rôle commun permettant d'uniformiser la configuration. J'ai donc créé un playbook général, mettant en scène les différents rôles affectés aux serveurs.

    $ cat getitrunning.yml
    ---
    - name: apply common configuration to all nodes
      hosts: all
      roles:
        - common

    - name: configure the webserver
      hosts: webserver
      roles:
        - webserver

    - name: deploy MySQL and configure access
      hosts: dbserver
      roles:
        - dbserver

    - name: configure the reverseproxy
      hosts: reverseproxy
      roles:
        - reverseproxy

Reste à alimenter comme il se doit les rôles utilisés.

Le rôle `common` n'est en fait qu'un simple playbook transféré en rôle, seul le fichier `tasks/main.yml` étant spécifié.

    $ cat roles/common/tasks/main.yml
    ---
    - name: Upgrading system
      apt: upgrade=dist

    - name: Adding common packages
      apt: name={{ item }} state=latest
      with_items:
        - wget
        - unzip
        - python2.7

La cible n'a pas à être précisée, elle est héritée du playbook appelant le rôle. On se contente ici de mettre à jour le système et d'installer quelques paquets généraux, à l'aide du module `apt`.

Pour le rôle dbserver, je souhaite effectuer plusieurs tâches.

    $ cat roles/dbserver/tasks/main.yml
    ---
    - name: Adding dbserver packages
      apt: name={{ item }} state=latest
      with_items:
        - mysql-server
        - mysql-client
        - python-mysqldb

    - name: set /etc/hosts file with webserver internal IPs
      lineinfile: dest=/etc/hosts regexp="webserver$" line="{{ webserver_internalip }} webserver"

    - name: Enable access to mysql on internal ip
      lineinfile: dest=/etc/mysql/my.cnf
        regexp="^bind-address"
        line="bind-address = {{ dbserver_internalip }}"
      notify: Restart mysql

    - name: Create admindb user
      mysql_user: >
        name=admindb
        password=ImakeTherules
        host=localhost
        priv=*.*:ALL,GRANT

- installer les paquets nécessaires à mysql et ansible
- en l'absence de DNS, référencer le serveur web dans le ficher hosts
- ouvrir l'accès à mysql sur l'adresse interne (et recharger mysql via un *handler*)
- créer un utilisateur admin

Concernant le rôle webserver, le même genre de tâches pour installer les paquets nécessaires et référencer le serveur mysql dans le fichier hosts, ainsi que la création d'une configuration par défaut en s'assurant que le dossier `/var/www` existe.

    $ cat roles/webserver/tasks/main.yml
    ---
    - name: Adding webserver packages
      apt: name={{ item }} state=latest
      with_items:
        - nginx
        - php5-cli
        - php5-common
        - php5-sqlite
        - php5-mysql
        - php5-curl
        - php5-fpm
        - php5-json
        - php5-tidy
        - rsync
        - git
        - mysql-client

    - name: set /etc/hosts file with dbserver internal IPs
      lineinfile: dest=/etc/hosts regexp="dbserver$" line="{{ dbserver_internalip }} dbserver"

    - name: Create default site folder
      file: path=/var/www state=directory owner=www-data group=www-data mode=0775

    - name: Set default site for webserver
      copy: src=default dest=/etc/nginx/sites-available/default
      notify: Restart nginx

Le fichier `default` utilisé directement dans le paramètre src de la dernière tâche et situé dans le dossier `roles/webserver/files`.

Pour le rôle reverseproxy, encore plus simple, une tâche pour installer nginx et une autre pour référencer le serveur web dans le fichier hosts.

    $ cat roles/reverseproxy/tasks/main.yml
    ---
    - name: Adding reverseproxy packages
      apt: name={{ item }} state=latest
      with_items:
        - nginx

    - name: set /etc/hosts file with webserver internal IPs
      lineinfile: dest=/etc/hosts regexp="webserver$" line="{{ webserver_internalip }} webserver"

Les variables \*\_internalip m'étant fournies par l'outil en ligne du fournisseur des VPS, je les spécifie dans les fichiers vars/main.yml de chaque rôle.

    $ cat roles/webserver/vars/main.yml
    webserver_internalip: 10.159.16.154
    dbserver_internalip: 10.159.16.158
    reverseproxy_internalip: 10.159.16.42

Mais il aurait été possible d'utiliser le module `setup` et récupérer dynamiquement les adresses IP avec la variable {{ ansible_eth1.ipv4.address }}.

Le playbook initial s'exécute de la sorte.

    $ ansible-playbook getitrunning.yml -i production

    <<insert result here>>

Les tâches s'exécutent d'abord parallèlement sur les 3 serveurs pour implémenter le rôle `common`, puis séquentiellement pour chaque rôle associé dans le playbook.

## Conclusion

Nous l'avons vu, les rôles ne diffèrent pas vraiment des playbooks, mais ont une vocation à être plus génériques et surtout réutilisables. Il en existe de nombreux qui vous rendrons probablement service pour installer une application ou un service de manière cohérente et reproductible, et vous pouvez vous inspirer des rôles existants pour les paramétrer à vos usages ou en créer de nouveau à partager sur le hub.

Ceci conclut la série sur Ansible, j'espère que ces screencasts vont auront donné suffisamment d'informations pour vous intéresser à l'orchestration de tâches d'administration système.
