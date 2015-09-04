Bienvenue dans cette vidéo consacrée à la création d'accesseurs dans une classe en Ruby.

Pour ce screencast nous utilisons la version 2.2 de Ruby.

Pour illustrer nos exemples, nous allons utiliser la console interactive IRB mais nous écrirons le code dans un éditeur de texte pour améliorer la lisibilité. Nous chargerons le fichier directement depuis IRB pour pouvoir utiliser et tester ce code.

### La théorie

Dans la vidéo précédente nous avons créé une classe basique qui permet de gérer des animaux.

Bien souvent vous aurez besoin de pouvoir modifier les propriétés d'une instance existante. Le fait d'avoir créé des variables d'instances ne suffit pas à pouvoir les lire ou les modifier depuis l'extérieur de la classe. Pour pouvoir accéder à ces variables d'instances depuis l'extérieur, que ce soit en lecture ou en écriture, vous devez écrire ce qui dans beaucoup de langage s'appelle les "getter" et les "setter".

### Les accesseurs

En Ruby ce sont les accesseurs. Ce sont des méthodes dédiées à la lecture ou à la modification du contenu d'une variable d'instance. Nous allons améliorer notre classe existante pour pouvoir lire et modifier le contenu de la variable d'instance `@age` :

```
class Animal
  WILD = true

  @@counter = 0

  def initialize(name, sex, age)
    @@counter += 1
    @name, @sex, @age = name, sex, age
  end

  def age
    @age
  end

  def age=(age)
    @age = age
  end

  def description
    puts "#{@name} is #{@age} years old."
  end

  def self.instances_count
    puts "We created #{@@counter} animals."
  end
end
```

On a donc ajouter la méthode `age` qui fait office de "getter", son but est simplement de retourner la valeur de la variable d'instance `@age`. On a également ajouté la méthode `age=` qui sert quant à elle de "setter". Elle va permettre de modifier le contenu de la variable d'instance `@age`. On note la présence du `=` dans le nom de méthode. Ce n'est absolument pas obligatoire mais par convention et pour améliorer la lisibilité, les Rubyistes ont pour habitude d'ajouter un `=` au noms de méthodes servant de "setter". Cette méthode prend un paramètre qui sera utilisé comme nouvelle valeur.

Testons cette classe améliorée :

```
load 'animal.rb'

a = Animal.new('Simba', 'male', 5)
a.age
a.description
a.age = 10
a.age
a.description
```

Ça fonctionne donc comme voulu, c'est satisfaisant sur le plan fonctionnel mais ce n'est pas du tout représentatif du code idiomatique à utiliser en Ruby. Ce besoin est tellement courant en Ruby qu’il met à notre disposition des macros permettant de faire ce travail à notre place.

On a donc à disposition trois méthodes qui sont `attr_reader`, `attr_writer` et `attr_accessor` qui permettent respectivement de créer un "getter", un "setter" ou les deux à la fois. On peut donc modifier notre classe pour la simplifier :

```
class Animal
  WILD = true

  @@counter = 0

  attr_accessor :age

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

On a donc supprimer nos deux méthodes dédiées à la gestion de l'âge pour les remplacer par un appel à `attr_accessor` suivi du nom de la variable d'instance pour laquelle les méthodes doivent être générées.

On peut recharger notre code dans IRB et vérifier que ça fonctionne toujours. On remarque un message d’avertissement qui nous dit que nous avons redéfinie une constante. Effectivement le fait de recharger notre fichier a écrasé la constante définie lors du premier chargement :

```
load 'animal.rb'

a = Animal.new('Simba', 'male', 5)
a.age
a.description
a.age = 10
a.age
a.description
```

Le comportement est identique mais le code est plus concis et les risques de bugs sont donc réduits.

### Conclusion

Vous connaissez maintenant les bases de la création des accesseurs dans une classe en Ruby. Vous allez donc pouvoir améliorer vos classes existantes et mettre en place des méthodes permettant de manipuler vos attributs d'instances.