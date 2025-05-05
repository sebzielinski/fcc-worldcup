#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.




# clearn database first
echo $($PSQL "TRUNCATE games, teams")
# echo -e "\n$($PSQL "SELECT * FROM teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR == "year" ]]
  then 
    continue 
  fi
  # echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
  
  # insert teams first
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  if [[ -z $WINNER_ID ]]
  then 
    echo Adding $WINNER to teams table
    INSERT_RES=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi
  
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ -z $OPPONENT_ID ]]
  then 
    echo Adding $OPPONENT to teams table
    INSERT_RES=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi
  
  # $INSERT_RES=$($PSQL "INSERT INTO teams (name) VALUES ('FC Barca')")
  # insert games with correct team_ids
  INSERT_RES=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_RES == "INSERT 0 1" ]]
  then
    echo Game inserted into games table
  else
    echo ERROR: $INSERT_RES
  fi
  # $INSERT_RES=$($PSQL "INSERT INTO games (")
done

echo -e "\n$($PSQL "SELECT * FROM games")"

: '
INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES
  (2006, 'Finals', 1, 1, 2, 3);
'

: '
INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES
  ($YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, OPPONENT_GOALS)
'
