import uvm_pkg::*;
`include "uvm_macros.svh"
`include "agent.sv" 


class environment extends uvm_env;
    
  `uvm_component_utils(environment)

  agent agt;
      
  /*Construtor*/ 
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

      agt = agent::type_id::create("agent", this);

  endfunction : build_phase
task run();
      fork;
         agt.run;
      join;
   endtask // run
/*  function void connect_phase(uvm_phase phase);

  endfunction : connect_phase*/
 
endclass : environment
