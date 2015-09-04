Bienvenue dans cette vidéo consacrée à la découverte des bases de la réflexion en Ruby.

Pour ce screencast nous utilisons la version 2.2 de Ruby et nous ferons les démonstrations dans IRB.

## La théorie

La réflexion est la possibilité pour un programme d'analyser son environnement pendant l'exécution. Elle lui permet d'interroger les objets qui le compose et de les étendre ou de les modifier à la volée.

Les possibilités de réflexion en Ruby sont très avancées. Il est par exemple possible de créer des méthodes ou savoir si une variable existe pendant l'exécution. Ces possibilités ouvrent de nombreuses perspectives du point de vue du programmeur qui peut de ce fait créer des programmes très dynamiques qui réagiront de manière spécifique en fonction des conditions dans lesquels ils sont exécutés.

Un programme peut par exemple définir une méthode avec une implémentation complètement différente en fonction du système sur lequel il est exécuté.

Il sera également possible de définir des méthodes relatives à une structure de données qu'on ne connaît pas à l'avance mais qui est découverte au moment de l'exécution.

## En pratique

On peut par exemple utiliser le mot-clé `defined?` qui permet de savoir si un identifieur, une variable par exemple, existe dans le contexte courant :

```ruby
if defined?(some_var)
  puts "some_var = #{some_var}"
else
  puts "some_var n'existe pas"
end
```

De la même façon, la méthode `respond_to?` permet de savoir si un objet répond à une méthode donnée :

```ruby
s = "test"
s.respond_to? :size
s.respond_to? :foo
```

Il devient donc possible de mettre en place des mécanismes évolués dans le code puisqu'on peut interroger les objets à la volée pour savoir s'ils implémentent tel ou tel comportement. Nous n'avons plus besoin de connaître le type de l'objet à l'avance. Il nous suffit de nous renseigner à son sujet.

On peut, à l'exécution, obtenir la classe d'un objet :

```ruby
s.class
123.class
Array.new.class
```

On pourra également savoir si un objet est une instance d'une classe donnée : 

```ruby
s.instance_of?(String)
s.instance_of?(Object)
```

On peut étendre cette demande à l'objet ainsi que ses ancêtres :

```ruby
s.kind_of?(String)
s.kind_of?(Object)
s.kind_of?(Array)
```

Pour poursuivre, on peut récupérer une liste complète des méthodes qui peuvent être appelées sur l'objet :

```ruby
s.public_methods
s.protected_methods
s.private_methods
```

On peut aussi manipuler les variables d'instance de l'objet :

```ruby
s.instance_variables
s.instance_variable_set :@foo, "test"
s.instance_variables_get :@foo
```

Au niveau d'une classe, il est possible de connaître ses ancêtres et modules inclus :

```ruby
Array.ancestors
Array.included_modules
```

Le module `ObjectSpace` contient toutes les informations concernant les objets actuellement disponibles dans l'interpréteur :

```ruby
ObjectSpace.each_object { |o| p o }
ObjectSpace.count_objects
```

C'est notamment ce module qui permet de forcer le lancement du garbage collector, c'est à dire, le nettoyage en mémoire des objets non-utilisés.

Il permet aussi de définir un comportement à mettre en place lorsqu'un objet est détruit.

Finalement l'un des mécanismes les plus utilisés est la définition à la volée de méthodes.

Quand l'interpréteur recherche une méthode, il regarde si elle existe sur l'objet, puis sur la classe de l'objet et finalement si l'un de ses ancêtres la définie. Si elle n'est pas trouvée, Ruby va exécuter la méthode `method_missing` de l'objet si elle existe sinon, une exception `NoMethodError` sera levée :

```ruby
"test".foo

class String
  def method_missing(name, *args, &block)
    puts "La méthode #{name} n'existe pas"
  end
end

"test".foo
```

## Conclusion

Comme vous pouvez le voir, la réflexion est une fonctionnalité extrêmement puissante. On peut, en peu de lignes de code, rendre un programme très dynamique, auto-évolutif et faire en sorte qu'il sache prendre en charge des cas complexes ou des éléments du contexte d'exécution qui ne peuvent pas être connus à l'avance.

Je vous invite toutefois à faire attention à ne pas en abuser. Quand vous pouvez développer une fonctionnalité sans recourir à la méta-programmation, il faut faire sans. Le code qui est évalué et généré au moment de l'exécution sera forcément plus lent que le même code "statique".

Sachez que cette possibilité existe et qu'elle a beaucoup à offrir mais utilisez la avec parcimonie.
