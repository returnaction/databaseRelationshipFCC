#!/bin/bash

PSQL="psql -X --username=postgres --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"

echo -e "\nWelcome to My Salon, how can I help you?"

MAIN_MENU(){
    if [[ $1 ]]
    then 
        echo -e "\n$1"
    fi

    SERVICES=$($PSQL "SELECT * FROM service;")

    echo "$SERVICES" | while read SERVICE_ID BAR NAME
    do
        echo $SERVICE_ID $NAME
    done

    read SERVICE_SELECTION
    SERVICE_AVAILABILITY=$($PSQL "SELECT name FROM service WHERE service_id = '$SERVICE_SELECTION'")
    
    if [[ -z $SERVICE_AVAILABILITY ]]
    then
        MAIN_MENU "I could not find that service. What would you like today?"      
    else
        echo -e "\nWhat is your phone number?"
        read PHONE_NUMBER

        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$PHONE_NUMBER'")

        if [[ -z $CUSTOMER_NAME ]]
        then 
            echo -e "I don't have a record for that  phone number, what's your name?"
            read CUSTOMER_NAME
            INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$PHONE_NUMBER', '$CUSTOMER_NAME')")
        fi

        APPOINTMENT_CREATE 

    fi
}

APPOINTMENT_CREATE(){
        echo -e "\nWhat time would you like your $SERVICE_AVAILABILITY, $CUSTOMER_NAME?"
        read TIME      
            
        if [[ -z $TIME ]]
        then 
        echo "You need to provide a time"
        APPOINTMENT_CREATE
        else
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")
        INSERTED=$($PSQL "INSERT INTO appointments (customer_id, time, service_id) VALUES ($CUSTOMER_ID, '$TIME', $SERVICE_SELECTION)")
        echo -e "\nI have put you down for a $SERVICE_AVAILABILITY at $TIME, $CUSTOMER_NAME"
        fi
}

EXIT(){
    echo -e "\nThank  you for using our salon"
}

MAIN_MENU