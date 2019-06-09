#!/bin/bash
set -e

for f in $(ls tests/*/startup.smk); do
    # Execute each test in a subshell.
    ( cd $(dirname $f); ./test.sh; );
done

echo "All tests exited with $?."
