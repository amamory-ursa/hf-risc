#!/bin/sh

#runs program
vsim -do generate.do -c

#cleanup
rm -rf transcript
rm -rf work

#setup apps
cd apps

directory=$PWD

for d in */ ; do
    echo "compiling $d"
	
	cd $directory/apps
#    mv $d $d/$d
done


#assemble @TODO