#!/bin/bash

directory=$PWD

cd $directory
#cp ../../../boot.txt .
#cp ../../../sim_randomtest.do .
#cp ../code.txt .

echo "#############################"
echo "$directory"
cd ../../../

vsim -c -do sim.do

cd $directory
