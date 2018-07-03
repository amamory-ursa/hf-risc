#!/bin/sh

#runs program
vsim -do generate.do -c

#cleanup
rm -rf transcript
rm -rf work

#setup apps
cd apps
directory=$PWD

#copy makefile into every directory
for d in */ ; do
	cp build.sh $d/build.sh
	cp run.sh $d/run.sh
done

#call individual builds
for d in */ ; do
	cd $d
	bash build.sh	
	cd ..
done

#back to main directory
cd ..

#run the stuff
bash apps/run_all.sh/