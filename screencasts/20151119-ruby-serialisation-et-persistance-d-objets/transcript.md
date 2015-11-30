Bienvenue dans cette vidéo faisant suite aux vidéos sur les entrées / sorties.

Nous verrons aujourd'hui comment persister des objets Ruby sur le disque pour pouvoir les ré-utiliser plus tard.

Plusieurs possibilités s'offrent à nous pour arriver à nos fins.

La brique la plus simple mise à notre disposition est la classe `Marshal`.

## Persistence simple avec Marshal ##

Dans la plupart des cas, le besoin sera de pouvoir sauver de manière permanente des objets que vous avez créé pendant le cycle de vie de votre programme. Vous pourrez donc, en le relançant plus tard, récupérer ses informations pour les restituer à l'utilisateur ou continuer un traitement.

On pourrait par exemple vouloir gérer une structure consistant en un tableau à deux dimensions. Disons un tableau de chansons, pour chaque chanson on aurait un tableau contenant, l'auteur, le titre et la durée.

Une fois ce tableau construit on voudra le sauver sur le disque pour y accéder à nouveau plus tard.

Mettons cet exemple en pratique. On crée donc notre tableau de musiques :

```ruby
songs = [
  ['Metallica', 'Nothing else matters', 389],
  ['Metallica', 'Sad but true', 325],
  ['Born of Osiris', 'The other half of me', 212]
]
```

On va maintenant créer un fichier pour stocker les informations :

```ruby
File.open("songs", "w") do |f|
  # Et y sérialiser les informations
  Marshal.dump(songs, f)
end
```

On pourra ensuite récupérer ses informations pour s'en servir :

```ruby
File.open("songs") do |f|
  songs = Marshal.load(f)
end
```

Comment faire plus simple ?

Malheureusement cette méthode ne permettra pas de sérialiser tout et n'importe quoi. Les classes de bas niveau ne sont pas sérialisables. On ne pourra pas, par exemple, sérialiser des objets issus des classes `IO` ou `Proc`. Les singletons, classes anonymes ou encore les modules ne peuvent pas non plus être sérialisés.

Vous pouvez par contre sérialisé sans souci vos classes maisons pour peu qu'elles n'embarquent pas un objet de bas niveau.

## Persistence améliorée avec PStore ##

Avec la classe `Marshal`, vous devez gérer un certain nombre de détails pour vous assurer que vos données persistées restent dans un état cohérent. Si un problème survient en milieu d'exécution, vous risquez d'avoir un fichier corrompu.

Pour faciliter la gestion de ce type de problématiques, Ruby met à disposition la classe `PStore`. Un objet `PStore` peut gérer une hiérarchie d'objets Ruby sous forme de clés / valeurs. La grande différence avec la classe `Marshal` est qu'un objet `PStore` va écrire ses changements sur le disque de façon transactionnel.

Lorsqu'un jeu de données sera modifié tout sera donc modifié avec succès ou sinon rien ne sera modifié. On évite donc de se retrouver avec des données dans un état transitoire sur le disque.

`PStore` se basant sur la classe `Marshal`, il est à noter que les mêmes limitations s'appliquent en ce qui concerne ce qui peut être sérialisé ou pas.

Voyons un exemple d'utilisation :

```ruby
require "pstore"

db = PStore.new("users")
db.transaction do
  db[123] = { name: "Nico", age: 34 }
end
```

Plus tard, nous pourrons récupérer ces informations :

```ruby
db2 = PStore.new("users")
db2.transaction { puts db2[123] }
```

Il est à noter qu'il est possible d'interrompre une transaction à tout moment, soit en conservant les changements effectués jusque là grâce à la méthode `commit`, soit en annulant les changements en utilisant la méthode `abort`.

Tous les changement qui suivront dans la transaction seront ignorés :

```ruby
db2.transaction do
  db2[1] = "test"
  db2.commit
  db2[2] = "foo"
end

db2.transaction do
  p db2[1]
  p db2[2]
end
```

On a donc enregistré les changements qui précédaient le `commit` mais pas les suivants. On aurait pu tout annuler avec `abort` :

```ruby
db2.transaction do
  db2[3] = "foo"
  db2.abort
  db2[4] = "bar"
end

db2.transaction do
  p db2[3]
  p db2[4]
end
```

On voit donc qu'ici rien n'a été persisté.

## Persistance avec YAML ##

Un autre format de persistance dont vous avez peut-être déjà entendu parler est YAML. L'avantage de ce format de stockage est qu'il est parfaitement lisible par une personne.

Le fait de charger la librairie "yaml" aura pour effet d'apporter une méthode `to_yaml` à chaque objet. Il devient alors possible de sérialiser des instances des classes de bases mais aussi de vos propres classes dans un format facilement compréhensible et exploitable.

Créons une classe simple pour illustrer l'utilisation :

```ruby
class Foo
  def initialize(a, b, c)
    @a, @b, @c = a, b, c
  end
end

foo = Foo.new("test", 123, {a: "foo", b: "bar", c: "baz"})
foo.to_yaml
```
On peut donc sauver ces données dans un fichier comme on le ferait pour stocker n'importe quelle autre chaîne :

```ruby
File.open("data.yml", "w") do |f|
  f.write(foo.to_yaml)
end
```

Voyons à quoi ressemble ce fichier :

```bash
cat data.yml
```

On pourra recharger ces informations plus tard de la manière suivante :

```ruby
file = File.new("data.yml")
YAML.load(file)
```

On a donc à nouveau une instance de la classe `Foo` à disposition. Elle contient les mêmes informations que lors de la sauvegarde.

Ce format de stockage est très apprécié des Rubyistes, notamment pour sa facilité d'édition.

## Stockage clés / valeurs avec DBM ##

Finalement, une autre option intéressante est la librairie DBM qui est un système de stockage sous forme de ficher basé sur des paires de clé / valeur. Ce sera donc un très bon moyen de persister vos `Hash`.

Il est à noter que les clés et les valeurs doivent être des chaînes. Hormis cela, un objet `DBM` se comporte de la même manière qu'un `Hash` et répond à quasiment toutes ses méthodes :

```ruby
require "dbm"

d = DBM.new("dbm")
d["foo"] = "bar"
d.close

d["foo"]

d2 = DBM.open("dbm")
d2["foo"]
d2.to_hash
d2.close
```

## Conclusion ##

Vous avez donc maintenant toutes les clés pour travailler avec les entrées sorties et vous pourrez largement en tirer partie dans vos programmes pour améliorer leurs qualités fonctionnelles.
