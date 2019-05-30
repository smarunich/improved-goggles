#!/bin/bash -e

PROXY=$1
curl --proxy "$PROXY" www.google.com > /dev/null
status=$?
while [ $status != 0 ]; do
    sleep 1
    curl --proxy "$PROXY" www.google.com > /dev/null
    status=$?
done