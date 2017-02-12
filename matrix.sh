#!/bin/bash

function get_char {
    RANDOM_U=$(echo $(( (RANDOM % 9) + 0)));
    RANDOM_D=$(echo $(( (RANDOM % 9) + 0)));
    
    #https://unicode-table.com/en/#kangxi-radicals
    CHAR_TYPE="\u2F"

    printf "%s" "$CHAR_TYPE$RANDOM_D$RANDOM_U";
}


function cursor_position {
    echo "\033[$1;${RANDOM_COLUMN}H";
}

function write_char {
    CHAR=$(get_char);
    print_char $1 $2 $CHAR
}

function erase_char { 
    CHAR="\u0020" #Space char
    print_char $1 $2 $CHAR
}

function print_char {
    CURSOR=$(cursor_position $1);
    echo -e "$CURSOR$2$3";
}


function draw_line {
    
    N_LINE=$(( $(tput lines) - 1));
    N_COLUMN=$(tput cols);
    RANDOM_COLUMN=$[RANDOM % $N_COLUMN];
    RANDOM_LINE_SIZE=$[RANDOM % $N_LINE];
    SPEED=0.03

    
    COLOR="\033[32m"; #GREEN
    COLOR_HEAD="\033[37m"; #WHITE

    #Draw Line
    for i in $(seq 1 $N_LINE ); do 
        write_char $[i-1] $COLOR;
        write_char $i $COLOR_HEAD;
        sleep $SPEED;
        if [ $i -ge $RANDOM_LINE_SIZE ]; then 
            erase_char $[i-RANDOM_LINE_SIZE]; 
        fi;
    done;

    #Erase Line
    for i in $(seq $[i-$RANDOM_LINE_SIZE] $N_LINE); do 
        erase_char $i
        sleep $SPEED;
    done
}

function matrix {
    tput setab 0 #Background Black
    clear
    while true; do
        draw_line & #Parallel
        sleep 0.6;
    done
}

matrix;