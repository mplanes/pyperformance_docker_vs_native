#!/bin/bash

native_results=/tmp/native_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12).json
docker_results=/tmp/docker_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12).json
docker_results2=/tmp/docker_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12).json
### native benchmark
type -P python3.7 &>/dev/null || { echo "python3.7 binary not found, installing" ; sudo apt install python3.7; }

virtualenv -p python3.7 venvbenchmark
source venvbenchmark/bin/activate
python -m pip install pyperformance pyperf
python -m pyperformance run -b nqueens -r -o $native_results

# create a cache folder for python dependencies
mkdir /tmp/venv_docker_debian
docker build . -f Dockerfile.py3perfdebian -t pyperfdebian
docker run -v /tmp:/tmp --privileged -v /tmp/venv_docker:/venv pyperfdebian pyperformance run --python=python3 -b nqueens -r -o $docker_results

docker build . -f Dockerfile.py3perfdebian2 -t pyperfdebian2
docker run -v /tmp:/tmp --privileged -v /tmp/venv_docker:/venv  pyperfdebian2 pyperformance run --python=python3 -b nqueens -r -o $docker_results2

# display results
python3 -m pyperf compare_to $native_results $docker_results $docker_results2 --table
