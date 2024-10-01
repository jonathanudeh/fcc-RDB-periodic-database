#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ARG=$1

if [[ $ARG =~ ^[0-9]+$ ]]
then
  ELEMENTS=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ARG")
else
  ELEMENTS=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$ARG' OR symbol='$ARG'")
fi

if [[ -z $ARG ]]
then
  echo "Please provide an element as an argument."
else
  if [[ -z $ELEMENTS ]]
  then
    echo "I could not find that element in the database."
  else 
      echo $ELEMENTS | while IFS="|" read A_NO NAME SYMBOL TYPE A_MASS MPC BPC
    do
      echo "The element with atomic number $A_NO is $NAME ($SYMBOL). It's a $TYPE, with a mass of $A_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done
  fi 
fi



