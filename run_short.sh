#!/bin/bash

native_results=/tmp/native_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12).json
docker_results=/tmp/docker_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12).json
docker_results2=/tmp/docker_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12).json
### native benchmark
type -P python3.7 &>/dev/null || { echo "python3.7 binary not found, installing" ; sudo apt install python3.7; }
python3.7 -m pip install virtualenv

virtualenv -p python3.7 venvbenchmark
source venvbenchmark/bin/activate
python -m pip install pyperformance pyperf
python -m pyperf system tune
python -m pyperformance run --venv venv -b nqueens -r --affinity 5,6 -o $native_results

# create a cache folder for python dependencies
mkdir /tmp/venv_docker_debian
docker build . -f Dockerfile.py3perfdebian -t pyperfdebian
docker run -v /tmp:/tmp --privileged -v venv:/venv pyperfdebian pyperformance run --venv /venv --python=python3 -b nqueens -r --affinity 5,6 -o $docker_results

docker build . -f Dockerfile.py3perfdebian2 -t pyperfdebian2
docker run -v /tmp:/tmp --privileged -v venv:/venv  pyperfdebian2 pyperformance run --venv /venv --python=python3 -b nqueens -r --affinity 5,6 -o $docker_results2

# display results
python3 -m pyperf compare_to $native_results $docker_results $docker_results2 --table
