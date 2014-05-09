# Les nouveautés de Rails 4.1

## Spring

Rails 4.1 apporte beaucoup de nouveautés permettant de gagner du temps lors du développement. Parmi celles ci on trouve Spring qui accélère grandement le lancement des commandes telles que "rails" ou "rake".

Spring fonctionne avec Rails 3.2, 4.0 et est intégré à Rails 4.1. Pour l'utiliser, ajouter dan votre Gemfile la ligne

    gem "spring", group: :development
    
Ensuite, au lieu de taper "rails" ou "rake" suivi une commande, tapez "spring rails" ou "spring rake". Par exemple, pour lancer la console on va taper :

    spring rails console

Quand vous aurez terminé et quitté la console, Spring va conserver l'application en mémoire.
La prochaine fois que vous lancerez la console, elle se chargera quasiment instantanément :

    spring rails console

C'est aussi valable pour toutes les autres commandes rails, comme les générateurs.
Par exemple, générer un modèle est quasiment instantané :

    spring rails generate model Post title:string body:text

Mais on peut aussi l'utiliser pour les commandes "rake" qui sont généralement longues à lancer :

    spring rake about
    spring rake stats

C'est très pratique pour gagner de précieuses secondes au lancement des tests, par exemple. Plus votre application est riche en modèles, contrôleurs et utilise de gem, plus le gain sera important. Dans une autre vidéo nous vous montrerons comment utiliser Spring avec Guard pour exécuter des tests spécifiques extrêmement rapidement sans avoir quasiment de délai d'attente.

## Contrôler Spring

Vous pouvez afficher l'état actuel de spring avec la commande :

    spring status

On voit que l'application est bien chargée en mémoire. Il est possible de l'arrêter avec la commande :

    spring stop

Tout comme Rails, Spring détecte les changements dans votre code (modèle, contrôleurs, etc.) et recharge automatiquement les modifications. Vous ne devriez pas avoir besoin d'arrêter et relancer spring, sauf en cas de comportement erratique de votre application. 

Si vous avez modifié des fichiers d'initialisation dans /config ou mis à jour votre Gemfile, Spring rechargera l'application automatiquement.

Vous pouvez ajouter un fichier config/spring.rb contenant la liste d'autres fichiers à surveiller pour déclencher un rechargement de l'application. Par exemple un fichier de configuration YAMLspécifique, avec la commande :

    Spring.watch "config/my_variables.yml"

## Automatiser l'utilisation de Spring

Taper "spring" avant chaque commande est fastidieux. Pour gagner du temps on va utiliser de petits scripts baptisés "binstubs" qui vont automatiquement lancer spring quand vous tapez "rake" ou "rails". On demande à Spring de les créer avec la commande :

    bundle exec spring binstub --all

Dans le répertoire /bin de notre application, on retrouve deux scripts "rails" et "rake".

Pour que notre interpréteur (le shell, Bash ou ZSH par exemple), sache qu'il doit utiliser en priorité ces scripts, il faut placer "./bin" en première position dans notre PATH, le chemin de recherche pour l'execution.

	export PATH="./bin:$PATH"

Pour que cela soit permanent, on ajoute cette commande dans le fichier .bash_profile ou .zshrc à la racine de votre compte :

	echo "export PATH=./bin:$PATH" >> .bash_profile

Si vous souhaitez n'utiliser ce comportement que pour un répertoire ou une application donnée, vous pouvez utiliser "direnv" et définir un PATH différent.