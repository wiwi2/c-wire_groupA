#!/bin/bash

# Description : this shell script will allow us to sort a csv file using program c 

# Function to display the help
help() {
    echo -e "...................................HELP............................................\n"
    echo -e "\n\nHow to use: $0 <file_path> <type_station> <type_consumer> [powerplant_id]"
    echo
    echo "Parameters :"
    echo "  file_path            : Path to the csv file. This parameter is obligatory." 
    echo "  type_station         : Type of station to process. Possible values : hvb, hva, lv. This parameter is obligatory."
    echo "  type_consumer        : Type of consumer to process. Possible values : comp, indiv, all. This parameter is obligatory."
    echo "  powerplant_id        : Id of the power plant. There's only 5 power plants, so it has to be between 1 and 5 included. This parameter is optional : it will sort out the station chosen under the given power plant."
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



# ------------------------ DIRECTORIES CHECKS ------------------------
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
# ----------------------------------------------------------------


# ---------------------- ARGUMENTS CHECKS ------------------------
# Now we start by checking everything about the arguments...
# if -h is encountered in the arguments, regardless of its position, the help will be displayed 
for arg in "$@"; do
    if [ "$arg" == "-h" ]
    then
    	echo -e "\nYou chose to display the help :\n"
        help
        timer
        exit 2
    fi
done

# Check that parameters are passed
if [ "$#" -lt 3 ]; # -lt = less than ; to check how many arguments there are
    then
    echo "Error : some options are missing."
    help
    timer
    exit 3
fi

# Recovery of the csv file and the parameters passed as argument
file_path="$1"
type_station="$2"
type_consumer="$3"
powerplant_id="$4"

# Checking the path/existence of the file (the csv one)
if [ ! -f "$1" ] ;
    then 
    echo -e "Error : the file $1 does not exist or the path is incorrect. \nPlease check its existence of the path to the file."
    help
    timer
    exit 4
fi

# Cheching the parameters : type of station, type of consumer, id of a power plant... 
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

# Checking the existence of the parameter powerplant_id (because it's optionnal); as we know there are just 5 power plants, we check it therefore :
if [ ! -z "$4" ]; then  # if the argument exist (argument != void)
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
# ------------------------------------------


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


# ------------ DATA PROCESSING ------------
# We just finished checking everything about the parameters and compilation, so we start getting the time here...
start_time=$(date +%s.%N)  

# Part to verify if a power plant has been chosen by the user to put it in the name everytime
suffix=''
if ! [ -z "$4" ]; then
	suffix="_${4}"
fi


# 'Big' switch case for all possibles stations (hvb, hva and lv) :
case "$2" in
  "hvb")

  # STEPS : (that will be repeated more or less each time)
        # We turn all the '-' first to ease the treatment later (during the sum of conso)
        # We grep if there is a power plant specified by the user, if not, then grep sends all the lines, which is what we want 
        # Then we awk with conditions (relative to the desired station, and later with lv, relative to the desired consumer too)
        # We send everything to our c program that will do the sum of the consumption 
        # We sort by capacity (ascending order)
        # Finally, we put everything in the appropriate file 

        tr '-' '0' < "$1" | grep -E "^$4" | awk -F ';' '{if($2 != 0 && $3 == 0 && $4 == 0) {printf("%d;%ld;%ld\n", $2,$7,$8)} }' | ./codeC/prog | sort -t ':' -k2 -n > "output/hvb_comp${suffix}.csv"
        sed -i "1s/^/HVB-Stations:Capacity:TotalConsumption(companies)\n/" "output/hvb_comp${suffix}.csv"
    ;;
  "hva")
    if [[ "$3" == "comp" ]]; then
        tr '-' '0' < "$1" | grep -E "^$4" | awk -F ';' '{if($4 == 0 && $3 != 0) {printf("%d;%ld;%ld\n", $3, $7, $8)} }' | ./codeC/prog | sort -t ':' -k2 -n > "output/hva_comp${suffix}.csv"
        sed -i "1s/^/HVA-Stations:Capacity:TotalConsumption(companies)\n/" "output/hva_comp${suffix}.csv"
    fi
    ;;
   "lv")
     # 'Small' switch case in the lv case for the different types of consumers (all, comp, and indiv) :
    case "$3" in
      "all")
      # Here, we tail to avoid an error because of the header line
          tail -n +2 "$1" | tr '-' '0' | grep -E "^$4" | awk -F ';' '{if($4 != 0) {printf("%d;%ld;%ld\n", $4, $7, $8)} }' | ./codeC/prog | sort -t ':' -k2 -n > "output/lv_all${suffix}.csv"

          # Extraction of the 10 stations with the lowest consumption, using head 
          echo "LV-Stations:Capacity:TotalConsumption(all)" > "output/lv_all_minmax${suffix}.csv"
          sort -t ':' -k3 -n "output/lv_all${suffix}.csv" | head -n 10 | \
            awk -F':' '{ printf("%d:%ld:%ld:%d\n", $1,$2,$3,$2 - $3) }' > "tmp/temp_lv_all_minmax${suffix}.csv"

          # Extraction of the 10 positions with the highest consumption, using tail 
          sort -t ':' -k3 -n "output/lv_all${suffix}.csv" | tail -n 10 | \
            awk -F':' '{ printf("%d:%ld:%ld:%d\n", $1,$2,$3,$2 - $3) }' >> "tmp/temp_lv_all_minmax${suffix}.csv"

          # We sort in function of the 4th colomn that is the absolute quantity of energy consumed (in a increasing manner to have the most loaded to the least loaded in term of difference...)
          # ...because we did capacity - sum_consumption earlier
          sort -t ':' -k4 -n "tmp/temp_lv_all_minmax${suffix}.csv" >> "output/lv_all_minmax${suffix}.csv"

        # We add the first line after sorting out everything in the lv all file... 
        sed -i "1s/^/LV-Stations:Capacity:TotalConsumption(all)\n/" "output/lv_all${suffix}.csv" 

          # Deleting the difference column (4th column) that helped us to sort out by consumtion...
          # And to avoid overwriting our file, we use a temporary file that we'll rename with mv afterward
         cut -d ':' --complement -f 4 "output/lv_all_minmax${suffix}.csv" > "tmp/lv_all_minmax_tmp${suffix}.csv" && \
            mv "tmp/lv_all_minmax_tmp${suffix}.csv" "output/lv_all_minmax${suffix}.csv"
        ;;

      "comp")
          tr '-' '0' < "$1" | grep -E "^$4" | awk -F ';' '{if($4 != 0 && $6 == 0) {printf("%d;%ld;%ld\n", $4,$7,$8) } }' | ./codeC/prog | sort -t ':' -k2 -n > "output/lv_comp${suffix}.csv"
          sed -i "1s/^/LV-Stations:Capacity:TotalConsumption(companies)\n/" "output/lv_comp${suffix}.csv"
        ;;

      "indiv")
          tr '-' '0' < "$1" | grep -E "^$4" | awk -F ';' '{if($4 != 0 && $5 == 0) {printf("%d;%ld;%ld\n", $4,$7,$8) } }' | ./codeC/prog | sort -t ':' -k2 -n > "output/lv_indiv${suffix}.csv"
          sed -i "1s/^/LV-Stations:Capacity:TotalConsumption(indivivuals)\n/" "output/lv_indiv${suffix}.csv" 
        ;;
    esac # end of the second switch case (the small one)
    ;;
esac # end of the first switch case (the big one) 



# ------------------------------ BONUS : Gnoplot for lv all ! ------------------------------


if [[ $2 == "lv" ]] && [[ $3 == "all" ]]; then

file="lv_all${suffix}.csv"

# We put in a tmp file id:capa:sum_conso:capa-sum_conso in a new file : we will need it to do the graph
# We use tail because we don't need the header line
# We sort everything in a increasing manner according to the last column that we added 
    tail -n +2 output/$file | awk -F ':' '{ printf("%d:%ld:%ld:%d\n", $1,$2,$3,$2 - $3) }' | sort -t ':' -k4 -n > "tmp/lv_info${suffix}.csv"

    # Then we cut it, because we don't need it any further, the lv stations are sorted out 
    cut -d ':' --complement -f 4 "tmp/lv_info${suffix}.csv" > "tmp/lv_info_tmp${suffix}.csv" && \
            mv "tmp/lv_info_tmp${suffix}.csv" "tmp/lv_info${suffix}.csv"

    # We take the first 10 and the last 10 of this file, so the 10 most loaded stations and the 10 less loaded ones
    # And we put it in a file that will help us do the graph 
    head -n 10 "tmp/lv_info${suffix}.csv" > "tmp/lv_info_graph${suffix}.csv" 
    tail -n 10 "tmp/lv_info${suffix}.csv" >> "tmp/lv_info_graph${suffix}.csv" 
    


# We will modify the file to help us build the graph. First, we'll identify the green and red parts :
# The green part : the consumption which does not exceed the capacity
# The red part is the difference between consumption and capacity (appears if : sum_conso > capa) 

# We'll read the file copied earlier line by line and add new columns for the green and red parts for the graph in a new file :
while IFS=':' read -r id capa sum_conso; do
    # In the case that follows, there won't be any red part : the sum_conso is < or = to the capacity : no overload
    if (( $sum_conso <= $capa )); then 
        green_part=$sum_conso
        red_part=0
    # Here, sum_conso > capa so there will be a red part :
    else
        green_part=$capa
        red_part=$(( sum_conso - capa ))
    fi

    # Finally, we add the modified line in the output file that we'll need
    echo "$green_part:$red_part" >> "tmp/lv_info_graph_with_parts${suffix}.csv"
done < "tmp/lv_info_graph${suffix}.csv" # in this loop, we used the copy created earlier. 




# Gnuplot starting command
gnuplot << EOF

# We set the output terminal to PNG with a specific size and font
set terminal pngcairo size 1600,1100 enhanced font "Open Sans, 20" background rgb "black"
set output 'graphs/lv_all_minmax_graph$suffix.png'
set datafile separator ":"

# Set the legend position and other graphical settings (colors, positions...)
set key right textcolor rgb "white"
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

# Plus...
set label 1 "🎅" at screen 0.95, 0.95 font ",30" textcolor rgb "black"

# Plot the data with stacked bars (Green for capacity, Red for overload)
plot 'tmp/lv_info_graph_with_parts$suffix.csv' using 1:xtic(1) title "Capacity" lc rgb "green" lw 3, \
     '' using 2:xtic(1) title "Overload" lc rgb "red" lw 3 

EOF
fi 


# End : we get the time that took to the program to sort out what the user asked for !
end_time=$(date +%s.%N)
execution_time=$(echo "$end_time - $start_time" | bc) 
timer 


# ----------------- the end -----------------



# =======================================================
if ! [ -f output/festive_message_displayed ]; then
  colors=(31 32 33 34 35 36 37)  
  for i in {1..10}; do
    color=${colors[$((i % ${#colors[@]}))]} 
    echo -ne "\033[1;${color}m 🎅🎄 We wish you a merry christmas and a happy new year ! 😊\033[0m\r" 
    sleep 0.7
  done
  touch output/festive_message_displayed
fi
# =======================================================
