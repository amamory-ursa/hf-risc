#!/bin/sh

#setup apps
directory=$PWD

cd randomtest/apps
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