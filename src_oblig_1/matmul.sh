#!/bin/bash

#Subtask 1
# compiling files so they are ready to run...
javac MatMulASCII.java
javac MatMulBinary.java
gcc toBinary.c -o toBinary

# testing
cat /dev/urandom | od | sed "s/\(.\)/\1 /g" | java MatMulASCII

# prints "Ok, hello"
./toBinary <<< "79 107 44 32 72 101 108 108 111 10"


#Subtask 2 & 3
printf "\nSubtask 2 & 3 \n"

# this function checks if arguments exist, prints error message and exits if not
exist () {
    f="$(basename -- $1)"
    s="$(basename -- $2)"

    if [[ ! -f $1 ]] 
    then 
    echo "File $f file/directory does not exist"
    echo "Here is a list of existing mat files in the folder:"
    # finding every file in working directory that has mat format
    find . -name "*.mat"
    # exit if file does not exist with error code 1 for generall errors 
    exit 1

    # the same if second argument doesen't exist
    elif [[ ! -s $2 ]] 
    then
    echo "File $s file/directory does not exist"
    echo "Here is a list of existing mat files in the folder:"
    find . -name "*.mat"
    exit 1
    fi
}

run_all () {
    # start_tot=$(date +%s%N)
    local sum_time=0
    for i in A*.mat
        do
        for j in B*.mat
            do
            main $i $j 
            sum_time=$(($sum_time + $tid))
        done
    done

    # displaying total time consummed to run every javaprogram in for-loop
    printf "\nTotal/summed time consummed: $sum_time ms\n"

    # Exit normally when done 0 for successful exit
    exit 0
}

# main method that i use to run everything else
main () {
    # using this to check later if arguments are numbers from 0 - 9
    re='^[0-9]+$'

    # if number of arguments is 0 we run every combination available
    if [ $# -eq 0 ];
    then run_all
    fi

    # getting first letter of argument name's
    f="$(basename -- $1)"
    g="$(basename -- $2)"
    ff="$(echo $f | head -c 1)"
    fs="$(echo $g | head -c 1)"

    # i know we should assume that this would not happen, but here's an if that
    # makes sure that script wont run with argument innput of filename and a number
    if [[ $1 =~ $re && ! $2 =~ $re || $2 =~ $re && ! $1 =~ $re ]]
    then
    printf "Syntax error, this script will not accept a number and a file name as innput\nPlease use 2 files or 2 numbers as innput"
    
    # if both arguments are of the same sort aka A & A or B & B the script wont run
    elif [[ $ff == $fs ]]
    then
    
    # error message
    printf "Innput arguments cannot be of same sort\nPlease run script with one matrix A and one matrix B, or none to run every combination there is!\n"
    
    # exit with error code 1 for generall errors...
    exit 1

    # if both arguments are nubers, we assume that order of innput arguments are A then B
    elif [[ $1 =~ $re && $2 =~ $re ]];
    then 
    exist A$1.mat B$2.mat

    # starttime
    start=$(date +%s%N)

    cat A$1.mat B$2.mat | ./toBinary | java MatMulBinary;

    # endtime we also save time consummed to run the code as an variable, 
    # using it to print as well
    end=$(date +%s%N)
    tid=$(($(($end-$start))/1000000))
    echo "Java runtime: $tid ms"
    
    # if first argument is a B matrix, we run main function with opposite order of innput arguments
    elif [[ $ff == "B" ]];
    then
    exist $2 $1 

    start=$(date +%s%N)

    cat $2 $1 | ./toBinary | java MatMulBinary;

    end=$(date +%s%N)
    tid=$(($(($end-$start))/1000000))
    echo "Java runtime: $tid ms"

    else
    exist $1 $2

    start=$(date +%s%N)

    cat $1 $2 | ./toBinary | java MatMulBinary;

    end=$(date +%s%N)
    tid=$(($(($end-$start))/1000000))
    echo "Java runtime: $tid ms"

    fi
}

# checking if quantity of innput arguments satisfies mine script
if [[ $# -eq 1 || $# -gt 2 ]];
    then printf "You have given wrong quantity of arguments!\nPlease use 2 arguments as innput or none to use every combination there is!\n";
    exit 1
fi

# running main
main $1 $2

# exit normally... when done exit code 0
exit 0