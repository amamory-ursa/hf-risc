#!/bin/bash

directory=$PWD

cd $directory
cp ../../../boot.txt .
cp ../../../sim_randomtest.do .
vsim -c -do sim_randomtest.do
