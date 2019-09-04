#!/bin/bash

bash run_native.sh
bash run_docker_debian.sh
bash run_docker_alpine.sh

source venv_pyperf/bin/activate
python3 -m pyperf compare_to /tmp/py3_native.json /tmp/py3_alpine.json /tmp/py3_debian.json --table
