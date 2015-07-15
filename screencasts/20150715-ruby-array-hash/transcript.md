Bienvenue dans cette vidéos consacrée à la découverte des classes `Array` et `Hash`en Ruby.

Avant de démarrer assurez vous que vous possédez une version récente de Ruby, nous utilisons ici la 2.2.

Nous allons, comme dans la vidéo précédente utiliser la console interactive IRB pour faire la démonstration de l'utilisation des différentes classes.

### Les tableaux : Array

Les tableaux sont très utilisés et vous permettent  de stocker et d'ordonner un jeu d'objets. On peut stocker des objets de différents types au sein d'un même tableau.

On stocker un tableau dans la variable `a`. Ce tableau contient certain nombre d'entiers. Ici 2, 5 et 10.

On va ensuite ajouter un entier supplémentaire à la fin de ce tableau grâce au double chevron qui est un sucre syntaxique pour un vrai appel de méthode, la méthode `push`.

On va maintenant ajouter un entier en début de tableau grâce à la méthode `unshift` et on va essayer de rappeler l'une des valeurs grâce à son index que l'on passe entre crochets. C'est encore une fois un sucre syntaxique pour la méthode `at`.

Nous ajoutons maintenant en fin de tableau deux objet `nil` qui représentent le néant. Et nous allons compacter le tableau, c'est à dire supprimer l'ensemble de ses valeurs `nil`.

On appele donc pour ce faire la méthode `compact!`.

On ajoute maintenant un tableau en fin de tableau et on va donc se retrouver avec un tableau à deux dimensions. On va maintenant aplatir ce tableau grâce à la méthode `flatten!` puis on va rendre les valeurs uniques grâce à la méthode `uniq!`. On a donc ici chaîné deux appels de méthode.

On ajoute maintenant une chaîne "foo" en fin de tableau et on va chercher à connaître son index grâce à la méthode `index`.

On mélange ensuite le tableau grâce à la méthode `shuffle`.

On va maintenant créer un nouveau tableau qui va contenir les valeurs doublées de chaque valeur du premier tableau et pour ce faire on utilise la méthode `map` qui nous permet d'itérer sur chaque valeur du premier tableau et de stocker dans le nouveau tableau la valeur qui est retournée par notre morceau de code, ici la valeur multipliée par deux.

On se retrouve donc bien avec un tableau pour lequel l'ensemble des valeurs ont été doublées et notamment la chaîne qui est devenue "foofoo".

On va maintenant soustraire au tableau `double_a` le tableau `a`, on a donc supprimé les valeurs communes.

On procède ensuite à une jointure entre le tableau `double_a` et le tableau `a`, grâce au `|`

Et on fait maintenant une intersection entre le tableau `double_a` et le tableau `a`. Ce qui nous retourne uniquement les valeurs communes.

### Les tableaux associatifs : Hash

On passe maintenant aux tableaux associatifs représentés en Ruby par la classe `Hash`. On va donc stocker dans la variable `h` un tableau associatif. On utilise donc une accolade ouvrante et un ensemble de clés / valeurs puis on referma avec une accolade fermante.

Ici les clés sont un élément un peu spécial de Ruby qu'on appelle des symboles mais on reviendra sur ce point précis plus tard.

On va ensuite essayer d'afficher la valeur de l'une des clés.

On essaie de récupérer la valeur d'une clé qui n'existe pas ce qui nous retourne `nil` et on va modifier le comportement de ce hash pour qu'il ait une valeur par défaut sur les clés qui n'existent pas, ici la chaîne "Foo".

Si on appelle à nouveau cette clé qui n'existe pas, on a maintenant la valeur par défaut qui nous est retournée.

On recherche maintenant une clé qui existe.

On crée un nouveau hash avec une clé commune au premier hash, le symbole `:a`. Et une clé qui n'existe pas, le symbole `:z` dans lequel on va stocker "baz".

On note que la valeur pour la clé `a` est différente de la valeur pour la clé `a` du premier tableau.

On va maintenant procéder à un merge entre les deux tableaux et on voit donc que la valeur associée à la clé `a` a été modifiée pour prendre celle qui était disponible dans `h2` et la clé `z` est tout simplement ajoutée.

### Conclusion

Voilà pour cette présentation rapide des types `Array` et `Hash` que vous utiliserez trés souvent.
 
Bien évidemment ce n'est ici que approche très succincte et une fois encore je vous invite à aller lire la documentation relative à ces classes.