#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi



#check if argument inserted is an atomic number
if [[ $1 =~ ^[1-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = '$1'")
else
#check if argument inserted is an element name or symbol
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1' or name = '$1'")
fi



#if cannot find element in the database
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi



#print out details
echo $ELEMENT | while IFS=" |" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT 
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
