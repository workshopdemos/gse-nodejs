#!/bin/bash

USER_ID=$1

HOST="10.1.2.73"
ZOSMF_PORT="10443"
SSH_PORT="2022"

zowe config init --user-config --no-prompt
zowe config set "profiles.zosmf.properties.port" "$ZOSMF_PORT" --user-config
zowe config set "profiles.ssh.properties.port" "$SSH_PORT" --user-config
zowe config set "profiles.base.properties.host" "$HOST" --user-config
zowe config set "profiles.base.properties.rejectUnauthorized" "false" --user-config
zowe config set "profiles.base.properties.user" "$USER_ID" --secure false --user-config
zowe config set "profiles.base.properties.password" "$USER_ID" --secure false --user-config