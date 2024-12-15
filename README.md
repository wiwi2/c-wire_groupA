#groupeA-MEF2

## Idée du projet
      Ce projet a pour but de gérer un fichier '.csv' et de le trier en fonction des désirs de l'utilisateur. 
      Celui-ci utilise une partie shell pour trier des données, et une partie c pour calculer une partie de ces données. 

## Composantes du projet
      Le projet se compose de 6 dossiers : 
            - codeC  : Celui-ci regroupe tout ce qui est nécéssaire au fonctionnement de la partie c du projet (i.e : fonctions, strucutres, main, makefile...) 
            - graphs : Celui-ci est vide avant execution. On y retrouvera un graphique lorsque l'utilisateur demande un tri avec les paramètres 'lv all' ou 'lv all [id_centrale]'. 
            - input  : Celui-ci est vide et ne sert qu'à ranger le fichier '.csv' à trier à l'intérieur. Fondamentalement, celui-ci n'est pas nécéssaire au fonctionnement. 
            - output : Comme son nom l'indique, c'est le dossier dans lequel on retrouve les fichiers de sorties après execution du programme. 
            - tests  : Celui-ci a un exemple de résultat après execution du programme. 
            - tmp    : Celui-ci regroupera tous les fichiers temporaires nécessaires au fonctionnement du programme (i.e : main.o, function.o, autres fichiers générés lors de l'execution... Il sera vider à chaque fois


## Guides des commandes 
      A partir du terminal, pour compiler : 
          1) Se placer dans le dossier groupA_MEF2 avec la commande 'cd groupA_MEF2' après avoir télécharger l'ensemble des composants du projet
          2) Etre sur d'avoir les droits nécéssaire sur le script shell... On vous invite donc à taper la commande suivante avant de vous lancer : 'chmod 777 c-wire.sh'
          3) On vous invite à commencer par écrire dans le terminal : ' ./c-wire.sh -h ' et de regarder l'aide qui apparaitra. Cela vous permettra de passer en revue tous les traitements possibles. 
          4) Enfin, vous pouvez simplement lancer le programme avec : ./c-wire.sh [chemin du fichier csv à traiter] [station] [consommateur] (identifiant de la centrale).   


          
          


