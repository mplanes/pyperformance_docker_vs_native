#!/bin/sh

sudo apt install python3.7 python3.7-dev
virtualenv -p python3.7 venv_pyperf
source venv_pyperf/bin/activate
pip install pyperformance
pyperformance run -o /tmp/py3_native.json
