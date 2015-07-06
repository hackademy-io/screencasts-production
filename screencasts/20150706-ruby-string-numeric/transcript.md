Bienvenue dans cette toute nouvelle série dédiée à la découverte du langage Ruby.

Nous allons commencer par des sujets très simples qui vont vous permettre d'acquérir des bases solides avant nous attaquer à des aspects plus complexes du langage.

Cette série sera découpée en vidéos très succintes ne traitant que d'un sujet bien délimité.

Avant de démarrer assurez vous que vous possédez une version récente de Ruby, nous supposons dans cette vidéo que votre version de Ruby est supérieure ou égale à la 2.2.

Vous pouvez vérifier la version actuelle à l'aide de la commande `ruby -v`.

Si votre version de Ruby est trop ancienne, vous pouvez installer une version plus récente grâce à un gestionnaire de version tel que Rbenv ou encore RVM.

Dans ses vidéos nous utiliserons beaucoup un outil très utile livré avec Ruby qui s’appelle IRB. C'est une console interactive qui permet de saisir du code Ruby et de voir en retour le résultat de l'expression évaluée.

C'est donc notamment très pratique pour tester de petits morceaux de code, vérifier une syntaxe ou comparer deux implémentations.

Dans ces vidéos IRB vous permettra de voir en temps réel le résultat d'une expression sans avoir à tester de votre côté en parallèle.

Entrons maintenant dans le vif du sujet en parcourant les types "primitifs" disponibles en Ruby et que vous utiliserez au quotidien.

En Ruby, tout est objet, même ce que nous appelons ici les types primitifs. Quand nous utilisons ces types primitifs nous utilisons donc en fait une instance d'une classe.

Nous appelons ici la méthode `times` sur l'entier 2 ce qui va nous permettre d'afficher deux fois la chaîne "Hello".

Nous appelons ensuite la méthode `upto` sur l'entier 3 avec pour paramètre `5` ce qui va nous permettre d'afficher les entiers de 3 à 5.

Nous créons maintenant une chaîne "Hackademy" sur laquelle nous appelons la méthode `size` qui nous permet de connaître sa taille.

On voit que ses types primitifs sont en fait des objets sur lesquels on peut appeler des méthodes.

## La classe String

Voyons maintenant plus en détail la classe `String`.

Nous stockons ici une chaîne dans la variable `s` puis nous vérifions sa classe à l'aide de la méthode `class`. C'est bien une `String` qu'on a ici.

Nous appelons ensuite la méthode `succ` qui permet d'avoir le successeur de cette chaîne, ici le dernier caractère devient le "z".

Nous changeons maintenant le contenu de cette chaîne par "hackademy" suivi d'un retour à la ligne. Et nous appelons la méthode `chomp` dessus qui permet de supprimer ce retour à la ligne.

Nous changeons à nouveau le contenu de la variable `s` pour y mettre "hackademy". Nous allons appeler la méthode `chop` dessus qui permet simplement de supprimer le dernier caractère.

Nous vérifions maintenant la longueur de la chaîne `s` grâce à la méthode `length`.

Nous appelons maintenant la méthode `capitalize` qui n'agit que sur la première lettre. Puis la méthode `upcase` qui elle permet de transformer toute la chaîne.

## Les numériques : Numeric, Fixnum, Bignum, Integer, Float

Passons maintenant aux `Numeric`, c'est à dire les entiers mais aussi les nombres à virgules flottante.

Nous allons d'abord stocker l'entier "20" dans la variable `i`, vérifier sa classe, c'est un `Fixnum`. Les `Fixnum` sont en fait une classe enfant de la classe `Numeric`.

Cette classe `Numeric` regroupe donc les entiers, les flottants, les très grands entiers.

Nous appelons la méthode `succ` qui permet d'avoir le successeur, c'est ici 21.

Nous faisons une simple addition, 2 + 3 et nous nous rendons compte que c'est en fait un sucre syntaxique pour un appel de méthode : `2.+(3)`.

Vérifions maintenant la classe d'un nombre à virgule flottante, c'est un `Float`. Les `Float` eux aussi sont des enfants de la classe `Numeric`.

### Conclusion

Voilà pour cette présentation rapide des objets des classes `String` et `Numeric` que vous utiliserez au quotidien.
 
Nous n'avons ici qu'effleuré la surface des possibilités de ces classes. Je vous invite donc à en lire la documentation pour découvrir l'étendu des possibilités.