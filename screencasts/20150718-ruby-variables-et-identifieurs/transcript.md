Bienvenue dans cette vidéo consacrée à la découverte des variables et identifieurs en Ruby.

Je vous conseille d'utiliser une version récente de Ruby pour vos développements. Nous utilisons ici la 2.2.

Pour illustrer nos exemples, nous allons utiliser la console interactive IRB.

### La théorie

En Ruby, les variables et autres identifieurs commencent généralement par une lettre. Les régles de bases sont simples.

Les variables locales commencent par une lettre ou un underscore. Commencer le nom d'une variable par un underscore permet d'avertir l'interpréteur que vous n'allez pas utiliser cette variable mais que c'est intentionnel. Ça évite donc d'avoir un message d'avertissement à l'exécution.

Les conventions en Ruby veulent que si une variable contient plusieurs mots, on les sépare par un underscore.

Des exemples de variables locales pourraient donc être :

```
user = "Nico"
_unused = "Non utilisé"
some_var = 1234
```

Il faut également distinguer des pseudo-variables qui sont générées automatiquement par l'interpréteur. Il s'agit de `self` qui représente l'objet courant ou encore `nil` qui est une instance de la classe `NilClass`.

Il y a également `__FILE__` et `__dir__` qui utilisés dans un fichier Ruby permettent d'obtenir respectivement le chemin absolu vers ce fichier ainsi que le chemin absolu vers le répertoire qui contient ce fichier. Au sein d'IRB ces deux variables n'ont pas réellement de sens.

Viennent ensuite les variables globales qui commencent obligatoirement par un `$`. Ces variables une fois définies sont accessibles à travers tout le programme, quelque soit le fichier dans lequel on se trouve et celui où elles sont définies. Ces variables sont à utiliser avec parcimonie car elles "polluent" l'ensemble du programme et dénotent très souvent un problème de conception.

Voici quelques exemples de variables globales :

```
$version = "1.2.6"
$NOT_A_CONST = 42
```

Nous avons ensuite les variables d'instances qui sont un type de variable très utilisé. Elles sont utilisées au sein d'un objet et représentent des données qui lui sont directement liées. Seul l'objet y a accès.

Ces variables d'instances commencent toujours par un `@` et suivent les mêmes conventions que les variables locales. Voici quelques exemples :

```
@foobar = "baz"
@some_var_123 = 123
```

Nous avons également les variables de classe qui contiennent des données accessibles à l'ensemble d'une classe et des ses instances. Ces variables sont partagées entre tous les objets issus de la classe en question. Les variables de classe commencent par deux `@`. Voici quelques exemples :

```
@@counter = 10
@@file_path = "/some/dir/file.txt"
```

Il reste pour finir les constantes qui doivent commencer par une lettre majuscule. Par convention, de nombreux rubyistes écrivent les constantes avec uniquement des lettres majuscules et séparent les éventuels mots par un underscore.

Les constantes sont destinées à stocker des informations qui ne sont pas appelées à être modifiées. Il faut tout de même être vigilant puisque pour des raisons techniques, il est possible en Ruby de modifier une constante existante. Ça n'empêchera pas le programme de fonctionner, l'interpréteur émettra simplement un message d'avertissement.

Voici quelques exemples de noms de constantes :

```
STATUSES = ["draft", "published", "pinned"]
API_URL = "http://something.com"
```

### En pratique

Dans la pratique, en Ruby, les développeurs aiment encapsuler les logiques métier dans des classes et c'est dans ce contexte qu'on travaille le plus et que nous utilisons ces différents types de variables.

Voyons donc un exemple dans le contexte d'une classe. Ne vous inquiétez pas, nous aurons l’occasion de voir plus en détail le fonctionnement des classes dans les prochains épisodes :

```
class User
	MIN_AGE = 18
	MAX_AGE = 90

	@@count = 0

	def initialize(name)
		@name = name
		@@count += 1
	end

	def self.instances_count
		@@count
	end
end
```

Nous avons donc définie deux constantes, une variable de classe ainsi qu'une variable d'instance qui est initialisée dans le constructeur, la méthode `initialize`.

Cette classe contient deux méthodes, le constructeur qui permet de préparer l'objet lorsqu'on crée une instance et une méthode de classe qui sert ici à retourner le nombre d'instances qui ont été créées par cette classe.

Pour finir utilisons cette classe nouvellement crée :

```
User.new("nico")
User.new("martin")
User.new("jon")

User.instances_count
```

On a donc créé trois instances de la classes `User` et c'est bien ce que nous confirme l'appel à la méthode de classe `instances_count`.

### Conclusion

Vous connaissez maintenant les différents types de variables et d'identifieurs à votre disposition ce qui vous permettra de stocker correctement les informations dans votre programme en fonction de leur contexte.