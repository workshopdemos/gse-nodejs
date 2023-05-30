#!/bin/bash

echo ">>>>>> start-server.sh: create sequential data set for job"
zowe zos-files create data-set-sequential $HLQ.NJSERVER
sed "s|TARGET_DIR|$TARGET_DIR|g" "$LOCAL_DIR/scripts/templates/job-template.txt" > "$LOCAL_DIR/scripts/job.txt"

echo ">>>>>> start-server.sh: upload job to the data set"
zowe files upload file-to-data-set "$LOCAL_DIR/scripts/job.txt" "$HLQ.NJSERVER" 

echo ">>>>>> start-server.sh: submit job to run the server"
zowe jobs submit data-set "$HLQ.NJSERVER" --vasc > ./output.txt
zowe files delete data-set "$HLQ.NJSERVER" -f

echo ">>>>>> start-server.sh: read run job output"
RESULT="$(grep content ./output.txt)"
if [ -n "$RESULT" ]; then
    echo ">>>>>> start-server.sh: server run fine, deleting output.txt"
    rm ./output.txt
else 
    echo ">>>>>> start-server.sh: server run failed, check output.txt"
fi

# Alternatively, do not wait for the output but test with "curl --head <host>:<port>"