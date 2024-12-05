#!/bin/bash

# Description : this shell script will allow us to sort a csv file using program c 

# Function to display the help
help() {
    echo -e "...................................HELP............................................\n"
    echo -e "\n\nHow to use: $0 <file_path> <type_station> <type_consumer> [centrale_id]"
    echo
    echo "The various options :"
    echo "  file_path            : Path to the csv file. This option is obligatory." 
    echo "  type_station         : Type of station to process. Possible values : hvb, hva, lv. This option is obligatory."
    echo "  type_consumer        : Type of consumer to process. Possible values : comp, indiv, all. This option is obligatory."
    echo "  centrale_id          : Id of the centrale. There's only 5 centrales, so it has to be between 1 and 5 included. This option is optional : it will sort out the station chosen under the centrale given."
    echo "  -h                   : Display this help."
    echo -e "\n \nMore explanations :\n"
    echo "  hvb ; hva ; lv : Are for a station (HV-B station, HV-A station, LV post)" 
    echo -e "\n  comp : To get companies' consumption of energy under the station selected. \n  indiv : To get individuals' consumption of energy under the station selected. \n  all : To get everyone's consumption of energy (individuals + companies) under the station selected.\n"
    echo -e "\nExample : $0 <file_path> hvb comp 2\n\n"
    echo "Warnings :"
    echo "1) The following combination of parameters are prohibited and will generate an error : "
    echo "     hvb all ; hvb indiv ; hva all ; hva indiv"
    echo "2) Be sure that your file exists !"
    echo
    echo -e "If you use -h, regardless of other parameter(s), the help will be displayed.\n"
}

# Check if the "tmp" directory exists
if [[ -d "tmp" ]]; then
    # If it exists, we remove all files in "tmp" but keep the directory itself
    rm -rf tmp/*
else
    # If "tmp" doesn't exist, create it
    mkdir -p "tmp"
fi


# Check if the "graphs" directory exists, create it if not
if [[ ! -d "graphs" ]]; then
    mkdir -p "graphs"
fi


# Same thing with the "output" directory
if [[ ! -d "output" ]]; then
    mkdir -p "output"
fi


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


# Now we start by checking everything about the arguments...
# if -h is encountered in the options, regardless of its position, the help will be displayed 
start_time=$(date +%s)  # Plus we start the timer here... 
for arg in "$@"; do
    if [ "$arg" == "-h" ]
    then
    	echo -e "\nYou chose to display the help :\n"
        help
        execution_time="${execution_time:-0.0}"
        echo -e "\n--------------------------TIMER--------------------------"
        echo "          The prog ran ${execution_time} seconds."
        echo "---------------------------------------------------------"
        exit 1
    fi
done

# Vérification que les paramètres sont passés
if [ "$#" -lt 3 ]; # -lt = less than ; to check how many options there are
    then
    echo "Error : some options are missing."
    help
    execution_time="${execution_time:-0.0}"
        echo -e "\n--------------------------TIMER--------------------------"
        echo "          The prog ran ${execution_time} seconds."
        echo "---------------------------------------------------------"
        
    exit 2
fi

# Recovery of the csv file and the options passed as argument
file_path="$1"
type_station="$2"
type_consumer="$3"
centrale_id="$4"

# Checking the path/existence of the file and if it's a csv file
if [ ! -f "$1" ] ;
    then 
    echo -e "Error : the file $1 does not exist or the path is incorrect. \nPlease check its existence of the path to the file."
    help
    execution_time="${execution_time:-0.0}"
        echo -e "\n--------------------------TIMER--------------------------"
        echo "          The prog ran ${execution_time} seconds."
        echo "---------------------------------------------------------"
        
    exit 3
elif [ "$1" != *.csv ]
    then
    echo -e "Error : the file isn't a csv file. Please check and try again."
    help
    execution_time="${execution_time:-0.0}"
        echo -e "\n--------------------------TIMER--------------------------"
        echo "          The prog ran ${execution_time} seconds."
        echo "---------------------------------------------------------"
        
    exit 4
fi




# Cheching the options : type of station, type of consumer, id of a centrale... 
# Check if both parameters are invalid first :
if [[ "$2" != "hvb" ]] && [[ "$2" != "hva" ]] && [[ "$2" != "lv" ]] && \
   [[ "$3" != "comp" ]] && [[ "$3" != "indiv" ]] && [[ "$3" != "all" ]]; then
    echo "Error: the type of station '$2' is invalid, as well as the type of consumer '$3'."
    help
    execution_time="${execution_time:-0.0}"
    echo -e "\n--------------------------TIMER--------------------------"
    echo "          The prog ran ${execution_time} seconds."
    echo "---------------------------------------------------------"
    exit 5
fi


# Then checking the type of station (hvb or hva or lv) :
if [[ "$2" != "hvb" ]] && [[ "$2" != "hva" ]] && [[ "$2" != "lv" ]]; 
then
    echo "Error : the type of station '$2' is invalid. Possible values : hvb, hva, lv."
    help
    execution_time="${execution_time:-0.0}"
    echo -e "\n--------------------------TIMER--------------------------"
    echo "          The prog ran ${execution_time} seconds."
    echo "---------------------------------------------------------"
    exit 5
fi


# Then checking the type of consumer (comp or indiv or all) :
if [[ "$3" != "comp" ]] && [[ "$3" != "indiv" ]] && [[ "$3" != "all" ]];  
then
    echo "Error : the type of consumer '$3' is invalid. Possible values : comp, indiv, all."
    help
    execution_time="${execution_time:-0.0}"
    echo -e "\n--------------------------TIMER--------------------------"
    echo "          The prog ran ${execution_time} seconds."
    echo "---------------------------------------------------------"
    exit 6
fi


# Checking the existence of the option centrale_id (because it's optionnal); as we know there are just 5 centrales, we check it therefore :
if [ ! -z "$4" ]; then  # if the argument exist (argument != void) // voir ici
    if [[ ! "$4" =~ ^[0-9]+$ ]]; then
        echo "Error: The centrale's id must be a whole number between 1 and 5."
        help
        execution_time="${execution_time:-0.0}"
        echo -e "\n--------------------------TIMER--------------------------"
        echo "          The prog ran ${execution_time} seconds."
        echo "---------------------------------------------------------"
        exit 9
    fi
# if the id is below 1 or above 5 : error
    if [[ "$4" -lt 1 || "$4" -gt 5 ]]; then
        echo "Error: The centrale's id must be between 1 and 5 (inclusive)."
        help
        execution_time="${execution_time:-0.0}"
        echo -e "\n--------------------------TIMER--------------------------"
        echo "          The prog ran ${execution_time} seconds."
        echo "---------------------------------------------------------"
        exit 10
    fi
fi



# Checking restrictions on certain parameter combinations (like hvb all)
# With hvb station :
if [[ "$2" == "hvb" ]] && ( [[ "$3" == "all" ]] || [[ "$3" == "indiv" ]] ); 
then
    echo "Error : the combinations 'hvb all' and 'hvb indiv' are prohibited."
    help
    execution_time="${execution_time:-0.0}"
        echo -e "\n--------------------------TIMER--------------------------"
        echo "          The prog ran ${execution_time} seconds."
        echo "---------------------------------------------------------" 
    exit 7
fi

# With hva station 
if [[ "$2" == "hva" ]] && ( [[ "$3" == "all" ]] || [[ "$3" == "indiv" ]] ); 
then
    echo "Error : the combinations 'hva all' and 'hva indiv' are prohibited."
    help
    execution_time="${execution_time:-0.0}"
        echo -e "\n--------------------------TIMER--------------------------"
        echo "          The prog ran ${execution_time} seconds."
        echo "---------------------------------------------------------" 
    exit 8
fi


# Replace all '-' with '0' in the file (we use a temporary file in /tmp to avoid overwriting the csv file)
tr '-' '0' < "$1" > /tmp/temp.csv && mv /tmp/temp.csv "$1"





// ici switch case à faire, voir
// partie qui ne fonctionne pas

# cas hvb comp avec check que l'option centraleid existe ou non ... 
if [[ "$2" == "hvb" ]] && [[ "$2" == "comp" ]]; then 
    if [ ! -z "$4" ]; then
          cut -d ';' -f 1,2,5,7,8 "$1" | ./prog | sort -t ';' -k2 -n > "/output/hvb_comp_${4}.csv"
    fi
    else
         cut -d ';' -f 2,5,7,8 "$1" | ./prog | sort -t ';' -k2 -n > "/output/hvb_comp.csv"
    fi
fi

# cas hvb indiv avec check que l'option centraleid existe ou non ...
if [[ "$2" == "hvb" ]] && [[ "$3" == "indiv" ]]; then 
    if [[ ! -z "$4" ]]; then
        cut -d ';' -f 1,2,6,7,8 "$1" | ./prog | sort -t ';' -k2 -n > "/output/hvb_indiv_${4}.csv"
    fi
else
    cut -d ';' -f 2,6,7,8 "$1" | ./prog | sort -t ';' -k2 -n > "/output/hvb_indiv.csv"
fi


# cas hva comp avec check que l'option centraleid existe ou non ... 
if [[ "$2" == "hva" ]] && [[ "$3" == "comp" ]]; then 
    if  [[ ! -z "$4" ]]; then
        cut -d ';' -f 1,3,5,7,8 "$1" | ./prog | sort -t ';' -k2 -n > "/output/hva_comp_${4}.csv"
    fi
    else
         cut -d ';' -f 3,5,7,8 "$1" | ./prog | sort -t ';' -k2 -n > "/output/hva_comp.csv"
    fi
fi

# cas hva indiv avec check que l'option centraleid existe ou non ...
if [[ "$2" == "hva" ]] && [[ "$3" == "indiv" ]]; then 
   if  [[ ! -z "$4" ]]; then
        cut -d ';' -f 1,3,6,7,8 "$1" | ./prog | sort -t ';' -k2 -n > "/output/hva_indiv_${4}.csv"
   fi
   else
        cut -d ';' -f 3,6,7,8 "$1" | ./prog | sort -t ';' -k2 -n > "/output/hva_indiv.csv"
   fi
fi

# cas lv indiv avec check de l'option centraleid existe ou non ... ! attention 3 cas ou lv (comp, indiv, all ! + traitement supp pour all) 
if [[ "$2" == "lv" ]] && [[ "$3" == "comp" ]]; then 
    if  [[ ! -z "$4" ]]; then
        cut -d ';' -f 1,4,5,7,8 "$1" | ./prog | sort -t ';' -k2 -n > "/output/lv_comp_${4}.csv"
    fi
    else
        cut -d ';' -f 4,5,7,8 "$1" | ./prog | sort -t ';' -k2 -n > "/output/lv_comp.csv"
    fi
fi

# cas lv comp
if [[ "$2" == "lv" ]] && [[ "$3" == "indiv" ]]; then 
    if  [[ ! -z "$4" ]]; then
        cut -d ';' -f 1,4,6,7,8 "$1" | ./prog | sort -t ';' -k2 -n > "/output/lv_indiv_${4}.csv"
    fi
    else
        cut -d ';' -f 4,6,7,8 "$1" | ./prog | sort -t ';' -k2 -n > "/output/lv_indiv.csv"
    fi
fi


# Case for lv all
if [[ "$2" == "lv" ]] && [[ "$3" == "all" ]]; then
    if  [[ ! -z "$4" ]]; then
        cut -d ';' -f 1,4-8 "$1" | ./prog | sort -t ';' -k2 -n > "/output/lv_all_${4}.csv"

        # Extract and sort the 10 posts with the lowest consumption, then process line by line
        cut -d ';' -f 1,3,2 "/output/lv_all_${4}.csv" | sort -t ';' -k2 -n | head -n 10 | awk -F';' '{print $1, $2, $3, $2 - $3}' | sort -t ';' -k4 -nr > "/output/lv_all_minmax.csv"

        # Extract and sort the 10 posts with the highest consumption, then process line by line
        cut -d ';' -f 1,3,2 "/output/lv_all_${4}.csv" | sort -t ';' -k2 -n | tail -n 10 | awk -F';' '{print $1, $2, $3, $2 - $3}' | sort -t ';' -k4 -nr >> "/output/lv_all_minmax.csv"

        # Remove the last column (the difference column) in lv_all_minmax.csv
        cut -d ';' --complement -f 4 "/output/lv_all_minmax.csv" > "/output/lv_all_minmax_tmp.csv" && mv "/output/lv_all_minmax_tmp.csv" "/output/lv_all_minmax.csv"

    fi
else
    cut -d ';' -f 4-8 "$1" | ./prog | sort -t ';' -k2 -n > "/output/lv_all.csv"

    # Extract and sort the 10 posts with the lowest consumption, then process line by line
    cut -d ';' -f 1,3,2 "/output/lv_all.csv" | sort -t ';' -k2 -n | head -n 10 | awk -F';' '{print $1, $2, $3, $2 - $3}' | sort -t ';' -k4 -nr > "/output/lv_all_minmax.csv"

    # Extract and sort the 10 posts with the highest consumption, then process line by line
    cut -d ';' -f 1,3,2 "/output/lv_all.csv" | sort -t ';' -k2 -n | tail -n 10 | awk -F';' '{print $1, $2, $3, $2 - $3}' | sort -t ';' -k4 -nr >> "/output/lv_all_minmax.csv"

    # To finish, we remove the last column (the difference column) in lv_all_minmax.csv
    cut -d ';' --complement -f 4 "/output/lv_all_minmax.csv" > "/output/lv_all_minmax_tmp.csv" && mv "/output/lv_all_minmax_tmp.csv" "/output/lv_all_minmax.csv"
fi
fi






# Continuer avec les opérations sur les données (par exemple, traitement du fichier de données)
# ./votre_programme $chemin_fichier_donnees $type_station $type_consommateur $identifiant_centrale








