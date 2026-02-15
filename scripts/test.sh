#!/bin/bash

# --- Configuration ---
# Default to non-verbose mode
VERBOSE=0
# Log file to capture all hidden output
LOG_FILE="/tmp/agent-eval-setup-$(date +%s).log"

# Argument Parsing
if [[ "$1" == "-v" || "$1" == "--verbose" ]]; then
  VERBOSE=1
  echo "Verbose mode: ON. Output will be printed and logged to $LOG_FILE"
else
  echo "Verbose mode: OFF. Output is hidden."
  echo "Details can be found in $LOG_FILE"
fi

> "$LOG_FILE"

spinner2() {
  local chars="|/-\\"
  while true; do
    for (( i=0; i<${#chars}; i++ )); do
      printf "\r%s" "${chars:$i:1}"
      sleep 0.1
    done
  done
}

spinner() {
  local chars="|/-\\"
  while true; do
    for (( i=0; i<${#chars}; i++ )); do
      # \r returns to start, prints char, THEN a space
      printf "\r%s " "${chars:$i:1}"
      sleep 0.1
    done
  done
}

run_step() {
  local desc="$1"
  shift

  printf "%s... " "    $desc"

  if [ "$VERBOSE" -eq 1 ]; then
    echo
    
    script -q -c "$*" /dev/null | tee -a "$LOG_FILE"
    local exit_code=${PIPESTATUS[0]}
    
    if [ $exit_code -eq 0 ]; then
      printf "\n✓ Step '%s' completed successfully.\n" "$desc"
    else
      printf "\n✗ Step '%s' failed with exit code %d.\n" "$desc" $exit_code
      exit 1
    fi
  
  else
    spinner &
    local spinner_pid=$!
    trap "kill $spinner_pid 2>/dev/null; exit" INT TERM EXIT

    "$@" >> "$LOG_FILE" 2>&1
    local exit_code=$?

    kill $spinner_pid 2>/dev/null
    wait $spinner_pid 2>/dev/null
    trap - INT TERM EXIT

    if [ $exit_code -eq 0 ]; then
      printf "\r\033[K✓ %s... done.\n" "$desc"
    else
      printf "\r\033[K✗ %s... failed.\n" "$desc"
      echo "  Error details have been logged to $LOG_FILE"
      echo "  (Run with -v or --verbose to see live output)"
      exit 1
    fi
  fi
}

echo "Starting deployment process..."
echo "---"

run_step "Creating terraform variables (terraform.tfvars)" ./scripts/create-vars.sh 3
run_step "Deploying database cluster" sleep 5
run_step "Running integration tests" sleep 4 && false
run_step "Cleaning up deployment" sleep 2

echo "---"
echo "All steps completed successfully."
