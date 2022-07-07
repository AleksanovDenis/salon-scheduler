#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SHOW_SERVICE_LIST_MENU(){
  echo -e "\nPlease select service you need to:"
  #show list of all services
  SERVICE_LIST=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICE_LIST" | while read SERVICE_ID BAR SERVICE_NAME 
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
}

SHOW_SERVICE_LIST_MENU

read SERVICE_ID_SELECTED
#if selected service id is not a number
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
    #show servise list
    SHOW_SERVICE_LIST_MENU
else
  #check if service exists
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]
  then
    #if service not found, show servise list
    SHOW_SERVICE_LIST_MENU
  else
    #get customer info
    echo -e "\nPlease enter your phone number:"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    #if customer not found
    if [[ -z $CUSTOMER_NAME ]]
    then
      # get new customer name
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME
      # insert new customer
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
    #get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    #get service time
    echo -e "\nEnter time you want to get service:"
    read SERVICE_TIME

  fi
fi

#create appointment record
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."




