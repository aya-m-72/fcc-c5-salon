#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

SHOW_SERVICES() {


SERVICES=$($PSQL "SELECT service_id,name FROM services;")

CHECK=true
while [ $CHECK ]
do

echo "$SERVICES" | while read SERVICE_ID BAR NAME
do
echo $SERVICE_ID\) $NAME
done
echo -e "\nSelect a service number"
read SERVICE_ID_SELECTED

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
if [[ $SERVICE_NAME ]]
then 
  CHECK=''
fi

done

# SERVICE_ID_SELECTED is valid
# customer phone/name
echo -e "\nEnter your phone number"
read CUSTOMER_PHONE
# if phone exists query customer_id if not get name, insert customer and get new id
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
if [[ -z $CUSTOMER_ID ]]
then
echo -e "\nEnter your name"
read CUSTOMER_NAME
INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name,phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE');")
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
fi
# service time
echo -e "\nEnter time"
read SERVICE_TIME
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id,service_id,time) VALUES ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID;")

echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME.\n"
}
SHOW_SERVICES 
