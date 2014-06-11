# ActiveRecord enums

Ruby on Rails 4.1 apporte des solutions élégantes et rapides à des problèmes fréquemment rencontrés lors du développement.

Vous avez peut-être déjà codé de quoi gérer, plus ou moins élégamment, un attribut à plusieurs états. Par exemple, pour une commande,
sur un site ecommerce, on peut définir que son statut a 3 états possibles : "en cours", "terminée" ou "annulée".

Avant Rails 4.1, on aurait pu utiliser plusieurs attributs booléen pour définir cet état : un attribut "annulée" qui peut être vrai ou faux, un autre pour "terminée", etc. Ce n'est ni élégant, ni très logique. On préfère en général utiliser un seul attribut texte dont la valeur varie selon chaque état : "en cours", "terminée" et "annulée" mais aucune combinaison de tout cela.

Ce n'est pas optimal côté utilisation de la base de données, ni très performant en général. On a donc jusqu'à présent utilisé un nombre associé à chaque état : 0 pour "en cours", 1 pour "terminée", 2 pour "annulée". On stocke cet état dans une variable de type entier
ce qui est léger dans la base de données et plutôt rapide.

Il fallait ajouter à cela des validations côté Rails, des méthodes pour accéder à cette valeur ; quand on demande l'état
on ne doit pas retourner 0, 1 ou 2 mais bien l'état qui peut être en cours, terminé ou annulé. Puis on peut rajouter des méthodes booléennes pour demander à une commande si elle est terminée ou non, des méthodes pour attribuer un nouvel état, et éventuellement des scopes pour demander à ActiveRecord de retourner toutes les commandes "en cours", ou "annulée"….

ActiveRecord 4.1 met à disposition la méthode "enum" qui évite ces lourdeurs et répétitions.

Pour l'utiliser c'est très simple, on commence par créer un champ entier dans la base de données avec une migration :

    rails generate migration add_state_to_order state:integer:index

Au passage, on oublie pas de spécifier "index" pour pouvoir filtrer de manière performante nos enregistrements.

Ensuite il suffit d'ajouter une ligne notre modèle ActiveRecord :

    class Order << ActiveRecord::Base
        enum state: [:in_progress, :completed, :canceled]
    end

ActiveRecord nous met à disposition une méthode du nom de l'attribut qui nous permet d'obtenir son état :

    order = Order.new
    order.state
    # => nil

On peut attribuer un nouvel état très simplement :

    order.state = :in_progress
    order.save!
    # => true

Mais aussi une méthode du nom de chaque état possible, retournant une valeur booléenne :

    order.completed?
    # => false

On peut même changer la valeur et enregistrer les modifications en tapant le nom de l'état suivi d'un point d'exclamation :

    order.completed!

Enfin, des scope ActiveRecord sont automatiquement créés pour chaque état :

    Order.canceled
    Order.completed
    Order.in_progress

On peut les utiliser pour créer, par exemple, une nouvelle commande avec l'état en cours :

    Order.in_progress.create

Si l'on désire une valeur par défaut, il suffit de le spécifier directement dans la base de données : dans notre cas, la première valeur (en cours) se trouve en première position, soit la valeur 0.

    rails generate migration add_default_value_to_order_state
    change_column :order, :state, :integer, default: 0
    rails db:migrate

    order = Order.new
    order.state
    # => "in_progress"

Vérifiez bien à ne pas changer l'ordre des valeurs définies pour votre attribut. Rails utilise cet ordre pour y associer les différentes valeurs possibles.
Pour une commande "annulée", par exemple, c'est la valeur 2 qui est enregistrée dans la base de données (seconde position dans la liste des valeurs possibles) :

    order = Order.create(state: :canceled)
    order.state
    # => "canceled"
    order.state_before_type_cast
    # => 2

Si vous n'ajoutez pas votre nouvelle valeur à la fin de la liste, cela va décaler tous les états.

    enum state: [:in_progress, :delivered, :completed, :canceled]

La commande précédemment "annulée" est devenue "terminée" (nouvelle valeur en troisième position).
