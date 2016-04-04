# Gestion du canvas

La gestion du canvas va être une partie très utile étant donné que c'est la partie qui va nous servir de moniteur au moment du montage.

Si je déplace une vidéo sur la timeline, on voit que le canvas affiche la vidéo à l'instant `T` défini par le curseur. On peut le vérifier simplement, en faisant bouger le curseur.

Le canvas est aussi une partie qui va nous permettre de déterminer la taille de sortie de notre vidéo, pour cela un simple clic droit à côté de notre canvas va nous permettre d'ajuster la taille du canvas avec `adjust canvas`.

On a alors la possibilité de sélectionner un `preset`c'est-à-dire une taille d'écran prédéfinie, ou alors de la déterminer nous-même, ici je souhaite une vidéo en `1300x800`.

La zone de canvas s'ajuste alors, on aura aussi la possibilité de garder une proportionnalité entre largeur et hauteur en cochant la checkbox.

Enfin si je décide que mon canvas sera plus grand que ma vidéo je peux souhaiter appliquer une couleur de fond qui est par défaut le noir. Je lui applique ici un violet pour bien voir la différence.

Autre possibilité intéressante, celle de recadrer notre vidéo à l'aide de la fonctionnalité de `crop`.  

Enfin vous avez peut-être remarqué que je peux zoomer et dézoomer sur mon canvas soit avec les commandes `⌘ +` et `⌘ -`, soit en utilisant la liste en surbrillance.

## Propriétés des vidéos

Il arrive parfois de devoir superposé des vidéos, pour cela le sous menu `arrange` va nous permettre de gérer l'empilement de nos vidéos. 
Ici je fais une copie de ma vidéo, je me retrouve avec deux vidéos superposées. Je vais maintenant souhaiter inverser l'ordre d'empilement en faisant un clic droit puis `arrange` et `move to front` sur la vidéo que je souhaite voir au premier plan.

Je réduis ensuite ma fenêtre pour voir un autre aspect intéressant. On se retrouve avec deux vidéos de taille et d'emplacement différent. Si je fais un clic droit sur une des vidéos et que je fais `copy properties`, j'ai la possibilité d'appliquer ces propriétés à mon autre vidéo qui adoptera la taille et l'emplacement de la première.