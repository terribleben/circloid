#!/bin/bash

trap "exit" INT TERM ERR
trap "kill 0" EXIT

python -m SimpleHTTPServer &
sleep 0.5

if [[ "$OSTYPE" == "darwin" ]]; then
    open castle://localhost:8000/main.lua
fi

wait

