#!/bin/bash

if [ "$1" = "rand" ]
then

  echo "	simulating random tests... please wait"
  # module load modelsim
  {

    #remove apps subfolders
    cd scripts/randomtest
    bash cleanup.sh         # apps folders cleanup
    cd ../../
    
    # ./run_all.sh
    # cd ../../

    cd scripts/
    vsim -c -do sim_randomtest.do
    cd ../

    #cleanup
    cd scripts
    rm -rf *.ini **transcript *.wlf work *.vcd
    cd ../

  # } > /dev/null
  } > simulation.log
  # module unload modelsim

elif [ "$1" = "std" ]
then

  # module load modelsim
  echo "	simulating standard tests... please wait"
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