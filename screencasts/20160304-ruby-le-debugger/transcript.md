# Ruby - Le débogueur #

Bienvenue dans cette vidéo consacrée au débogage en Ruby.

Quelque soit l'attention que vous portez à l'architecture et
l'écriture de votre code, vous finirez un jour par être confronté à un
bug. Parfois les bugs sont très simples à trouver et vous n'aurez
besoin d'aucun outil pour le repérer et le corriger. Le reste du
temps, il vous faudra comprendre ce qui se passe, analyser ce que vous
avez en entrée et pourquoi ce que vous avez en sortie n'est pas
conforme à ce qui est attendu.

Vous devrez alors suivre l'exécution du code, passer de méthodes en
méthodes pour analyser ce qu'il se passe. Beaucoup de développeurs se
cantonnent à l'utilisation de messages de débogage pour vérifier les
valeurs des éléments clés à différents endroits. Il ne sera donc pas
rare de voir un développeur mettre des `puts` dans son code ou de
façon un peu plus élégante en utilisant un logger avec quelque chose
comme `logger.debug`.

Quand on sait dans quelle méthode se trouve le problème et que cette
méthode ne fait pas des dizaines de lignes, ce qui ne devrait
d'ailleurs jamais être le cas, ces méthodes d'analyse peuvent
suffir. Pour les cas plus complexes, il existe un outil bien plus
adapté qu'on retrouve dans tous les langages, le debbuger.

En Ruby plusieurs outils sont disponibles pour faire du
debbugage. Bien évidemment, Ruby propose de base un outil qui permet
de poser un point d'arrêt dans le code et de lancer la console
interactive pour analyser l'état courant puis continuer à avancer dans
le code. Bien que tout à fait honorable, il existe des alternatives à
cet outil qui permettent d'accéder à plus de flexibilité.

Aujourd'hui on a principalement `pry` et `byebug`. Nous allons
utiliser ce dernier dans cette vidéo mais gardez à l'esprit que
quelque soit l'outil utilisé, ils partagent tous les mêmes
fonctionnalités de base.

## Installation de byebug ##

`byebug` n'est pas livré de base avec Ruby, il faut donc
l'installer. On va utiliser la commande `gem` :

```shell
$ gem install byebug
```

## Placer un point d'arrêt ##

Pour l'utiliser, il nous suffit maintenant de charger `byebug` dans
notre code et d'appeler la méthode `byebug` à l'endroit où l'on
souhaite que l'exécution s'arrête.

Voici un exemple de script que j'ai préparé pour démontrer
l'utilisation :

```ruby
require 'byebug'

class Computer
  def initialize(a, b)
    @a = a
    @b = b
  end

  def sum_and_double
    sum = sum(@a, @b)
    double(sum)
  end

  private

  def sum(a, b)
    a + b
  end

  def double(a)
    a * a
  end
end

computer = Computer.new(2, 3)
res = computer.sum_and_double

puts res
```

On a écrit une classe qui prend deux paramètres. Son but est de
faire la somme des deux paramètres puis de doubler ce résultat et le
retourner.

Évidemment l'exemple est extrêmement simple, difficile de faire une
erreur, on peut même se demander pourquoi faire une classe. C'est
uniquement pour vous montrer l'utilisation du debugger dans un
contexte très simple à comprendre.

Comme vous pouvez le voir, j'ai le constructeur qui stocke nos valeurs
initiales. J'ai ensuite une méthode principale qui permet de faire le
traitement attendu.

Cette méthode principale délégue les deux parties du traitement
(l'addition et la multiplication) à des méthodes privées. Avec cette
structuration découpée, on se retrouve avec une architecture assez
proche d'un cas réel.

Comme vous l'aurez remarqué, ce code comporte un bug grossier. La
multiplication ne double pas la valeur mais retourne son carré. Faites
comme si vous ne l'aviez pas vu et que ce bug est très difficile à
détecter.

Si on lance notre programme, on a bien un résultat erroné :

```shell
$ ruby buggy.rb
```

Ajoutons donc un point d'arrêt pour suivre le déroulé et comprendre ce
qu'il se passe.

Et relançons notre script.

## Naviguer dans les sources ##

On se retrouve dans une console interactive qui nous présente
l'instruction sur laquelle on s'est arrêté. Juste après notre
instruction `byebug`, donc juste avant la première instruction de la
méthode `sum_and_double`.

Comme c'est notre première session `byebug`, on peut commencer par
afficher la liste des commandes avec la commande `help` puis l'aide
d'une commande donnée, ici la commande next.

Une commande intéressante est la commande `list` qui comme son aide
l'indique (taper help list) permet de lister les lignes de code autour
d'une ligne donnée. Par défaut la ligne courante. Essayons:

```ruby
list 3-5
```

On a donc les lignes 3 à 5 de notre fichier courant, on peut également
afficher le contexte autour de la ligne en cours d'exécution :

```ruby
list=
```

On peut évidemment lister les lignes qui précédent :

```ruby
list-
```

## Analyser l'état courant ##

Passons maintenant à l'analyse des variables de notre script. On peut
simplement appeler une variable par son nom, si elle existe dans le
contexte, son contenu sera affiché :

```ruby
@a
```

mais on peut aussi afficher toutes les variables d'un type donné pour
le contexte courant:

```ruby
var
var instance
```

Nos variables d'instance sont donc bien conformes à ce qu'on
attendait. On va donc demander l'exécution de l'instruction suivante
et voir où ça nous mène. Les debuggers nous offrent deux possibilités
pour avancer dans le code, on peut soit exécuter l'instruction et
s'arrêter à la suivante ou alors exécuter en entrant dedans pour
exécuter son code ligne par ligne. C'est ce que nous allons faire ici :

```ruby
step
```

On se retrouve donc dans la définition de la méthode `sum`. C'est
l'occasion de découvrir une autre fonctionnalité intéressante qui
permet de savoir comment on est arrivé là où on se trouve :

```ruby
backtrace
```

On sait donc qu'on se trouve dans la méthode `Computer.sum` qui a été
appelée par `Computer.sum_and_double` elle-même appelée par le
programme principal. C'est particulièrement pratique dans de grosses
applications où les points d'entrée sont nombreux comme une
application Rails par exemple.

On pourrait se déplacer dans l'un des appels parents et obtenir le
contexte de cet appel parent :

```ruby
frame 1
```

On peut donc voir l'état des variables et autres éléments comme si
nous venions juste de passer dans le parent. C'est l'une des grandes
force des debuggers. Vous avez une machine à voyager dans le temps qui
vous permet d'analyser le comportement qu'a eu votre programme tout au
long de son exécution.

Continuons notre inspection à la recherche de notre bug:

```ruby
next
```

On est sortie de notre méthode `sum`, on peut vérifier le contenu de
notre variable avant de continuer :

```ruby
sum
```

Notre variable contient la valeur attendue, notre bug est donc plus
loin, continuons :

```ruby
next
res
```

La valeur obtenue en sortie de la méthode `double` est erronée, on
peut donc supposer que l'erreur se trouve dans cette méthode. En y
regardant, on comprendra que la multiplication devrait en fait être
une addition.

Voici à quoi peut ressembler une chasse au bug avec un debugger. Son
utilisation prend tout son sens avec des programmes plus complexes.

## Encore plus ##

`byebug` a encore plus à offrir, je vous invite à décortiquer son
aide, vous pouvez par exemple :

- ajouter des points d'arrêt à la volée
- lister l'ensemble des points d'arrêt
- lister les threads et passer de l'un à l'autre
- attraper les exceptions
- lancer l'édition d'un fichier à un endroit précis
- relancer le programme
- tracer des variables globales
- sauver une session de débogage et la restaurer plus tard
- créer des points d'arrêt conditionnels
- etc

## Conclusion ##

Le debugger, quelque soit le langage utilisé, est l'arme par
excellence pour résoudre des cas complexes. Par expérience je sais
que cet outil est trop sous-estimé, particulièrement par les
développeurs qui n'ont jamais utilisé des langages compilés ou qui
n'ont jamais dû gérer eux-mêmes l'utilisation de la mémoire dans leurs
programmes.

Le prochaine fois que vous rencontrez un bug, plutôt que de mettre des
`puts` un peu partout, essayer de placer un ou plusieurs points
d'arrêts aux endroits stratégiques et lancer votre debugger. Même si
ce n'est pas naturel au début, vous deviendrez vite accro à cet outil
indispensable.
