# Processus de réalisation du screencast avec une machine virtuelle GNU/Linux

## Déroulé

- Écrire un script grossier
- Réaliser la vidéo en petites parties en parlant dessus et en utilisant
les outils de machine virtuelle présent dans ce dépôt
- Écrire le transcript précis de ce qui a été montré et dit
- Réaliser la piste audio en se basant sur le transcript

Nous nous occupons du montage.

## Utiliser une machine virtuelle

Vous avez trois configurations possibles actuellement:

- Utiliser un client GNU/Linux (ubuntu) sur un hôte GNU/Linux
- Utiliser un client GNU/Linux (ubuntu) sur un hôte Mac OS X
- Utiliser un client Mac OS X sur un hôte GNU/Linux

Les instructions se trouvent dans les fichiers `doc/use-linux-guest.md` et
`doc/use-osx-guest.md`.

## Humain

- S'assurer qu'on ne sera pas dérangé
- Bien articuler
- Limiter les bruits de bouche
- Couper son téléphone
- Couper les notifications
- Couper le son de l'ordinateur

## Capture vidéo

- Résolution 1280 x 720
- Conteneur MOV ou MP4
- Codec H264
-- Compression la moins destructrice possible
-- Pas de lossless H264 (option de FFMPEG / x264) : incompatible avec les logiciels de montage OSX

## Présentation du contenu en vidéo

- il faut de l'air autour de la zone de contenu, sinon le texte est trop proche des bords de l'écran, non lisible et avec certains lecteurs même croppé.
- il faut capturer dans une résolution standard pour le montage : 1280x720 est le plus simple, 1920x1080 est le plus qualitatif ; entre les deux on aura des problèmes de netteté ou de ratio d'aspect
- utiliser des polices assez grandes et grasses pour que ça reste lisible sur mobile (16pt en 1280x720 est un minimum)
- tout taper au clavier et utiliser le moins choses invisibles possibles / magie de l'éditeur ou du terminal possibles = copier coller "chruby" après l'avoir sélectionné, des gens ne vont pas capter comment c'est arrivé là ou que l'on peut juste taper. je sais c'est bête mais ...
- simplifier les commandes "mkdir -p" c'est pas connu de tous et je pense que cat "texte" >> sous-repertoire/fichier encore beaucoup moins :-(
- avoir un comportement constant : par moment "allons dans le répertoire et vérifions ceci" et à d'autres moments ce qui se passe (doit se passer) est simplement cité, il faut une position plus "constante" je pense du narrateur par rapport aux actions.

## Capture audio

- Utiliser Audacity pour produire des fichiers audio séparés du fichier vidéo (permet de re-capturer ensuite et remplacer les fichiers audio imparfaits)
- Capturer en 48 kHz 16 bits mono, sauvegarder les fichiers en WAV, AIFF ou FLAC

### Prise de son

- Décaler le micro (prise de son sur le côté de la bouche pour éviter les bruits d'air)
- Placer le micro très près de la bouche, 2 ou 3 cm, pour limiter la perception de l'écho de la pièce
- Les bruits de bouche sont très bien capturés : essayer de parler après avoir bien dégluti et de bien articuler pour limiter ça
- Les clics de souris et pression sur le clavier le son aussi : mettre le micro très près de la bouche et le régler en mode directif plutôt qu'omnidirectionnel pour ne pas capter "l'ambiance"
- Les bruits mécaniques sont transmis au microphone par son pied : taper sur un clavier = bureau vibre = pied vibre = micro vibre. Idéalement le micro est sur un support amortissant les chocs, sinon sur un support indépendant du bureau. Idéalement on enregistre la voix sans aucune autre source de bruit, vibration.

### Commentaire audio

- plutôt dire "c'est que je fais" pour le commentaire audio soit ce qui se passe à l'écran, au lieu de "c'est ce que je vais faire"

## Montage

### Pre-processing avec Audacity

- conversion mono http://cl.ly/image/1d0l0M193i1O
- réduction de bruit http://cl.ly/image/3g203f1a472Q : sélectionner la zone de silence, analyser, sélectionner tout le reste, appliquer la réduction (paramètres standards)
- compression 2:1 http://cl.ly/image/0G1A1q1O1G43 et http://cl.ly/image/35271n1b3N25
- normalize http://cl.ly/image/0g132f0j3r2G
- exportation FLAC vers AIFF http://cl.ly/image/0x1u181v2U0F

### Pre-processing vidéo

- Si la source n'est pas en MP4 H264 ou MOV H264, effectuer un transcodage MP4/H264 10Mbps (le moins de perte possible) ratio de dimensions 1 (pas de resize) pour permettre l'édition


### Edition

- réutiliser le template de projet (intro son/logo + titre)
- changer le titre de l'intro
- importer les pistes vidéo et audio dans le projet
- crop, crop, crop : pour chaque phrase/segment, on scinde la vidéo puis on élague avant/après, et ensuite on fait de même pour l'audio, ça évite les décalages/pertes de temps au montage

## Diffusion du contenu

### Pré-requis

On installe FFMPEG sous OSX avec la libvpx (encodage WebM) :

    brew install ffmpeg --with-libvpx --with-libvorbis --with-fdk-aac --with-theora

### Master

- Générer un master
-- Vidéo 1280 x 720 pixels 25 fps, très peu compressée (débit élevé ~ 10 à 20 mbps)
-- Audio en PCM 48 kHz 16 bits mono
- Utiliser les scripts de compression pour générer 3 vidéos à partir du master

FFMPEG a besoin des flags suivants pour obtenir cela :

    -ac 1

Conversion en mono (ac pour "Audio Channels")

    -ar 48000

Conversion en 48 kHz (ar = "Audio Rate")

### Version MP4

- Vidéo H264, complexité faible (compatibilité web / smartphone / tablettes), VBR qualité constante (crf = 25)
- Audio AAC, VBR à qualité constante, sinon 64kbits ABR

    ffmpeg -i input.mp4 -codec:v libx264 -preset:v slow -crf:v 22 -profile:v baseline -level 3.0 -movflags +faststart -ac 2 -c:a libfdk_aac -vbr 3 -ar 48000 output.mp4

### Version OGM

- Vidéo WebM (VP8 = codec VP80), VBR qualité constante
- Audio OGG Vorbis, VBR qualité constante

    ffmpeg -i input.mp4 -codec:v libtheora -codec:a libvorbis -qscale:v 7 -qscale:a 5 -ac 1 -ar 48000 output.ogv

### Version WebM (Chrome / Firefox)

- Vidéo Theora Video, VBR qualité constante
- Audio OGG Vorbis, VBR qualité consatnte

    ffmpeg -i input.mp4 -codec:v libvpx -threads 4 -codec:a libvorbis -qmin 0 -qmax 50 -crf 10 -b:v 1M -quality good -cpu-used 0 -ac 1 -ar 48000 output.webm
