#!/bin/bash
GREEN='\033[1;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
ORANGE='\033[0;33m'
NC='\033[0m'
CHECK='\xE2\x9C\x94'
CROSS='\xE2\x9C\x97'
BIG_CROSS='\xE2\x9D\x8C'
SMILE='\xE2\x98\xBB'
PENDING='\xE2\x86\x92'
SRC="src"

# if [ -z "$2" ]
#   then
#     # Only remove the src if this is not a production release.  This should cut down on time regenerating zip
#     # files.
#     if [ $PRODUCTION_RELEASE == "no" ]; then
#       rm -rf dist/${1}/src/*
#     fi
#     printf "\n${CYAN}Packaging all Functions in SRC for Lambda ...${NC}\n"
#     for path in ${SRC}/*; do
#       [ -d "${path}" ] || continue # if not a directory, skip
#       dirname="$(basename "${path}")"
#       printf " ${ORANGE}${PENDING}${NC} Packaging '${dirname}' for Lambda ... "
#       FILE="./dist/${1}/src/${dirname}.zip"
#       if test -f "$FILE"; then
#         printf "\r ${GREEN}${CHECK}${NC} Packaging '${dirname}' for Lambda ... ${GREEN}EXISTS${NC}\n"
#       else
#         ./bin/package/install-and-prune.sh $1 $dirname ${SRC}/
#         PACKAGE_RESULT=$?
#         if [ $PACKAGE_RESULT == "0" ]; then
#           printf "\r ${GREEN}${CHECK}${NC} Packaging '${dirname}' for Lambda ... ${GREEN}DONE${NC}\n"
#         else
#           printf "\r ${RED}${CROSS}${NC} Packaging '${dirname}' for Lambda ... ${RED}FAILED${NC}\n"
#           exit 1 
#         fi
#       fi
#     done
# else
#  rm -f dist/${1}/src/${2}.zip
#   if [ -d "${SRC}/$2" ]; then
#     printf " ${ORANGE}${PENDING}${NC} Packaging '${2}' for Lambda ... "
    rm -rf dist/${1}/src/*
    ./bin/install-and-prune.sh $1 /
#     PACKAGE_RESULT=$?
#     if [ $PACKAGE_RESULT == "0" ]; then
#        printf "\r ${GREEN}${CHECK}${NC} Packaging '${2}' for Lambda ... ${GREEN}DONE${NC}\n"
#     else
#        printf "\r ${RED}${CROSS}${NC} Packaging '${2}' for Lambda ... ${RED}FAILED${NC}\n"
#        exit 1 
#     fi
#   else
#     echo "$2 does not exist"
#   fi
# fi
printf "\n ${GREEN}${SMILE} All functions packaged!${NC}\n\n"
exit 0