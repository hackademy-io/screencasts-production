Bienvenue dans cette vidéo consacrée à la programmation réseau en Ruby.

Dans de nombreux projets, on souhaite pouvoir faire communiquer plusieurs programmes entre eux à travers le réseau. On peut vouloir écrire un client pour communiquer avec un service existant. On peut aussi vouloir créer un serveur qui fournira des services à des clients externes (chat, jeu, ferme de calcul, peer to peer, etc). Finalement on voudra parfois écrire le client et le serveur.

Voyons donc quelques exemples de cas concrets pour vous permettre d'appréhender ce qu'il est possible de faire.

## Écrire un serveur ##

Un serveur passe son temps à attendre l'arrivée d'une requête pour renvoyer une réponse. Ce qu'il fait entre deux peut être divers et varié. Ça peut être un traitement très simple ou des opérations très lourdes.

Pour ce faire le serveur pourra ne répondre qu'à une réponse à la fois ce qui est le plus simple à programmer. Il pourra aussi utiliser des threads pour être capable de répondre à plusieurs clients en simultané.

### Cas simple ###

Commençons avec quelque chose de très simple, un serveur de temps dont le but sera simplement de renvoyer l'heure courante au client.

La version simple, sans thread, et qui donc ne pourra répondre qu'à un client à la fois pourrait ressembler à ça :

```ruby
require "socket"

server = TCPServer.new(4567)

loop do
  client = server.accept
  client.puts Time.now
  client.close
end
```

On voit donc qu'on charge la librairie `socket` pour pouvoir écrire facilement notre serveur. Puis on crée une instance d'un serveur TCP sur le port 4567.

On implémente finalement la logique de notre serveur qui consiste à écouter en boucle les connexions entrantes. Lorsqu'une connexion est détectée, on y envoie une chaîne qui correspond à l'heure courante sur le serveur. Pour finir, on ferme la connexion avec le client.

On peut maintenant tester notre serveur :

```bash
$ ruby time_server.rb
```

Un simple appel à telnet suffirait à effectuer le test :

```bash
$ telnet localhost 4567
```

### Serveur multi-threads ###

C'est satisfaisant mais pour avoir un serveur réellement utilisable, il faudrait qu'il puisse pouvoir répondre à plusieurs requêtes en simultané. Modifions donc notre code :

```ruby
require "socket"

server = TCPServer.new(4567)

loop do
  Thread.start(server.accept) do |client|
    client.puts Time.now
    client.close
  end
end
```

On a donc simplement enrobé notre logique de réponse dans un thread ce qui suffit à ne pas bloquer la boucle principale lorsqu'on répond à un client.

Une fois encore on peut tester notre serveur avec telnet :

```bash
$ ruby threaded_time_server.rb
$ telnet localhost 4567
```

## Écrire un client ##

### Un client pour notre serveur de temps ###

Pour le plaisir, on pourrait aussi écrire le client plutôt que de passer par telnet :

```ruby
require "socket"

HOST = ARGV[0] || "localhost"

session = TCPSocket.new(HOST, 4567)
puts session.gets
session.close
```

Une fois encore on charge la librairie `socket` pour nous faciliter la tâche.

On définie ensuite une constante qui sera remplie avec le premier argument fourni lors de l'appel de notre client ou "localhost" si aucun argument n'est passé.

On ouvre une connexion sur le serveur, puis on lui demande de nous envoyer du contenu qu'on affiche en local par la même occasion.

Finalement, on clos la connexion.

Difficile de faire plus simple !

### Un client de nombres aléatoires ###

On a parfois besoin de générer des nombres aléatoires. Comme vous le savez sûrement, les librairies de génération de nombres aléatoires sont souvent pseudo-aléatoire. Dans certaines situation vous voudrez pouvoir générer des nombres réellement aléatoires et non-prédictibles. Il existe des services en ligne pour faire ça et notamment random.org qui est un service qui utilise le bruit atmosphérique pour générer des nombres aléatoires.

Créons un client qui nous permet de simuler un jet de 5 dès qui pourrait servir de base pour un jeu de hasard :

```ruby
require "net/http"
require "openssl"

uri = URI.parse("https://www.random.org/integers/?num=5&min=1&max=6&col=1&base=10&format=plain")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

resp = http.get(uri.request_uri)

puts resp.body if resp.is_a?(Net::HTTPSuccess)
```

On a donc chargé les librairies `net/http` pour ouvrir un connexion HTTP et `openssl` pour pouvoir accéder à une URL en HTTPS, ce qui est le cas du service que nous voulons utiliser.

On parse notre URL pour obtenir un objet URI plus pratique à manipuler. Dans notre URL, on voit qu'on demande 5 entiers, compris entre 1 et 6, affichés avec un résultat par ligne. Les nombres attendus devront être en base 10, rendus au format texte.

On crée ensuite un objet `Net::HTTP` auquel on passe en paramètre l'hôte et le port à contacter. On autorise ensuite l'utilisation de SSL.

On lance ensuite une requête en GET sur notre URI puis on vérifie si la réponse a été un succès. Si c'est le cas, on peut afficher nos résultats.

```bash
ruby random_numbers.rb
```

Alors biensûr, on peut faire plus simple et plus concis en Ruby grâce à la librairie `open-uri` mais ça aurait été moins drôle et instructif :

```ruby
require "open-uri"

puts open("https://www.random.org/integers/?num=5&min=1&max=6&col=1&base=10&format=plain").read
```

```bash
ruby random_numbers_2.rb
```

## Conclusion ##

Nous avons donc vu ici les bases des accès réseaux tout d'abord avec des sockets TCP puis ensuite un peu plus spécialisé avec `net/http`. Il y a encore beaucoup à dire sur le sujet, on aurait pu par exemple écrire un client pour un vrai serveur de temps en utilisant `net/telnet`, ou encore accéder à un serveur IMAP avec `net/imap` puis discuter avec un serveur SMTP pour envoyer des emails via `net/smtp`. On pourrait imaginer monter un pont entre un canal d'un serveur IRC et un newsgroup, les possibilités sont infinies.

Ce qu'il faudra retenir c'est que vous avez à disposition les outils bas niveau pour créer vos propres protocoles client / serveur mais que si vous souhaitez utiliser un protocole établi, alors Ruby met certainement déjà à votre disposition un lib pour vous faciliter le travail. Si ce n'est pas le cas, vous trouverez sans aucun doute un gem qui le fait.
