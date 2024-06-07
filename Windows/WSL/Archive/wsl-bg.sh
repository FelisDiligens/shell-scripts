#!/bin/bash

if [ -n "$1" ] && [ "$1" = "kill" ]; then
    if [ -f ~/nohup-pid ]; then
        echo "Killing PID $(cat ~/nohup-pid)"
        kill $(cat ~/nohup-pid)
        rm ~/nohup-pid
    else
        echo "Not running."
        echo "Run './wsl-bg.sh'"
    fi
elif [ ! -f ~/nohup-pid ]; then
    echo "Running: nohup sleep 100000"
    nohup sleep 100000 > /dev/null 2>&1 &
    echo $! > ~/nohup-pid
else
    echo "Already running."
    echo "Run './wsl-bg.sh kill'"
fi