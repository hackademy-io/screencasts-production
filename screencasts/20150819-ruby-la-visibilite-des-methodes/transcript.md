Bienvenue dans cette vidéo consacrée à la visibilité des méthodes en Ruby.

Pour ce screencast nous utilisons la version 2.2 de Ruby.

Nous écrirons le code dans un éditeur de texte pour une meilleure lisibilité. Nous chargerons ensuite le fichier depuis IRB pour pouvoir utiliser et tester ce code.

## La théorie

Lorsque vous écrivez une classe en Ruby, il est possible de limiter la visibilité de ses méthodes. Certaines méthodes sont conçues pour être utilisées directement par la classe, elle n'ont pas vocation à être utilisé à l'extérieur de celle ci. En limitant la visibilité, vous empêchez leur utilisation depuis l'extérieur.

Par défaut, les méthodes que vous ajoutez à une classe sont publiques, elle peuvent donc être appelées depuis l'extérieur. Les mots-clés `protected` et `private` permettent de modifier la visibilité des méthodes qui sont définies ensuite.

On a donc trois visibilités à disposition : `public`, `protected` et `private`.

## En pratique ##

### Depuis la classe ###

Écrivons une classe qui utilise les trois :

```ruby
class Visibility
  def public_method
    puts "public"
  end

  protected

  def protected_method
    puts "protected"
  end

  private

  def private_method
    puts "private"
  end
end
```

Voyons maintenant comment ces trois méthodes se comportent au sein de la classe en ajoutant deux méthodes qui les utilisent :

```ruby
def without_self
  public_method
  protected_method
  private_method
end

def with_self
  self.public_method
  self.protected_method
  self.private_method
end
```

Testons maintenant dans IRB :

```ruby
load 'visibility.rb'
visibility = Visibility.new
visibility.without_self
```

Les trois méthodes sont donc appelées sans le moindre problème avec un receveur implicite.

Testons maintenant la version utilisant les `self`

```ruby
visibility.with_self
```

Dans ce cas les méthodes publique et protégée sont bien appelées mais la méthode privée lève une exception `NoMethodError`.

Il est donc impossible d'appeler une méthode privé avec un receveur explicite, elle ne peut être appelée que sur l'objet courant.

### À l'extérieur de la classe ###

Voyons maintenant comment ces méthodes se comportent depuis l'extérieur de la classe :

```ruby
visibility.public_method
```

La méthode publique peut, sans surprise, être appelée de l'extérieur.

```ruby
visibility.protected_method
visibility.private_method
```

Les méthodes protégée et privée lèvent quant à elles une exception `NoMethodError`. Il est donc impossible d'y faire appelle depuis l'extérieur. Elles ont une visibilité limitée et ne font pas partie de l'interface publique de la classe.

### Différence entre `protected`et `private` ###

Vous devez sûrement vous demander quelle est la différence entre les visibilités `protected` et `private`. Elle est subtile.

Si l'objet qui envoie le message, autrement dit qui appelle la méthode, est du même type que l'objet qui le reçoit alors il peut appeler une méthode protégée. Il reste impossible d'appeler une méthode privée même dans ce cas.

Voyons un exemple :

```ruby
class Extended < Visibility
  def call_methods(other)
    other.public_method
    other.protected_method
    other.private_method
  end
end

class NotRelated
  def public_method
    puts "public"
  end

  protected

  def protected_method
    puts "protected"
  end

  private

  def private_method
    puts "private"
  end
end
```

On ajoute une classe `Extended` qui hérite de `Visibility`. Cette classe implémente une méthode `call_methods` qui permet d'appeler nos trois méthodes mais sur un autre objet passé en paramètre.

Nous ajoutons également une classe `NotRelated` qui implémente nos trois méthodes mais qui n'a aucun lien avec nos deux classes précédentes.

On recharge notre fichier et on teste le comportement :

```ruby
e = Extended.new
e.call_methods(Visibility.new)
```

Les méthodes publique et protégée de l'objet `Visibility` ont pu être appelées depuis l'objet `Extended`. C'est possible car ces deux objets proviennent de la même classe parent :

```ruby
e.is_a?(Visibility)
```

Seule la méthode privée ne peut être appelée.

Essayons maintenant avec un objet qui n'a aucun lien :

```ruby
e.call_methods(NotRelated.new)
```

Ici seule la méthode publique peut être appelée, l'appel à la méthode protégée lève une exception `NoMethodError` car les deux objets ne font pas partie de la même hiérarchie :

```ruby
e.is_a?(NotRelated)
```

L'utilisation la plus fréquente pour les méthodes protégées est de permettre à deux objets du même type de coopérer. Par exemple pour écrire une méthode qui permet de comparer deux objets, disons des personnes et savoir qui est le plus âgé sans pour autant avoir accès publiquement à l'âge dans l'interface.

## Conclusion

Il est important de maîtriser le concept de visibilité des méthodes pour être en mesure d'écrire des classes avec une interface propre. Le plus souvent vous utiliserez des méthodes publiques et privées mais il reste essentiel de savoir utiliser les méthodes protégées pour permettre à vos objets de communiquer entre eux sans polluer l'interface publique.