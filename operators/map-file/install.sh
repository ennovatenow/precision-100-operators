OPERATOR_NAME=map-file
echo "Installing $OPERATOR_NAME operator"

CONNECTION_NAME=$PRECISION100_PROJECT_DEFAULT_CONNECTION
CONNECTION_STRING=$($PRECISION100_BIN_FOLDER/get-connection-string.sh $CONNECTION_NAME)

sqlplus -s /nolog << EOF
CONNECT $CONNECTION_STRING
@$PRECISION100_OPERATORS_FOLDER/map-file/sql/O_TAB_COLUMNS.sql
@$PRECISION100_OPERATORS_FOLDER/map-file/sql/TRANSFORM_INTERCEPTOR.sql
EOF
