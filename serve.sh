#!/bin/bash

trap "exit" INT TERM ERR
trap "kill 0" EXIT

python -m SimpleHTTPServer &
sleep 0.5
open castle://localhost:8000/main.lua

wait

