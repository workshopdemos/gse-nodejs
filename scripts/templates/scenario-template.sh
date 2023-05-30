# TODO: Split to tasks, clean - install - test | - run locally - verify with curl ?
#                                              | - run on MF - pack - send - run - verify

# zowe_cli_users=$(cat ~/.zowe/zowe.config.json | grep "user" | sed "s/user//g" | sed 's/"//g' | sed "s/,//g" | sed "s/://g") 

# export USER_ID=$(echo $zowe_cli_users | cut -d ' ' -f 1)
# echo $USER_ID
# export HLQ=$USER_ID

# export LOCAL_DIR=/home/developer/gse-nodejs
# export TARGET_DIR=/u/users/$USER_ID/server

# cd $LOCAL_DIR


# # ========


# echo ">>> prepare.sh: start with clean up"
# ./scripts/cleanup.sh


# # ========


# echo ">>> prepare.sh: npm install"
# npm install 
# mkdir ./public
# echo "Blank" > ./public/index.html


# # ========


# echo ">>> prepare.sh: run tests"
# npm run test 

# echo ">>> prepare.sh: make coverage report to be UI for server"
# rm ./public/*
# cp -r ./coverage/lcov-report/* ./public/
# rm -r ./public/*.png


# # ========


# echo ">>> prepare.sh: update server location in run script"
# sed "s|TARGET_DIR|$TARGET_DIR|g" "$LOCAL_DIR/scripts/run-template.sh" > "$LOCAL_DIR/src/run.sh"

# echo ">>> prepare.sh: create a tar archive"
# tar -cf server.tar src node_modules public package.json package-lock.json

# echo ">>> prepare.sh: upload to ${TARGET_DIR}/server.tar"
# zowe uss iss ssh "rm -r ${TARGET_DIR} 2>/dev/null"
# zowe uss iss ssh "mkdir ${TARGET_DIR}" 
# zowe files ul ftu -b "server.tar" "${TARGET_DIR}/server.tar"

# # Wrap every command with echo as it is silent
# echo ">>> prepare.sh: extract and remove ${TARGET_DIR}/server.tar"
# zowe uss iss ssh "tar -xf server.tar 2>/dev/null" --cwd $TARGET_DIR
# zowe uss iss ssh "rm server.tar 2>/dev/null" --cwd $TARGET_DIR

# echo ">>> prepare.sh: update files permissions"
# zowe uss iss ssh "chown -R $USER_ID ./ 2>/dev/null" --cwd $TARGET_DIR
# zowe uss iss ssh "chtag -tRc ISO8859-1 ./ 2>/dev/null" --cwd $TARGET_DIR
# zowe uss iss ssh "chmod +x ./src/run.sh 2>/dev/null" --cwd $TARGET_DIR


# # ========


# echo ">>> prepare.sh: create and submit job to start the server"
# zowe zos-files create data-set-sequential $HLQ.NJSERVER
# sed "s|TARGET_DIR|$TARGET_DIR|g" "$LOCAL_DIR/scripts/job-template.txt" > "$LOCAL_DIR/scripts/job.txt"
# zowe files upload file-to-data-set "$LOCAL_DIR/scripts/job.txt" "$HLQ.NJSERVER" 
# zowe jobs submit data-set "$HLQ.NJSERVER" --vasc > ./output.txt
# zowe files delete data-set "$HLQ.NJSERVER" -f

# echo ">>> prepare.sh: read run output"
# RESULT="$(grep content ./output.txt)"
# if [ -n "$RESULT" ]; then
#     echo ">>> prepare.sh: server run fine"
#     rm ./output.txt
# else 
#     echo ">>> prepare.sh: server run failed, check output.txt"
# fi

# Alternatively, do not wait for the output but test with "curl --head <host>:<port>"


# # ========


# echo ">>> prepare.sh: end with clean up"
# ./scripts/cleanup.sh