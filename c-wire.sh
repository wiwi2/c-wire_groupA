
NOTES PERSO A NE PAS SUPPRIMER POUR L INSTANT ! 

les parametres quon doit mettre ; ==> enlever les - !
chemin du fichier (obligatoire)
type de station (hvb , hva , lv ) (obligatoire)
type de conso (comp , indiv , all ) (obligatoire) 
ATTENTION : pas de hvb all, hvb indiv, hva all, hva indiv
identifiant de centrale (attention spécial)
option daide help 


à faire : (voir ou mettre ça) pour le temps 
récup le temps dexecution en utilisant : 
start_time = (date + %s) pour recup en secondes le temps 
end_time = same
puis : durée = end minus start 

à faire aussi 
ranger les exit dans lodre : ordre perdu à un moment 
ranger avec fonctions et main après setre rensegné auprès du prof     HERE on s'en fout


comment envoyer entre programme c et le shell aller retour...         HERE ok
make ok oui
puis pour recupérer ? pas trop capté ok normalement < > voir cut tout ca -> simple efficace

pour le fichier csv : ou le mettre ?? il est trop gros pour github... HERE pas mettre
et le chemin... fonctionne comme j ai fait ou ?? voir                 here normalement ok 



normalement : 
main : commence par help, 
puis verifie les arguments 
avant de passer au traitement 

quand cest clair >> passer au traitement du fichier 
cut ...
programme c...


programme c : main idea 
on rentre on scanf 
on traite avec avl 
puis on printf 
et on < > vers un fichier 

ou placer le fichier ? : le placer avec / dans output si on veut ; ou encore nimporte ou on sen fout 
tmp à vider a chaque fois ! (lire le projet)
input dossier : pas besoin du coup 

pas besoin de chmod cest le prof qui fait ca

grep  a use pour les lv pour trier par ligne entre comp et indiv du coup 
tr pour changer - en 0 pour faciliter le calcul des conso 


dans tests : juste un test comme le projet l'explique : un fichier texte quoi hva indiv ou autre 
on nomera le truc < hva_indiv.txt par exemple 
on fera trois cas du coup ? hva , hvb et lv 
avec des sous cas ..? pour all indiv etc et des cut.. à voir









#!/bin/bash

# Description : this shell script will allow us to sort a csv file using program c 

# Function to display the help
help() {
    echo "How to use: $0 <file_path> <type_station> <type_consumer> [centrale_id]"
    echo
    echo "The various options :"
    echo "  file_path            : Path to the csv file (obligatory)" // ici voir comment lécrire
    echo "  type_station         : Type of station to process. Possible values : -hvb, -hva, -lv (obligatory)"
    echo "  type_consumer        : Type of consumer to process. Possible values : -comp, -indiv, -all (obligatory)"
    echo "  centrale_id          : Id of the centrale (option)" // attention à ça 
    echo "  -h                   : Display this help."
    echo -e "\n \nMore explanations :"
    echo "-hvb ; -hva ; -lv : are for a station (HV-B station, HV-A station, LV post)" // ici anglais à voir
    echo -e "\n-comp : to get companies' consumption of energy. \n-indiv : to get individuals' consumption of energy. \n-all : to get everyone's consumption of energy (individuals + companies).\n\n"
    echo -e "Example : $0 <file_path> -hvb -comp 2\n\n"
    echo "Warning :"
    echo " The options that follow are prohibited : "
    echo "    -hvb -all, -hvb -indiv, -hva -all, -hva -indiv"
    echo
    echo "If you use -h, regardless of other option(s), the help will be displayed"
}

# if -h is encountered in the options, regardless of its position, the help will be displayed 
for arg in "$@"; do
    if [ "$arg" == "-h" ]
    then
        help
        exit 1
    fi
done

# Vérification que les paramètres sont passés
if [ "$#" -lt 3 ]; # -lt = less than ; to check how many options there are
    then
    echo "Error : some options are missing."
    echo "Reminder : ./prog /waytothefile.csv [typeofstation] [typeofconsumer]. Please try again." 
    exit 2
fi

# Recovery of the csv file and the options passed as argument
file_path="$1"
type_station="$2"
type_consumer="$3"
centrale_id="$4"

# Checking the path/existence of the file and if it's a csv file
if [ ! -f "$file_path" ] // pas sure pour le check 
    then 
    echo -e "Error : the file $file_path does not exist or the path is incorrect. \nPlease check its existence of the path to the file."
    exit 3
elif [ "$file_path" == *.csv ]
    then
    echo -e "Error : the file isn't a csv file. Please check and try again."
    exit 4
fi


# Cheching the options : type of station, type de consumer, id of a centrale... 
# Checking the type of station (-hvb or -hva or -lv)
if [[ "$type_station" != "-hvb" && "$type_station" != "-hva" && "$type_station" != "-lv" ]]; 
then
    echo "Error : the type of station '$type_station' is invalid. Possible values : -hvb, -hva, -lv."
    exit 2
fi


# Checking the type of consumer
if [[ "$type_consommateur" != "-comp" && "$type_consommateur" != "-indiv" && "$type_consommateur" != "-all" ]]; 
then
    echo "Error : the type of consumer '$type_consommateur' is invalid. Possible values : -comp, -indiv, -all."
    exit 3
fi


# Checking restrictions on certain parameter combinations
# With hvb station
if [[ "$type_station" == "-hvb" && ( "$type_consommateur" == "-all" || "$type_consommateur" == "-indiv" ) ]]; 
then
    echo "Error : the combinations '-hvb -all' and '-hvb -indiv' are prohibited."
    exit 4
fi

# With hva station 
if [[ "$type_station" == "-hva" && ( "$type_consommateur" == "-all" || "$type_consommateur" == "-indiv" ) ]]; 
then
    echo "Error : the combinations '-hva -all' and '-hva -indiv' are prohibited."
    exit 5
fi

# Checking the existence of the option centrale_id ; as we know there are just 5 centrales, we check it therefore
if [ ! -z "$centrale_id" ]; // si largument nest pas vide (car rappel : optionnel)
then
    if ! [[ "$centrale_id" =~ ^[0-9]+$ ]]; 
    then
        echo "Error : The centrale's id must be a whole number."
        exit 7
# if the id is below 1 or above 5 : error
    elif [ "$centrale_id" -lt 1 ] || [ "$centrale_id" -gt 5 ]; 
        then
        echo "Error : The centrale's id must be between 1 and 5 (included)."
        exit 8
    fi
fi







# Continuer avec les opérations sur les données (par exemple, traitement du fichier de données)
# ./votre_programme $chemin_fichier_donnees $type_station $type_consommateur $identifiant_centrale






