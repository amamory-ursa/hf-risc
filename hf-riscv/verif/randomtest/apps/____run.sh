#!/bin/bash

directory=$PWD

cd $directory
cp ../../boot.txt .
cp ../../sim_testcase.do .
vsim -c -do sim_testcase.do
