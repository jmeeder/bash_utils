#!/bin/bash

############################
# Bash Runner
############################

# Banner Creation via https://patorjk.com/software/taag/#p=testall&f=Big&t=CeASF%0A

cat << EOF

██████  ███████ ███    ███  ██████      ██ ███    ██ ███████ ████████  █████  ██      ██      ███████ ██████  
██   ██ ██      ████  ████ ██    ██     ██ ████   ██ ██         ██    ██   ██ ██      ██      ██      ██   ██ 
██   ██ █████   ██ ████ ██ ██    ██     ██ ██ ██  ██ ███████    ██    ███████ ██      ██      █████   ██████  
██   ██ ██      ██  ██  ██ ██    ██     ██ ██  ██ ██      ██    ██    ██   ██ ██      ██      ██      ██   ██ 
██████  ███████ ██      ██  ██████      ██ ██   ████ ███████    ██    ██   ██ ███████ ███████ ███████ ██   ██ 
                                                                                                              
Installation Wizard
(C) Your Company 2023                             
                                                                                               
EOF

# ------------------------
# Global Vars

INSTALLER_NAME="DemoInstaller"
CURRENT_DATETIME=$(date +"%Y-%m-%d_%T")
LOG_FILE="${CURRENT_DATETIME}_${INSTALLER_NAME}.log"
CHECK_MARK="\U2705"

SPINNER_PID=

# ------------------------

function create_logfile() {
    echo "------------------------------------" > $LOG_FILE
    echo "Log-File of of $INSTALLER_NAME" >> $LOG_FILE
    local datetime=$(date +"%Y-%m-%d %T")
    echo "Datetime: $datetime" >> $LOG_FILE
    echo "------------------------------------" >> $LOG_FILE

}


function spin() {
    while :; do 
        for s in / - \\ \|; do 
            printf "\r$s"; sleep .1; 
        done;
    done
}

function start_spinner() {
    # We can disable this by turning off Job Control in Bash via set +m. 
    set +m
    { spin & } 2>/dev/null
    SPINNER_PID=$!
}

function stop_spinner {
    { kill -9 $SPINNER_PID && wait; }  2>/dev/null
    set -m
    # What does echo -en "\033[2K\r" do? Let's break it down. 
    # First, echo -e will allow echo to interpret escape sequences in its arguments and not print them as-is.
    # Next, echo -n will print its arguments without a new line. 
    # The escape sequence \033[2K will erase the contents of the current line, and the carriage return \r will reset the cursor to the beginning of the line.
    # This allows us to continue printing to the terminal normally after stopping our spinner.
    echo -en "\033[2K\r"
}

function print_string() {
    printf " | $1"
}

sighandler_SIGABRT() {
    echo "something went wrong"
    exit 1;
}

function work() {
    ping -c 3 www.google.de &>> $LOG_FILE
}

#######################################
# Start of Work
#######################################
echo "Installation Log can be found in $LOG_FILE"
create_logfile
echo
# A safeguard via a trap against bash exists.
trap stop_spinner EXIT
trap 'sighandler_SIGABRT' 6

##### START First Job #####
start_spinner 

print_string "Work on Ping..."

echo "##### START First Job #####" >> $LOG_FILE
work

stop_spinner

echo -e "$CHECK_MARK Ping done"
##### END First Job #####

##### START Second Job #####
echo "##### START Second Job #####" >> $LOG_FILE
start_spinner 

print_string "Work on Sleep..."

sleep 5;

stop_spinner

echo -e "$CHECK_MARK Sleep done"
##### END Second Job #####