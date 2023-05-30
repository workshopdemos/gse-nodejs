#!/bin/bash

full=false

while getopts "f" opt; do
    case $opt in 
        f) 
            full=true
            ;;
        \?)
            echo "Invalid option"
            exit 1
            ;;
    esac
done

echo ">>>>>> cleanup.sh: start clean up"

if [ -d "./public" ]; then
    echo ">>>>>> cleanup.sh: found ./public, removing..."
    rm -r ./public
fi

if [ -d "./coverage" ]; then
    echo ">>>>>> cleanup.sh: found ./coverage, removing..."
    rm -r ./coverage
fi

if [ -d "./node_modules" ]; then
    echo ">>>>>> cleanup.sh: found ./node_modules, removing..."
    rm -r ./node_modules
fi

if [ -f "./server.tar" ]; then
    echo ">>>>>> cleanup.sh: found ./server.tar, removing..."
    rm ./server.tar
fi

if [ -f "./scripts/job.txt" ]; then
    echo ">>>>>> cleanup.sh: found ./scripts/job.txt, removing..."
    rm ./scripts/job.txt
fi

if [ -f "./src/run.sh" ]; then
    echo ">>>>>> cleanup.sh: found ./src/run.sh, removing..."
    rm ./src/run.sh
fi

if $full; then
    echo ">>>>>> cleanup.sh: clean up USS and DS" 
    zowe_cli_users=$(cat ~/.zowe/zowe.config.json | grep "user" | sed "s/user//g" | sed 's/"//g' | sed "s/,//g" | sed "s/://g") 
    USER_ID=$(echo $zowe_cli_users | cut -d ' ' -f 1)
    HLQ=$USER_ID
    MF_HOME_DIR=/u/users/$USER_ID
    TARGET_DIR=$MF_HOME_DIR/server
    zowe uss iss ssh "rm -r ${TARGET_DIR} 2>/dev/null"
    zowe files delete data-set "$HLQ.NJSERVER" -f
    zowe files delete uss-file "$MF_HOME_DIR/.profile"
fi

echo ">>>>>> cleanup.sh: clean up done"