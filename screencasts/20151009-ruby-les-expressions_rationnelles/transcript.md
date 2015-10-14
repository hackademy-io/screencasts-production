Bienvenue dans cette vidéo consacrée à la découverte de l'utilisation des expressions rationnelles en Ruby.

Les expressions rationnelles, ou parfois appelées à tord "expressions régulières", sont des expressions qui permettent de décrire un motif à rechercher dans une chaîne.

Comme d'habitude, nous ferons les démonstrations dans IRB.

## La théorie ##

Les expressions rationnelles peuvent être déclarées grâce une paire de slashes, avec la notation `%r` ou encore grâce à `Regexp.new` :

```ruby
s = "Ruby"
/Ruby/ =~ s
/[Rr]uby/ =~ s
%r(^abc) =~ s
Regexp.new("xyz%") =~ s
```
 
Il est possible d'utiliser des modifieurs pour modifier le comportement de l'expression rationnelles :

```ruby
/ruby/i =~ "Ruby"
```

Il existe beaucoup d'autres ancres et modifieurs utilisables dans les expressions rationnelles. Une bonne compréhension vous apportera beaucoup de bénéfices dans vos développements.

Faire le tour des possibilités prendrait bien plus de temps qu'on en a pour cette vidéo mais heureusement la documentation officielle de la classe `Regexp` est particulièrement exhaustive.

C'est un sujet tellement vaste que des livres entiers sont consacrés au sujet.

## En pratique ##

### Les échappements ###

Vous voudrez parfois rechercher des caratères qui correspondent à des caractères spéciaux dans les expressions rationnelles. Il faudra donc les échapper.

Vous pourrez les échapper à la main :

```ruby
/./ =~ s
/\./ =~ s
```

mais dans les cas plus complexes, il est préférable d'utiliser la méthode `escape` :

```ruby
Regexp.escape("[*?]")
```

### Début et fin de chaînes, de lignes et de mots ###

Les expressions rationnelles sont un bon moyen de détecter les débuts et fin de chaînes, de lignes et de mots.

Chercher un motif en début de ligne utilisera l'ancre "^", pour la fin de ligne on utilisera "$" :

```ruby
s = "abc def ghi"
/abc/ =~ s
/def/ =~ s
/^def/ =~ s
/def$/ =~ s
/ghi$/ =~ s
```

Si on remplace les espaces par des retours à la ligne, les résultats seront différents :

```ruby
s = "abc\ndef\nghi"
/abc/ =~ s
/def/ =~ s
/^def/ =~ s
/def$/ =~ s
/ghi$/ =~ s
```

D'autres ancres nous permettent de rechercher en début et fin de chaîne sans prendre en compte les retours à la ligne :

```ruby
s = "abc\ndef\nghi"
/\Aabc/ =~ s
/\Adef/ =~ s
/def\Z/ =~ s
/ghi\Z/ =~ s
```

On ne cherche donc plus en début ou fin de ligne mais bien en début et fin de chaîne ce qui est tout à fait différent.

De la même façon, on peut repérer les limites des mots ou au contraire tout ce qui n'en est pas :

```ruby
s = "Ruby is awesome"
s.gsub(/\b/, "|")
s.gsub(/\B/, "-")
```

## Conclusion ##

Les expressions rationnelles sont donc un moyen très puissant d'analyser du texte mais c'est aussi un outil assez difficile à prendre en main. Nous n'avons qu'effleuré les possibilités dans cette vidéo. 

La vidéo suivante nous permettra d'en apprendre un peu plus.