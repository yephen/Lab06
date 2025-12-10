#!/bin/bash

LOG_DIR="$CODESPACE_VSCODE_FOLDER/command_logs"
LOG_FILE="$LOG_DIR/command_history_$(date +%Y%m%d_%H%M%S).log"

mkdir -p "$LOG_DIR"

function log_command() {
    local cmd="$1"
    local pwd="$PWD"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    if [[ "$cmd" =~ ^(clear|history|exit|pwd)$ ]]; then
        return
    fi
    
    echo "[${timestamp}] [${pwd}] ${cmd}" >> "$LOG_FILE"
}

function analyze() {
    echo "Command Usage Analysis"
    echo "===================="
    echo "Top 10 most used commands:"
    awk -F '] ' '{split($NF, cmd, " "); print cmd[1]}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10
    
    echo -e "\nTotal commands executed: $(wc -l < "$LOG_FILE")"
    echo "Unique commands used: $(awk '{print $NF}' "$LOG_FILE" | sort -u | wc -l)"
}

function check_progress() {
    local required_commands=("ls" "cd" "mkdir" "touch" "cp" "mv" "rm" "grep" "find")
    
    echo "Required Commands Check"
    echo "====================="
    
    for cmd in "${required_commands[@]}"; do
        count=$(grep " ${cmd}$" "$LOG_FILE" | wc -l)
        if [ $count -eq 0 ]; then
            echo "❌ ${cmd}: Not used yet"
        else
            echo "✓ ${cmd}: Used ${count} times"
        fi
    done
}

PROMPT_COMMAND='log_command "$(history 1 | sed "s/^[ ]*[0-9]\+[ ]*[0-9-]\{10\}[ ][0-9:]\{8\}[ ]*//")"'

HISTTIMEFORMAT="%Y-%m-%d %T "

HISTSIZE=10000
HISTFILESIZE=20000

HISTCONTROL=ignoreboth

shopt -s histappend

PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

echo "Command logging enabled. Your commands will be logged to: $LOG_FILE"
echo "Use 'analyze' to see command usage statistics"
echo "Use 'check-progress' to verify required commands usage"
PS1="UCR \w > "