#!/bin/bash

PSQL="psql -X --username=postgres --dbname=periodic_table --no-align --tuples-only -c"

echo -e "\nPlease provide an element as an argument"
read SYMBOL



# if input is not a number then we have to options:
if [[ ! $SYMBOL =~ ^[0-9]+$ ]]
then 
    # if input > 2 letters
    if [[ $(expr length "$SYMBOL") > 2 ]]
    then
        # get data by full name
        DATA=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name='$SYMBOL';")
        if [[ -z $DATA ]]
        then 
            echo "I could not find that element in the database."
        else
            # display data
            echo $DATA
        fi
    else
        # get data by symbol
         DATA=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol ='$SYMBOL';")
        if [[ -z $DATA ]]
        then 
            echo "I could not find that element in the database."
        else
            # display data
            echo $DATA
        fi
    fi
else
    # get data by atomic_numbers
        DATA=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $SYMBOL;")
        if [[ -z $DATA ]]
        then 
            echo "I could not find that element in the database."
        else
            # display data
            echo $DATA
        fi
    
fi

