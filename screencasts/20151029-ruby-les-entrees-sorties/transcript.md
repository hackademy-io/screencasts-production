Bienvenue dans cette vidéo consacrée à la découverte des entrées / sorties en Ruby. Les entrées / sorties sont souvent appelées I/O de l'anglais Input / Output.

La gestion des entrées / sorties est une des bases de la programmation. Même si vous n'en avez pas conscience parce que vous utilisez un framework, vous les utilisez sans cesse. Les usages sont d'une variété quasi infinie.

Aujourd'hui, nous nous pencherons uniquement sur les fichiers classiques, stockés sur un support. Ça nous permettra de creuser le sujet dans les vidéos suivantes.

## Théorie ##

En Ruby, toute la gestion des entrées / sorties repose sur la classe `IO`. C'est la classe qui définie les comportements communs à toutes les entrées / sorties.

De cette classe découle la classe `File` qui encapsule tous les détails de la gestion de fichiers tels que les permissions, les dates de création, etc.

C'est sur ces fondements que sont réalisées d'autres classes et librairies qui vont permettre de persister des éléments dans des fichiers ou dans des bases de données.

## Ouvrir / fermer des fichiers ##

Commençons donc à travailler avec les fichiers qui sont le moyen le plus simple et le plus commun pour stocker de l'information persistante.

Les opérations les plus communes sont l'ouverture et la fermeture des fichiers. Entre deux on lira ou écrira des informations.

Pour ouvrir un fichier on utilisera la méthode `File#new` qui prend en premier paramètre le chemin vers le fichier à ouvrir et en deuxième paramètre optionnel le mode d'ouverture.

Le mode d'ouverture sert à indiquer si on ouvre le fichier en lecture, en écriture, en lecture et écriture, etc.

On peut donc ouvrir un fichier en écriture :

```ruby
file1 = File.new("one", "w")
```

ou en lecture:

```ruby
file2 = File.new("one")
```

Quand vous ouvrez des fichiers, il est de bon ton de les fermer une fois que vous avez fini de les utiliser. Si vous ouvrez de nombreux fichiers et que vous les laissez tous ouverts, le système finira par se plaindre.

D'ailleurs si vous ne fermez pas un fichier dans lequel vous avez écrit, il est fort probable que vous perdiez une partie des données.

Fermons donc nos deux fichiers précédemment ouverts :

```ruby
file1.close
file2.close
```

Pour ouvrir des fichiers, vous pouvez également utiliser la méthode `File#open` qui est plus ou moins un synonyme de `File#new` à ceci près que vous pouvez lui passer un bloc et le fichier sera automatiquement fermer à la fin de ce bloc :

```ruby
File.open("test.txt", "w") do |file|
  file.puts "Line 1"
  file.puts "Line 2"
  file.puts "Line 3"
end
```

C'est sans aucun doute la façon la plus élégante de procéder. Nous avons donc ouvert en écriture le fichier "test.txt", qui a été créé s'il n'existait pas.

Nous avons ensuite appelé la méthode `puts`. Nous l'avons déjà largement utilisé jusqu'ici pour afficher des valeurs à l'écran. Par défaut `puts` s'applique sur la sortie standard, ce qui dans la plupart des cas est la console dans laquelle le script est exécuté.

Ici c'est différent, nous l'appelons explicitement sur la variable locale `file` qui représente le fichier que nous avons ouvert ce qui a pour effet d'écrire les chaînes dans ce fichier.

## Mettre à jour un fichier ##

Si vous veniez à ouvrir à nouveau le même fichier, toujours avec le mode "w", vous écraseriez le contenu existant.

Pour mettre à jour un fichier existant, il faut utiliser le mode adéquat. Pour pouvoir lire et écrire dans un fichier, il suffit d'ajouter "+" derrière le mode utilisé. Il reste maintenant à choisir le mode en fonction de ce que vous souhaitez faire.

Pour mettre à jour un fichier, en partant du début, on utilisera le mode "r+" :

```ruby
f1 = File.new("one", "r+")
```

Pour écraser le contenu du fichier existant ou en créer un nouveau, on utilisera "w+" :

```ruby
f2 = File.new("one", "w+")
```

Finalement pour compléter le fichier, en partant donc de la fin de ce dernier, on utilisera le mode "a+" :

```ruby
f3 = File.new("one", "a+")
```

Notez que les "+" ne sont pas nécessaire à la mise à jour, ils ne sont là que pour indiquer qu'on souhaite pouvoir lire **et** écrire. On pourrait très bien se cantonner à un simple "a" pour faire de la mise à jour de fichier.

## Accès aléatoires ##

Naturellement quand vous lirez un fichier, la lecture se fera de manière séquentielle. Ce sera donc caractère par caractère ou ligne par ligne.

```ruby
File.open("test.txt", "r") do |file|
  puts file.getc
  puts file.gets
end
```

Pour vous déplacer à un endroit précis, il faudra utiliser la méthode `IO#seek` qui attend qu'on lui passe un entier représentant le nombre de bytes dont on veut avancer dans le fichier :

```ruby
File.open("test.txt", "r") do |file|
  file.seek 7
  puts file.gets
end
```

On a donc avancé de 7 bytes pour passer la première ligne qui contient la chaîne "Line 1" constituée de 6 caractères plus un retour à la ligne ce qui nous permet d'arriver directement à la deuxième ligne.

Par défaut la méthode `IO#seek` commence toujours en début de fichier, on peut aussi lui demander de commencer à la position actuelle en lui passant un deuxième paramètre :

```ruby
File.open("test.txt", "r") do |file|
  file.seek 7
  puts file.gets

  file.seek 0
  puts file.gets

  file.seek 7
  puts file.gets

  file.seek 0, IO::SEEK_CUR
  puts file.gets
end
```

On peut également commencer depuis la fin de fichier grâce à la constante `IO::SEEK_END`.

### Entrée / sortie par défaut ###

Comme on l'a expliqué un peu plus tôt, par défaut, les méthodes `Kernel.puts` et `Kernel.gets` si elles sont appelées sans receveur vont tenter d'écrire sur la sortie standard et de lire depuis l'entrée standard.

Ce phénomène s'explique par le fait que l'interpréteur lorsqu'il est lancé met à disposition trois constantes `STDIN`, `STDOUT` et `STDERR`. Ces constantes sont automatiquement affectées à trois variables globales qui sont `$stdin`, `$stdout` et `$stderr`.

Quand vous appelez `puts`, vous appelez en fait implicitement `$stdout.puts`. De la même manière en faisant `gets`, vous faites en réalité un `$stdin.gets`.

En ré-assignant ces variables globales, vous pouvez modifier le comportement par défaut de `puts`, `gets` et autres méthodes similaires ce qui peut se révéler très pratique.

Créons un script dans notre éditeur :

```ruby
file = File.new("io.txt", "w")
puts "Hello"

$stdout = file
puts "Bye"

$stdout = STDOUT
puts "Done"
```

Nous pouvons maintenant l'exécuter en console : `ruby io.rb`

On voit que sur la sortie standard apparaissent les chaînes "Hello" et "Done". Si on consulte le contenu du fichier "io.txt", on voit qu'il contient la ligne "Bye" : `cat io.txt`

### Gestion des arguments ###

Une autre constante très utile lorsqu'on écrit des scripts est `ARGF`. Elle contient le contenu des fichiers qui ont été passés au script lors de son lancement.

On pourrait par exemple écrire un script qui affiche le contenu de ces fichiers :

```ruby
puts ARGF.read
```

Puis le lancer : `ruby cat.rb test.txt io.txt`

Plutôt simple n'est-ce pas ?

Une autre constante spéciale existe et permet de lister les arguments passés au script :

```ruby
ARGV.each do |arg|
  puts arg
end
```

On le lance : `ruby args.rb foo bar baz`

C'est un élément indispensable pour quiconque souhaite écrire des scripts.

### Lire l'entrée standard ###

Une autre tâche dont vous aurez souvent besoin si vous écrivez des scripts sera de pouvoir lire des entrées utilisateur. Pour ce faire, il nous suffira d'écouter ce qu'il se passe sur `$stdin` :

```ruby
puts "Il y a de l'écho ici !"

while line = $stdin.gets
  puts "echo: " + line.chomp
end
```

On le lance : `ruby echo.rb`

On a donc créé une boucle infinie qui attend une entrée utilisateur puis la répète.

### Conclusion ###

Vous connaissez donc maintenant les bases de la manipulation des entrées / sorties. Ces quelques bases vous permettent d'aller déjà assez loin dans l'interaction entre votre script et le système ou l'utilisateur.

Dans les prochaines vidéos nous approfondirons ces concepts pour apprendre à manipuler les attributs des fichiers, travailler avec les fichiers temporaires, les répertoires ainsi que la persistance d'objets.

