
`ifndef SCOREBOARD__SV
`define SCOREBOARD__SV


import uvm_pkg::*;
`include "uvm_macros.svh"

class scoreboard extends uvm_scoreboard;
     `uvm_component_utils(scoreboard)
 
     //export
     //fifo
     //transactions
 
     function new(string name, uvm_component parent);
          super.new(name, parent);
          //new transactions
     endfunction: new
 
     function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          //new export
          //new fifo
     endfunction: build_phase
 
     function void connect_phase(uvm_phase phase);
          //connect fifo
     endfunction: connect_phase
 
     task run();
          //forever begin
               //get transaction from fifo and compare
               compare();
          //end
     endtask: run
 
     virtual function void compare();
          if(1/*transaction_before.out == transaction_after.out*/) begin
               `uvm_info("compare", {"Test: OK!"}, UVM_LOW);
          end else begin
               `uvm_info("compare", {"Test: Fail!"}, UVM_LOW);
          end
     endfunction: compare
endclass: scoreboard


`endif // SCOREBOARD__SV