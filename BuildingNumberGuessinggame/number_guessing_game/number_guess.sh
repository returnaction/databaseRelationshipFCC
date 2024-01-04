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
    GAME_PLAYED=$($PSQL "SELECT COUNT(*) FROM games INNER JOIN using(user_id) WHERE username = $USERNAME;")
    BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games INNER JOIN USING(user_id) WHERE username = $USERNAME;")
    echo -e "\nWelcome back, $USERNAME! You have played $GAME_PLAYED and your best game took $BEST_GAME guesses."
fi

RANDOM_NUMBER=$((1 + RANDOM % 1000))
echo -e "\nGuess the secret number between 1 and 1000"
read 
