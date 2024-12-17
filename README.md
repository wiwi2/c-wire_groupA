#groupeA-MEF2

## Utilisation 
      Après avoir vérifié que vous avez les droits sur le script '.sh", vous pouvez lancer le programme avec : 
      ./c-wire.sh [chemin vers le fichier .csv] [station] [consommateur] [identifiant de centrale] 

      Pour plus de détails sur les paramètres, regarder 'Traitement (objectifs) ou afficher l'aide avec -h. 

## Idée du projet
      Ce projet a pour but de gérer un fichier '.csv' et de le trier en fonction des désirs de l'utilisateur. 
      Celui-ci utilise une partie shell pour trier des données, et une partie c pour calculer une partie de ces données. 

## Traitements (objectifs)
      1) Stations 
            hvb : tri en fonction des stations HVB 
            hva : tri en fonction des stations HVA 
            lv  : tri en fonction des postes LV 
      2) Consommateurs
            indiv : tri par rapport aux particuliers sous la station choisie. 
            comp  : tri par rapport aux entreprises sous la station choisie. 
            all   : tri par rapport tous types de consommateurs sous la station choisie (entreprises et particuliers). 
      3) Autres 
            -h : affiche l'aide. 
                  N.B : peu importe la position de ce paramètre, l'aide sera affichée. 
      4) Optionnel
            identifiant d'une centrale : à ajouter après le choix de la station et du consommateur ; tri en fonction de la centrale choisie en plus de la station et du consommateur. 
            

## Composantes du projet
      Le projet se compose de 6 dossiers : 
            - codeC  : Celui-ci regroupe tout ce qui est nécéssaire au fonctionnement de la partie c du projet (i.e : fonctions, strucutres, main, makefile...) 
            - graphs : Celui-ci est vide avant execution. On y retrouvera un graphique lorsque l'utilisateur demande un tri avec les paramètres 'lv all' ou 'lv all [id_centrale]'. 
            - input  : Celui-ci est vide et ne sert qu'à ranger le fichier '.csv' à trier à l'intérieur. Fondamentalement, celui-ci n'est pas nécéssaire au fonctionnement. 
            - output : Comme son nom l'indique, c'est le dossier dans lequel on retrouve les fichiers de sorties après execution du programme. 
            - tests  : Celui-ci a plusieurs exemples de résultats après execution du programme dont un exemple de graphique (pour les paramètres lv all). (Ces exemples sont commentés dans le document pdf disponible). 
            - tmp    : Celui-ci regroupera tous les fichiers temporaires nécessaires au fonctionnement du programme (i.e : main.o, function.o, autres fichiers générés lors de l'execution...)

      N.B : si le dossier graphs, input, output ou tmp n'existe pas, le programme va se charger de les créer dans tous les cas. 

## Utilisation - remarques

      1) Si le dossier graphs, input, output ou tmp n'existe pas, le programme va se charger de les créer dans tous les cas dès que l'utilisateur lance le programme pour la première fois. 
      2) A chaque nouveau traitement, les fichiers générés temporairement sont placés dans tmp. A chaque nouveau traitement, tmp est vidé. De leur côté, les graphiques (placés dans graphs) seront toujours disponibles dans le dossier dédié. 


## Guide des commandes 
      A partir du terminal, pour compiler : 
          1) Se placer dans le dossier c-wire_groupA-main avec la commande 'cd c-wire_groupA-main' après avoir téléchargé l'ensemble des composantes du projet.
          2) Etre sûr d'avoir les droits nécéssaires sur le script shell... On vous invite donc à taper la commande suivante avant de vous lancer : 'chmod 777 c-wire.sh'
          3) On vous invite à commencer par écrire dans le terminal : ' ./c-wire.sh -h ' et de regarder l'aide qui apparaitra. Cela vous permettra de passer en revue tous les traitements possibles. 
          4) Enfin, vous pouvez simplement lancer le programme avec : ./c-wire.sh [chemin du fichier csv à traiter] [station] [consommateur] (identifiant de la centrale).   
                Rappel : l'identifiant de la centrale n'est qu'optionnel. 


## Construction du projet 
      Ce projet a été construit principalement sous linux (ordinateurs de CY tech) sur le logiciel gedit. Les principaux langages utilisés sont le c et le shell. 


## Auteures 
      Wiame Boudella (https://github.com/wiwi2)
      Sanem Sayed (https://github.com/snm-s)
      Sagana Srinivassane (https://github.com/sagana-21)







          
          


