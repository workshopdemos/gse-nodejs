#!/bin/bash

USER_ID=$1

export LOCAL_DIR=/home/developer/gse-nodejs
export MF_HOME_DIR=/u/users/$USER_ID

zowe files ul ftu "$LOCAL_DIR/scripts/templates/profile-template.txt" "$MF_HOME_DIR/.profile"