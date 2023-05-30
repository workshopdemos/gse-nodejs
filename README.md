# GSE NodeJS

This project demonstrates how to build and test a primitive Node.js server and then deploy and run it on the mainframe using Zowe CLI.

To open the terminal window use the menu in the top left corner > “Terminal” > “New Terminal”

## Prerequisites

Before getting started, ensure you have the following prerequisites:

- Zowe CLI is installed and the profile is configured. This part should be done already, if not, we will need to manually [install Zowe CLI](https://docs.zowe.org/stable/user-guide/cli-installcli) and run ```scripts/configure-zowe-cli.sh <user-id>``` to configure the local profile.

- Node.js is installed on zDNT and is accessible in PATH, at the moment it is not included in the PATH, so we should create a basic ```.profile``` for the user by running ```scripts/configure-remote-profile.sh <user-id>```


## Installation

This demo describes the automation case, so all the tasks could be done by running one command:
```bash
npm run start
```
Automation in detail is represented by a set of scripts under ```scripts/*```

For testing purposes or to try the Node JS server locally, use these commands:
```bash
npm install
npm run test
npm run start-dev
```


## Deployment and Execution on Mainframe

After the server files are built locally the automation script packs server source code with dependencies to the server.tar and then sends it to the user's home directory on the mainframe using Zowe CLI. 

<details>
  <summary>Script</summary>

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

</details><br>

As a result ```/u/users/<user-id>/server``` folder is created in USS.

Then we define a job to start the server, upload it to the dataset, submit, and wait for the output.

<details>
  <summary>Script</summary>

    echo ">>>>>> start-server.sh: create sequential data set for job"
    zowe zos-files create data-set-sequential $HLQ.NJSERVER
    sed "s|TARGET_DIR|$TARGET_DIR|g" "$LOCAL_DIR/scripts/templates/job-template.txt" > "$LOCAL_DIR/scripts/job.txt"

    echo ">>>>>> start-server.sh: upload job to the data set"
    zowe files upload file-to-data-set "$LOCAL_DIR/scripts/job.txt" "$HLQ.NJSERVER" 

    echo ">>>>>> start-server.sh: submit job to run the server"
    zowe jobs submit data-set "$HLQ.NJSERVER" --vasc > ./output.txt
    zowe files delete data-set "$HLQ.NJSERVER" -f

</details><br>

In this step, we create ```<user-id>.NJSERVER``` data set containing job to start the server and submit it. 
For the demo purposes server will run for 60 seconds and stop automatically, then delete the dataset.
While the server is running, we can check it is up by running the cURL command 
```curl --head 10.1.2.73:60111```


## Conclusion

This demo scenario shows how to use a combination of NodeJS, bash, and Zowe CLI commands to provision the lifecycle of a simple Node JS server and can be used as a startup or reference point for creating a development pipeline. 

For more information on Zowe CLI and its capabilities, refer to the official Zowe documentation: [Zowe CLI Documentation](https://docs.zowe.org/stable/user-guide/cli-using-usingcli)
