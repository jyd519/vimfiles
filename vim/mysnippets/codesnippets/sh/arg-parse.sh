#!/bin/bash

CLEAR='\033[0m'
RED='\033[0;31m'

function usage() {
  if [ -n "$1" ]; then
    echo -e "${RED}👉 $1${CLEAR}\n";
  fi
  echo "Usage: $0 [-n number-of-people] [-s section-id] [-c cache-file]"
  echo "  -n, --number-of-people   The number of people"
  echo "  -s, --section-id         A sections unique id"
  echo "  -q, --quiet              Only print result"
  echo ""
  echo "Example: $0 --number-of-people 2 --section-id 1 --cache-file last-known-date.txt"
  exit 1
}

# parse params
while [[ "$#" > 0 ]]; do case $1 in
  -n|--number-of-people) NUMBER_OF_PEOPLE="$2"; shift;shift;;
  -s|--section-id) SECTION_ID="$2";shift;shift;;
  -v|--verbose) VERBOSE=1;shift;;
  *) usage "Unknown parameter passed: $1"; shift; shift;;
esac; done

# verify params
if [ -z "$NUMBER_OF_PEOPLE" ]; then usage "Number of people is not set"; fi;
if [ -z "$SECTION_ID" ]; then usage "Section id is not set."; fi;
