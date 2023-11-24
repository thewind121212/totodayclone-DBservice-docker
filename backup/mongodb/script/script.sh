#!/bin/bash

sleep 25

HOST1="mongodb-repl1:27017"
HOST2="mongodb-repl2:27017"
URI="mongodb://adminLinh:linhporo1@localhost:27017"


# Define ANSI color codes
RED='\033[0;31m'      # Red
GREEN='\033[0;32m'    # Green
YELLOW='\033[0;33m'   # Yellow
PURPLE='\033[0;35m'   # Purple
RESET='\033[0m'       # Reset color

echo -e "${PURPLE}------Ping relp mongo server for intial${RESET}"


 checkMongoOk() {
   mongosh $1 --eval "db.runCommand({ ping: 1 })" | grep "{ ok: 1 }"
   local status=$?
    if [ $? -eq 0 ]; then 
   echo -e "${GREEN}+your mongodb repl server $1 is running${RESET}"
    else
   echo -e "${YELLOW}+your mongodb repl server $1 waiting for startup ${RESET}"
    fi
   return $status
 }


 until checkMongoOk $HOST1 && checkMongoOk $HOST2; do
   echo -e "${RED}+Both repl still not run waiting for ruining${RESET}"
   echo -e "${GREEN}+Retring...${RESET}"
   sleep 5
 done


echo -e "${GREEN}+Both repl mongodb server running${RESET}"

echo -e "${PURPLE}------Replicant init for mongodb${RESET}"

sleep 10

  initiateRepl() {
mongosh -u adminLinh -p linhporo1 --eval '
   rs.initiate(
      {
         _id: "totodayrs",
         members: [
            { _id: 0, host: "mongodb-primary:27017" },
            { _id: 1, host: "mongodb-repl1:27017" },
            { _id: 2, host: "mongodb-repl2:27017" }
         ]
      }
   )
'

    local status=$?
    if [ $status -eq 0 ]; then 
   echo -e "${GREEN}+Set repl complete${RESET}"
    else
   echo -e "${RED}+SEt repl fail ${RESET}"
   return status
    fi
  }


until initiateRepl; do
  echo -e "${GREEN} run again"
  echo -e "${PURPLE} run again"
done


sleep 60 

echo -e "${PURPLE}------Restore Data${RESET}"

  restoreData() {
    mongorestore --uri "$URI" /backup 
    local status=$?
    if [ $status -eq 0 ]; then 
   echo -e "${GREEN}+Backup Complete${RESET}"
    else
   echo -e "${RED}+Backup Fail${RESET}"
    fi
  }

  restoreData


echo -e "${PURPLE}------Complete${RESET}"






