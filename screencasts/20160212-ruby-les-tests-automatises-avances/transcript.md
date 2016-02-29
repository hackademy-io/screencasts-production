Bienvenue dans cette deuxième partie de la vidéo dédiée aux tests en Ruby.

Maintenant que nous avons vu les bases de la mise en place de tests à l'aide de Minitest::Spec, nous allons aller un peu plus loin et découvrir les outils que Minitest met à notre disposition pour éviter la redondance et gérer des cas complexes dans lequels le contexte doit être maitrisé pour pouvoir écrire des tests robustes.

## Callbacks et accesseurs paresseux ##

### before / after ###

Vous aurez souvent besoin, pour plusieurs tests d'un même contexte, d'initialiser pour chaque test un objet ou un environnement identique.

Plutôt que refaire cette initialisation dans chaque test ou d'écrire une méthode privée que vous appellerez manuellement dans chaque test, Minitest met à votre disposition des callbacks qui sont `before` et `after` et qui seront respectivement appelés avant et après chaque test du contexte.

```ruby
require "minitest/spec"
require "minitest/autorun"

require_relative "person"

describe Person do
  before do
    puts "Avant le test"
  end

  after do
    puts "Après le test"
  end

  it "should do something" do
    puts "dans le test"
  end

  it "should do something else" do
    puts "dans l'autre test"
  end
end
```

On voit donc que les blocs `before` et `after` sont bien exécutés avant **et** après **chaque** test.

C'est donc l'endroit parfait pour initialiser des données qui seront utilisés dans chaque test ou nettoyer une base de données après chaque test.

```ruby
require "minitest/spec"
require "minitest/autorun"

require_relative "person"

describe Person do
  describe "#full_name" do
    before do
      @person = Person.new(first_name: "Nico", last_name: "C.")
    end

    after do
      puts "Cleaning DB"
    end

    it "should include first name" do
      @person.full_name.must_include("Nico")
    end

    it "should include last name" do
      @person.full_name.must_include("C.")
    end
  end
end
```

Ces tests sont bizarrement constitués je vous l'accorde mais permettent de bien mettre en évidence l'utilisation de `before` et `after`.

On a donc profité du bloc `before` pour initialiser une instance de la classe `Person` qu'on stocke dans une variable d'instance. On va donc pouvoir ré-utiliser cette variable à travers tous nos tests du contexte. On s'épargne donc l'initialisation dans chaque test.

Dans notre exemple, le bloc `after` fait prétendument un nettoyage de la base de donnée après chaque test.

### Lazy accessors ###

Un autre besoin encore plus courant est de mutualiser le contenu d'une variable entre plusieurs tests d'un même contexte. C'est ce que nous avons fait avant avec le `before` mais en pratique on le réservera plutôt à de la configuration d'environnement.

Bien souvent, on utilisera les accesseurs paresseux pour gérer les variables à partager entre plusieurs tests. Ces accesseurs paresseux sont déclarée à l'aide de `let` qui attend un bloc de code qui ne sera exécuté que lors du premier appel dans un test. Le bloc n'est donc pas exécuté s'il la variable n'est pas utilisée. De plus ce bloc ne sera exécuté qu'une fois par test. C'est donc la méthode la plus efficace et performante pour gérer des variables partagées.

On pourrait donc remplacer notre code de test précédent par :

```ruby
require "minitest/spec"
require "minitest/autorun"

require_relative "person"

describe Person do
  describe "#full_name" do

    after do
      puts "Cleaning DB"
    end

    let(:person) { Person.new(first_name: "Nico", last_name: "C.") }

    it "should include first name" do
      person.full_name.must_include("Nico")
    end

    it "should include last name" do
      person.full_name.must_include("C.")
    end
  end
end
```

On a donc supprimé le bloc `before` pour le remplacer par un appel à `let` qui définie un accesseur paresseux qui sera générée à son premier appel. Ce n'est pas une variable mais plutôt une méthode qui nous retourne le résultat d'un bloc au premier appel puis sa version cachée ensuite.

Dans nos tests, on appelle donc l'accesseur `person`  plutôt que la variable d'instance `@person`.

## Stubs ##

Lorsqu'on teste, on a aussi régulièrement besoin de pouvoir forcer certains objets à répondre de manière attendu. C'est particulièrement vrai quand l'une de vos méthodes manipule des heures et dates ou des données aléatoires.

Dans ce cas il est particulièrement utile de pouvoir demander à une méthode de toujours répondre de la même manière lorsqu'on l'appel à un certain endroit ou avec certains paramètres.

Disons que notre classe `Person` peut retourner l'âge de la personne en secondes, on serait tenté d'écrire le test comme suit:

```ruby
describe "#age_in_seconds" do
  it "should return person age in second from now" do
    thirty_years_ago = 30 * 365 * 24 * 60 * 60
    borned_at = Time.now - thirty_years_ago

    p = Person.new(first_name: "foo", last_name: "bar", birthday: borned_at)
    p.age_in_seconds.must_equal Time.now - borned_at
  end
end
```

On crée une date qui correspond à un age de 30 ans, puis on utilise cette date pour définir l'âge de notre personne.

On appelle ensuite la méthode `age_in_seconds` et on la compare à l'heure courante moins 30 ans.

On ajoute ensuite la méthode à notre classe ainsi que l'attribut `@birthday`:

```ruby
def age_in_seconds
  Time.now - @birthday
end
```

Si on lance notre test on a une erreur. Le souci ici est qu'on va avoir un décalage de quelques millisecondes entre la création de la date anniversaire et le retour de notre méthode, il s'est passé quelques millisecondes dans le programmes.

Le plus simple est donc de faire en sorte que la méthode `Time.now` réponde avec une valeur fixe qui nous permet de tester dans des conditions connues :

```ruby
current_time = Time.now

Time.stub :now, current_time do
  # …
end
```

On a donc stubber la méthode `now` de la classe `Time` pour que la valeur retournée soit toujours `current_time`. Tous les appels à `Time.now` dans le bloc retourneront donc la valeur de `current_time` y compris celui fait par notre méthode `age_in_seconds`.

Il ne faut évidemment pas en abuser et ne l'utiliser que dans le cas où contrôler la valeur de retour d'une méthode est une nécessité.

### MiniTest::Mock ###

Le dernière fonctionnalité de MiniTest que je souhaite vous présenter est MiniTest::Mock dont le but est de créer un objet factice qui sera capable de recevoir des appels de méthode et de retourner des valeurs. Il permettra également de vérifier que les méthodes attendues ont bien été appelées pendant notre test. On pourra même vérifier qu'elles ont été appelées avec les bons arguments.

C'est particulièrement utile lorsque vous souhaitez simuler les appels à un service externe que vous ne maîtrisez pas.

De manière générale, c'est une bonne pratique de "mocker" tous les appels à des services externes. Ça permet de lancer les tests sans avoir de connexion réseau ou même encore si le service externe ne répond pas. Ça permettra d'ailleurs de tester le cas où le service est indisponible. Dans tous les cas, vos tests seront plus rapides.

On pourra donc simuler des appels à un serveur IMAP, à une base de données, une API, etc.

Créons donc une classe dédiée à l'envoie de message sur des plate-formes variées, Twitter par exemple.

Nous pourrions mettre en place une classe qui utilisera une interface commune pour envoyer les messages, il suffira donc de passer à l'initialisation de notre objet un autre objet qui implémente l'interface en question.

Ici les objets passés devront au moins répondre à la méthode `post` pour pouvoir être utilisés. Le reste de leur interface et le fonctionnement interne nous est égale :

```ruby
class SocialMedia
  def initialize(media)
    @media = media
  end

  def post(message)
    @media.post("#{message} from SocialMedia class")
  end
end
```

On a donc une classe `SocialMedia` qui lors de son instanciation attend un paramètre qui est en fait le client pour l'API visée. Cette instance du clent sera donc capable de s'identifier, poster un message, etc.

Notre classe déclare ensuite une méthode `post` dont le but est d'utiliser le client fourni et d'appeler sa méthode `post` avec un message retravaillé.

L'implémentation est fantaisiste, personne n'aurait d'intérêt à utiliser ça mais l'idée est là. On isole les responsabilités pour avoir une architecture propre.

On écrit maintenant les tests pour notre classe :

```ruby
require 'minitest/autorun'

require_relative 'social_media'

describe SocialMedia do
  before do
    @twitter  = MiniTest::Mock.new
  end

  let(:social_media) { SocialMedia.new(@twitter) }
  let(:content) { "I'm social!"}

  it "should append a watermark from the class" do
    @twitter.expect :post, true, ["#{content} from SocialMedia class"]
    social_media.post(content)

    assert @twitter.verify # verifies tweet and hashtag was passed to `@twitter.update`
  end
end
```

Dans le bloc `before` nous avons créé un mock de l'objet servant à communiquer avec l'API de tweeter puisque dans nos test nous ne souhaitons pas réellement contacter l'API de twitter mais simplement simuler son comportement.

Nous déclarons ensuite deux accesseurs paresseux, l'un instanciant notre classe avec en paramètre le mock de l'API Twitter puis un autre qui contient simplement le contenu à envoyer sur le réseau social.

Ensuite on déclare notre test qui va s'assurer que notre classe ajoute bien une chaîne l'identifiant à la fin du message original.

On fait savoir à notre mock qu'il doit normalement être appelé via sa méthode `post` avec en paramètre la chaîne "#{content} from SocialMedia class" et que dans ce cas il retournera true.

On appelle ensuite la méthode de notre classe qui est censée déclencher l'appel à la méthode `post` de l'API en lui passant le contenu d'origine.

Finalement, on s'assure avec `assert` que notre mock a bien été appelé comme prévu.

Si le test passe, on a donc l'assurance que les objets utilisés en interne dans notre méthode on bien été appelés avec les paramètres attendus. Dans notre cas, ça revient à confirmer que notre classe appelle bien la méthode `post` de l'objet API fourni et lui passe en argument la chaîne modifiée.

## Conclusion ##

Vous connaissez maintenant toutes les bases vous permettant d'écrire des tests automatisés. Vous verrez que très rapidement l'écriture de tests deviendra naturelle et que vous ferez de plus en plus de TDD sans vous en rendre compte.

Les tests sont sans aucun doute possible l'un de vos meilleurs alliés pour écrire un code de qualité et que vous pourrez faire évoluer sur le long terme sans vous tirer les cheveux.
