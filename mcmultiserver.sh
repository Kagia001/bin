#! /bin/bash

# mcmultiserver add servername jar 
# mcmultiserver run servername


# Configuration file lodation
CONFIG_FILE="$HOME/.config/mcmultiserver.conf"

# Folder whidh contains all servers
SERVER_FOLDER=$(crudini --get $CONFIG_FILE options server_folder)
SERVER_FOLDER="${SERVER_FOLDER/#\~/$HOME}"
TASK=$1
echo "$TASK"

if [ "$TASK" == "add" ]
then
    echo "add"
    SERVER_NAME=$2
    JAR_LOCATION=$3
    [ -n "$SERVER_NAME" ] && [ -n "$JAR_LOCATION"] || echo "add needs two inputs"
    crudini --set $CONFIG_FILE $SERVER_NAME jar_location $JAR_LOCATION
elif [ "$TASK" == "run" ]
then
    echo "run"
    SERVER_NAME=$2
    
    JAR_LOCATION=$(crudini --get $CONFIG_FILE $SERVER_NAME jar_location)

    JAR=$(basename $JAR_LOCATION)
    SERVER=$(dirname $JAR_LOCATION)
    RAM="-Xmx$(crudini --get $CONFIG_FILE options allocated_ram)G"

    if [ $(crudini --get $CONFIG_FILE options nogui) == "yes" ]
    then 
        NOGUI="--nogui"
    else
        NOGUI=""
    fi

    (cd $SERVER_FOLDER/$SERVER && java $RAM -jar $JAR $NOGUI)
else
    echo "$TASK is not a supported argument. Supported argunents are \'task\', \'run\'"
fi