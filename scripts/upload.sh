#!/bin/bash

echo ">>>>>> upload.sh: update server location in run script"
sed "s|TARGET_DIR|$TARGET_DIR|g" "$LOCAL_DIR/scripts/templates/run-template.sh" > "$LOCAL_DIR/src/run.sh"

echo ">>>>>> upload.sh: create a tar archive"
tar -cf server.tar src node_modules public package.json package-lock.json

echo ">>>>>> upload.sh: upload the archive to ${TARGET_DIR}/server.tar"
zowe uss iss ssh "rm -r ${TARGET_DIR} 2>/dev/null"
zowe uss iss ssh "mkdir ${TARGET_DIR}" 
zowe files ul ftu -b "server.tar" "${TARGET_DIR}/server.tar"

echo ">>>>>> upload.sh: extract and remove ${TARGET_DIR}/server.tar"
zowe uss iss ssh "tar -xf server.tar 2>/dev/null" --cwd $TARGET_DIR
zowe uss iss ssh "rm server.tar 2>/dev/null" --cwd $TARGET_DIR

echo ">>>>>> upload.sh: update files permissions"
zowe uss iss ssh "chown -R $USER_ID ./ 2>/dev/null" --cwd $TARGET_DIR
zowe uss iss ssh "chtag -tRc ISO8859-1 ./ 2>/dev/null" --cwd $TARGET_DIR
zowe uss iss ssh "chmod +x ./src/run.sh 2>/dev/null" --cwd $TARGET_DIR