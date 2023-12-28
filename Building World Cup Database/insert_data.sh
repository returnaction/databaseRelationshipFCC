#! /bin/bash

if [[ $1 == "test" ]]
then
    PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
    PSQL="psql --username=postgres --dbname=worldcup -t --no-align -c"
fi

# Do not change any code above this line.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
    if [[ $YEAR != year ]]
    then
        #insert teams into teams table

        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

        # if WINNER_ID not found then we insert it

        if [[ -z $WINNER_ID ]]
        then
            INSERT_WINNER_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
            if [[ $INSERT_WINNER_ID_RESULT == 'INSERT 0 1' ]]
            then 
                echo $WINNER inserted into teams;
            fi

            WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        fi

        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

         # if OPPONENT_ID not found then we insert it
        if [[ -z $OPPONENT_ID ]]
        then
            INSERT_OPPONENT_ID_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
            if [[ $INSERT_OPPONENT_ID_RESULT == 'INSERT 0 1' ]]
            then 
                echo $OPPONENT inserted into teams;
            fi
            
            OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        fi
    fi
done

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
    if [[ $YEAR != year ]]
    then
        #get winner id

        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

        INSERT_INTO_GAMES_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")

        if [[ $INSERT_INTO_GAMES_RESULT == "INSERT 0 1" ]]
        then
            echo Inserted into games table values: YEAR = $YEAR , ROUND = $ROUND, WINNER ID = $WINNER_ID, OPPONENT ID = $OPPONENT_ID, WINNER GOALS = $WINNER_GOALS, OPPONENT GOALS = $OPPONENT_GOALS ;
        fi

    fi

done



