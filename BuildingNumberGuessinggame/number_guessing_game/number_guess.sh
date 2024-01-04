#!/bin/bash

PSQL="psql -X --username=postgres --dbname=number_guess --no-align --tuples-only -c"


echo -e "\nEnter your username:"
read USERNAME

RETURNING_USER=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME'")

if [[ -z $RETURNING_USER ]]
then
    #make a new user
    INSERTED_USER=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
    # greeting existing user
    GAME_PLAYED=$($PSQL "SELECT COUNT(*) FROM games INNER JOIN users USING(user_id) WHERE username = '$USERNAME';")
    BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games INNER JOIN users USING(user_id) WHERE username = '$USERNAME';")
    echo -e "\nWelcome back, $USERNAME! You have played $GAME_PLAYED and your best game took $BEST_GAME guesses."
fi

SECRET_NUMBER=$((1 + RANDOM % 1000))

echo -e "\nGuess the secret number between 1 and 1000"
read GUESS
TRIES=0

while [ ! $GUESS -eq $SECRET_NUMBER ]
do
        ((TRIES++))
        # checking if guess is a valid numbe
        if [[ ! $GUESS =~ ^[0-9]+$ ]]
        then
            # we print a message then number is not valid
            echo -e "\nThat's not an integer, guess again:"
        else
                #
                if [[ $GUESS -lt $SECRET_NUMBER ]]
                then
                    echo -e "\nIt's higher than that, guess again"
                    read GUESS

                # elif [[ $GUESS -lt $SECRET_NUMBER ]]
                # then
                else 
                    echo -e "\nIt's lower than that, guess again"
                    read GUESS
                fi

        fi
        
        
done



echo -e "\nYou guessed it in $TRIES. The secret number was $SECRET_NUMBER"
USERID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
INSERT_RESULTS=$($PSQL "INSERT INTO games(user_id, guesses) VALUES ('$USERID', $TRIES)")

