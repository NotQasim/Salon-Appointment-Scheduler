#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon ~~~~~\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nWelcome! Here are the services we offer:"
  echo -e "\n1) Haircut\n2) Facial\n3) Pedicure"
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]+$ ]]
  then
    MAIN_MENU "Please input a valid service number."
  else
    SERVICE_NAME_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
    
    echo -e "\nPlease enter your phone number:"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nWhat is your name?"
      read CUSTOMER_NAME

      INSERTED_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
    fi
    if [[ -z $CUSTOMER_ID ]]
    then
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
    fi

    echo -e "\nWhat time would you like your $SERVICE_NAME_SELECTED, $CUSTOMER_NAME?"
    read SERVICE_TIME 

    MADE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, time, service_id) VALUES ($CUSTOMER_ID, '$SERVICE_TIME', $SERVICE_ID_SELECTED);")

    echo -e "\nI have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU
