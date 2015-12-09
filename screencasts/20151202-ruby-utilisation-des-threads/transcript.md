Bienvenue dans cette vidéo consacrée à la manipulation des threads en Ruby.

## Introduction aux threads ##

Les threads aussi appelés «processus légers» sont un moyen très pratique d'exécuter du code en parallèle sans avoir à lancer un nouveau processus qui serait plus coûteux.

Il faut savoir que les threads en Ruby ne sont pas des threads système mais des threads utilisateur qui fonctionnent indépendamment du système hôte. C'est bien sûr moins performant mais aussi plus portable.

Les threads vous seront particulièrement utiles lorsque vous avez des morceaux de code qui peuvent fonctionner de manière indépendantes ou pour gérer une partie du code qui passe la plupart de son temps à attendre des événements.

Si votre logique métier fonctionne de manière sérialisée alors les threads ne vous aideront pas. Ils ne seront également pas très pratiques si vous devez synchroniser l'accès à de nombreuses données globales.

Sachez qu'un code multi-threadé sera toujours plus sujets aux bugs qu'une version sans threads et qu'il compliquera le débogage.

Il faut donc savoir analyser le besoin, le contexte et le gain potentiel avant de choisir de multi-threader un programme.

## Création et manipulation de threads ##

Les bases de l'utilisation des threads consiste à en créer, y faire transiter de l'information puis les stopper. On pourra évidemment obtenir une liste des threads, leur état actuel, etc.

### Créer un thread ###

Pour créer un thread, il suffit d'utiliser la classe dédiée :

```ruby
thread = Thread.new do
  # something
end
```
On obtient donc en retour une instance de la classe `Thread` qui peut être manipulée depuis le thread principal.

On pourra passer des arguments à un thread lors de sa création :

```ruby
Thread.new("foo", "bar") do |a, b|
  puts a
end
```

Il faut savoir qu'un thread a accès au contexte courant, il peut donc modifier le contenu des variables qui lui sont accessibles au moment de la création. C'est un vrai piège auquel il faut faire attention :

```ruby
a = "foo"
b = "bar"

Thread.new(a) do |a|
 a = "not changed"
 b = "changed"
end

a
b
```

La variable locale `a` qui est passée au thread sous le nom de `a` n'est impactée que localement, par contre la variable `b` qui n'a pas été passée localement est accessible depuis le contexte global. En la modifiant, on modifie sa valeur au niveau global.

### Accéder aux variable locales des threads ###

Il est donc clair qu'il est dangereux d'utiliser des variables du contexte extérieur depuis un thread. On voudra pourtant parfois pouvoir passer des données au contexte global depuis notre thread. Heureusement des mécanismes sont mis à notre disposition pour pouvoir faire ça proprement :

```ruby
thread = Thread.new do
  t = Thread.current
  t[:foo] = "Here is foo"
  t[:bar] = 42

  baz = "Not available outside"
end

thread[:foo]
thread[:bar]
thread.key?(:foo)
thread.key?(:baz)
```

On peut donc depuis notre thread, communiquer de l'information à l'extérieur sans polluer le contexte global. C'est beaucoup plus propre ! Ne passez __jamais__ par les variables du contexte global pour communiquer de l'information ou vous vous exposerez à de gros soucis.

### Connaître et changer le statut d'un thread ###

La classe `Thread` met à notre disposition des méthodes qui nous permettent d'interroger et de modifier le statut d'un thread donné.

On peut récupérer la liste des threads vivants grâce à la méthode de classe `list` ou encore obtenir une référence vers le thread principal via la méthode de classe `main`. La méthode de classe `current` nous retournera une référence vers le thread en cours d'exécution comme on a pu le voir avant :

```ruby
Thread.current == Thread.main

Thread.new do
  puts Thread.list.size
  puts Thread.current == Thread.main
end

Thread.list.include?(Thread.main)
```

D'autres méthodes vont nous permettent de modifier ou de connaître le statut d'un thread :

```ruby
t1 = Thread.new { loop {} }

t1.status
t1.kill
t1.alive?
t1.stop?
```

On voit que si le thread est en cours d'exécution son statut sera `run`, s'il est en attente à cause d'un `sleep` ou de l'attente d'un retour d'une entrée / sortie alors il sera en statut `sleep`. S'il a fini son travail avec succès le statut sera `false` et `nil` si une exception a été levée.

On est donc en mesure de savoir où en est le déroulement de nos différents thread et donc, par extension, de notre programme principal.

Pour les cas plus complexe, il sera possible de forcer un thread à passer la main à un moment précis de son exécution avec la méthode `pass`, de lui demander d'arrêter son exécution grâce à la méthode `stop` puis de la reprendre plus tard en utilisant la méthode `run` ou encore `wakeup` qui réveillera le thread sans forcer son exécution immédiate.

Pour autant, il ne faudra pas se servir de ces mécanismes pour tenter de faire de la synchronisation. D'autres techniques sont mises à notre disposition spécialement pour ça.

### Attendre la fin d'exécution d'un thread ###

Dans bien des cas, vous aurez besoin de faire en sorte que votre programme attende que vos threads aient fini leur travail pour rendre la main. Vous pourriez mettre en place cette vérification dans votre thread principal grâce aux méthodes vues précédemment mais ça deviendrait vite fastidieux.

Fort heureusement, une méthode prête à l'emploi nous est fournie, elle s'appelle `join`. Si cette méthode est appelée sur un thread, le programme principal ne rendra pas la main tant que le thread en question n'aura pas fini son exécution.

Il est donc assez commun, avant la fin de son programme principal de mettre en place un idiome qui permet de s'assurer que tous les threads de l'application ont fini leur travail :

```ruby
Thread.list.each { |t| t.join if t != Thread.main }
```

On a donc listé tous les threads disponibles dans l'application et pour chacun d'entre eux, on a appelé `join` qui garantit que le programme ne peut pas rendre la main avant la fin de leur exécution.

On a simplement ajouté un test qui n'appelle pas `join` sur le thread principal qui serait alors incapable de se terminer.

## Conclusion ##

Nous avons pu voir dans cet épisode que Ruby met à notre disposition une base solide d'outils qui nous permettent de mettre en place de la concurrence et donc de gagner du temps précieux de traitement lorsqu'une autre partie du programme est en attente d'éléments pour continuer.

Dans l'épisode suivant, nous verrons comment synchroniser les threads entre eux pour assurer la cohérence des données.
