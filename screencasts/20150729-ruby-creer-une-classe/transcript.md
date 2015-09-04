 Bienvenue dans cette vidéo consacrée à la création d'une classe en Ruby.

Pour ce screencast nous utilisons la version 2.2 de Ruby.

Pour illustrer nos exemples, nous allons utiliser la console interactive IRB. Cette fois nous utiliserons aussi un éditeur de texte pour améliorer la lisibilité du code. Nous chargerons le fichier directement depuis IRB pour pouvoir utiliser et tester ce code.

### La théorie

Ruby propose de base de nombreuses classes qui vous faciliteront le travail quotidien mais dans la plupart des cas, vous aurez besoin de créer vos propres classes.

L'intérêt d'une classe est de permettre d'encapsuler les comportements spécifiques à un objet métier et d'isoler sa logique du reste du code. Cette encapsulation va faciliter la maintenance et l'évolution des fonctionnalités liées à cet objet métier.

Comme vous avez pu le voir dans les épisodes précédents, une classe en Ruby se construit grâce au mot-clé `class` qui permet d'ouvrir une classe pour y définir des attributs et des méthodes.

Ce mot-clé `class` sera suivi du nom de la classe que vous voulez créer. Le nom de la classe est une constante et à ce titre il doit commencer par une majuscule.

Dans une classe on pourra stocker des constantes, des variables de classe, des variables d'instance, des méthodes de classe et des méthodes d'instance.

Les données stockées dans des variables de classe sont disponibles dans tous les objets de cette classe. Les données stockées dans des variables d'instance seront disponibles uniquement dans l'objet qui les a définies.

Il est intéressant de noter que puisqu'en Ruby tout est objet, les classes elles même sont des objets. Ce sont en fait des instances de la classe `Class`.

### La pratique

Créons une classe `Animal` qui permettra de gérer des animaux.

```
class Animal
  WILD = true

  @@counter = 0

  def initialize(name, sex, age)
    @@counter += 1
    @name, @sex, @age = name, sex, age
  end

  def description
    puts "#{@name} is #{@age} years old."
  end

  def self.instances_count
    puts "We created #{@@counter} animals."
  end
end
```

On a donc créé une classe dans laquelle on a définie une constante `WILD`, une variable de classe `@@counter` qui est initialisée à 0 directement dans la définition de la classe.

On a ensuite définie la méthode `initialize` qui sert de constructeur. Cette méthode est appelée automatiquement dès qu'une instance est allouée. On profite de cette méthode pour stocker nos différents paramètres dans des variables d'instance mais aussi pour incrémenter notre compteur. On aura donc un historique du nombre d'animaux qu'on a instancié.

On a également définie une méthode d'instance `description` qui aura pour but d'afficher des informations concernant l'animal, ici on ré-utilise nos variables d'instance `@name` et `@age` pour construire une phrase descriptive.

Finalement on a définie une méthode de classe `instances_count` qui est donc précédée par le mot-clé `self`. Cette méthode a pour but de nous informer sur le nombre d'instances qui ont été créées.

On va maintenant utiliser cette classe pour tester son comportement. On commence par charger notre fichier dans IRB grâce à la méthode `load`

```
load 'animal.rb'
```

On peut utiliser notre classe.

```
a1 = Animal.new('Simba', 'male', 5)
a2 = Animal.new('Cheetah', 'male', 20)

a1.description
a2.description
```

Vérifions maintenant le nombre d'instances créées :

```
Animal.instances_count
```

On peut également accéder à la constante depuis l'extérieur de la classe grâce à la notation `::` :

```
Animal::WILD
```

C'est très souvent utilisé pour accéder à la valeur depuis une autre partie du code.

### Conclusion

Vous connaissez maintenant les bases de la création d'une classe en Ruby. Vous allez donc pouvoir commencer à organiser votre code de façon plus modulaire. Il reste évidemment beaucoup d'autres choses relatives aux classes à découvrir pour prétendre les maitriser, c'est ce que nous verrons dans les prochains épisodes.