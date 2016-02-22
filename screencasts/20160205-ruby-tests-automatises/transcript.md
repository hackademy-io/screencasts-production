Bienvenue dans cette vidéo consacrée à la mise en place de tests automatisés en Ruby.

La mise en place de tests automatisés pour votre code peut sembler rédhibitoire si vous n'y êtes pas habitués mais s'avère vite indispensable sur des projets voués à évoluer et dépassant les quelques dizaines de ligne de code.

C'est l'assurance pour vous et les autres développeurs du projet que les modifications que vous apportez ne cassent pas le comportement d'une autre partie de l'application. Vous gagnez donc en confort et vous vous évitez des suées à chaque modification d'une portion de code que vous connaissez mal.

## Les outils à disposition ##

Plusieurs librairies dédiées à la mise en place de tests sont disponibles pour Ruby bien que deux options majeures sortent du lot. Si vous regardez les tests d'un projet libre écrit en Ruby, ils seront sûrement écrit à l'aide de RSpec qui a longtemps largement dominé la place grâce à ses nombreuses fonctionnalités et surtout parce qu'il a été le premier à proposer une écriture façon "spec" qui rend l'écriture et la lecture des tests plus naturelle.

Toutefois, depuis quelques temps, la librairie Minitest gagne beaucoup de terrain. Elle plaît de plus en plus aux développeurs car elle est très simple à prendre en main, utilise peu de magie pour fonctionner et reste très proche du langage Ruby de base. Pour ne rien gâcher, elle est très rapide à l'exécution et est livrée de base avec l'interpréteur Ruby !

C'est donc Minitest, dans sa version Minitest::Spec que nous allons utiliser pour profiter de l'écriture des tests à la manière "spec".

## Premiers tests ##

Supposons que nous avons une classe `Person` qui peut prendre en entrée un nom et un prénom et que nous voulions mettre en place une méthode d'instance qui permettra d'avoir le nom complet :

```ruby
class Person
  def initialize(first_name:, last_name:)
    @first_name, @last_name = first_name, last_name
  end

  def full_name
    [@first_name, @last_name].join(" ")
  end
end
```

On a donc le constructeur qui prend deux paramètres nommés. Ces valeurs sont stockées dans des variables d'instance pour être ré-utilisables.

On a ensuite une méthode qui permet de générer le nom complet en utilisant un tableau contenant le prénom et le nom. Ces éléments sont ensuite joins par un espace.

Pour s'assurer que notre classe fonctionne correctement, nous devons écrire les tests adéquats :

```ruby
require "minitest/autorun"

require_relative "person"

describe Person do
  it "should return person full name" do
    Person.new(first_name: "foo", last_name: "bar").full_name.must_equal "foo bar"
  end
end
```

C'est un bon début. Nous chargeons `minitest/autorun` qui permet de lancer automatiquement les tests lorsque le fichier est exécuté.

On charge ensuite le code de notre classe `Person`.

C'est maintenant le moment de passer au vif du sujet, à savoir l'écriture des tests.

La première chose remarquable est l'instruction `describe` qui permet de créer un contexte. Chaque fois qu'on souhaite grouper de manière logique un ensemble de tests, on peut utiliser un contexte. On peut d'ailleurs imbriquer les contextes.

Ici notre contexte est tout simplement la classe `Person`.

Une fois dans un contexte, on peut écrire des tests grâce au mot-clé `it` suivi d'une chaîne qui décrit ce qu'on va tester. Ici on souhaite vérifier qu'on peut obtenir le nom complet de la personne.

On va donc instancier un objet `Person` puis appeler la méthode qu'on souhaite tester, ici `full_name`. Il ne nous reste qu'à valider que la valeur retournée correspond à ce qu'on attend. C'est ce qu'on appelle une assertion.

Ici notre assertion consiste à dire que le résultat de la méthode doit être égale à la chaîne "foo bar".

Plutôt simple n'est-ce pas ?

Lançons nos tests pour voir si tout fonctionne comme attendu :

```bash
ruby person_spec.rb
```

Minitest met à notre disposition tout un tas d'assertions qui permettent de vérifier des choses diverses et variées comme l'égalité, la différente, la nullité, l'inclusion ou encore le fait qu'on objet réponde ou non à une méthode.

Toutes les assertions disponibles sont listées dans la documentation de Minitest. Il y a aussi l'aide-mémoire de [Matt Sears](http://www.mattsears.com/articles/2011/12/10/minitest-quick-reference/) qui est très bien fait.

L'idée est de tester tous les comportements de votre classe pour vous assurer que vous ne passez pas à côté de quelque chose et que vos tests garantirons le bon fonctionnement de votre classe lorsque vous la modifierez.

## TDD ##

L'une des grandes tendances dans le domaine du test est d'écrire les tests avant même d'écrire le code fonctionnel. Ça peut paraître étrange au premier abord mais c'est en fait un très bon moyen de bien réfléchir ses besoins et d'architecturer correctement son code.

Bien souvent quand on écrit les tests après le code fonctionnel, on a tendance à ne tester que l'implémentation présente plutôt que de tester réellement le comportement attendus pour l'ensemble des cas qu'on souhaite gérer.

On va donc procéder de cette manière pour la suite. Disons qu'à l'initialisation de notre objet, on veut pouvoir passer un deuxième prénom facultatif. Il faudrait modifier nos tests pour signifier ce besoin :

```ruby
require "minitest/autorun"

require_relative "person"

describe Person do
  describe "#full_name" do
    it "should return first name and last name when there's no middle name available" do
      Person.new(first_name: "foo", last_name: "bar").full_name.must_equal "foo bar"
    end

    it "should return first name, middle name and last name when all available" do
      Person.new(first_name: "foo", last_name: "bar", middle_name: "baz").full_name.must_equal "foo baz bar"
    end
  end
end
```

On a ajouter un contexte `full_name` pour regrouper les tests relatifs à cette méthode.

Le premier test est le même qu'avant, nous avons simplement changé son nom pour être plus explicite sur ce qui est testé.

Nous avons finalement ajouté un test pour vérifier que si le second prénom est disponible, il sera utilisé dans la chaîne générée.

L'idée est donc de lancer notre test pour voir s'il passe ou non. Il ne doit logiquement pas passer puisque nous n'avons jamais prévu ce cas.

```bash
ruby person_spec.rb
```

On a bien une erreur qui nous explique que le paramètre `middle_name` est inconnu de la méthode `initialize`. Ajoutons le :

```ruby
def initialize(first_name:, last_name:, middle_name:)
  @first_name, @last_name, @middle_name = first_name, last_name, middle_name
end
```

puis relançons nos tests:

```bash
ruby person_spec.rb
```

Nous avons maintenant deux erreurs… L'une d'entre elle nous dit qu'on a essayé d'initialiser l'objet sans passer de `middle_name`. Corrigeons déjà ça puisque effectivement ce paramètre est facultatif:

```ruby
def initialize(first_name:, last_name:, middle_name: nil)
  @first_name, @last_name, @middle_name = first_name, last_name, middle_name
end
```

Si on relance nos tests:

```bash
ruby person_spec.rb
```

On voit qu'il ne nous reste qu'une erreur qui nous dit que la chaîne obtenue ne correspond pas à la chaîne attendu. C'est donc à nous de jouer et de modifier notre code pour qu'il réponde au besoin :

```ruby
def full_name
  [@first_name, @middle_name, @last_name].compact.join(" ")
end
```

Lançons à nouveau nos tests :

```bash
ruby person_spec.rb
```

Et tous nos tests passent ! Voilà un exemple parfait de développement basé sur les tests plus connus sous le nom de "TDD".

## Conclusion ##

Cette introduction rapide vous permettra de commencer à mettre en place des tests pour garantir le bon fonctionnement de votre code et éviter l'introduction de régression. Elle vous montre également comment mettre un pied à l'étrier pour utiliser le TDD qui est une pratique qui devient indispensable lorsqu'on la maîtrise.

Dans le prochain épisode nous verrons comment éviter la redondance à travers les différents tests mais aussi comment maîtriser le contexte d'exécution des tests pour pouvoir tester des cas complexes dépendant d'éléments extérieur à priori non maîtrisables.
