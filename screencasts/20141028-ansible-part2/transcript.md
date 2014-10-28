# Orchestration d'une tâche complète avec Ansible

Dans le [screencast précédent](https://hackademy.io/tutoriel-videos/ansible-automatiser-gestion-serveur-partie-1), nous avions exploré les bases de ansible pour nous familiariser avec les modules et l'inventaire. Aujourd'hui nous allons mettre à profit ces concepts pour automatiser une tâche d'administration plus complexe, de bout en bout à l'aide de playbooks.

## There's a playbook for that!

Un playbook est un fichier au format YML, qui peut aussi bien servir une seule fois ou avoir un usage plus récurrent.

    $ cat phpsymfony_setacl_and_clear_cache.yml
    ---
    - hosts: websymfony
      gather_facts: false
      vars:
        - app_path: /var/www/html
        - app_user: www-data
        - app_group: www-data
      tasks:
        - name: Mettre les bons droits sur les répertoires
          file: dest={{ app_path }}
                mode=0775 owner={{ app_user }} group={{ app_group }}
                recurse=yes

        - name: Effacer le cache et les fichiers temporaire
          command: php {{ app_path }}/app/console cache:clear
          sudo: yes
          sudo_user: "{{ app_user }}"

Dans ce fichier, on y retrouve une cible de base avec la directive `hosts`, puis des variables qu'on utilisera tout au long du playbook, en plus de celles fournies par le module *setup*, vu dans le screencast précédent, qui est appelé automatiquement pour peupler la liste des variables disponibles.

Viennent ensuite les tâches proprement dites. On les préfixe par la directive `name`. Bien qu'optionnelle, elle permet d'avoir une trace lisible de ce qui se déroule à l'exécution du playbook.

Dans cet exemple, je m'asssure que l'application PHP/Symfony localisée sur le serveur websymfony dans le répertoire `/var/www/html` possède les bons droits sur les fichiers, et que le cache applicatif est réinitialisé.

Vous constatez que nous utilisons des modules tout comme nous le faisions avec la commande ansible (ici `file` et `command`), à la différence que nous avons à disposition des variables, mais aussi comme nous le verrons ensuite, des boucles, des valeurs de retour et des opérateurs conditionnels pour faciliter le travail.

Le playbook une fois construit s'exécute avec la commande `ansible-playbook`.

    $ ansible-playbook phpsymfony_setacl_and_clear_cache.yml -i hosts

    PLAY [websymfony] *************************************************************

    TASK: [Mettre les bons droits sur les répertoires] ****************************
    changed: [websymfony]

    TASK: [Effacer le cache et les fichiers temporaire] ***************************
    changed: [websymfony]

    PLAY RECAP ********************************************************************
    websymfony                 : ok=2    changed=2    unreachable=0    failed=0

La sortie de la commande indique le résultat des tâches que nous avons définies par la directive `name` en jaune si le module a effectué une modification ou sinon en vert si rien n'a changé et éventuellement en rouge si une erreur s'est produite (par défaut le playbook s'arrête à ce moment là).

Un playbook peut également s'appliquer sur plusieurs cibles, à l'instar de la commande `ansible`. Dans ce cas les différentes tâches sont effectuées à la suite les unes des autres séquentiellement sur chaque cible.

    $ cat push_to_webservers.yml
    ---
      - hosts: webservers
        gather_facts: false
        tasks:
          - name: Synchroniser les fichiers sources sur les cibles
            synchronize: src=./webapp dest=/var/www/html

          - name: Déployer le ficher de configuration
            copy: src=config/nginx.conf
                  dest=/etc/nginx/nginx.conf
                  mode=0664 owner=root group=staff
            notify: Recharger Nginx

        handlers:
          - name: Recharger Nginx
            service: name=nginx state=reloaded

    $ cat webservers_inventory
    [webservers]
    web[1:5]

Dans ce playbook, les 2 tâches spécifiées s'assurent que l'application dans le répertoire webapp est bien synchronisée avec celle sur les serveurs web, et que le fichier de configuration de nginx spécifié est à jour. Puis, la tâche `Recharger nginx` doit être notifiée du changement éventuel. Cette tâche spéciale est définie dans la section `handlers` et exécutée uniquement si le statut de la tâche appelante est *changed*. C'est très pratique pour recharger au besoin les services dont la configuration a été modifiée.

L'exécution du playbook se déroule séquentiellement par serveur et par tâche et pas forcément dans l'ordre puisque ces actions sont lancée parallèlement sur l'ensemble des cibles (5 par défaut).

    $ ansible-playbook push_to_webservers.yml -i webservers_inventory

    PLAY [webservers] *************************************************************

    TASK: [Synchroniser les fichiers sources sur les cibles] **********************
    changed: [nginx3]
    changed: [nginx2]
    changed: [nginx1]
    changed: [nginx4]
    changed: [nginx5]

    TASK: [Déployer le ficher de configuration] ***********************************
    changed: [nginx2]
    changed: [nginx3]
    changed: [nginx5]
    changed: [nginx1]
    changed: [nginx4]

    NOTIFIED: [Recharger Nginx] ***************************************************
    changed: [nginx2]
    changed: [nginx3]
    changed: [nginx4]
    changed: [nginx5]
    changed: [nginx1]

    PLAY RECAP ********************************************************************
    nginx1                     : ok=3    changed=3    unreachable=0    failed=0
    nginx2                     : ok=3    changed=3    unreachable=0    failed=0
    nginx3                     : ok=3    changed=3    unreachable=0    failed=0
    nginx4                     : ok=3    changed=3    unreachable=0    failed=0
    nginx5                     : ok=3    changed=3    unreachable=0    failed=0

L'intérêt des commandes et des playbooks ansible, est qu'ils ont un fonctionnement idempotent, c'est à dire qu'une action n'est exécutée que si nécessaire. Si je relance le playbook à nouveau, l'état `changed` devient `ok` et le *handler* `Recharger nginx` n'est pas exécuté.

    $ ansible-playbook push_to_webservers.yml -i webservers_inventory

    PLAY [webservers] *************************************************************

    TASK: [Synchroniser les fichiers sources sur les cibles] **********************
    ok: [nginx1]
    ok: [nginx2]
    ok: [nginx3]
    ok: [nginx5]
    ok: [nginx4]

    TASK: [Déployer le ficher de configuration] ***********************************
    ok: [nginx1]
    ok: [nginx2]
    ok: [nginx3]
    ok: [nginx5]
    ok: [nginx4]

    PLAY RECAP ********************************************************************
    nginx1                     : ok=2    changed=0    unreachable=0    failed=0
    nginx2                     : ok=2    changed=0    unreachable=0    failed=0
    nginx3                     : ok=2    changed=0    unreachable=0    failed=0
    nginx4                     : ok=2    changed=0    unreachable=0    failed=0
    nginx5                     : ok=2    changed=0    unreachable=0    failed=0

## Définition d'un _Use Case_ concret

Afin de démontrer les possibilités d'orchestration plus avancées, allons un peu plus loin dans le déroulement du déploiement d'une application. En PHP, Ruby ou Java, le seul dépôt du logiciel sur le serveur n'est pas toujours suffisant, et on se retrouve à configurer un ensemble de choses à la suite les unes des autres. Il existe bien évidemment d'autres outils probablement plus adaptés pour cela, mais l'idée est de présenter un _use case_ classique et connu, à l'aide d'un playbook ansible.

Prenons l'exemple de l'installation de l'application web [Wallabag](http://wallabag.org). Celle-ci doit être :

- déposée dans un répertoire déterminé du serveur avec des droits spécifiques sur les répertoires
- adjointe d'une base de données sur un autre serveur
- adaptée à sa configuration locale
- configurée dans un reverse-proxy
- éventuellement testée pour vérifier que tout fonctionne

Un playbook ansible permet d'exécuter ces différentes opérations, y compris sur des serveurs différents.

    $ cat deploy_wallabag.yml
    ---
    - hosts: webserver
      # gather_facts: false
      vars:
        - app_domain: wallabag.mydomain.org
        - app_proto: http
        - app_path: /var/www
        - db_host: dbserver
        - db_name: db_app
        - db_user: user
        - db_pass: pa$$w0rD
        - db_adminuser: admindb
        - db_adminpass: ImakeTherules

      tasks:
        - name: Deployer à partir du dépôt de référence
          git: repo=https://github.com/wallabag/wallabag.git
               dest={{ app_path }}
               version=master
          register: deployed

        - name: ensure app_path rights are correct
          file: path="{{ app_path }}" state=directory recurse=yes
            owner=www-data group=www-data mode=0755
          when: deployed|success

        - name: Créer la db
          mysql_db: db={{ db_name }} state=present
                    login_user={{ db_adminuser }} login_password={{ db_adminpass }}
          delegate_to: "{{ db_host }}"
          register: dbcreated
          when: deployed|success

        - name: Créer le user correspondant
          mysql_user:
                 name={{ db_user }}
                 password={{ db_pass }}
                 host={{ inventory_hostname }}
                 priv={{ db_name }}.*:ALL
                 login_user={{ db_adminuser }} login_password={{ db_adminpass }}
          delegate_to: "{{ db_host }}"
          register: usercreated
          when: dbcreated|success

        - include: configure_wallabag.yml

        - include: add_to_reverse_proxy.yml

        - name: tester si le site fonctionne
          local_action: uri url=http://{{ app_domain }} return_content=yes
          register: webpage
          tags:
            - test

        - name: Passe cette action si le contenu attendu est correct
          local_action: fail msg="Le contenu attendu n'est pas correct"
          when: "'login to your walabag' not in webpage.content"
          tags:
            - test

Comme dans l'exemple précédent, nous définissons une cible de base et un ensemble de variables qui seront utilisées tout au long du playbook. Les tâches décrites précédemment sont définies séquentiellement, avec les paramètres spécifiés.

La directive `register` récupère la sortie de l'exécution du module et on utilise la directive `when` pour déterminer si le module doit être exécuté en fonction du résultat du module précédent (changed, success ou failed). Cela permet de valider le bon déroulement du playbook et de garantir la cohérence de l'ensemble. On pourrait aller encore plus loin et prévoir des tâches de *rollback* ou tout un playbook en cas d'échec de l'une des tâches.

La directive `delegate_to` permet de spécifier que l'exécution du module doit s'effectuer sur une autre cible que celle par défaut. Nous appelons ici les modules mysql_db et mysql_user pour créer éventuellement la base de données spécifiée en paramètres et les accréditations nécessaires à l'application. Il est ainsi possible d'orchestrer des tâches sur la cible principale, d'autres serveurs ou même sur la machine qui exécute le playbook.

La directive `include` permet comme elle l'indique d'insérer le contenu d'un autre fichier YML dans notre playbook. Cela permet de réutiliser des tâches que l'on décrit dans des fichiers séparés pour une meilleure lisibilité ou pour permettre de factoriser notre code.

Pour exécuter ce playbook, j'appelle tout simplement la commande :

    $ ansible-playbook deploy_app.yml -i production

Comme pour la commande `ansible`, il est bien entendu nécessaire que les accréditations SSH soient correctement positionnées sur les machines ciblées dans ce playbook.

    PLAY [webserver] **************************************************************

    GATHERING FACTS ***************************************************************
    ok: [webserver]

    TASK: [Deployer à partir du dépôt de référence] *******************************
    changed: [webserver]

    TASK: [ensure app_path rights are correct] ************************************
    changed: [webserver]

    TASK: [Créer la db] ***********************************************************
    changed: [webserver -> dbserver]

    TASK: [Créer le user correspondant] *******************************************
    changed: [webserver -> dbserver]

    TASK: [migrer le schéma de la DB] *********************************************
    changed: [webserver]

    TASK: [ajouter un user par défaut dans la DB] *********************************
    changed: [webserver]

    TASK: [Paramétrer le fichier de configuration de wallabag] ********************
    changed: [webserver]

    TASK: [deployer les extensions] ***********************************************
    changed: [webserver]

    TASK: [supprimer le répertoire install] ***************************************
    changed: [webserver]

    TASK: [Ajouter un vhost pointant sur le serveur web] **************************
    changed: [webserver -> reverseproxy]

    TASK: [Lien symbolique pour la configuration] *********************************
    changed: [webserver -> reverseproxy]

    TASK: [Recharger Nginx] *******************************************************
    changed: [webserver -> reverseproxy]

    TASK: [tester si le site fonctionne] ******************************************
    ok: [webserver -> 127.0.0.1]

    TASK: [Test du contenu] *******************************************************
    skipping: [webserver -> 127.0.0.1]

    PLAY RECAP ********************************************************************
    webserver                  : ok=14    changed=12   unreachable=0    failed=0

Notre application est correctement installée comme le signale la dernière tâche qui effectue un test de contenu sur l'url publique de l'application. On peut bien entendu vérifier manuellement.

## Conclusion

Nous avons donc vu que les playbooks sont des suites de tâches telles que nous les avions vues dans le [screencast précédent](https://hackademy.io/tutoriel-videos/ansible-automatiser-gestion-serveur-partie-1) avec la commande `ansible`. Ils sont toutefois plus flexibles et paramétrables à l'aide des structures de contrôles et des variables que l'on peut utiliser.

Il existe un niveau d'abstraction encore supérieur que sont les **rôles**. Ils permettent d'être plus générique et ainsi de concevoir une abstraction plus globale au niveau d'une infrastructure. C'est ce que nous aborderons dans la dernière partie de cette série.
