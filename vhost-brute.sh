#!/bin/bash

function usage() {
    echo "Usage:"
    echo "      $0 [-h] [-d DOMAIN] URI WORDLIST"
    echo "Arguments:"
    echo "      URI         targeted URI (i.e. http(s)://server[:port])"
    echo "      WORDLIST    path to wordlist"
    echo "Options:"
    echo "      -h          Display this help"
    echo "      -d [DOMAIN] Append a fixed domain name to all items of the specified wordlist"
    echo "Example:"
    echo "      $0 -d example.org http://192.168.1.1 namelist.txt"
}

# parse args
while getopts 'hd:s' OPTION; do
    case "$OPTION" in
        h)
            usage
            exit 0
            ;;
        d)
            DOMAIN=".$OPTARG"
            ;;
        ?)
            usage >&2
            exit 1
            ;;
    esac
done
shift "$(($OPTIND -1))"

if [[ $# -ne 2 ]]; then
    usage >&2
    exit 1
fi

URI=$1
WORDLIST=$2

# run vhost enumeration
for name in $(cat $WORDLIST); do
    vhost=$name$DOMAIN
    echo -n "$vhost:"
    curl -s -k $URI -H "Host: $vhost" | sha256sum | cut -d' ' -f1
done

