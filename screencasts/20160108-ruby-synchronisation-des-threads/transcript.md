Bienvenue dans cette vidéo faisant suite à la vidéo d'introduction aux threads.

Nous verrons cette fois ci comment synchroniser la manipulation des données entre les différents threads. En effet, si aucune synchronisation n'est mise en place il se pourrait que les différents threads se marchent sur les pieds en modifiant une même variable. Les modifications de l'un serait donc écrasées et perdues par l'autre.

C'est ce qu'on appelle avoir un code "thread-safe" qui assure qu'un code qui va être manipuler par plusieurs threads en même temps se comportera comme attendu.

## Démonstration par l'exemple ##

Voyons un exemple que j'ai déjà écrit pour gagner du temps :

```ruby
x = 0

10.times.map do |i|
  Thread.new do
    puts "avant ajout (#{i}): #{x}"
    x += 1
    puts "après ajout (#{i}): #{x}"
    puts
  end
end.each(&:join)

puts "valeur finale : #{x}"
```

Comme vous le voyez, quand chaque thread démarre, il récupère la valeur courante de `x` pour l'afficher. Ensuite il tente d'ajouter 1 à cette valeur mais le résultat obtenu est variable du fait du traitement en parallèle de cette même variable par plusieurs threads concurrents.

Sans synchronisation, il devient impossible de prédire l'état de la variable `x` et par extension, le comportement de notre méthode. Le résultat retourné sera parfois correct et parfois erroné…

Il faut donc porter une attention particulière aux variables ayant une portée plus large que le thread dans lequel elles sont utilisées.

## Atomicité ##

Pour obtenir un code thread-safe, il va falloir travailler de manière atomique. Si nos opérations de modifications des valeurs sont faîtes de telle façon que les autres threads ne peuvent ni les lire, ni les écrire pendant qu'on travaille dessus, alors notre code sera thread-safe.

Pour gérer un ensemble d'opération de façon atomique, il nous faut utiliser les `Mutex` dont le rôle est de garantir que les opérations sont traitées d'une traite, comme un ensemble indivisible.

## Notre code thread-safe ##

Modifions donc notre code pour le rendre thread-safe. Pour cela il suffit d'encapsuler l'ensemble du code à jouer de manière atomique dans un bloc dédié.

Voyons le code :

```ruby
x, mutex = 0, Mutex.new

10.times.map do |i|
  Thread.new do
    mutex.synchronize do
      puts "avant ajout (#{i}): #{x}"
      x += 1
      puts "après ajout (#{i}): #{x}"
      puts
    end
  end
end.each(&:join)

puts "valeur finale : #{x}"
```

Ce simple ajout nous suffit à éviter bien des problèmes et à assurer que notre bloc d'instruction est joué en une seule fois sans être interrompu par un autre thread.

## De l'utilisation d'un code thread-safe ##

Il ne suffit pas d'utiliser des librairies thread-safe pour que le code qui les utilise le soit aussi. En fait, vous pouvez tout à fait écrire un code non thread-safe lorsque vous utiliser une librairie ou une classe qui l'est.

Prenons par exemple la classe suivante :

```ruby
class Counter
  attr_reader :count

  def initialize
    @count = 0
    @mutex = Mutex.new

    puts 'Counter created'
  end

  def increment!
    @mutex.synchronize { @count += 1 }
  end
end
```

Cette classe est thread-safe puisqu'elle utilise un `Mutex` pour incrémenter atomiquement la valeur.

Créons maintenant une application qui l'utilise :

```ruby
class Application
  def increment!
    counter.increment!
  end

  def counter
    @counter ||= Counter.new
  end

  def count
    counter.count
  end
end

app = Application.new

10.times.map do |i|
  Thread.new { app.increment! }
end.each(&:join)

puts app.count
```

Si on lance plusieurs fois cette application, on notera que parfois son résultat est erroné. Elle devrait toujours renvoyer 10.

Cette application n'est pas thread-safe pour une seule raison, elle initialise l'instance de `counter` grâce à l'opérateur `||=`. Cet opérateur n'est pas atomique. Il va d'abord lire la valeur puis la modifier après coup si nécessaire. Cette valeur a donc pu changer entre temps.

Dans les cas où notre application se comporte anormalement, c'est parce que plusieurs threads ont vu le contenu de la variable `counter` égale à `nil`. Ils ont donc voulu l'initialiser.

En réalité l'un des threads s'occupait déjà de l'initialisation, l'autre thread a ré-initialiser cette variable et écrasé l'existante.

On a donc créé une application qui n'est pas thread-safe sur la base d'une classe qui l'est. Il faut donc être vigilent.

La meilleure façon d'écrire notre application aurait été la suivante :

```ruby
class Application
  attr_reader :counter

  def initialize
    @counter = Counter.new
  end

  def increment!
    counter.increment!
  end

  def count
    counter.count
  end
end
```

L'idée est donc d'éviter que notre instance de compteur puisse être modifiée. Le plus simple est de l'initialiser au démarrage de l'application puis d'utiliser cet instance partout ailleurs.

Ça règle notre souci et ça semble plus performant puisqu'on s'évite un test d'existence inutile à chaque appel à la méthode `counter`.

Quelque soit le contexte dans lequel vous utilisez l'idiome `||=`, essayez d'abord de de voir s'il est possible d'initialiser la variable en amont. Vous y gagnerez un comportement plus sain.

## Pour aller plus loin ##

D'autres classes livrées avec Ruby permettent de gérer facilement des cas typiques d'utilisation des threads avec notamment les classes `Queue` et `SizedQueue` qui vous permettent de gérer des files de threads avec communication synchronisée. Les threads qui utiliseront la même file d'attente n'auront pas à se soucier des problèmes de synchronisation des données.

Il peut également être intéressant de jeter un œil à la classe `ConditionVariable` qui permet d'interrompre l'exécution d'un thread pour qu'il attende la disponibilité d'une autre ressource avant de continuer son traitement.

## Conclusion ##

Nous avons donc vu grâce à ces deux épisodes les principales fonctionnalités mises à disposition par les threads, leurs utilité ainsi que les pièges à éviter.

Les threads sont un sujet difficile à appréhender au début mais qui peut vous ouvrir de nombreuses portent vers l'optimisation de portions de code ayant pour résultat des améliorations notables des performances de votre application.
