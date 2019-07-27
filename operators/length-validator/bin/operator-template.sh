#!/bin/bash

CONTAINER=$1
INDEX=$(echo $2 | cut -d ',' -f 1)
FILE_NAME=$(echo $2 | cut -d ',' -f 2)
FILE_TYPE=$(echo $2 | cut -d ',' -f 3)
VIEW_NAME=$(echo $2 | cut -d ',' -f 4)
CONNECTION_NAME=$(echo $2 | cut -d ',' -f 5)

echo "        START LENGTH-VALIDATOR ADAPTOR $FILE_NAME"

if test "$PRECISION100_RUNTIME_SIMULATION_MODE" = "TRUE"; then
   sleep $PRECISION100_RUNTIME_SIMULATION_SLEEP;
   echo "        END LENGTH-VALIDATOR ADAPTOR $FILE_NAME"
   exit;
fi

source $PRECISION100_OPERATORS_FOLDER/length-validator/conf/.operator.env.sh
mkdir -p $PRECISION100_OPERATOR_LENGTH_VALIDATOR_WORK_FOLDER;

if [[ -z "$VIEW_NAME" ]]; then
  VIEW_NAME="${DEFAULT_VIEW_PREFIX:-V}_${FILE_NAME}_${DEFAULT_VIEW_SUFFIX:-L}"
fi

CONNECTION_STRING=$($PRECISION100_BIN_FOLDER/get-connection-string.sh "$CONNECTION_NAME")

$PRECISION100_BIN_FOLDER/audit.sh  $0 "PRE-LENGTH-VALIDATOR" "$CONTAINER / $FILE_NAME" "LENGTH-VALIDATOR" $0 "START"

echo "        LENGTH-VALIDATOR ADAPTOR CREATING VIEW SCRIPT"
$PRECISION100_OPERATORS_FOLDER/length-validator/bin/length-validator-generator.sh $FILE_NAME $VIEW_NAME $CONNECTION_STRING > $LENGTH_VALIDATOR_WORK_FOLDER/$VIEW_NAME.sql

echo "        LENGTH-VALIDATOR ADAPTOR EXECUTING SCRIPTS"
sqlplus -s /nolog << EOL 
CONNECT $CONNECTION_STRING
SET FEEDBACK OFF

@$LENGTH_VALIDATOR_WORK_FOLDER/$VIEW_NAME.sql

EOL

$PRECISION100_BIN_FOLDER/audit.sh  $0 "POST-LENGTH-VALIDATOR" "$CONTAINER / $FILE_NAME" "LENGTH-VALIDATOR" $0 "END"

echo "        END LENGTH-VALIDATOR ADAPTOR $FILE_NAME"
