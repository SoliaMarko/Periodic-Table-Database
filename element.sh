#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else 
  ELEMENT=""
  # if numeric 
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # find by atomic number
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number = '$1'")
  else
    # find by symbol or name
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol = '$1' OR name = '$1'")
  fi

  if [[ ! -z $ELEMENT ]]
  then
    read ATOMIC_NUMBER BAR SYMBOL BAR NAME <<< "$ELEMENT"

    PROPERTIES=$($PSQL "SELECT * FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      
    read ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE_ID <<< "$PROPERTIES" 

    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = '$TYPE_ID'")

    TYPE_FORMATTED=$(echo $TYPE | sed 's/ //')
      
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE_FORMATTED, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      
  else
    echo "I could not find that element in the database."
  fi
fi
