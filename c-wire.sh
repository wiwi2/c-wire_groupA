#!/bin/bash

# Description : this shell script will allow us to sort a csv file using program c 

# Function to display the help
help() {
    echo -e "...................................HELP............................................\n"
    echo -e "\n\nHow to use: $0 <file_path> <type_station> <type_consumer> [powerplant_id]"
    echo
    echo "The various options :"
    echo "  file_path            : Path to the csv file. This option is obligatory." 
    echo "  type_station         : Type of station to process. Possible values : hvb, hva, lv. This option is obligatory."
    echo "  type_consumer        : Type of consumer to process. Possible values : comp, indiv, all. This option is obligatory."
    echo "  powerplant_id          : Id of the power plant. There's only 5 power plants, so it has to be between 1 and 5 included. This option is optional : it will sort out the station chosen under the giver power plant."
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
    LC_NUMERIC=C printf "                         The prog ran %.4f seconds.\n" "$execution_time"
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


# Same thing with the "input" directory
if [[ ! -d "input" ]]; then
    mkdir -p "input"
fi


# ------ COMPILATION ------

# Set the path to the codeC folder
CODEC_DIR="./codeC"
# We store the name of the expected executable (defined in our makefile) 
EXECUTABLE="$CODEC_DIR/prog"

    # Check if the executable exists 
    # Then go to the codeC folder and run make
    if ! [ -f $EXECUTABLE ]; then
        if ! (cd $CODEC_DIR && make); then # if the output of make isn't 0, the compilation failed
          echo "Error: The executable '$EXECUTABLE' was not generated after compilation. Please try again."
          timer
          exit 1
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
        exit 2
    fi
done

# Vérification que les paramètres sont passés
if [ "$#" -lt 3 ]; # -lt = less than ; to check how many options there are
    then
    echo "Error : some options are missing."
    help
    timer
    exit 3
fi

# Recovery of the csv file and the options passed as argument
file_path="$1"
type_station="$2"
type_consumer="$3"
powerplant_id="$4"

# Checking the path/existence of the file and if it's a csv file
if [ ! -f "$1" ] ;
    then 
    echo -e "Error : the file $1 does not exist or the path is incorrect. \nPlease check its existence of the path to the file."
    help
    timer
    exit 4
fi




# Cheching the options : type of station, type of consumer, id of a power plant... 
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
    exit 6
fi


# Then checking the type of consumer (comp or indiv or all) :
if [[ "$3" != "comp" ]] && [[ "$3" != "indiv" ]] && [[ "$3" != "all" ]];  
then
    echo "Error : the type of consumer '$3' is invalid. Possible values : comp, indiv, all."
    help
    timer
    exit 7
fi


# Checking the existence of the option powerplant_id (because it's optionnal); as we know there are just 5 power plants, we check it therefore :
if [ ! -z "$4" ]; then  # if the argument exist (argument != void) // voir ici
    if [[ ! "$4" =~ ^[0-9]+$ ]]; then
        echo "Error: The power plant's id must be a whole number between 1 and 5."
        help
        timer
        exit 8
    fi
# if the id is below 1 or above 5 : error
    if [[ "$4" -lt 1 || "$4" -gt 5 ]]; then
        echo "Error: The power plant's id must be between 1 and 5 (inclusive)."
        help
        timer
        exit 9
    fi
fi



# Checking restrictions on certain parameter combinations (like hvb all)
# With hvb station :
if [[ "$2" == "hvb" ]] && ( [[ "$3" == "all" ]] || [[ "$3" == "indiv" ]] ); 
then
    echo "Error : the combinations 'hvb all' and 'hvb indiv' are prohibited."
    help
    timer
    exit 10
fi

# With hva station 
if [[ "$2" == "hva" ]] && ( [[ "$3" == "all" ]] || [[ "$3" == "indiv" ]] ); 
then
    echo "Error : the combinations 'hva all' and 'hva indiv' are prohibited."
    help
    timer
    exit 11
fi


# We just finished checking everything about the parameters, so we start getting the time here...
start_time=$(date +%s.%N)  


# Replace all '-' with '0' in the file specified by $1
# The result is first written to a temporary file in /tmp to avoid overwriting the original file directly  
# Then, the temporary file is moved to overwrite the original file at the path specified by $1
# tr '-' '0' < "$1" > /tmp/temp.csv && mv /tmp/temp.csv "$1"



# 'Big' switch case for all possibles stations (hvb, hva and lv) :
case "$2" in
  "hvb")
    if [[ "$3" == "comp" ]]; then
    # If the power plant is specified by the user... (if $4 isn't empty)
      if ! [ -z "$4" ]; then 
        tr '-' '0' < "$1" | grep -E "^$4" | awk -F ';' '{if($2 != 0 && $3 == 0 && $4 == 0) {printf("%d;%ld;%ld\n", $2,$7,$8)} }' | ./codeC/prog | sort -t ':' -k2 -n > "output/hvb_comp_${4}.csv"
        echo "HVB-Stations:Capacity:TotalConsumption(companies)" | cat - "output/hvb_comp_${4}.csv" > "tmp/tmp_hvbcomp_${4}.csv" && mv "tmp/tmp_hvbcomp_${4}.csv" "output/hvb_comp_${4}.csv"
   # If the power plant isn't specified by the user... (if $4 is empty)
      else 
         tr '-' '0' < "$1" | awk -F ';' '{if($2 != 0 && $3 == 0 && $4 == 0) {printf("%d;%ld;%ld\n", $2,$7,$8)} }' | ./codeC/prog | sort -t ':' -k2 -n > "output/hvb_comp.csv"
          echo "HVB-Stations:Capacity:TotalConsumption(companies)" | cat - "output/hvb_comp.csv" > "tmp/tmp_hvacomp.csv" && mv "tmp/tmp_hvacomp.csv" "output/hvb_comp.csv"
         
      fi
    fi
    ;;

  "hva")
    if [[ "$3" == "comp" ]]; then
        # If the power plant is specified by the user... (if $4 isn't empty)
      if ! [ -z "$4" ]; then
        tr '-' '0' < "$1" | grep -E "^$4" | awk -F ';' '{if($4 == 0 && $3 != 0) {printf("%d;%ld;%ld\n", $3, $7, $8)} }' | ./codeC/prog | sort -t ':' -k2 -n > "output/hva_comp_${4}.csv"
        echo "HVA-Stations:Capacity:TotalConsumption(companies)" | cat - "output/hva_comp_${4}.csv" > "tmp/tmp_hvacomp_${4}.csv" && mv "tmp/tmp_hvacomp_${4}.csv" "output/hva_comp_${4}.csv"
        # If the power plant isn't specified by the user... (if $4 is empty)
      else
        tr '-' '0' < "$1" | awk -F ';' '{if($4 == 0 && $3 != 0) {printf("%d;%ld;%ld\n", $3, $7, $8)} }' | ./codeC/prog | sort -t ':' -k2 -n > "output/hva_comp.csv"
        echo "HVA-Stations:Capacity:TotalConsumption(companies)" | cat - "output/hva_comp.csv" > "tmp/tmp_hvacomp.csv" && mv "tmp/tmp_hvacomp.csv" "output/hva_comp.csv"
      fi
    fi
    ;;

   "lv")
   # Little switch case in the lv case for the differents types of consumers (all, comp and indiv) :
    case "$3" in
      "all")
        # First, if a power plant has been added by the user : (so if $4 isn't empty) 
        if ! [ -z "$4" ]; then
          tail -n +2 "$1" | tr '-' '0' | grep -E "^$4" | awk -F ';' '{if($4 != 0) {printf("%d;%ld;%ld\n", $4, $7, $8)} }' | ./codeC/prog | sort -t ':' -k2 -n > "output/lv_all_${4}.csv"

          # Extraction of the 10 stations with the lowest consumption
          echo "LV-Stations:Capacity:TotalConsumption(all)" > "output/lv_all_minmax_${4}.csv"
          sort -t ':' -k3 -n "output/lv_all_${4}.csv" | head -n 10 | \
            awk -F':' '{ printf("%d:%ld:%ld:%ld\n", $1,$2,$3,$2 - $3) }' > "tmp/temp_lv_all_minmax_${4}.csv"

          # Extraction of the 10 positions with the highest consumption
          sort -t ':' -k3 -n "output/lv_all_${4}.csv" | tail -n 10 | \
            awk -F':' '{ printf("%d:%ld:%ld:%ld\n", $1,$2,$3,$2 - $3) }' >> "tmp/temp_lv_all_minmax_${4}.csv"

          # We sort in function of the 4th colomn that is is the absolute quantity of energy consumed (in a decreasing manner)
           sort -t ':' -k4 -n "tmp/temp_lv_all_minmax_${4}.csv" >> "output/lv_all_minmax_${4}.csv"

        # We add the first line after sorting out everything in the lv all file... 
        echo "LV-Stations:Capacity:TotalConsumption(all)" | cat - "output/lv_all_${4}.csv" > "tmp/tmp_lvall_${4}.csv" && mv "tmp/tmp_lvall_${4}.csv" "output/lv_all_${4}.csv"

          # Deleting the difference column (4th column) that helped us to sort out by consumtion...
          # And to avoid overwriting our file, we use a temporary file that we'll rename with mv afterward. 
         cut -d ':' --complement -f 4 "output/lv_all_minmax_${4}.csv" > "tmp/lv_all_minmax_tmp_${4}.csv" && \
            mv "tmp/lv_all_minmax_tmp_${4}.csv" "output/lv_all_minmax_${4}.csv"


        # Now, if a power plant hasn't been added by the user  (so, if $4 is empty this time)
        else
          tail -n +2 "$1" | tr '-' '0' | awk -F ';' '{if($4 != 0) {printf("%d;%ld;%ld\n", $4, $7, $8) } }' | ./codeC/prog | sort -t ':' -k2 -n > "output/lv_all.csv"  

          # Same as before, extraction of the 10 stations with the lowest consumption that are in the begeinning of our file lv_all.csv         
          echo "LV-Stations:Capacity:TotalConsumption(all)" > "output/lv_all_minmax.csv"
           sort -t ':' -k3 -n "output/lv_all.csv" | head -n 10 | \
            awk -F ':' '{ printf("%d:%ld:%ld:%ld\n", $1,$2,$3,$2 - $3) }' > "tmp/temp_lv_all_minmax.csv"

          # Extraction of the 10 positions with the highest consumption
           sort -t ':' -k3 -n "output/lv_all.csv" | tail -n 10 | \
            awk -F ':' '{ printf("%d:%ld:%ld:%ld\n", $1,$2,$3,$2 - $3) }' >> "tmp/temp_lv_all_minmax.csv"

	        # We sort in function of the 4th colomn that is is the absolute quantity of energy consumed (in a decreasing manner)
           sort -t ':' -k4 -n "tmp/temp_lv_all_minmax.csv" >> "output/lv_all_minmax.csv"

        # We add the first line after sorting out everything in the lv all file... 
        echo "LV-Stations:Capacity:TotalConsumption(all)" | cat - "output/lv_all.csv" > "tmp/tmp_lvall.csv" && mv "tmp/tmp_lvall.csv" "output/lv_all.csv"

          # And finally, deleting the difference column (4th column) that helped us to sort out by consumtion...
          # Again, we use a temporary file to avoid overwriting lv_all_minmax.csv and we rename it at the end
          cut -d ':' --complement -f 4 "output/lv_all_minmax.csv" > "tmp/lv_all_minmax_tmp.csv" && \
      mv "tmp/lv_all_minmax_tmp.csv" "output/lv_all_minmax.csv"
        fi
        ;;

      "comp")
        # If the power plant is specified by the user... (if $4 isn't empty)
        if ! [ -z "$4" ]; then
          tr '-' '0' < "$1" | grep -E "^$4" | awk -F ';' '{if($4 != 0 && $6 == 0) {printf("%d;%ld;%ld\n", $4,$7,$8) } }' | ./codeC/prog | sort -t ':' -k2 -n > "output/lv_comp_${4}.csv"
          echo "LV-Stations:Capacity:TotalConsumption(companies)" | cat - "output/lv_comp_${4}.csv" > "tmp/tmp_lvcomp_${4}" && mv "tmp/tmp_lvcomp_${4}" "output/lv_comp_${4}.csv"
          
        # If the power plant isn't specified by the user... (if $4 is empty)
        else 
          tr '-' '0' < "$1" | awk -F ';' '{if($4 != 0 && $6 == 0) {printf("%d;%ld;%ld\n", $4,$7,$8) } }' | ./codeC/prog | sort -t ':' -k2 -n > "output/lv_comp.csv"
          echo "LV-Stations:Capacity:TotalConsumption(companies)" | cat - "output/lv_comp.csv" > "tmp/tmp_lvcomp" && mv "tmp/tmp_lvcomp" "output/lv_comp.csv"

        fi
        ;;

      "indiv")
        # If the power plant is specified by the user... (if $4 isn't empty)
        if ! [ -z "$4" ]; then
          tr '-' '0' < "$1" | grep -E "^$4" | awk -F ';' '{if($4 != 0 && $5 == 0) {printf("%d;%ld;%ld\n", $4,$7,$8) } }' | ./codeC/prog | sort -t ':' -k2 -n > "output/lv_indiv_${4}.csv"
          echo "LV-Stations:Capacity:TotalConsumption(indivivuals)" | cat - "output/lv_indiv_${4}.csv" > "tmp/tmp_lvindiv_${4}.csv" && mv "tmp/tmp_lvindiv_${4}.csv" "output/lv_indiv_${4}.csv"

        # If the power plant isn't specified by the user... (if $4 is empty)
        else
          tr '-' '0' < "$1" | awk -F ';' '{if($4 != 0 && $5 == 0) {printf("%d;%ld;%ld\n", $4,$7,$8) } }' | ./codeC/prog | sort -t ':' -k2 -n > "output/lv_indiv.csv"
          echo "LV-Stations:Capacity:TotalConsumption(indivivuals)" | cat - "output/lv_indiv.csv" > "tmp/tmp_lvindiv.csv" && mv "tmp/tmp_lvindiv.csv" "output/lv_indiv.csv"

        fi
        ;;
    esac # end of the second switch case (the little one)
    ;;
esac # end of the first switch case (the big one) 






# ------------------------------ BONUS : Gnoplot for lv all ! ------------------------------


if [[ $2 == "lv" ]] && [[ $3 == "all" ]]; then

# We copy the whole output of the case concerned but the first line (we just want the numbers (id:totalconso:capa)) in a new file : we will need it to do the graph
# But we won't need it any further after this manipulation, that explains why we put it in tmp...

# Part to verify if a power plant has been chosen by the user to put it in the name of the png graph
suffix=''
if ! [ -z "$4" ]; then
	suffix="_${4}"
fi
file="lv_all_minmax${suffix}.csv"

 
tail -n +2 "output/$file" > "tmp/lv_info_graph.csv" 


# We will modify the file to help us build the graph. First, we'll identify the green and red parts :
# The green part : the consumption which does not exceed the capacity
# The red part is the difference between consumption and capacity (appears if : sum_conso > capa) 

# We'll read the file copied earlier line by line and add new columns for the green and red parts for the graph in a new file :
while IFS=':' read -r id capa conso; do
    # In the case that follows, there won't be any red part : the conso is < or = to the capacity : no overload
    if (( $capa >= $conso )); then 
        partie_verte=$conso
        partie_rouge=0
    # Here, conso > capa so there will be a red part :
    else
        partie_verte=$capa
        partie_rouge=$(( conso - capa ))
    fi

    # Finally, we add the modified line to the output file that we'll need
    echo "$id:$capa:$conso:$partie_verte:$partie_rouge" >> "tmp/lv_info_graph_with_parts.csv"
done < "tmp/lv_info_graph.csv" # in this loop, we used the copy created earlier. 


# Gnuplot starting command
gnuplot << EOF

# We set the output terminal to PNG with a specific size and font
set terminal pngcairo size 1600,1100 enhanced font "Open Sans, 20" background rgb "black"
set output 'graphs/lv_all_minmax_graph$suffix.png'
set datafile separator ":"

# Set the legend position and other graphical settings (colors, positions...)
set key left textcolor rgb "white"
set grid y
set xtics rotate by 35 offset -1.5, -1.5
set ytics nomirror
set xtics textcolor rgb "white"
set ytics textcolor rgb "white"
set border lc rgb "white"

# Set the style for the histogram (rowstacked, box width, fill pattern)
set style data histograms
set style histogram rowstacked
set boxwidth 0.8

# Set the fill to solid (fully filled) without border lines
set style fill solid 1.0 border -1

# Set the y and x axis titles and the graph title
set ylabel "Load (kWh)" font "Open Sans Bold, 22" textcolor rgb "white"
set xlabel "LV Stations" font "Open Sans Bold, 22" offset -1,0 textcolor rgb "white"
set title "Energy consumption per LV station" font "Open Sans Bold, 25" textcolor rgb "white"

# Plot the data with stacked bars (Green for capacity, Red for overload)
plot 'tmp/lv_info_graph_with_parts.csv' using 4:xtic(1) title "Capacity" lc rgb "green" lw 3, \
     '' using 5:xtic(1) title "Overload" lc rgb "red" lw 3 

EOF
fi 


# End : we get the time that took to the program to sort out what the user asked for !
end_time=$(date +%s.%N)
execution_time=$(echo "$end_time - $start_time" | bc) 
timer 


# ----------------- the end -----------------
