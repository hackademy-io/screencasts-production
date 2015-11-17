Bienvenue dans cette vidéo consacrée aux fichiers temporaires et à la manipulation des répertoires.

Comme d'habitude, nous allons utiliser IRB pour faire nos démonstrations.

## Les fichiers temporaires ##

Dans bien des cas, vous serez amené à manipuler des fichiers temporaires pour stocker de l'information. C'est par exemple nécessaire lorsqu'on écrit une librairie qui gére les envois de fichier.

Quand on crée un fichier temporaire, on veut s'assurer que son nom est unique et qu'il sera bien effacé lorsqu'on aura fini de s'en servir. Biensûr il est possible de gérer ça soit même en écrivant le code nécessaire mais ça peut être fastidieux et sujet à erreur surtout si vous souhaitez avoir un code portable.

Heureusement, Ruby met à notre disposition la classe `Tempfile` dédiée à la gestion de cette opération courante :

```ruby
temp = Tempfile.new("foo")
temp.path
```

Un fichier avec un nom unique, commençant par "foo" a donc été créé dans le répertoire temporaire du système. Ce nom est garanti unique à travers les threads et le processus.

```ruby
temp.puts "On ajoute une ligne"
temp.close

temp.open
temp.gets
temp.close!
```

Si nous n'avions pas détruit le fichier, il l'aurait été automatiquement en fin de processus. Il est recommandé de le faire explicitement pour éviter que le fichier temporaire reste disponible sur le système de fichier jusqu'à ce qu'il soit collecté alors qu'il n'est plus utilisé par notre programme.

Si votre programme stocke des données sensibles qui ne doivent pas être accessibles aux autres processus, vous pouvez supprimer le fichier juste après sa création. Sur les systèmes POSIX, tant que le descripteur du fichier n'est pas clos, vous pouvez toujours vous en servir même s'il n'est plus visible sur le système de fichier :

```ruby
file = Tempfile.new("bar")
file.unlink
file.puts "Fichier toujours accessible"
file.close
```

## Manipuler les chemins ##

Un autre besoin récurrent est de manipuler les chemins de fichiers. On pourra vouloir connaître le répertoire correspondant :

```ruby
f = File.open("args.rb")
path = f.path

File.dirname(path)
```

Ou simplement le nom du fichier avec ou sans son extension :

```ruby
File.basename(path)
File.basename(path, ".rb")
```

On peut donc préciser l'extension à occulter, quand on ne la connaît pas à l'avance, on pourra utiliser l'étoile.

On va également pouvoir obtenir un chemin absolu depuis un chemin relatif :

```ruby
File.expand_path("~")
```

ou recomposer un chemin depuis ses différents composants en respectant le séparateur du système courant :

```ruby
File.join("usr", "local", "bin")
```

La classe `Pathname` a pour but de regrouper toutes ces fonctionnalités et permet également d'aller un peu plus loin :

```ruby
pn = Pathname.new(path)
pn.directory?
pn.file?
pn.split
pn.extname
pn.size
```

Cette classe offre beaucoup d'autres méthodes très utiles et je vous invite à lire sa documentation. Vous pourrez par exemple pour un répertoire connaître son parent et ses enfants.

## Manipuler les répertoires ##

Finalement, en plus d'analyser les chemins, on voudra pouvoir se déplacer dans les répertoires, en créer, en supprimer, etc.

Tout d'abord on pourra se renseigner sur le répertoire courant :

```ruby
Dir.pwd
```

puis se déplacer dans un autre :

```ruby
Dir.chdir("Desktop")
Dir.pwd
```

Cette méthode peut prendre un bloc bien pratique puisque le changement de répertoire ne sera effectif qu'à l'intérieur du bloc :

```ruby
Dir.chdir("..") do
  puts Dir.pwd
end
puts Dir.pwd
```

On pourra également lister l'ensemble des entrées d'un répertoire :

```ruby
Dir.chdir("..")
Dir.foreach(".") do |item|
  puts item
end
```

Dans certains cas, on préférera simplement récupérer cette liste sous forme d'un tableau :

```ruby
Dir.entries(".")
```

On va maintenant s'attacher à gérer les répertoires en Ruby en commençant par en créer un :

```ruby
Dir.mkdir("rep_1")
```

Plutôt simple mais comment créer une chaîne de répertoire ? Comme vous le savez sûrement, il est impossible de créer un répertoire si son parent n'existe pas. Il faudrait donc créer les répertoires de la chaîne un par un pour assurer un bon déroulé. C'est un peu fastidieux et Ruby met donc à notre disposition une méthode qui peut le faire pour nous :

```ruby
FileUtils.mkdir_p("rep_2/rep_3/foo/bar")
```

Parfait on peut maintenant passer au renommage d'un fichier et par extension d'un répertoire :

```ruby
FileUtils.mv("rep_1", "rep_10")
```

Pour finir, on voudrait pouvoir supprimer un répertoire. Avec la méthode de base on ne pourra supprimer qu'un seul répertoire à la fois et seulement s'il est vide. S'il n'est pas vide, une exception sera levée :

```ruby
Dir.delete("rep_10")
```

Bien souvent c'est un répertoire et l'ensemble de son contenu que vous voudrez supprimer récursivement. Ruby met à disposition une méthode nous évitant d'avoir à écrire un code fastidieux :

```ruby
FileUtils.rm_r("rep_2")
```

## Conclusion ##

Vous savez donc maintenant vous déplacer à travers le système de fichier, lister les entrées, en créer et en supprimer.

Vous avez pu voir en bonus comment mettre en place des fichiers temporaires de manière robuste ce qui vous permettra de stocker de l'information qui n'a pas vocation à être conservée et qui ne doit pas être accessible par un autre processus.

Le prochain épisode vous donnera les clés pour sérialiser et persister des objets Ruby dans des fichiers.
