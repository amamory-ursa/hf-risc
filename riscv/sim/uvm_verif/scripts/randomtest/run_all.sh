#!/bin/bash

#generate random tests
bash generate.sh

cd apps

directory=$PWD
args=""

for d in */ ; do
    cd $directory/$d
    args=""$d"coverage.ucdb $args"
    ./run.sh
done

cd $directory/..
#vcover merge total_coverage.ucdb $args

#cleanup
# cd $directory
# bash cleanup.sh