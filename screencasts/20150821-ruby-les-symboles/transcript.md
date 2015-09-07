Bienvenue dans cette vidéo consacrée à la présentation des symboles en Ruby.

Pour ce screencast nous utilisons la version 2.2 de Ruby et nous ferons les démonstrations dans IRB.

## La théorie

Les symboles sont l'un des éléments du langage les plus utilisés.

Un symbole est une instance de la classe `Symbol`. Pour en déclarer un il suffit d'utiliser les deux-points suivi par un identifieur.

Un symbole ressemble à une chaîne dans son fonctionnement et son usage. Mais contrairement aux chaînes, chaque symbole n'a qu'une seule instance et n'existe donc qu'une seule fois en mémoire :

```ruby
:foo.class

:foo.object_id
:foo.object_id

"foo".object_id
"foo".object_id
```

Il y a donc une différence importante entre ces deux types d'objets qui peut impacter la consommation mémoire ou les performances de votre programme.

Si on crée un tableau comme suit :

```ruby
array = ["foo", :foo, "foo", :foo, :foo]
```

Les deux chaînes "foo" seront des objets distincts en mémoire. Les symboles `:foo` sont quand à eux plusieurs références vers le même objet en mémoire. On peut voir ça comme un objet unique qui a un nom.

## Utilisation


### Identifieur

L'utilisation la plus commune pour les symboles est de s'en servir pour représenter le nom d'une variable ou d'une méthode. Rappelez-vous dans les épisodes précédents nous avons vu comment ajouter des accesseurs à une classe, nous nous sommes servi de symboles à cette occasion :

```ruby
class Foo
	attr_accessor :something
end
```

Nous aurions très bien pu utiliser une chaîne à la place du symbole, ça aurait tout de même fonctionné. À vrai dire, la plupart des méthodes livrées avec Ruby qui attendent un symbole en argument savent aussi se débrouiller avec un chaîne.

Un symbole est finalement très proche d'un chaîne, il est composé par une suite de caractères. On peut considérer qu'un symbole est un peu comme une chaîne immuable. On peut d'ailleurs simuler le comportement d'un symbole à l'aide d'une chaîne :

```ruby
"foo".freeze.object_id
"foo".freeze.object_id
```

Le fait de geler la chaîne fait qu'elle n'est instanciée qu'une fois et représente toujours le même objet en mémoire.

Mais malgré ces similitudes, il ne faut pas s'y méprendre, les symboles et les chaînes sont des objets différents avec une interface publique différente. Les symboles n'héritent pas de la classe `String`.

```ruby
:foo.kind_of?(String)
```

Il est à noter qu'on peut créer des symboles contenant des caractères spéciaux en entourant l'identifieur de guillemets :

```ruby
:"identifieur peu commun !"
```

On pourrait donc créer des méthodes avec des noms barbares mais ce n'est pas une bonne idée.

### Énumération

Une autre utilisation fréquente des symboles est de s'en servir pour créer des énumérations :

```ruby
STATUSES = [:draft, :published, :pinned]
NORTH, SOUTH, EAST, WEST = :north, :south, :east, :west
```

C'est plus expressif que d'utiliser, par exemple, des entiers pour définir les points cardinaux.

### Méta-valeur

Un autre usage assez commun est d'utiliser les symboles comme des méta-valeurs. Ils vont donc pouvoir être utilisés comme code de retour de méthodes qui n'ont pas vocation à être des chaînes qui seront utilisées en tant que tel. C'est une fois encore plus expressif que de retourner des entiers.

## Conversion des symboles en chaîne et vice-versa

Il est très facile de convertir des symboles en chaîne et vice-versa. C'est pratique pour permettre à vos méthodes d'utiliser indépendamment l'un ou l'autre en tant que paramètre par exemple :

```ruby
"foo".to_sym
:foo.to_s

def hello_dude(name)
	puts "Hello #{name.to_s}!"
end

hello_dude("Nico")
hello_dude(:Nico)
```

## Génération de proc

La dernière utilisation commune pour les symboles permet de raccourcir les appels à des méthodes qui acceptent un bloc en paramètre. Disons par exemple qu'on veut capitaliser chaque mot d'un tableau, on pourrait faire :

```ruby
array = ["one", "two", "three"]
array.map { |word| word.capitalize }
```

mais Ruby permet de raccourcir cet appel très commun grâce à l'utilisation d'un symbole qui va permettre de générer le bloc à la volée :

```ruby
array.map(&:capitalize)
```

## Conclusion

Les symboles sont un des piliers de Ruby qu'il est important de maîtriser pour améliorer votre code mais aussi pour comprendre celui des autres. Désormais quand vous créerez une chaîne, demandez vous si c'est vraiment ce dont vous avez besoin. Allez-vous la manipuler en tant que tel ? Si la réponse est non, vous avez certainement besoin d'un symbole pour représenter cette valeur.