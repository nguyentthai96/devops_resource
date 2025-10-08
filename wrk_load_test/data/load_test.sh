#!/bin/bash

TARGET_URL="http://127.0.0.1:15001/v1/process"

# Function to perform a single wrk test
run_wrk() {
    local threads=$1
    local connections=$2
    local duration=$3

    echo "Running wrk with $threads threads, $connections connections, and $duration duration..."
    wrk -t$threads -c$connections -d$duration --timeout 10s \
        -s curl.lua -- "$TARGET_URL"
    echo "----------------------------------------------"
}

# Example tests
run_wrk 2 10 30s
run_wrk 32 100 30s
run_wrk 4 20 1m
run_wrk 8 40 2m


