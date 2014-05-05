Pour que des utilisateurs acc§dent à votre application Rails, vous devez la lancer dans un serveur HTTP Ruby. Placé juste apr§s un serveur web tel que Apache ou nginx, il reçoit les requêtes du visiteur et les transmets à votre application.

# Le serveur HTTP de Rails et ses limites

Rails int§gre un serveur HTTP basique baptisé Webrick, que vous utilisez déjà durant le développement grâce à la commande :

    $ rails server

Il ne peut traiter qu'une requête à la fois. Les suivantes sont placées dans une file d'attente et son traitées les unes à la suite des autres, ce qui peut peut donner un résultat tr§s lent.

Prenons une application tr§s simple affichant l'heure actuelle. Un outil comme Apache Bench (ab) nous permet de simuler plusieurs accès simultanés à celle ci. Si on ajoute une pause de 3 secondes avant de retourner la réponse :

    def index
    sleep 3
end

En utilisant Apache Bench pour faire 2 acc§s simultanés à la page :

    $ ab --c2 -n2 http://127.0.0.1:3000/

On se rends compte que le temps total pour générer les deux pages est de 6 secondes : une requête générée en 3 secondes, une seconde requête générée en 3 secondes supplémentaires.

# Puma en production

Avec une application en production on utilise des serveurs HTTP Ruby capables de gérer plusieurs requêtes en parall§le comme Thin, Rainbows, Unicorn ou présentement Puma.

    $ puma -w2

Si l'on reprends le test précédent de 2 requêtes simultanées avec Puma :

    ab --c2 -n2 http://0.0.0.0:9292/

On obtient un temps de traitement de 3 secondes. Les deux requêtes sont traitées en parall§le, chacune par un des processus créés par Puma. Chaque processus est indépendant, et contient une copie compl§te de votre application et toutes les librairies utilisées.

# Preload app, ou comment réduire l'occupation mémoire

En production si vous devez charger, par exemple, 20 processus pour gérer 20 requêtes simultanées, l'occupation mémoire peut devenir tr§s importante.

    $ puma -w20

Puma est capable de ne charger qu'une seule fois en mémoire, pour tous les processus, les données de votre application et des librairies.

Pour activer cette fonction, passez le param§tre preload en ligne de commande et lancez Puma :

    $ puma -w20 --preload

Dans le cas de l'exemple précédent, on remarque que la consommation mémoire est passée de 27 Mo par processus à approximativement 2 Mo.

Notez bien que l'on parle de consommation mémoire au lancement de l'application. Chaque processus va ensuite consommer de la mémoire en fonction des données qu'il traite, et cela ne pourra pas être partagé ou réduit avec cette fonctionnalité.

## Pré-requis : Ruby 2.0+ et une app "thread-safe"

Preload app est un param§tre que l'on passer si l'on utilise Ruby 2.0 ou plus récente, les versions antérieures n'étant pas capables de gérer ce partage mémoire.

Notez enfin que votre application et toutes les biblioth§ques que vous utilisez doivent être "thread-safe". Pour expliquer simplement ce concept, disons que vous ne devez pas utiliser des variables globales une fois que votre application est lancée. Les variables globales sont en effet stockées dans l'espace mémoire partagé, ce qui fait qu'un processus altérant ces valeurs va les modifier pour tous les autres processus.

Vérifiez donc bien pour chacune des librairies utilisées que sa documentation mentionne qu'elle est bien pensée pour être "thread-safe". Dans le cas de Rails, par exemple, c'est le cas par défaut depuis la version 4.0.
