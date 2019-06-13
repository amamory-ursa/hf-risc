#!/bin/bash 

rm -rf code.txt out.txt debug.txt transcript vsim.wlf wlf* read_debug.txt init.dat

# if you are inside GAPH research lab, using GAPH's computers, then you can simply 
# type the following commands to set the environment variables for modelsim and 
# RISCV compiler. On the other hand, you will need to set it by yourself and comment 
# these two lines
module load modelsim
module load riscv32-elf/8.1.0

vdel -all

cd ../../../software
make clean $1
cd -

rm -rf code.txt
cp -f ../../../software/code.txt .
cp -f ../../../software/code.bin .

vsim -c -do sim_environment.do -t 10ps

cat debug.txt

