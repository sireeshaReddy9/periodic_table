#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Check if input is number
if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, p.type_id, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type
                   FROM elements e 
                   JOIN properties p USING(atomic_number) 
                   JOIN types t USING(type_id) 
                   WHERE e.atomic_number=$1")
else
  ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, p.type_id, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type
                   FROM elements e 
                   JOIN properties p USING(atomic_number) 
                   JOIN types t USING(type_id) 
                   WHERE e.symbol='$1' OR e.name='$1'")
fi

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
else
  IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE_ID MASS MELT BOIL TYPE <<< "$ELEMENT"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
fi
# Script for periodic table lookup
