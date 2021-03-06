CONTAINER=$1
FILE_NAME=$(echo $2 | cut -d ',' -f 2)
FILE_TYPE=$(echo $2 | cut -d ',' -f 3)
TABLE_NAME=$(echo $2 | cut -d ',' -f 4)
COL_SEP=$(echo $2 | cut -d ',' -f 5)
CONNECTION_NAME=$(echo $2 | cut -d ',' -f 6)

if test "$PRECISION100_RUNTIME_SIMULATION_MODE" = "TRUE"; then
   echo "        START SQL ADAPTOR $PRECISION100_EXECUTION_CONTAINER_FOLDER/$CONTAINER/$FILE_NAME"
   sleep $PRECISION100_RUNTIME_SIMULATION_SLEEP;
   echo "        END SQL ADAPTOR $PRECISION100_EXECUTION_CONTAINER_FOLDER/$CONTAINER/$FILE_NAME"
   exit;
fi

echo "        START SQL ADAPTOR $PRECISION100_EXECUTION_CONTAINER_FOLDER/$CONTAINER/$FILE_NAME"
source $PRECISION100_OPERATORS_FOLDER/psql/conf/.operator.env.sh

CONNECTION_STRING=$($PRECISION100_BIN_FOLDER/get-connection-string.sh "$CONNECTION_NAME")

$PRECISION100_BIN_FOLDER/audit.sh  $0 "PRE-LOADER" "$CONTAINER / $FILE_NAME" "P-CSV-LOADER" $0 "START"

DELIMITER=${COL_SEP:-,}

psql "$CONNECTION_STRING" << LOADER_CMD
\COPY $TABLE_NAME FROM '$PRECISION100_EXECUTION_CONTAINER_FOLDER/$CONTAINER/$FILE_NAME' DELIMITER '$DELIMITER' CSV
LOADER_CMD

$PRECISION100_BIN_FOLDER/audit.sh  $0 "POST-LOADER" "$CONTAINER / $FILE_NAME" "P-CSV-LOADER" $0 "END"

echo "        END SQL ADAPTOR $PRECISION100_EXECUTION_CONTAINER_FOLDER/$CONTAINER/$FILE_NAME"
