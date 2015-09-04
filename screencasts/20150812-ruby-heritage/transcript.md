Bienvenue dans cette vidéo consacrée à l'héritage de classe en Ruby.

Pour ce screencast nous utilisons la version 2.2 de Ruby.

Nous écrirons le code dans un éditeur de texte pour une meilleure lisibilité. Nous chargerons ensuite le fichier depuis IRB pour pouvoir utiliser et tester ce code.

### La théorie

Dans la vidéo précédente nous avons amélioré une classe existante qui permet de gérer des animaux.

Nous allons aujourd'hui apprendre à nous servir de l'héritage en Ruby.

L'héritage permet de créer une classe sur la base d'une autre pour en modifier certains aspects. Ça permet donc de refléter des comportements spécifiques qui ne peuvent pas être mis en commun dans la classe parent.

Imaginez que sur la base de notre classe `Animal` nous voulions créer des chiens mais aussi des chats. Le cri de chaque animal est différent et il est donc impossible de le mutualiser dans la classe `Animal`. C'est une méthode que nous devrons mettre en place spécifiquement dans chaque classe enfant. Pour autant on souhaite garder tous les comportements communs pour ne pas avoir à les ré-écrire. C'est ce que permet l'héritage.

### Mise en place de l'héritage

Nous allons donc créer notre première classe qui hérite de la classe `Animal`. Ce sera la classe `Dog`. Dans cette classe, nous allons créer une méthode qui permet à l'animal d'émettre son cri. En Ruby, l'héritage se fait grâce à l'opérateur `<` :

```
class Dog < Animal
  WILD = false

  def cry
    puts "Woof!"
  end
end
```

On a donc défini une classe `Dog` qui hérite de la classe `Animal`. De ce fait elle possède déjà tous les comportements de la classe `Animal` :

```
load 'animal.rb'
load 'dog.rb'

d = Dog.new('Snoopy', 'male', 10)
d.age
d.description
```

Mais cette classe possède également une nouvelle méthode qu'on peut appeler :

```
d.cry
```

Ce qui est impossible sur un objet de la classe `Animal` :

```
a = Animal.new('Simba', 'male', 5)
a.cry
```

Une exception `NoMethodError` est levée.

On voit également qu'on a redéfini la constante `WILD` parce que les chiens ne sont pas des animaux sauvages :

```
Dog::WILD
```

### Redéfinition de méthode

L'héritage laisse aussi la liberté de ré-écrire entièrement ou en partie des méthodes de la classe parent. On va donc modifier la description pour qu'elle soit plus personnelle :

```
class Dog < Animal
  WILD = false

  def cry
    puts "Woof!"
  end

  def description
    puts "I'm #{@name} the dog and I'm #{@age} years old!"
  end
end
```

On a donc complètement écrasé la définition du parent pour avoir un comportement personnalisé :

```
load 'dog.rb'

d = Dog.new('Snoopy', 'male', 10)
d.description
```

On aurait pu vouloir garder le comportement par défaut mais simplement y ajouter du comportement additionnel. C'est possible grâce au mot-clé `super` qui permet d'appeler la méthode correspondante du parent. Modifions notre classe :

```
class Dog < Animal
  WILD = false

  def cry
    puts "Woof!"
  end

  def description
    super
    puts "He's a dog."
  end
end
```

Testons à nouveau :

```
load 'dog.rb'

d = Dog.new('Snoopy', 'male', 10)
d.description
```

On a donc la méthode `description` de la classe `Animal` qui génère la première ligne, puis le méthode `description` de notre classe `Dog` qui génère la deuxième ligne.

### Conclusion

L'héritage est un moyen très flexible pour architecturer vos classes et éviter la redondance. C'est une notion qu'il est nécessaire de maîtriser si vous voulez vous attaquer à des projets ambitieux et bien encapsuler le comportement de chaque entité. Je vous invite donc à faire des essais de votre côté !