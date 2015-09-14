Bienvenue dans cette vidéo consacrée à la présentation de la classe Time en Ruby.

Pour ce screencast nous utilisons la version 2 de Ruby et nous ferons les démonstrations dans IRB.

## La théorie ##

La manipulation de dates et heures est une nécessité fréquente en programmation. Fort heureusement, en Ruby il est facile de manipuler ce type d'information.

Ruby met à notre disposition la classe `Time` qui permet de faire la majorité des manipulations inhérentes à ce type de données.

En interne, les objets de la classe `Time` sont stockés sous forme d'un entier qui représente le nombre de nano-secondes écoulées depuis ce qu'on appelle "Epoch" qui correspond au 1 janvier 1970 à minuit UTC.

Nous verrons dans une prochaine vidéo que les classes `Date` et `DateTime` apportent quelques outils supplémentaires qui améliorent la flexibilité.

## Création d'objets `Time` ##

La chose la plus fondamentale qu'on puisse vouloir faire est de connaître la date et l'heure courante :

```ruby
Time.new
```

Nous n'avons pas passé de paramètre à `new` c'est donc l'heure courante qui nous est retournée. Pour ce cas fréquent, il existe une méthode plus explicite :

```ruby
Time.now
```

Il existe plusieurs façon de créer des objets `Time`. Pour le fuseau horaire local, pour le fuseau horaire UTC et finalement pour un fuseau horaire arbitraire :

```ruby
Time.local(2015, 8, 12, 8, 15, 20)
Time.utc(2015, 8, 12, 8, 15, 20)
Time.new(2015, 8, 12, 8, 15, 20, "-05:00")
```

Les paramètres à passer vont de celui ayant la plus grande unité, l'année, à celui ayant la plus petite, la seconde. Seul l'année est un paramètre obligatoire :

```ruby
Time.local(2015, 8, 12, 8)
Time.local(2015, 8, 12)
```

Si vous tentez de créer une date invalide, disons avec un mois qui n'existe pas, vous auriez une exception `ArgumentError` qui serait levée :

```ruby
Time.local(2015, 13)
```

## Affichage des objets `Time` ##

De nombreuses méthodes sont mises à notre disposition pour manipuler ces dates :

```ruby
t = Time.local(2015, 8, 12, 8, 15, 20)
t.to_s
```

`to_s` nous retourne une version textuel de la date facilement compréhensible par un humain mais également simple à analyser avec un programme.

Il est également possible de formater la représentation à votre guise grâce à la méthode `strftime` :

```ruby
t.strftime("Printed on %d/%m/%Y")
t.strftime("at %H:%M")  
```

Les options de formatage sont très complètes et je vous invite à lire la documentation de `strftime` pour en avoir une liste exhaustive.

On peut par exemple utiliser le formatage suivant pour des dates compatibles ISO 8601 pour nos JSON :

```ruby
t.strftime("%FT%R")
```

## Les méthodes utilitaires ##

La classe `Time` nous livre aussi une panoplie de méthodes qui nous permettent de savoir si une instance correspond à un jour donné :

```ruby
t.monday?
t.tuesday?
t.wednesday?
t.thursday?
t.friday?
t.saturday?
t.sunday?
```

Nous avons aussi quelques méthodes qui nous permettent de récupérer le jour, le mois etc :

```ruby
t.day
t.month
t.year
t.hour
t.min
t.sec
t.usec
```

On peut également connaître le jour dans l'année que représente notre instance :

```ruby
t.yday
```

## Les fuseaux horaire ##

Nous avons également de quoi manipuler les fuseaux horaire. Quel est le fuseau horaire ?`

```ruby
t.zone
```

Est-ce que c'est une heure d'été ?

```ruby
t.dst?
```

Est-ce que c'est une heure UTC ?

```ruby
t.utc?
```

Convertir l'heure en heure locale

```ruby
t.getlocal
```

Convertir l'heure en heure UTC

```ruby
t.getutc
```

Quelle est le nombre de secondes de décalage entre mon heure et l'heure UTC ?

```ruby
t.utc_offset
```

## Arithmétique ##

Pour finir, il est également possible de faire de l'arithmétique sur les objets `Time` :

```ruby
t1 = Time.now
t2 = t1 + 60
```

On voit que `t2` est exactement une minute plus tard que `t1`, soit 60 secondes.

```ruby
t3 = t1 + 120

t1 != t2
t1 < t2

t2 - t1

t2.between?(t1, t3)
```

## Conclusion ##

La gestion des dates et heures en Ruby est donc quelque chose de très simple grâce à une panoplie de méthodes qui nous facilitent la vie.

Il devient facile d'écrire des méthodes de plus haut niveau pour manipuler de façon avancée ce type de données dans nos programmes. La librairie propose d'ailleurs les extensions `Date` et `DateTime` qui apportent encore plus d'aisance dans la manipulation.

D'autres librairies comme ActiveSupport vont encore plus loin et ajoutent encore plus de naturel dans la manipulation des dates.