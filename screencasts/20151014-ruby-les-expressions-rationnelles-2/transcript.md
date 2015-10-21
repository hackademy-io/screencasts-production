Bienvenue dans cette vidéo qui fait suite à la découverte de l'utilisation des expressions rationnelles en Ruby.

Nous n'avons la dernière fois pu voir que les bases et nous allons donc essayer d'aller plus loin dans cette nouvelle vidéo.

Continuons donc notre découverte dans IRB.

### Les quantificateurs ###

Vous aurez souvent besoin de gérer des motifs optionnels ou répétés. Les quantificateurs vous permettent de gérer ça.

On peut par exemple définir un ou plusieurs caractères optionnels, il pourront donc apparaître une fois ou pas du tout :

```ruby
re1 = /ax?b/
re2 = /a[xy]?b/

re1 =~ "ab"
re1 =~ "azb"
re1 =~ "axb"

re2 =~ "ayb"
re2 =~ "acb"
```

On peut également rechercher un caractère qui apparaît au moins une fois :

```ruby
re = /[0-9]+/
re =~ "1"
re =~ "8765432"
```

On peut simplifier cette expression avec l'ancre dédiée à la recherche de numériques :

```ruby
/\d+/ =~ "123"
```

Il est très fréquent de vouloir définir un motif qui peut apparaître de zéro ou une infinité de fois :

```ruby
re = /Yeah!*/
re =~ "Yeah"
re =~ "Yeah!!!!"
```

On peut préciser le nombre d’occurrences qu'on attend :

```ruby
re = /\d{3}-\d{2}-\d{2}/
re =~ "123-45-67"
re =~ "1-45-67"
```

On pourra aussi définir un nombre d’occurrences variable :

```ruby
re = /\d{1,3}-\d{2}-\d{2}/
re =~ "123-45-67"
re =~ "1-45-67"
```

Il faut savoir que les quantificateurs "*", "+" et "{}" sont gourmands par défaut, ils vont essayer de récupérer la plus grande partie de la chaîne qui correspond :

```ruby
s = "Il est à la fois le plus petit et le plus grand"
/.*le/.match(s)
```

Pour n'attraper que la plus petite occurrence, il faut demander à l'opérateur de ne pas être gourmand grâce au "?" :

```ruby
/.*?le/.match(s)
```

## Les groupes ##

Dans une expression rationnelle, il est possible de créer des groupes ré-utilisables. Chaque groupe pour lequel on a une correspondance sera donc accessible ensuite pour utilisation.

### Les groupes simples ###

Un groupe est créé en utilisant les parenthèses :

```ruby
"Ruby".sub(/(.)(.)(.)(.)/, '<\4> <\3> <\2> <\1>')
```

Pour chaque groupe qui aura une correspondance, on obtient un identifieur spécial. On a dans notre exemple quatre jeux de parenthèses et donc les identifieurs de 1 à 4.

La méthode `match` permet d'aller plus loin en retournant un objet `MatchData` :

```ruby
s = "alpha beta gamma delta epsilon"
re = /(b[^ ]+) (g[^ ]+) (d[^ ]+)/
md = re.match(s)
md[1]
md[2]
md[3]
md[0]
md.begin(2)
md.pre_match
md.post_match
```

### Les groupes nommés ###

Vous aurez sûrement remarqué qu'il faut compter les groupes pour savoir qui correspond à quoi. Ce n'est pas toujours pratique. Heureusement, Ruby nous permet de mettre en place des groupes nommés :

```ruby
re = /(?<beta>b[^ ]+) (?<gamma>g[^ ]+) (?<delta>d[^ ]+)/
md = re.match(s)
md[:beta]
```

Il suffit donc de commencer le groupe par un point d'interrogation suivi d'un identifieur entre chevrons. On peut ensuite faire référence au groupe grâce à cet identifieur.

L'écriture est plus longue mais la lisibilité est considérablement augmentée.

## Recherche en avant ##

Dans les expressions rationnelles il est possible de faire de la recherche en avant (lookahead) pour ne les valider que si elles sont suivies ou non par un motif précis. Ce motif ne sera pas retourné dans notre résultat :

```ruby
s1 = "J'aime le Ruby"
s2 = "J'aime le PHP"
s3 = "J'aime le Javascript"

re = /J'aime le (?=Ruby|Javascript)/
re.match(s1)
re.match(s2)
re.match(s3)
```

On voit donc que l'expression n'est vérifiée que si elle est suivi par le mot "Ruby" ou "Javascript".

On peut également faire l'inverse, à savoir ne valider que si ce qui suit ne correspond pas :

```ruby
re = /J'aime le (?!Ruby|Javascript)/
re.match(s1)
re.match(s2)
re.match(s3)
```

Ici seule les correspondances n'étant pas suivies par les mots "Ruby" ou "Javascript" seront validées.

## Recherche en arrière ##

Il est également possible de faire le même type d'opérations mais en revenant en arrière (lookbehind).

L'utilisation de cette technique est plus difficile à décrire par un cas pratique. Ça pourrait être pour modifier du contenu dans un langage balisé après analyse de ses balises ou encore pour analyser des séquences ADN.

Je vais donc reprendre un exemple d'utilisation connu pour nécessiter les recherches en arrières.

Imaginons que vous vouliez retrouver dans une séquence ADN, toutes les séquences nucléotidiques, de quatre éléments donc, qui suivent un "T". On ne pourrait pas simplement chercher le "T" puisqu'on ne serait plus capable de détecter deux séquences contiguës si la première finie par un "T". Pour illustrer cela utilisons la séquence suivante :

```ruby
adn = "GATTACAAACTGCCTGACATACGAA"
adn.scan(/T(\w{4})/)
```

Il manque donc la séquence "GACA" qui suit la séquence "GCCT" qui est elle même une des correspondances.

En utilisant la recherche arrière, on pourrait palier à ce problème en demandant de vérifier également le caractère précédent :

```ruby
adn.scan(/(?<=T)(\w{4})/)
```

## Conclusion ##

Les expressions rationnelles permettent donc des recherches très avancées. Ça sera parfois la seule solution à votre problématique.

Il faut par contre avoir conscience qu'elles sont des opérations coûteuses. Si vous pouvez vous en passer votre programme n'en sera que plus réactif.

Pour continuer l'exploration, je vous invite à tester des expressions dans votre console et à lire attentivement la documentation de la classe `Regexp`.
