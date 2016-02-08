Bienvenue dans cette vidéo consacrée à la programmation système via des script Ruby.

Dans le monde Unix, il n'est pas rare d'exécuter des tâches depuis le terminal, que ce soit pour lancer un ensemble de commandes ou encore faire de l'administration système. Quand ces tâches deviennent répétitives, on a tendance à les encapsuler dans un script pour les automatiser.

La plupart du temps, ces script seront des scripts shell écrit en Bash par exemple. Pourtant, quand on fait du Ruby, il peut très vite devenir intéressant de l'utiliser pour avoir accès à tout notre arsenal habituel.

## Lancer des programmes externes ##

Le besoin le plus courant pour l'utilisation d'un shell script est de vouloir faire le pont entre deux programmes existants.

Il y a plusieurs façons de lancer une commande externe en Ruby.

### Équivalent de la librairie standard C ###

On peut tout d'abord utiliser la commande `system` qui va lancer un sous-shell et exécuter la commande :

```ruby
system("whoami")
```

La sortie de cette commande sera affichée sur la sortie standard. N'importe quelle commande, même évoluée, que vous pourriez entrer directement dans le shell peut être utilisée directement avec la méthode `system`.

On pourrait également utiliser la méthode `exec` mais elle a pour effet de remplacer le processus courant par celui nouvellement créé. Notre programme perdrait donc la main :

```ruby
exec("whoami")
```

### Récupération de la sortie ###

Ces deux méthodes sont très pratiques pour une utilisation simple mais il sera fréquent de vouloir récupérer la sortie de la commande pour la stocker dans une variable qu'on va manipuler ensuite. Ruby nous propose l'opérateur backtick pour ça :

```ruby
name = `whoami`
now = `date`
```

Il existe une autre notation pour faire la même chose qui évite d'avoir à se soucier des caractère spéciaux par exemple :

```ruby
%x(uptime)
%x(ls -l).split("\n").size
```

## Manipuler les processus ##

Maintenant qu'on sait lancer des commandes externes et récupérer leur sortie penchons nous sur la manipulons des processus.

### Créer des sous-processus ###

Depuis un programme Ruby, il est possible de lancer un autre processus dans lequel nous exécuterons du code de manière indépendante du processus principal.

C'est possible grâce à la méthode `fork` directement calquée sur la fonction Unix du même nom :

```ruby
fork do
 puts "Je suis un enfant"
end

Process.pid
```

On a donc bien deux processus différents confirmés par les PID différents.

On peut demander à notre programme principal d'attendre qu'un enfant ait fini son travail avant de reprendre la main grâce à la méthode `wait`, on peut même attendre la fin d'un processus donné grâce à la méthode `waitpid` :

```ruby
pid = fork { sleep 10; exit 1 }
Process.waitpid pid
```

Au sein d'un processus, il est possible de connaître le pid du processus parent :

```ruby
parent_pid = Process.pid

fork { p Process.ppid == parent_pid }
```

### Tuer des processus ###

Maintenant que nous savons comment créer de nouveaux processus, il pourrait être intéressant de voir comment tuer des existants.

Comme pour le reste, la méthode proposée par Ruby est très similaire à la fonction unix `kill`. Cette méthode est `Process.kill` et prend deux paramètres. En premier, le signal à envoyer, le second étant le PID du processus à tuer.

On peut donc simplement faire un programme qui tue d'autres programmes sur le système en fonction de leur état, de leur consommation de ressource ou sur n'importe quelle autre base mais on peut aussi mettre en place des systèmes interne de dialogue entre processus dans notre code Ruby :

```ruby
pid = fork do
   Signal.trap("SIGTERM") { puts "Parent asked me to quit!"; exit }
   loop { } # Do something
end

Process.kill("SIGTERM", pid)
```

On peut donc depuis un processus, envoyer un signal à un autre processus pour le faire réagir en conséquence.

## Arguments et options en ligne de commande ##

### OptParse ###

Si vous écrivez des scripts en Ruby, il y a de fortes chances que vous vouliez pouvoir passer des arguments et des options à votre script lors de son lancement.

C'est souvent le meilleur moyen de le rendre flexible. Fort heureusement, c'est facile à faire et d'ailleurs Ruby propose même des librairies pour simplifier le travail. Ma préférée étant `OptParse`, voici un exemple d'utilisation :

```bash
$ ruby options_parser.rb
$ ruby options_parser.rb -v
$ ruby options_parser.rb -d --upcase
$ ruby options_parser.rb -d --upcase file1 file2 other
$ ruby options_parser.rb -unknown
```

On peut donc très facilement et de façon élégante gérer les options passées à notre programme, récupérer les arguments, afficher une aide à l'utilisation ou encore gérer le cas des options inconnues.

### ARGF et ARGV ###

Si vous le souhaitez, vous pouvez descendre à plus bas niveau grâce à deux constantes pré-remplies au moment du lancement de votre script.

Vous avez tout d'abord `ARGF` qui représente un pseudo fichier concaténant tout le contenu des différents fichiers passés en arguments au lancement du programme. On pourra donc écrire par exemple :

```ruby
puts ARGF.readline
```

qui reviendrait ni plus ni moins à cloner le fonctionnement basique de la commande unix `cat` :

```bash
ruby argf_reader.rb file1 file2
```

`ARGV` permet quant à elle de connaître la liste des arguments qui ont été passés sous la forme d'un simple tableau:

```ruby
puts "count: #{ARGV.size}"
puts "args: #{ARGV.join(", ")}"
```

```bash
$ ruby argv_reader.rb
$ ruby argv_reader.rb --help foo bar
```

## Accéder aux variables d'environnement ##

Pour finir, on voit assez régulièrement des scripts qui tirent parti des variables d'environnement mises à leur disposition. C'est également possible d'y avoir accès depuis Ruby :

```ruby
ENV.keys
ENV["RBENV_VERSION"]
```

Vos programmes pourraient donc récupérer de l'information extérieure de cette manière et même proposer des variables d'environnement spécifiques  qui pourraient être ajustées par l'utilisateur au moment du lancement de votre programme.

## Conclusion ##

Nous avons donc ici toutes les bases nécessaires pour nous lancer dans l'écriture de scripts d'administration. Ajouter à cela tout ce qu'on a pu voir précédemment avec la vidéo sur les entrées / sorties et la disponibilités de classes dédiées à la gestion de systèmes Unix. Je pense par exemple à la classe `Etc`, nous voilà prêt à automatiser nos tâches de gestion du système.
