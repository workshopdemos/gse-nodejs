#!/bin/bash

# # ==================== Preparing env vars ========================

# zowe_cli_users=$(cat ~/.zowe/zowe.config.json | grep "user" | sed "s/user//g" | sed 's/"//g' | sed "s/,//g" | sed "s/://g") 
# export USER_ID=$(echo $zowe_cli_users | cut -d ' ' -f 1)

user=$(env | grep OWNER_EMAIL | sed 's/@.*//' | sed 's/^.*=//')
value="${user#mfwsuser}"
formatted_value=$(printf "%02d" $value)
export USER_ID="cust0$formatted_value"

if [ -z "$USER_ID" ]; then
    echo "No user id found"
    exit 1 
    # export USER_ID="cust0xx"
fi

export HLQ=$USER_ID
export LOCAL_DIR=/home/developer/gse-nodejs
export MF_HOME_DIR=/u/users/$USER_ID
export TARGET_DIR=$MF_HOME_DIR/server

cd $LOCAL_DIR

# # ================================================================

echo ">>> run.sh: start with quick clean up"
./scripts/cleanup.sh

# # ================================================================

echo ">>> run.sh: prepare, install dependencies, create public dir"
./scripts/prepare.sh

# # ================================================================

echo ">>> run.sh: run local tests (unit/system)"
./scripts/test.sh

# # ================================================================

echo ">>> run.sh: upload server with dependencies to the mainframe"
./scripts/upload.sh

# # ================================================================

echo ">>> run.sh: configure remote mainframe profile to include NODE_HOME to PATH"
./scripts/configure-remote-profile.sh $USER_ID

# # ================================================================

echo ">>> run.sh: run server remotely and wait for job output"
./scripts/start-server.sh

# # ================================================================

# echo ">>> run.sh: full clean up"
# ./scripts/cleanup.sh -f

# # ================================================================

# echo ">>> run.sh: configure Zowe CLI profile"
# ./scripts/configure-zowe-cli.sh $USER_ID
