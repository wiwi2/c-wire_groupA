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
    echo "3) Of course, be sure the compilation works..."
    echo
    echo -e "If you use -h, regardless of other parameter(s), the help will be displayed.\n"
}

# The execution time that will help us get the time of execution of the program 
# For now, we set it to 0.0 until the current sort
execution_time="${execution_time:-0.0}"


# Function to display the timer using the execution time above 
timer() {
    echo -e "\n---------------------------------TIMER---------------------------------"
    # For the time to appear in the form d.d... (with a point in between)
    LC_NUMERIC=C printf "                         The prog ran %.1f seconds.\n" "$execution_time"
    echo "-----------------------------------------------------------------------"
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


# ------ COMPILATION ------

# Set the path to the codeC folder
CODEC_DIR="./codeC"
# We store the name of the expected executable (defined in our makefile) 
EXECUTABLE="$CODEC_DIR/prog"

# Check if the executable file exists
if ! [ -f "$EXECUTABLE" ]; then # if not, we start the compilation...
    # Go to the codeC folder and run make
    if ! (cd "$CODEC_DIR" && make); then # if the output of make isn't 0, the compilation failed
       "Error: The executable '$EXECUTABLE' was not generated after compilation. Please try again."
        timer
        exit 9
    fi
fi
# -------------------------
    
   

# Now we start by checking everything about the arguments...
# if -h is encountered in the options, regardless of its position, the help will be displayed 
for arg in "$@"; do
    if [ "$arg" == "-h" ]
    then
    	echo -e "\nYou chose to display the help :\n"
        help
        timer
        exit 1
    fi
done

# Vérification que les paramètres sont passés
if [ "$#" -lt 3 ]; # -lt = less than ; to check how many options there are
    then
    echo "Error : some options are missing."
    help
    timer
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
    timer
    exit 3
fi




# Cheching the options : type of station, type of consumer, id of a centrale... 
# Check if both parameters are invalid first :
if [[ "$2" != "hvb" ]] && [[ "$2" != "hva" ]] && [[ "$2" != "lv" ]] && \
   [[ "$3" != "comp" ]] && [[ "$3" != "indiv" ]] && [[ "$3" != "all" ]]; then
    echo "Error: the type of station '$2' is invalid, as well as the type of consumer '$3'."
    help
    timer
    exit 5
fi


# Then checking the type of station (hvb or hva or lv) :
if [[ "$2" != "hvb" ]] && [[ "$2" != "hva" ]] && [[ "$2" != "lv" ]]; 
then
    echo "Error : the type of station '$2' is invalid. Possible values : hvb, hva, lv."
    help
    timer
    exit 5
fi


# Then checking the type of consumer (comp or indiv or all) :
if [[ "$3" != "comp" ]] && [[ "$3" != "indiv" ]] && [[ "$3" != "all" ]];  
then
    echo "Error : the type of consumer '$3' is invalid. Possible values : comp, indiv, all."
    help
    timer
    exit 6
fi


# Checking the existence of the option centrale_id (because it's optionnal); as we know there are just 5 centrales, we check it therefore :
if [ ! -z "$4" ]; then  # if the argument exist (argument != void) // voir ici
    if [[ ! "$4" =~ ^[0-9]+$ ]]; then
        echo "Error: The centrale's id must be a whole number between 1 and 5."
        help
        timer
        exit 9
    fi
# if the id is below 1 or above 5 : error
    if [[ "$4" -lt 1 || "$4" -gt 5 ]]; then
        echo "Error: The centrale's id must be between 1 and 5 (inclusive)."
        help
        timer
        exit 10
    fi
fi



# Checking restrictions on certain parameter combinations (like hvb all)
# With hvb station :
if [[ "$2" == "hvb" ]] && ( [[ "$3" == "all" ]] || [[ "$3" == "indiv" ]] ); 
then
    echo "Error : the combinations 'hvb all' and 'hvb indiv' are prohibited."
    help
    timer
    exit 7
fi

# With hva station 
if [[ "$2" == "hva" ]] && ( [[ "$3" == "all" ]] || [[ "$3" == "indiv" ]] ); 
then
    echo "Error : the combinations 'hva all' and 'hva indiv' are prohibited."
    help
    timer
    exit 8
fi


# We just finished checking everything about the parameters, so we start getting the time here...
start_time=$(date +%s)  


# Replace all '-' with '0' in the file specified by $1
# The result is first written to a temporary file in /tmp to avoid overwriting the original file directly  
# Then, the temporary file is moved to overwrite the original file at the path specified by $1
tr '-' '0' < "$1" > /tmp/temp.csv && mv /tmp/temp.csv "$1"



# 'Big' switch case for all possibles stations (hvb, hva and lv) :
case "$2" in
  "hvb")
    if [[ "$3" == "comp" ]]; then
    # If the centrale is specified by the user... (if $4 isn't empty)
      if ! [ -z "$4" ]; then 
       # echo "HVB-Stations:Capacity:TotalConsumption(companies)" > "output/hvb_comp_${4}.csv"
        cat "$1" | grep -E "^$4" | awk -F ':' '{if($2 != 0 && $3 == 0 && $4 == 0) {printf("%d;%d;%d\n", $2,$7,$8)} }'  | ./codeC/prog | sort -t ':' -k2 -n > "output/hvb_comp_${4}.csv"
        echo "HVB-Stations:Capacity:TotalConsumption(companies)" | cat - "output/hvb_comp_${4}.csv" > "tmp/temp_hvbcomp.csv" && mv "tmp/temp_hvbcomp.csv" "output/hvb_comp_${4}.csv"
    # If the centrale isn't specified by the user... (if $4 is empty)
      else 
        echo "HVB-Stations:Capacity:TotalConsumption(companies)" > "output/hvb_comp.csv"
         cat "$1" | awk -F ';' '{if($2 != 0 && $3 == 0 && $4 == 0) {printf("%d;%d;%d\n", $2,$7,$8)} }' | ./codeC/prog | sort -t ':' -k2 -n >> "output/hvb_comp.csv"
      fi
    fi
    ;;

  "hva")
    if [[ "$3" == "comp" ]]; then
        # If the centrale is specified by the user... (if $4 isn't empty)
      if ! [ -z "$4" ]; then
        echo "HVA-Stations:Capacity:TotalConsumption(companies)" > "output/hva_comp_${4}.csv"
        cat "$1" | grep -E "^$4" | awk -F ';' '{if($4 == 0 && $3 != 0) {printf("%d;%d;%d\n", $3, $7, $8)} }' | ./codeC/prog | sort -t ':' -k2 -n >> "output/hva_comp_${4}.csv"
        # If the centrale isn't specified by the user... (if $4 is empty)
      else
        echo "HVA-Stations:Capacity:TotalConsumption(companies)" > "output/hva_comp.csv"
        cat "$1" | awk -F ';' '{if($4 == 0 && $3 != 0) {printf("%d;%d;%d\n", $3, $7, $8)} }' | ./codeC/prog | sort -t ':' -k2 -n >> "output/hva_comp.csv"
      fi
    fi
    ;;

   "lv")
   # Little switch case in the lv case for the differents types of consumers (all, comp and indiv) :
    case "$3" in
      "all")
        # First, if a centrale has been added by the user : (so if $4 isn't empty) 
        if ! [ -z "$4" ]; then
          echo "LV-Stations:Capacity:TotalConsumption(all)" > "output/lv_all_${4}.csv"
          cat "$1" | grep -E "^$4" | awk -F ';' '{if($4 != 0) {printf("%d;%d;%d\n", $4, $7, $8)} }' | ./codeC/prog | sort -t ':' -k2 -n >> "output/lv_all_${4}.csv"

          # Extraction of the 10 stations with the lowest consumption
          echo "LV-Stations:Capacity:TotalConsumption(all)" > "output/lv_all_minmax_${4}.csv"
          cat "output/lv_all_${4}.csv" | sort -t ':' -k3 -n | head -n 10 | \
            awk -F':' '{ printf("%d:%d:%d:%d\n", $1,$2,$3,$2 - $3) }' | sort -t ':' -k4 -nr >> "output/lv_all_minmax_${4}.csv"

          # Extraction of the 10 positions with the highest consumption
          cat "output/lv_all_${4}.csv" | sort -t ':' -k3 -n | tail -n 10 | \
            awk -F':' '{ printf("%d:%d:%d:%d\n", $1,$2,$3,$2 - $3) }' | sort -t ':' -k4 -nr >> "output/lv_all_minmax_${4}.csv"

          # Deleting the difference column (4th column) that helped us to sort out by consumtion...
          # And to avoid overwriting our file, we use a temporary file that we'll rename with mv afterward. 
         cut -d ':' --complement -f 4 "output/lv_all_minmax_${4}.csv" > "tmp/lv_all_minmax_tmp_${4}.csv" && \
            mv "tmp/lv_all_minmax_tmp_${4}.csv" "output/lv_all_minmax_${4}.csv"


        # Now, if a centrale hasn't been added by the user  (so, if $4 is empty this time)
        else
          echo "LV-Stations:Capacity:TotalConsumption(all)" > "output/lv_all.csv"
          cat "$1" | awk -F ';' '{if($4 != 0) {printf("%d;%d;%d\n", $4, $7, $8) } }' | ./codeC/prog | sort -t ':' -k2 -n >> "output/lv_all.csv"  

          # Same as before, extraction of the 10 stations with the lowest consumption that are in the begeinning of our file lv_all.csv
          
          
         # A FAIRE : IGNORER LA PREMIERE LIGNE DU FICHIER QU ON UTILISE ! erreur 0:0:0 pour lv all...
         
          
          echo "LV-Stations:Capacity:TotalConsumption(all)" > "output/lv_all_minmax.csv"
          cat "output/lv_all.csv" | sort -t ':' -k3 -n | head -n 10 | \
            awk -F ':' '{ printf("%d:%d:%d:%d\n", $1,$2,$3,$2 - $3) }' | sort -t ':' -k4 -nr >> "output/lv_all_minmax.csv"

          # Extraction of the 10 positions with the highest consumption
          cat "output/lv_all.csv" | sort -t ':' -k3 -n | tail -n 10 | \
            awk -F ':' '{ printf("%d:%d:%d:%d\n", $1,$2,$3,$2 - $3) }' | sort -t ':' -k4 -nr >> "output/lv_all_minmax.csv"

          # And finally, deleting the difference column (4th column) that helped us to sort out by consumtion...
          # Again, we use a temporary file to avoid overwriting lv_all_minmax.csv and we rename it at the end
          cut -d ':' --complement -f 4 "output/lv_all_minmax.csv" > "tmp/lv_all_minmax_tmp.csv" && \
            mv "tmp/lv_all_minmax_tmp.csv" "output/lv_all_minmax.csv"
        fi
        ;;

      "comp")
        # If the centrale is specified by the user... (if $4 isn't empty)
        if ! [ -z "$4" ]; then
          echo "LV-Stations:Capacity:TotalConsumption(companies)" > "output/lv_comp_${4}.csv"
          cat "$1" | grep -E "^$4" | awk -F ';' '{if($4 != 0 && $6 == 0) {printf("%d;%d;%d\n", $4,$7,$8) } }' | ./codeC/prog | sort -t ':' -k2 -n >> "output/lv_comp_${4}.csv"
          
        # If the centrale isn't specified by the user... (if $4 is empty)
        else 
          echo "LV-Stations:Capacity:TotalConsumption(companies)" > "output/lv_comp.csv"
          cat "$1" | awk -F ';' '{if($4 != 0 && $6 == 0) {printf("%d;%d;%d\n", $4,$7,$8) } }' | ./codeC/prog | sort -t ':' -k2 -n >> "output/lv_comp.csv"
        fi
        ;;

      "indiv")
        # If the centrale is specified by the user... (if $4 isn't empty)
        if ! [ -z "$4" ]; then
          echo "LV-Stations:Capacity:TotalConsumption(indivivuals)" > "output/lv_indiv_${4}.csv"
          cat "$1" | grep -E "^$4" | awk -F ';' '{if($4 != 0 && $5 == 0) {printf("%d;%d;%d\n", $4,$7,$8) } }' | ./codeC/prog | sort -t ':' -k2 -n >> "output/lv_indiv_${4}.csv"

        # If the centrale isn't specified by the user... (if $4 is empty)
        else
          echo "LV-Stations:Capacity:TotalConsumption(individuals)" > "output/lv_indiv.csv"
          cat "$1" | awk -F ';' '{if($4 != 0 && $5 == 0) {printf("%d;%d;%d\n", $4,$7,$8) } }' | ./codeC/prog | sort -t ':' -k2 -n >> "output/lv_indiv.csv"
        fi
        ;;
    esac # end of the second switch case (the little one)
    ;;
esac # end of the first switch case (the big one) 






# ------------------------------ BONUS : Gnoplot for lv all ! ------------------------------


# et commentaires sur partie verte et rouge à voir aussi :
#partie verte : min ( capa, conso_totale ) 
# partie rouge : max ( 0, conso - capa )


# à faire : trier les exit ; -> fil perdu à un moment encore...

# ne pas oublier de test le machin pour voir si les free sont bien fait... 
# check tout le doc pour verif que rien n a été oublié !!! 



if [[ $2 == "lv" ]] && [[ $3 == "all" ]]; then

# We copy the whole output of the case concerned but the first line (we just want the numbers (id:totalconso:capa)) in a new file : we will need it to do the graph
# But we won't need it any further after this manipulation, that explains why we put it in tmp... 



tail -n +2 "output/lv_all_minmax.csv" > "tmp/lv_info_graph.csv" 



# ajout temporaire pour verifier que gnugnu fonctionne... à partir du awk (en enlevant les ligne avec des 0...) 
# | awk -F ';' '{if($1 != 0) { printf("%d:%d:%d:%d:%d\n", $1, $2, $3, $4, $5) } }' > (à voir.. ca fonctionne pas)

# We will modify the file to help us build the graph. First, we'll identify the green and red parts :
# The green part : the consumption which does not exceed the capacity
# The red part is the difference between consumption and capacity (appears if : sum_conso > capa) 


# We'll read the file copied earlier line by line and add new columns for the green and red parts for the graph in a new file :
while IFS=':' read -r id sum_conso capa; do
    # In the case that follows, there won't be any red part : the sum_conso is < or = to the capacity : no overload
    if (( sum_conso <= capa )); then 
        partie_verte=$sum_conso
        partie_rouge=0
    # Here, sum_conso > capa so there will be a red part :
    else
        partie_verte=$capa
        partie_rouge=$((sum_conso - capa))
    fi

    # Finally, we add the modified line to the output file that we'll need
    echo "$id:$sum_conso:$capa:$partie_verte:$partie_rouge" >> "tmp/lv_info_graph_with_parts.csv"
done < "tmp/lv_info_graph.csv" # in this loop, we used the copy creaated earlier. 


# Gnuplot starting command
gnuplot << EOF 

# We set the output terminal to PNG with a specific size
set terminal png size 1024,768
set output 'output/lv_all_minmax_graph.png'

# Set the title of the graph and the titles for the axes (X and Y)
set title "Load of the 10 most and least loaded LV stations"
set xlabel "LV Stations"
set ylabel "Load (kWh)"

# Set the bar chart style, with a gap between clusters of bars
set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9

# Define the color palette (green for capacity and red for overload)
set palette defined (0 "green", 1 "red")

# Specify the datafile separator
set datafile separator ";"

# Set the x-tics explicitly if needed (show the stations by their IDs)
set xtics rotate by 45 # Rotate the x-axis labels for readability (if needed)

# Plot the data from the file with all the useful information to draw the histogram 

set datafile missing NaN

plot 'tmp/lv_info_graph_with_parts.csv' using 4:xtic(1) title "Capacity (Green)" with boxes lc rgb "green", \
     '' using 5:xtic(1) title "Overload (Red)" with boxes lc rgb "red"

# End of Gnuplot commands  
EOF


fi 


# End : we get the time that took to the program to sort out what the user asked for !
end_time=$(date +%s)
execution_time=$((end_time-start_time)) 
timer 













