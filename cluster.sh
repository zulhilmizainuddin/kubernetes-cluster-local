#!/bin/bash

set -e

if [[ $# -eq 0 ]]; then
    echo "Commands not provided"
    exit 1
fi

command=$1
subcommand=$2

case $command in
    start)
        export ANSIBLE_CACHE_PLUGIN=yaml
        export ANSIBLE_CACHE_PLUGIN_CONNECTION=.cache

        ansible-galaxy install -r requirements.yml > /dev/null 2>&1

        BOX_TYPE=$subcommand vagrant up
        ;;

    ssh)
        vagrant ssh $subcommand
        ;;

    delete)
        vagrant destroy -f
        ;;

    *)
        echo "Unsupported command provided"
        exit 1
esac