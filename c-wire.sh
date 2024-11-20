#!/bin/bash // à continuer.... pour l'instant juste pour verifier l'entrée du fichier en parametre

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

