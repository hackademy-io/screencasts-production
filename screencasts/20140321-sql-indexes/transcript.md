Il existe plusieurs type d'index pour les bases de données relationnelles. Ils sont souvent
spécifiques au système de gestion de base de donnée utilisé. Par défaut, les deux acteurs
majeurs du domaine que sont MySQL et PostgreSQL utilisent un arbre équilibré comme structure
d'indexation.

Dans ce screencast, on observera l'influence d'index composites, c'est à dire sur
plusieurs colonnes, sur le filtrage et le tri de données.

On va créer et se connecter à une base de donnée nommée `test`.

$ createdb test
$ psql -d test

Une fois connecté on va utiliser un éditeur externe, ici vim, pour éditer certaines commandes
un peu longues. On commencera par créer la table `rankings` et la remplir de données générées
grâce au script fourni.

> \e (seed.sql)

On voit que 1 million d'entrées ont été insérées dans la table `rankings` grâce à la commande
suivante.

> select count(*) from rankings;

Si on observe la table `rankings` on peut voir qu'elle ne contient que deux colonnes :
`nick` et `score`.

> \d rankings

              Table "public.rankings"
     Column |         Type          | Modifiers
    --------+-----------------------+-----------
     nick   | character varying(40) | not null
     score  | integer               | not null

Grâce à cette table, on souhaite pouvoir effectuer les deux opérations suivantes :

* obtenir le score d'un joueur et
* obtenir un extrait du classement des joueurs.

==========================================================================================

On va observer les 10 premiers éléments de notre table rankings
afin de savoir s'ils sont conformes à nos attentes.

> select * from rankings limit 10;

Essayons maintenant d'obtenir le score d'un joueur donné.
Nous utilisons explain analyse afin d'obtenir le plan qui
va être utilisé par le système de gestion de base de données
pour effectuer la requête.

> explain analyse select score from rankings where nick = 'user1';

                                                   QUERY PLAN
    --------------------------------------------------------------------------------------------------------
     Seq Scan on rankings  (cost=0.00..17905.00 rows=1 width=4) (actual time=0.026..107.090 rows=1 loops=1)
       Filter: ((nick)::text = 'user1'::text)
       Rows Removed by Filter: 999999
     Total runtime: 107.162 ms

On voit qu'actuellement 999999 éléments ont été filtrés à la main, donc aucun index n'a
été utilisé.

La requête a mis 107 millisecondes. On peut accélérer la requête en utilisant une limite,
c'est à dire s'arrêter dès lors qu'on aura récupéré une entrée correspondant à 'user1'.

> explain analyse select score from rankings where nick = 'user1' limit 1;

                                                     QUERY PLAN
    ------------------------------------------------------------------------------------------------------------
     Limit  (cost=0.00..17905.00 rows=1 width=4) (actual time=0.019..0.020 rows=1 loops=1)
       ->  Seq Scan on rankings  (cost=0.00..17905.00 rows=1 width=4) (actual time=0.012..0.012 rows=1 loops=1)
             Filter: ((nick)::text = 'user1'::text)
     Total runtime: 0.042 ms

On voit que l’exécution de cette requête dure moins d'une milliseconde.
Le gain est énorme, on n'a aucun enregistrement qui a été supprimé par un filtre.

Toutefois le résultat est très inégal puisque si on essaye avec une autre utilisateur,
comme le dernier, le temps d'éxécution sera de 104 millisecondes.

> explain analyse select score from rankings where nick = 'user1000000' limit 1;

                                                       QUERY PLAN
    ----------------------------------------------------------------------------------------------------------------
     Limit  (cost=0.00..17905.00 rows=1 width=4) (actual time=104.221..104.224 rows=1 loops=1)
       ->  Seq Scan on rankings  (cost=0.00..17905.00 rows=1 width=4) (actual time=104.213..104.213 rows=1 loops=1)
             Filter: ((nick)::text = 'user1000000'::text)
             Rows Removed by Filter: 999999
     Total runtime: 104.260 ms

Le gain est lié au fait que la recherche s'arrête très tôt mais le parcours se fait
séquentiellement et pour chaque entrée de la table le filtre nick = 'user1' est testé.

==========================================================================================

Pour uniformiser cette recherche du score, on ajoute un index sur celui ci:

> create index rankings_nick_index on rankings (nick);

La création d'index peut être plus ou moins longue en fonction du nombre d'entrées déjà
existantes dans la table.

Par défaut, l'index créé utilise un arbre équilibré.

Une fois l'index créé, on peut à nouveau exécuter nos requêtes :

Ici pour le dernier utilisateur de notre table on voit que le temps d'éxécution
est inférieur à 1 milliseconde.

> explain analyse select score from rankings where nick = 'user1000000' limit 1;

                                                                 QUERY PLAN
    ------------------------------------------------------------------------------------------------------------------------------------
     Limit  (cost=0.42..8.44 rows=1 width=4) (actual time=0.065..0.070 rows=1 loops=1)
       ->  Index Scan using rankings_nick_index on rankings  (cost=0.42..8.44 rows=1 width=4) (actual time=0.054..0.054 rows=1 loops=1)
             Index Cond: ((nick)::text = 'user1000000'::text)
     Total runtime: 0.117 ms

Le temps d’exécution est plus élevé pour le premier utilisateur lorsqu'on
utilisait une limite à 1 mais il est beaucoup moins élevé que le temps
de recherche du dernier utilisateur sans index.

> explain analyse select score from rankings where nick = 'user1' limit 1;

                                                                 QUERY PLAN
    ------------------------------------------------------------------------------------------------------------------------------------
     Limit  (cost=0.42..8.44 rows=1 width=4) (actual time=0.088..0.092 rows=1 loops=1)
       ->  Index Scan using rankings_nick_index on rankings  (cost=0.42..8.44 rows=1 width=4) (actual time=0.078..0.078 rows=1 loops=1)
             Index Cond: ((nick)::text = 'user1'::text)
     Total runtime: 0.143 ms

Le temps de recherche est constant, on voit qu'on utilise un index pour récupérer
l'entrée avec la ligne user1000000.

De la même manière sans utiliser la limite le temps d'exécution est toujours très court.
Ici la différence de temps d'exécution s'explique par le fait que la même requête
vient d'être faite.

Si on prend l'utilisateur n°1 le résultat est identique en terme de temps d'exécution.
On a donc un temps d'exécution constant quelque soit la position de l'utilisateur
dans la table.

==========================================================================================

On peut définir l'ordre du classement comme ceci :

* plus le score est grand, meilleur est le classement et
* en cas d'égalité, plus nick est petit, meilleur est le classement.

Une page de classement s'obtient en demandant les joueurs meilleurs ou moins bon qu'un
autre.

Pour récupérer les 10 meilleurs joueurs après un utilisateur donné, on aura les requêtes suivantes.
Ici on va prendre user1000.

> select score from rankings where nick = 'user1000' limit 1;

     score
    -------
     225729

On obtient son score, qu'on garde en tête pour les prochaines requêtes.
On récupère toutes les entrées de la table qui ont un score
supérieur à 225729 ou dont le score est égal à 225729 et dont le nick
est inférieur ou égal à user1000.

On ne cherche pas à récupérer tous les utilisateurs mais uniquement un sous ensemble de 10 utilisateurs.
On ordonne sur le score et la colonne nick en fonction des critères vus précédemment.

> select * from rankings where score > 225729 or (score = 225729 and nick <= 'user1000') order by score asc, nick desc limit 10;

        nick    | score
    ------------+-------
     user1000   | 225729
     user955918 | 225730
     user873925 | 225730
     user891089 | 225731
     user513452 | 225732
     user511353 | 225732
     user335650 | 225733
     user567337 | 225735
     user995498 | 225736
     user17114  | 225738

On peut voir que cette requête inclue l'utilisateur 1000 et qu'on a bien
le classement des utilisateurs qui sont meilleurs que lui.

Analysons cette requête afin de voir ce qui est fait par le système de gestion de base de
données.

> explain analyse select * from rankings where score > 12193 or (score = 12193 and nick <= 'user1000') order by score asc, nick desc limit 10;

                                                               QUERY PLAN
    --------------------------------------------------------------------------------------------------------------------------------
     Limit  (cost=44276.35..44276.38 rows=10 width=14) (actual time=3926.246..3926.294 rows=10 loops=1)
       ->  Sort  (cost=44276.35..46748.78 rows=988973 width=14) (actual time=3926.238..3926.256 rows=10 loops=1)
             Sort Key: score, nick
             Sort Method: top-N heapsort  Memory: 17kB
             ->  Seq Scan on rankings  (cost=0.00..22905.00 rows=988973 width=14) (actual time=0.020..2004.869 rows=987925 loops=1)
                   Filter: ((score > 12193) OR ((score = 12193) AND ((nick)::text <= 'user1000'::text)))
                   Rows Removed by Filter: 12075
     Total runtime: 3926.353 ms

Le résultat de cette commande nous montre qu'on a un tri, qui a lieu
sur score et nick.

Ensuite on voit qu'aucun index n'est utilisé et qu'une recherche
séquentielle est faite sur la table rankings pour trouver 10 utilisateurs
qui satisfont nos critères.

Notre index sur la colonne nick n'influe donc pas sur la vitesse de cette
requête.

==========================================================================================

Pour tenter d'améliorer la situation, on ajoute un index sur la colonne score.
On avait déjà un index sur la colonne nick, peut être qu'avec un index sur la colonne
score notre requête sera plus efficace.

> create index rankings_score_index on rankings (score);

On tente de visualiser le plan proposé pour notre dernière requête :

> explain analyse select * from rankings where score > 12193 or (score = 12193 and nick <= 'user1000') order by score asc, nick desc limit 10;

                                                               QUERY PLAN
    --------------------------------------------------------------------------------------------------------------------------------
     Limit  (cost=44276.35..44276.38 rows=10 width=14) (actual time=3954.005..3954.055 rows=10 loops=1)
       ->  Sort  (cost=44276.35..46748.78 rows=988973 width=14) (actual time=3953.996..3954.013 rows=10 loops=1)
             Sort Key: score, nick
             Sort Method: top-N heapsort  Memory: 17kB
             ->  Seq Scan on rankings  (cost=0.00..22905.00 rows=988973 width=14) (actual time=0.022..2015.880 rows=987925 loops=1)
                   Filter: ((score > 12193) OR ((score = 12193) AND ((nick)::text <= 'user1000'::text)))
                   Rows Removed by Filter: 12075
     Total runtime: 3954.112 ms

On voit que l'index sur le score n'a été d'aucune utilité puisqu'on a exactement
le même plan qu'avant.

On va donc supprimer notre index puisqu'il ne sert à rien.

> drop index if exists rankings_score_index;

==========================================================================================

Ajouter naïvement un index sur le score n'est pas suffisant. Il faut ajouter un index
composite sur les champs utilisés dans le order by. Cet index permettra d’accéder au
données directement dans l'ordre souhaité.

> create index rankings_score_nick_index on rankings (score asc, nick desc);

On peut afficher de nouveau l'analyse précédente:

> explain analyse select * from rankings where score > 12193 or (score = 12193 and nick <= 'user1000') order by score asc, nick desc limit 10;

                                                                             QUERY PLAN
    ------------------------------------------------------------------------------------------------------------------------------------------------------------
     Limit  (cost=0.42..1.03 rows=10 width=14) (actual time=14.095..14.223 rows=10 loops=1)
       ->  Index Only Scan using rankings_score_nick_index on rankings  (cost=0.42..59532.13 rows=988973 width=14) (actual time=14.082..14.132 rows=10 loops=1)
             Filter: ((score > 12193) OR ((score = 12193) AND ((nick)::text <= 'user1000'::text)))
             Rows Removed by Filter: 12075
             Heap Fetches: 12085
     Total runtime: 14.307 ms

On voit que le plan d’exécution a changé et que l'index est bien pris en compte, la phase
de filtrage est toujours présente mais les tris ont été remplacés par l'utilisation de
notre index.

Ajouter un index composite avec un ordre différent n'aurait pas été utile.

==========================================================================================

On remarque que l’exécution proposée par PostgreSQL utilise un filtre sur la condition de
notre where.

Utiliser un OR dans cette condition empêche l'utilisation de l'index sur le score.

On dispose en effet d'un index composite qui peut être utilisé sur son ou ses premiers éléments
comme un index classique.

En remplaçant ce OR par un AND, PostgreSQL va pouvoir mettre un peu plus à profit les index
que nous avons créés :

> explain analyse select * from rankings where score >= 12193 and (score != 12193 or nick <= 'user1000') order by score asc, nick desc limit 10;

                                                                                QUERY PLAN
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------
     Limit  (cost=0.42..20.41 rows=10 width=14) (actual time=0.049..0.336 rows=10 loops=1)
       ->  Index Only Scan Backward using rankings_score_nick_index on rankings  (cost=0.42..22040.13 rows=11027 width=14) (actual time=0.038..0.108 rows=10 loops=1)
             Index Cond: (score <= 12193)
             Filter: ((score <> 12193) OR ((nick)::text > 'user1000'::text))
             Rows Removed by Filter: 1
             Heap Fetches: 11
     Total runtime: 0.425 ms

On voit que le temps d'exécution est beaucoup plus rapide que sur la requête précédente.

Le filtre porte maintenant sur beaucoup moins d'éléments.

Comme quoi avoir de bon index ne suffit pas, il faut aussi travailler ses requêtes pour
être sûr de les exploiter.

==========================================================================================

