#!/bin/sh

docker build . -f Dockerfile.py3perfalpine -t pyperfalpine

docker run --privileged -v /tmp:/tmp pyperfalpine pyperformance run --python=python3 -o /tmp/py3_alpine.json
