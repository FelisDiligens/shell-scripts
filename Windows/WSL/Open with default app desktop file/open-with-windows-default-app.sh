#!/bin/bash

OPENWITHDEFAULT="cmd.exe /C START \"\""
    
for f in "${@}"; do
    # Convert the URI to a file path:
    path=$(echo "$f" | sed -e 's/%/\\x/g' -e 's_^file://__' | xargs -0 printf "%b")
    # Convert the Unix file path to a Windows file path:
    windows_path=$(wslpath -w "${path}")
    # Print to pass it via stdout to xargs:
    echo "${windows_path}"
# Pass each file path to the specified command using `xargs`:
done | xargs -d$'\n' $OPENWITHDEFAULT
