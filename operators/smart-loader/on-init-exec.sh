#!/bin/bash
echo "Executing smart-loader on-init-exec"

source $PRECISION100_OPERATORS_FOLDER/smart-loader/conf/.operator.env.sh
mkdir -p "$PRECISION100_OPERATOR_SMART_LOADER_INPUT_FOLDER"
mkdir -p "$PRECISION100_OPERATOR_SMART_LOADER_LOG_FOLDER"
mkdir -p "$PRECISION100_OPERATOR_SMART_LOADER_BAD_FOLDER"
mkdir -p "$PRECISION100_OPERATOR_SMART_LOADER_CTL_FOLDER"
