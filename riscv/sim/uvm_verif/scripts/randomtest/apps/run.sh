#!/bin/bash

directory=$PWD                        # uvm_verif/scripts/randomtest/apps/app'$d'
cd $directory                         # @ uvm_verif/scripts/randomtest/apps/app'$d'
echo "#############################"
echo "$directory"

# cd ../../../                          # @ uvm_verif/scripts
# vsim -c -do sim.do                    # runs uvm_verif/scripts/sim.do with current random code.txt
# cd $directory                         # @ uvm_verif/scripts/randomtest/apps/app'$d'
