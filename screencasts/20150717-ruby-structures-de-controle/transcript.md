Bienvenue dans cette vidéo consacrée à la découverte des structures de contrôle en Ruby.

Comme à l'habitude, assurez vous que vous possédez une version récente de Ruby, nous utilisons ici la 2.2.

Nous allons utiliser la console interactive IRB pour faire la démonstration de l'utilisation des structures de contrôle.

### Les classiques

Voyons tout d'abord les structures classiques.

Comme vous pouvez vous en douter, il existe en Ruby le mot-clé `if` qui permet de créer une branche conditionnelle dans le code.

On peut donc écrire des choses comme :

```
if 1 == 1
	puts "OK"
end
```

On utilise dans cet exemple le double égal pour comparer deux valeurs entre elles. Si les valeurs sont égales, on utilise la méthode `puts` qui va nous permettre d'afficher une chaîne. On clôt notre condition avec le mot-clé `end`.

On peut aussi créer des conditions à deux branches qui permettent de couvrir le cas où les valeurs sont égales mais aussi le cas où elles ne le sont pas. Pour ce faire, on utilise le mot-clé `else` en coordination avec le mot-clé `if` :

```
if 1 > 2
	puts "1 est plus grand que 2"
else
	puts "1 est plus petit que 2"
end
```

Si la condition n'est pas égale à `true` alors on passera dans la branche `else` ce qui est le cas dans notre exemple.

On utilise ici le chevron pour vérifier si la valeur de gauche est plus grande que la valeur de droite.

Pour aller plus loin, on peut encore ajouter des branches à notre condition grâce au mot-clé `elsif`. C'est un cas plus rare mais c'est une possibilité du langage. On peut donc écrire des conditions du type :

```
if false
	puts "faux"
elsif true
	puts "vrai"
else
	puts "autre"
end
```

C'est donc la branche `elsif` qui remplie la condition et on affiche "vrai".

### Utilisation de `unless`

Très souvent on a besoin d'inverser une condition, on peut donc utiliser le mot-clé `if` avec un point d'exclamation devant la condition pour l'inverser :

```
if !false
	puts "OK"
end
```

mais il existe un idiome en Ruby pour exprimer cette condition inversée, c'est le mot clé `unless`. On peut donc ré-écrire notre condition de la façon suivante :

```
unless false
	puts "OK"
end
```

On gagne donc en lisibilité et les intentions sont plus claires.

### Les conditions post-fixées

Dans bien des cas, on souhaite écrire une condition qui ne va concerner qu'une seule ligne de code. En Ruby, plutôt que d'ouvrir un bloc conditionnel pour une seule ligne, on peut utiliser des conditions post-fixées.

Elles consistent à être placées directement après la ligne de code concernée et sont une fois encore un moyen d'améliorer la lisibilité du code :

```
puts "Ok" if true
```

On peut également utiliser le `unless` en version post-fixée :

```
puts "Ok" unless false
```

### Cas complexes

Pour les cas plus complexes, on utilisera souvent la structure de contrôle `case` qui dans d'autres langages s'exprime avec le mot-clé `switch`.

En Ruby cette structure de contrôle est bien plus puissante. Elle ne se cantonne pas à vérifier une égalité simple pour chaque branche, elle permet d'embarquer des conditions évoluées :

```
case "Ceci est une chaîne"
when "foo"
	puts "Branche 1"
when 1..10
	puts "Branche 2"
when /une/
	puts "Branche 3"
else
	puts "Branche 4"
end
```

Quand on exécute ce code, c'est la branche 3 qui ressort. Pourquoi ?

La première branche permet de vérifier si la valeur testée est égale à la chaîne "foo".

La deuxième vérifie si cette valeur est un entier compris entre 1 et 10. C'est un `Range`, une classe livrée avec Ruby que nous découvrirons par la suite.

La troisième branche compare la valeur à l'expression rationnelle `/une/` délimitée par les slashs. Notre valeur contient bien la sous-chaîne "une" c'est pourquoi la branche 3 ressort.

La branche `else` est le cas par défaut qui est appelé si aucune des conditions précédentes n'a été satisfaite. Cette branche est facultative.

### Conclusion

Vous avez donc maintenant les bases pour mettre en place des structures de contrôle dans votre code Ruby. Ces structures constituent la base d'un programme et vous seront utiles au quotidien.