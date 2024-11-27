
NOTES PERSO A NE PAS SUPPRIMER POUR L INSTANT ! 

les parametres quon doit mettre ;
chemin du fichier (obligatoire)
type de station (hvb , hva , lv ) (obligatoire)
type de conso (comp , indiv , all ) (obligatoire) 
ATTENTION : pas de hvb all, hvb indiv, hva all, hva indiv
identifiant de centrale (attention spécial)
option daide help 


à faire : (voir OU mettre ça) pour le temps 
récup le temps dexecution en utilisant : 
start_time = (date + %s) pour recup en secondes le temps 
end_time = same
puis : durée = end minus start 



comment envoyer entre programme c et le shell aller retour...  : cut .. < > 
puis pour recupérer : ok normalement < > voir cut tout ca -> simple efficace


normalement :  OK
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


dans tests : juste un test comme le projet l explique : un fichier texte quoi hva indiv ou autre 
on nomera le truc < hva_indiv.txt par exemple 

on fera trois cas du coup ? hva , hvb et lv 
avec des sous cas ..? pour all indiv etc et des cut.. à voir



QUESTIONS 
demander au prof par rapport au check du fichier csv ou de son nom...




#!/bin/bash

# Description : this shell script will allow us to sort a csv file using program c 

# Function to display the help
help() {
    echo -e "...................................HELP............................................\n"
    echo -e "\n\nHow to use: $0 <file_path> <type_station> <type_consumer> [centrale_id]"
    echo
    echo "The various options :"
    echo "  file_path            : Path to the csv file (obligatory)" // ici voir comment lécrire
    echo "  type_station         : Type of station to process. Possible values : hvb, hva, lv (obligatory)"
    echo "  type_consumer        : Type of consumer to process. Possible values : comp, indiv, all (obligatory)"
    echo "  centrale_id          : Id of the centrale (option) : between 1 and 5 included." // attention à ça 
    echo "  -h                   : Display this help."
    echo -e "\n \nMore explanations :"
    echo "  hvb ; hva ; lv : are for a station (HV-B station, HV-A station, LV post)" // ici anglais à voir
    echo -e "\n  comp : to get companies' consumption of energy under the station selected. \n  indiv : to get individuals' consumption of energy under the station selected. \n  all : to get everyone's consumption of energy (individuals + companies) under the station selected.\n\n"
    echo -e "\nExample : $0 <file_path> -hvb -comp 2\n\n"
    echo "Warnings :"
    echo "1) The options that follow are prohibited : "
    echo "     hvb all ; hvb indiv ; hva all ; hva indiv"
    echo "2) Be sure that your file exists and that it is a csv one ! (with the extension csv)"
    echo
    echo "If you use -h, regardless of other option(s), the help will be displayed."
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
    help
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
    help
    exit 3
elif [ "$file_path" != *.csv ]
    then
    echo -e "Error : the file isn't a csv file. Please check and try again."
    help
    exit 4
fi

ICI VOIR SI JE DOIS CHECK L EXTENSION OU LE NOM COMPLET... JSP

# Check if the file is a CSV and named 'DATA_CWIRE.csv'
if [ "$file_path" != */DATA_CWIRE.csv ]; then
    echo "Error: The file must be named 'DATA_CWIRE.csv'."
    exit 4
fi





# Cheching the options : type of station, type of consumer, id of a centrale... 
# Checking the type of station (-hvb or -hva or -lv) first :
if [ "$type_station" != "hvb" && "$type_station" != "hva" && "$type_station" != "lv" ]; 
then
    echo "Error : the type of station '$type_station' is invalid. Possible values : hvb, hva, lv."
    help
    exit 5
fi


# Checking the type of consumer :
if [ "$type_consommateur" != "comp" && "$type_consommateur" != "indiv" && "$type_consommateur" != "all" ];  
then
    echo "Error : the type of consumer '$type_consommateur' is invalid. Possible values : comp, indiv, all."
    help
    exit 6
fi


# Checking the existence of the option centrale_id (because it's optionnal); as we know there are just 5 centrales, we check it therefore :
if [ ! -z "$centrale_id" ]; # if the argument exist (argument != void) // voir ici 
then
    if [[ ! "$centrale_id" =~ ^[0-9]+$ ]]; then
        echo "Error : The centrale's id must be a whole number between 1 and 5."
        help
        exit 9
    fi
# if the id is below 1 or above 5 : error
    elif [ "$centrale_id" -lt 1 ] || [ "$centrale_id" -gt 5 ]; 
        then
        echo "Error : The centrale's id must be between 1 and 5 (included)."
        help
        exit 10
    fi
fi

# Checking restrictions on certain parameter combinations (like hvb all)
# With hvb station :
if [ "$type_station" == "hvb" && ( "$type_consommateur" == "all" || "$type_consommateur" == "indiv" ) ]; 
then
    echo "Error : the combinations 'hvb all' and 'hvb indiv' are prohibited."
    help
    exit 7
fi

# With hva station 
if [ "$type_station" == "hva" && ( "$type_consommateur" == "all" || "$type_consommateur" == "indiv" ) ]; 
then
    echo "Error : the combinations 'hva all' and 'hva indiv' are prohibited."
    help
    exit 8
fi



# After checking everything related to the options, we start to get interested in the executable and the prog c... 
# We store the name of the expected executable (defined in our makefile) 
EXECUTABLE="prog"

# Check if the executable file exists
if [ ! -f "$EXECUTABLE" ]; then # if not, we start the compilation...
    # Run the compilation using make
    if ! make; then # if the output of make isn't 0, the compilation failed
        echo "Error: Compilation failed. Please try again."
        exit 9
    fi
    
    # Check if the executable was generated after compilation
    if [ ! -f "$EXECUTABLE" ]; then
        echo "Error: The executable '$EXECUTABLE' was not generated after compilation. Please try again."
        exit 10
    fi
fi




// voir ou je dois mettre cette ligne... en vrai ici ca fait pas de mal 
# Replace all '-' with '0' in the file (we use a temporary file in /tmp to avoid overwriting the csv file)
tr '-' '0' < "$file_path" > /tmp/temp.csv && mv /tmp/temp.csv "$file_path"


if [ "$type_station" == hvb && "$type_consumer" == "comp" ]; then 
    cut -d';' -f2,-1 "$file_path" | ./prog > /output/hvb_comp.txt # remplacer avec les colonnes qui nous intéressent... 
-> envoie au prog c les lignes et colonnes qui nous interessent, execute le prog c (donc partie ou on devra 
faire tout ce qui est conso, avl tout ca en fonction des id, puis ecris sa sortie dans data.txt creer dans output 
-> refaire ça pour tous les cas... 
-> voir les cas particuliers après (avec les lv notamment)


ici sert pas normalement mais voir : (
# We execute the program with the arguments passed to the script
./"$EXECUTABLE" "$@" // on rentre dans le programme c du coup ici ... ? voir quoi faire après )


if hva indiv ... 
cut ... ? faire un fichier avec les trucs intéréssants...
puis envoyer vers le programme c pour qu il lise et prenne ce qui est intéressant directement 
et fait donc la somme des conso (regarder photo... tout passe par le cut et les sorties > < )



# Continuer avec les opérations sur les données (par exemple, traitement du fichier de données)
# ./votre_programme $chemin_fichier_donnees $type_station $type_consommateur $identifiant_centrale






