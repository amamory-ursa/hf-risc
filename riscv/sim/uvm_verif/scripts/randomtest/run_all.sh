#!/bin/bash

#generate random tests
bash generate.sh

args=""
cd apps                     # @ uvm_verif/scripts/randomtest/apps
#run the stuff
for d in */ ; do            # app0, app1, ... appN
	cd $d                     # @ app'$d'
	rm -rf ../../../code.txt  # removes current uvm_verif/code.txt
	cp code.txt ../../../.    # add new random app'$d'/code.txt
  # args=""$d"coverage.ucdb $args"
	bash run.sh	              # runs uvm_verif/scripts/sim.do with current random code.txt
	cd ..                     # @ apps
done

# vcover merge total_coverage.ucdb $args

directory=$PWD
cd $directory/..



#cleanup
# cd $directory
# bash cleanup.sh