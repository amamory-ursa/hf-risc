#!/bin/bash

rm -rf code.txt out.txt debug.txt transcript vsim.wlf wlf* read_debug.txt init.dat

module load modelsim

vdel -all

cd ../../../software
make clean clean $1
cd -

rm -rf code.txt
cp -f ../../../software/code.txt .

vsim -c -do sim.do -t 10ps

cat sv_debug.txt

