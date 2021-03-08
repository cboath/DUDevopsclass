#!/bin/bash
# Color codes.
GREEN='\033[1;32m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
# Setting up some polling flags.
# Should the API be polled? This should be determined by the inclusion of a --poll or -p in the command.
POLL=false
# Check the command and see if the "Poll" flag was provided at runtime.
if [[ $* == *--poll* || $* == *-p* ]]; then 
    printf "\n${CYAN}Polling has been requested.  Cancel with 'Ctrl-C'.${NC}\n\n"
    POLL=true
fi
# Has the API called happene at least once.  This is because we want the API to be queried as least once.
RAN_ONCE=false
# These are poll-control flags.  We don't want to continue polling the API if the stack has reached an "end" state. Those being
# completed or failed states.
STACK_COMPLETE=false
STACK_FAILED=false
# Spinnger settings.
SPINNER_CHARS_INDEX=1
SPINNER_CHARS="/-\|"
# We will poll the API as long as:
# 1. We haven't polled it yet.
# 2. We need to poll it again because it hasn't reached an "end" state and polling was requested at runtime.
while [[ ($RAN_ONCE == "false" || $POLL == "true") && $STACK_COMPLETE == "false" && $STACK_FAILED == "false"  ]]
do
    # Query the API for the stack details.
    STACK_JSON=$(aws cloudformation describe-stacks --stack-name ${STACK_NAME})
    # Parse the current release from the stack outputs.
    #RELEASE=$(echo ${STACK_JSON} | jq '.Stacks[0].Outputs[0].OutputValue'  | tr -d \")
    # Parse the current release branch from the stack outpus.
    #BRANCH=$(echo ${STACK_JSON} | jq '.Stacks[0].Outputs[1].OutputValue'  | tr -d \")
    # Parse the status of the branch.
    STATUS=$(echo ${STACK_JSON} ) #| jq '.Stacks[0].StackStatus' | tr -d \") 
    # Default color for messages.
    STATUS_COLOR=$GREEN
    # This needs to be RED even though its a "COMPLETE".  Because this should be considered a call to action.
    if [[ $STATUS == "ROLLBACK_COMPLETE" ]]; then 
        STATUS_COLOR=$RED
        STACK_COMPLETE=true
    elif [[ $STATUS == *"_FAILED" ]]; then      # Anything that fails is a call to action.
        STATUS_COLOR=$RED
        STACK_FAILED=true
    elif [[ $STATUS == *"_IN_PROGRESS" ]]; then # Should show anything that is in progress as indicator.
        STATUS_COLOR=$ORANGE
    elif [[ $STATUS == *"_COMPLETE" ]]; then    # Anything that is complete (other than rollback) is a good thing; show in green.
        STATUS_COLOR=$GREEN
        STACK_COMPLETE=true
    fi
    # Print a spinner to show progress.
    printf "\r${SPINNER_CHARS:SPINNER_CHARS_INDEX++%${#SPINNER_CHARS}:1} Stack Status: ${STATUS_COLOR}${STATUS}${NC}"
    # Print the formated message.
    # printf "\r\nCurrent Stack Release: \n\nVersion: ${MAGENTA}${RELEASE}${NC} \n Branch: ${MAGENTA}${BRANCH}${NC}\n Status: ${STATUS_COLOR}${STATUS}${NC}\n\n"
    RAN_ONCE=true
    # Only sleep or pause if polling is enabled and the stack as NOT reached an "end" state.
    if [[ $POLL == "true" && $STACK_COMPLETE == "false" && $STACK_FAILED == "false" ]]; then
        sleep 1
    fi
done
# Print the final status over top the last status update.
STRING_REPEAT=$(printf "%-50s" " ")
printf "\rCurrent Stack Release${STRING_REPEAT// / }\n\nVersion: ${MAGENTA}${RELEASE}${NC} \n Branch: ${MAGENTA}${BRANCH}${NC}\n Status: ${STATUS_COLOR}${STATUS}${NC}\n\n"