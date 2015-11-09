Bienvenue dans cette vidéo consacrée à la manipulation des attributs avancés des fichiers. Les usages que nous verrons ici sont particulièrement destinés à des scripts s'exécutant sur des systèmes de type Unix.

## Bloquer les fichiers ##

Dans vos scripts système il sera parfois nécessaire de bloquer l'accès à un fichier pour éviter qu'un autre processus tente par exemple de le modifier pendant que vous vous en servez.

Plusieurs modes de blocage sont disponibles, ils correspondent à ce qui est mis à disposition par la commande Unix `flock`.

On peut donc bloquer le fichier en mode partagé (`LOCK_SH`) pour lequel plusieurs processus pourront accéder au fichier en parallèle. Aussi longtemps qu'il existera des processus accédant au fichier dans ce mode, il sera impossible d'obtenir un blocage exclusif (`LOCK_EX`).

Le blocage exclusif va lui permettre d'obtenir un accès unique au ficher, souvent pour y écrire. Si d'autres processus veulent accéder au fichier en mode partagé, ils devront attendre que le blocage exclusif soit levé.

On peut en plus ajouter le drapeau `LOCK_NB` aux deux premiers modes. Dans ce cas si un processus tente d'accéder au fichier, une exception sera levé, ça sera impossible. Il n'y aura pas de système de mise en attente de la levée du blocage.

Finalement lorsqu'un processus a fini d'utiliser un fichier, il est de son devoir de lever le blocage grâce au drapeau `LOCK_UN`.

En Ruby, on utilisera ces concepts de la manière suivante :

```ruby
file = File.new("foo", "w")

file.flock(File::LOCK_EX)
file.flock(File::LOCK_UN)

file.flock(File::LOCK_SH)
file.flock(File::LOCK_UN)

file.close
```

Pour faire une analogie, vous pouvez imaginer un prof devant son tableau. Le tableau correspond à notre fichier.

Pendant que le prof écrit au tableau, il y pose un blocage exclusif. Pendant ce temps, personne ne peut le lire. Aucun autre blocage partagé ou exclusif ne peut être obtenu.

Lorsqu'il a fini, le prof s'écarte du tableau et lève le blocage exclusif. Les étudiants peuvent maintenant lire le tableau, c'est à dire accéder au fichier, en y posant un blocage partagé. On peut poser plusieurs blocages partagés en parallèle.

Pendant que des élèves lisent le tableau, il est impossible pour le professeur de le modifier en y posant un blocage exclusif.

## Appartenance et permissions ##

Il sera également courant de vouloir manipuler l'appartenance des fichiers et les permissions associées.

On pourra tout d'abord vouloir vérifier qui est le propriétaire ou le groupe d'un fichier :

```ruby
s = File.stat("foo")
s.uid
s.gid
```

C'est en fait ici l'identifiant de l'utilisateur et du groupe qu'on obtient. Pour obtenir le nom correspondant il faut passer par le module `Etc` :

```ruby
Etc.getpwuid(s.uid).name
Etc.getgrgid(s.gid).name
```

On va pouvoir, de la même façon, récupérer les permissions associées au fichier :

```ruby
s.mode
```

Par défaut, les permissions sont affichées en mode octal, on peut obtenir un affichage plus classique à l'aide de `sprintf` :

```ruby
sprintf("%o", s.mode)
```

Bien que très standard, cet affichage n'est pas le plus pratique à exploiter, on a donc un ensemble de méthodes qui nous permettent d'obtenir les information plus clairement :

```ruby
s.readable?
s.writable?
s.executable?
```

Bien évidemment il existe aussi des commandes pour modifier les permissions, le propriétaire et le groupe. Vous serez toutefois limité par les permissions de l'utilisateur courant :

```ruby
file = File.new("foo")
file.chmod(0444)
file.chown(502, 20)
```

## Gestion des informations d'horodatage ##

Lorsque vous utilisez un fichier des horodatages sont mis-à-jour. Depuis Ruby vous pouvez récupérer trois données, la date de dernier accès qu'on appelle "access time", la date de dernière modification appelée "modify time" et finalement la date de la dernière modification, changement de propriétaire ou de permissions inclus, c'est ce qu'on appelle le "change time".

Ces informations peuvent être obtenues directement depuis la classe "File", depuis une instance de cette même classe via des méthodes dédiées, ou encore à travers les informations de la méthode `stat` :

```ruby
File.mtime("foo")

file.mtime
file.atime
file.ctime

s = file.stat
s.atime
```

En plus de la consultation, il est possible de définir les heures de modification et changement en passant par la méthode `utime` :

```ruby
today = Time.now
yesterday = today - 86400
File.utime(today, yesterday, "foo")
```

## Existence et taille des fichiers ##

Une autre tâche fréquente en administration système que vous voudrez pouvoir automatiser au travers de vos script Ruby est la vérification de l'existence de fichiers et de leur taille.

Vérifions donc l'existence de quelques fichiers :

```ruby
File.exist?("foo")
File.exist?("bar")
```

Bien que notre fichier existe, il est peut-être vide et nous sera donc tout aussi inutile. Ruby met à notre disposition une méthode qui permet de vérifier si le fichier existe **et** s'il n'est pas vide :

```ruby
File.size?("foo")
File.size?("args.rb")
```

Si le fichier existe et qu'il n'est pas vide, sa taille nous est retournée.

Dans la même veine, la méthode `zero?` nous permettra de savoir si le fichier existe et qu'il est vide :

```ruby
File.zero?("foo")
File.zero?("args.rb")
File.zero?("bar")
```

Il est à noter que l'objet `stat` disponible sur l'instance d'un fichier dispose lui aussi des méthodes `size?` et `zero?`.

Il existe bien évidemment la méthode plus directe `size` qui se contentera de donner la taille du fichier. Si le fichier passé en argument n'existe pas, une exception sera levée :

```ruby
file.size
File.size("foo")
File.size("bar")
```
## Caractéristiques spéciales des fichiers ##

Finalement vous voudrez peut-être pouvoir consulter les caractéristiques spéciales des fichiers.

Vous pourrez par exemple vouloir savoir si un fichier est un terminal :

```ruby
$stdin.tty?
file.tty?
```

Comme tout est fichier sous Unix, il est intéressant de connaître son type :

```ruby
File.file?("foo")
File.directory?("/tmp")
File.pipe?("foo")
File.socket?("foo")
```

Plutôt que de tirer à l'aveuglette quand vous ne connaissez pas le type probable du fichier, vous pouvez passer par la méthode `ftype` :

```ruby
File.ftype("/dev/disk0s1")
```

## Conclusion ##

Ces quelques pointeurs vous permettront sans aucun doute de vous lancer dans l'écriture de scripts d'administration et de gestion du système de fichier.

Pour compléter vos compétences, nous verrons dans le prochain épisode comment manipuler les fichiers temporaires ainsi que les chemins et répertoires.
