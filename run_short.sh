#!/bin/bash

native_results=/tmp/native_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12).json
dockerubuntu_results=/tmp/dockerubuntu_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12).json
dockerdebian_results=/tmp/dockerdebian_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12).json
dockeralpine_results=/tmp/dockeralpine_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 12).json



# setup
type -P python3.7 &>/dev/null || { echo "python3.7 binary not found, installing" ; sudo apt install python3.7; }
python3.7 -m pip install virtualenv
virtualenv -p python3.7 venvbenchmark
source venvbenchmark/bin/activate
python -m pip install pyperformance pyperf
python -m pyperf system tune

### native benchmark
python -m pyperformance run --venv venv -b nqueens -r -o $native_results

# debian
docker build . -f Dockerfile.py3perfdebian -t pyperfdebian
docker run -v /tmp:/tmp --privileged pyperfdebian pyperformance run --python=python3 -b nqueens -r -o $dockerdebian_results
# alpine
docker build . -f Dockerfile.py3perfalpine -t pyperfalpine
docker run -v /tmp:/tmp --privileged pyperfalpine pyperformance run --python=python3 -b nqueens -r -o $dockeralpine_results
# ubuntu
docker build . -f Dockerfile.py3perfubuntu -t pyperfubuntu
docker run -v /tmp:/tmp --privileged pyperfubuntu pyperformance run --python=python3 -b nqueens -r -o $dockerubuntu_results

# display results
python3 -m pyperf compare_to $native_results $dockerubuntu_results $dockerdebian_results $dockeralpine_results --table
python -m pyperf system reset
