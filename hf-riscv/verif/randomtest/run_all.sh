#!/bin/bash


source generate.sh .

directory=$PWD
args=""

for d in */ ; do
    echo "$d"
    cd $directory/$d
    args=""$d"coverage.ucdb $args"
    ./run.sh
done

cd $directory
vcover merge total_coverage.ucdb $args

