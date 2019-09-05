#!/bin/bash

native_results=/tmp/native_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12).json
docker_results=/tmp/docker_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12).json

### native benchmark
python3.7 -m pip install pyperformance
python3.7 -m pyperformance run -b nqueens -o $native_results

# create a cache folder for python dependencies
mkdir /tmp/venv_docker_debian
docker build . -f Dockerfile.py3perfdebian -t pyperfdebian
docker run -v /tmp:/tmp -v /tmp/venv_docker_debian:/app/venv pyperfdebian pyperformance run --python=python3 -b nqueens -o $docker_results

# display results
python3 -m pyperf compare_to $native_results $docker_results --table
