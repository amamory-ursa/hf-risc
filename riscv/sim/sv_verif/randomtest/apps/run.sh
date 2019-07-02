#!/bin/bash

directory=$PWD

cd $directory
cp ../boot.txt .
cp ../sim_randomtest.do .
#cp ../code.txt .

echo "#############################"
echo "$directory"
echo $directory
vsim -c -do sim_randomtest.do
