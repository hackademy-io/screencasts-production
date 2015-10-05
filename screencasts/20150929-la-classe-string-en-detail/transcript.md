Bienvenue dans cette vidéo consacrée à la revue détaillée de la classe String.

Dans une précédente vidéo, nous avons déjà survolé cette classe mais nous allons ici essayer d'en apprendre plus.

Comme d'habitude, les démonstrations seront faites dans IRB.

## Les déclarations 

Les chaînes peuvent être déclarées de différentes façons. Tout d'abord avec des guillemets simples ce qui créera la chaîne telle quelle sans transformation, il faudra simplement penser à échapper les guillemets simples :

```ruby
puts 'Ceci est une chaîne'
puts 'Aujourd\'hui'
```

On peut ensuite créer des chaînes en utilisant des guillemets doubles qui apportent plus de puissance puisqu'on pourra utiliser d'autres séquences d'échappement, des tabulations, retours à la ligne, etc. On pourra également interpoler des variables au sein de la chaîne :

```ruby
puts "Une tabulation (\t)"

s = "Nico"
puts "De l'interpolation #{s}"
```

Il existe également des moyens alternatifs de représenter les chaînes qui deviennent pratique quand la chaîne contient beaucoup de guillemets ou de caractères d'échappement :

```ruby
puts %q(Une chaîne avec des '', des "" et des "\t" et #{s})
puts %Q(Une chaîne avec des '', des "" et des "\t" et #{s})
```

La version minuscule correspond donc à une chaîne à guillemets simples alors que la version majuscule correspond à une chaîne à guillemets doubles.

Pour déclarer les très longues chaînes, les "Here-Documents" sont là pour nous aider. C'est très utile lorsqu'on souhaite créer une chaîne qui s'étend sur plusieurs lignes :

```ruby
puts <<EOF
une chaîne sur
plusieurs lignes
EOF
```

La chaîne doit donc commencer par deux chevrons suivi d'un identifieur. Cet identifieur sera ré-utilisé pour signifier la fin de la chaîne.

## Les utilitaires de la classe `String` ##

Voyons maintenant les méthodes utiles de la classe `String`. 

Souvent vous aurez besoin de connaître la longueur d'une chaîne :

### Comptage ###

```ruby
s.length
```

Ou connaître le nombre d’occurrences d'une sous-chaîne dans la chaîne :

```ruby
s.count("a")
s.count("a-i")
s.count("^a-i")
```

### Parcourir ###

On pourra également vouloir parcourir du texte, ligne par ligne :

```ruby
s = <<EOF
Première ligne
Deuxième ligne
Troisième ligne
EOF

s.each_line do |line|
  puts line.chomp + " !"
end
```

Ou encore caractère par caractère :

```ruby
s = "Ruby is awesome!"
s.each_char do |char|
  print char + "-"
end
```

Il sera assez fréquent de vouloir comparer deux chaînes pour savoir laquelle est la plus "grande", on pourra le faire en tenant compte de la casse ou non :

```ruby
"ab" <=> "AB"
"ab".casecmp("AB")
```

### Découpage ###

On peut également découper notre chaîne sur l'espace, un caractère quelconque ou encore une expression rationnelle :

```ruby
s.split
s.split("e")
s.split(/\W+/)
```

On pourra même limiter le nombre de champs retournés :

```ruby
s.split(/\W+/, 2)
```

La méthode `scan` quant à elle va permettre de nous retourner un tableau des éléments qui répondent à une expression rationnelle donnée :

```ruby
s.scan(/\w+/)
s.scan(/\w+/) { |w| print "<<#{w}>> " }
```

### Formater ###

Ceux qui ont fait du C doivent sans nul doute connaître la fonction `sprintf` qui existe aussi en Ruby et permet un formatage puissant des chaînes :

```ruby
name = "Nico"
age = 34

sprintf("Salut %s, tu as déjà %d ans…", name, age)
```

Jusque là rien de bien épatant, une simple chaîne avec interpolation aurait fait l'affaire. Mais `sprintf` va bien plus loin dans ses possibilités :

```ruby
sprintf("Salut %-20s, tu as déjà %03d ans…", name, age)
```

On peut également ajuster notre texte à l'affichage :

```ruby
name.ljust(15)
name.center(15)
name.rjust(15)
name.center(15, "-")
```

ou encore gérer la casse :

```ruby
s.downcase
s.upcase
s.capitalize
s.swapcase
```

### Accéder et assigner des sous-chaînes ###

En Ruby, il est également très facile de travailler avec des sous-chaînes. On peut à la fois accéder à des sous-chaînes mais également les modifier.

D'abord on y accède avec la notation [index de départ, longueur] :

```ruby
s[0, 4]
s[-8, 7]
```

Puis à l'aide de `Range` :

```
s[0..3]
s[-8..-2]
```

L'utilisation d'expressions rationnelles est également possible :

```ruby
s[/a.*e/]
```

On peut également utiliser l'ensemble de ces notations pour accéder à une sous-chaîne et la modifier :

```ruby
s[/a.*e/] = "yummy"
s
```

### Rechercher dans une chaîne ###

Il y d'autres façon de faire des recherches dans une chaîne qui conviendront mieux en fonction du cas d'utilisation :

```ruby
s.index("m")
s.index(/.y/)

s.rindex("m")
s.rindex(/.y/)

s.include?("a")
s.include?("uby")
```

On peut aussi obtenir un tableau des occurrences grâce à la méthode `scan` :

```ruby
s.scan("m")
s.scan(/.y/)
```

### Manipulation diverses ###

Dans la série des inclassables, il nous reste quelque méthodes à connaître. 

D'abord la possibilité de supprimer un caractère donné dans une chaîne :

```ruby
s.delete("u")
```

Il y a également la possibilité d'avoir la suite logique d'une chaîne :

```ruby
"R2D2".succ
```

Et finalement la possibilité de répéter une chaîne :

```ruby
etc = "Etc. " * 3
```

## Conclusion ##

Nous avons vu ici la majeur partie des possibilités livrées par la classe `String` qui, de base, est très bien fournie. Ce n'est pas un tour exhaustif des méthodes et de leurs possibilités mais le principal est là. Si vous êtes curieux, je vous conseille de jeter un œil à la documentation.
