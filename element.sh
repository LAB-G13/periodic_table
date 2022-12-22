#!/bin/bash
PSQL="psql  --username=freecodecamp --dbname=periodic_table  -t --tuples-only -c"


IMPUT=$1
if [[ -z $IMPUT ]]
then
echo  "Please provide an element as an argument."
exit
fi
if [[ $IMPUT =~ ^[0-9]*$ ]]
then 
JOIN=$($PSQL  "SELECT atomic_number, name, symbol,   type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM  elements JOIN properties USING(atomic_number) JOIN types  USING(type_id) WHERE atomic_number=$IMPUT ")
else
JOIN=$($PSQL  "SELECT atomic_number, name, symbol,   type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM  elements JOIN properties USING(atomic_number) JOIN types  USING(type_id) WHERE  symbol='$IMPUT' OR name='$IMPUT' ")
fi
if [[ -z $JOIN ]]
then 
echo  "I could not find that element in the database."
exit
fi

echo $JOIN | while IFS=" |" read an name symbol type mass mp bp 
do
  echo -e "The element with atomic number $an is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
done
