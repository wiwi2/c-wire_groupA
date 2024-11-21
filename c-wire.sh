#!/bin/bash 
#à continuer....
#pour l'instant juste pour verifier l'entrée du fichier en parametre


#--> on va utiliser des arguments à envoyer vers le programme c pour les mettre en lien 


# Vérifier si un argument (le chemin du fichier) a été fourni
if [ $# -eq 0 ]; then
    echo "Erreur : Aucun fichier n'a été spécifié en paramètre."
    exit 1
fi

# Vérifier si le fichier existe
if [ ! -f "$1" ]; then
    echo "Erreur : Le fichier '$1' n'existe pas."
    exit 1
fi

# Si tout est bon, afficher un message de confirmation
echo "Le fichier '$1' existe et est prêt à être utilisé."



./programme.c --> on appelle un fichier c pour qu'il soit exécuté puis on récupère sa sortie ?
--> cat output.txt / par exemple, ça va je sais plus à voir...
-> mais ca c'est si on ecrit avec le programme c... à faire pour la somme des conso ? je sais pas... 
voir ca probleme de logique 
