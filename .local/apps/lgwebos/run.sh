#!/bin/sh
cd $(dirname $(realpath $0))
pipenv run ./main.py "$@"
