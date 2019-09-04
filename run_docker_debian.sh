#!/bin/sh

docker build . -f Dockerfile.py3perfdebian -t pyperfdebian

docker run --privileged -v /tmp:/tmp pyperfdebian pyperformance run --python=python3 -o /tmp/py3_debian.json
