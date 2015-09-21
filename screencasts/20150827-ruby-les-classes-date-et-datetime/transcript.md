Bienvenue dans cette vidéo consacrée aux classes `Date` et `DateTime` en Ruby.

Cette vidéo vient compléter la vidéo à propos de la classe `Time` puisque ces deux classes l'enrichissent et apportent quelques outils supplémentaires.

Pour faire nos démonstrations, nous utiliserons une fois encore la console IRB.

## Les classe `Date` et `DateTime` et leurs motivations ##

La classe `Date` a été créée pour manipuler spécifiquement des dates sans tenir compte de l'heure. La classe `DateTime` quant à elle a été écrite pour apporter quelques méthodes manquantes à la classe `Time`, pour mieux cadrer la validation des dates et heures, gérer les différents types de calendriers et faciliter les analyses.

Il faut savoir qu'historiquement, avant Ruby 1.9, la classe `Time` était plus pauvre et limitée dans les valeurs possibles. Il n'était possible de gérer que des dates allant approximativement de 1901 à 2038.

Depuis la gestion des dates a été revue et le fossé entre la classe `Time` et `DateTime` a largement été réduit. Toutefois `DateTime` apporte encore quelques méthodes supplémentaires. Il est en parti possible de les reproduire dans la classe `Time` grâce à un `require 'time'`.

Les classes `Date` et `DateTime` partagent de nombreuses fonctionnalités et on va donc les présenter en parallèle.

## Pratique ##

Avant toute chose, il faut charger les classes `Date` et `DateTime` :

```ruby
require 'date'
```

### Création de dates ###

On peut maintenant les utiliser :

```ruby
d = Date.today
dt = DateTime.now
```

On peut bien évidemment créer des dates arbitraires :

```ruby
Date.new(2015, 9, 15)
DateTime.new(2015, 9, 15, 8, 10, 30, '+7')
```

On peut aussi créer des dates sur la base de la semaine calendaire et le jour de la semaine en lieux et place des jour et mois absolus :

```ruby
Date.commercial(2015, 5, 6)
```

On peut également créer une date sur la base du jour de l'année :

```ruby
Date.ordinal(2015, 34)
```

Il nous est également possible de faire de la validation de date :

```ruby
Date.valid_date?(2015,2,3)
Date.valid_date?(2015,2,29)
```

### Analyse des dates sous forme de chaînes ###

L'analyse de dates sous forme de chaînes est également facilité.

Là où la classe `Time` sera perdue :

```ruby
Time.new("2015-08-05")
```

La classe `Date` sera elle capable d'une analyse assez avancée :

```ruby
Date.parse("2015-08-05")
Date.parse("05/08/2015")
DateTime.parse("01/12/2015 09:43")
```ruby

La classe va même nous apporter quelques méthodes permettant d'analyser des formats de date répandus :

```ruby
DateTime.httpdate("Wed, 26 Aug 2015 15:13:02 GMT")
DateTime.iso8601('2015-02-03T08:10:30+07:00')
DateTime.rfc2822('Sat, 3 Feb 2015 04:05:06 +0700')
```

Si nous devons aller plus loin en supportant nos propres formats, c'est également possible :

```ruby
Date.strptime('03-02-2015', '%d-%m-%Y')
Date.strptime('2015!034', '%Y!%j')
```

Le template de format utilise ici la même syntaxe que `strftime` que nous avons déja vu.

### Arithmétique sur les dates ###

Comme pour la classe `Time`, les classes `Date` et `DateTime` nous permettent de faire de l'arithmétique :

```ruby
d + 1
d.next_day

d - 5
d.prev_day(5)

d << 2
d.prev_month(2)
d >> 2
d.next_month(2)

d.prev_year(2)
d.next_year(2)

other_date = Date.new(2015, 8, 2)
d - other_date
d <=> other_date
```

### Affichage et formattage des dates ###

Pour ce qui est de l'affichage des dates, nous avons également tout le nécessaire :

```ruby
dt.asctime
dt.to_s
dt.httpdate
dt.iso8601
dt.rfc2822
dt.strftime("%T%:z")
```ruby

Il nous est possible de récupérer le détail des éléments qui composent une date :

```ruby
dt.day
dt.month
dt.year
dt.hour
dt.min
dt.sec
```ruby

```ruby
d.cwday
d.cweek
d.yday
```

Une fois encore il nous est possible de savoir si la date correspond à un jour donné de la semaine :

```ruby
d.monday?
d.wednesday?
```

Au besoin, il est également possible de convertir un objet d'un type vers un autre :

```ruby
d.to_datetime
dt.to_date
dt.to_time
```

Finalement il nous est possible de parcourir des périodes pour y faire des traitements divers et variés :

```ruby
other_date.upto(d).count { |d| d.sunday? } 
d.downto(other_date).count { |d| d.sunday? } 
other_date.step(d, 2).count { |d| d.sunday? }
```

## Conclusion ##

Comme vous avez pu le voir ici, les classes `Date` et `DateTime` apportent les dernières briques qui permettent de manipuler très naturellement des dates et heures.

C'est une base solide pour l'écriture de méthodes de manipulation de plus haut niveau. Rails, par exemple, les utilise très largement pour manipuler les dates et heures en base de données et bien plus encore.
