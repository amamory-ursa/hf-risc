#!/bin/bash

if [ "$1" = "rand" ]
then

  echo "	creating random tests... please wait"
  cd scripts/randomtest
  ./generate.sh
  
  cd ../
  
  # module load modelsim
  echo "	simulating... please wait"
  # {
    #run vsim

    # vsim -c -do ./scripts/sv/3_simul.do

    #save log file
    # mv transcript simulation.log

    #cleanup
    # rm -rf *.ini transcript *.wlf work ./src/*~

  # } > /dev/null
  # module unload modelsim

elif [ "$1" = "std" ]
then

  # module load modelsim
  echo "	simulating... please wait"
  {

    #run sim
    cd scripts
    vsim -c -do sim.do

    cd ..
    #save log file
    mv scripts/transcript ./simulation.log

    #cleanup
    rm -rf scripts/dump.vcd scripts/work
    # rm -rf dump.vcd tests* transcript utopia.ucdb  vsim.wlf work *.ini

  } > /dev/null
  # module load modelsim

else

  echo "NOT AVAILABLE OPTION. Please, run \"./run.sh rand\" or \"./run.sh std\" "

fi