Bienvenue dans cette vidéo consacrée à la revue détaillée de la classe Array.

Dans une précédente vidéo, nous avons déjà survolé cette classe mais nous allons ici essayer d'en découvrir toute la puissance.

Comme d'habitude, les démonstrations seront faites dans IRB.

## Les déclarations

Nous avons vu qu'il est possible de créer un tableau avec la notation `[]` :

```ruby
a = []
```

Mais il est également possible d'utiliser la syntaxe classique `Array.new` qui peut prendre de zéro à deux arguments :

```ruby
a = Array.new(3)
a = Array.new(3, "foo")
```

Dans le premier cas notre tableau est initialisé à la taille spécifiée avec des éléments vides. Dans le deuxième cas, chaque élément représente ce qui est passé en deuxième argument.

Attention au piège, le tableau contient en fait des références à cet élément, pas des copies. Si vous en modifiez un, vous les modifierez tous :

```ruby
a[0].capitalize!
a
```

Si vous souhaitez que chaque élément soit un objet unique plutôt que de multiples références au même objet, il faut utiliser la syntaxe prenant un bloc :

```ruby
a = Array.new(3) { "foo" }
a[0].capitalize!
a
```

## Sélection et remplacement d'éléments

Il est courant de vouloir récupérer un ou plusieurs éléments en début ou fin de tableau, pour ce faire des méthodes nous facilitent la tâche :

```ruby
a.first
a.first(2)
a.last
a.last(2)
```

On sait qu'on peut également récupérer un élément à un index donné grâce à la notation `[index]` :

```ruby
a[0]
```

Mais on peut également récupérer un jeu d'éléments grâce à deux autres notations :

```
a[1, 2]
a[1..2]
```

La première demande de commencer la récupération à l'index "1" sur une longueur de deux éléments.
La seconde utilise un `Range` pour demander de récupérer les éléments des index 1 à 2 compris.

On peut se servir de cette même notation pour faire de l'affectation :

```
a[1, 2] = ["bar", "baz"]
a

a[1..2] = [2, 3]
a
```

On peut également récupérer plusieurs éléments éparpillés sur des index non-contiguës en une seule opération :

```
a = [10, 20, 30, 40, 50, 60]
a.values_at(0, 1, 4)
a.values_at(0..2, 5)
```

Une fois encore, on a utilisé un `Range`.

Il est également possible de récupérer le premier ou dernier éléments du tableau en le supprimant à la volée ce qui transforme notre tableau en pile :

```ruby
a_dup = a.dup
a_dup.shift
a_dup
a_dup.pop
a_dup
```

## Compter les éléments

Une autre opération commune est de vouloir compter le nombre d'éléments d'un tableau ou d'un sous-ensemble, plusieurs possibilités s'offrent à nous :

```ruby
a.size
a.count
a.count { |el| el > 30 }
```

La méthode `size` est la plus simple mais aussi la plus rapide puisqu'elle vérifie simplement la taille en mémoire du tableau.

La méthode `count` quant à elle est plus puissante puisqu'elle autorise un bloc qui va servir de filtre. Cette méthode est par contre plus lente puisqu'elle parcourt l'ensemble du tableau pour donner le résultat.

On va également pouvoir savoir si un tableau est vide ou s'il contient des éléments :

```ruby
a.empty?
a.any?
a.any? { |el| el > 100 }
```

Là encore, la méthode `any?` autorise un bloc de filtrage.

## Tri et recherche

La classe `Array` propose aussi de nombreuses méthodes permettant de faire du tri ou de la recherche :

```ruby
a.shuffle!
a.sort
a.sort { |a, b| b <=> a }
a.sort.reverse

b = ['Nico', 'Victor', 'Jon', 'Martin']
b.sort_by { |el| el.length }
b.sort_by { |el| [el.length, el] }
```

On peut rechercher le premier élément du tableau qui rempli une condition :

```ruby
a.find { |el| el > 20 }
```

ou tous les éléments qui remplissent la condition :

```ruby
a.find_all { |el| el > 20 }
```

Il existe également la méthode permettant de retourner tous les éléments qui ne répondent pas à la condition :

```ruby
a.reject { |el| el > 20 }
```

Dans la même veine nous avons la méthode `grep` qui permet de faire des recherches sur la base d'expressions rationnelles :

```ruby
b.grep(/ic/)
```

On peut éventuellement lui passer un bloc de transformation :

```ruby
b.grep(/ic/) { |el| el.length } 
```

On peut également rechercher les valeurs minimales et maximales :

```ruby
b.min
b.max
b.max { |a, b| a[1..-1] <=> b[1..-1] }
```

## Manipulation diverses

Finalement vous pourriez vouloir regrouper les éléments de deux tableaux, deux par deux, c'est ce que propose la méthode `zip` :

```ruby
c = a.zip(b)
```

et construire une chaîne en concaténant ces éléments :

```ruby
c.join("-")
```

## Conclusion

Nous avons vu ici la majeur partie des possibilités livrées par la classe `Array`, l'ensemble de ses méthodes devraient sans nul doute vous donner toutes les clés pour pouvoir effectuer vos manipulations. Nous avons volontairement omis quelques méthodes plus exotiques. Jetez un œil à la documentation si vous êtes curieux.

Quelques méthodes supplémentaires très pratiques sont mises à disposition par le module `Enumerable` que nous découvrirons plus tard.