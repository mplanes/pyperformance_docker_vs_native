# pyperformance_docker_vs_native

dependencies:
python3.7 python3.7-dev docker-ce docker-ce-cli containerd

Runs the pyperformance benchmark 3 times:
- Natively on your host, using python 3.7 and virtualenv
- Using an alpine based docker container
- Using a debian based docker container

To run:
bash run_short.sh (proof of concept, only runs a single benchmark), takes a couple of minutes
bash run_all.sh (long ~90 minutes on a recent desktop)

Results will be displayed in a table directly in your terminal.
