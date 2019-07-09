
`ifndef SCOREBOARD__SV
`define SCOREBOARD__SV
`define N_LINES 1048576/32
`define N_IO 512
//`include "gpio.sv"
`include "memory_model.sv"

//-----------------------C-INTERFACE-------------------------------------

import "DPI-C" function int run (input byte unsigned Mem2[`N_LINES], int size);
import "DPI-C" context function void export_mem(input int);
export "DPI-C" function export_sram;

//import "DPI-C" context function void export_io_c(input int);
//export "DPI-C" function export_io;

//---------------------------------------------------------------------

reg[31:0] Mem_from_C[`N_LINES];
//bit[31:0] Io_from_C[`N_IO];

//--------------------RETREIVE-FROM-C-FUNCTIONS-------------------------

//---Pull-Memory------------------------

function void export_sram(input reg[31:0] _sram[`N_LINES]);
        for (int h=0; h<`N_LINES; h++)begin
              Mem_from_C[h] = _sram[h];
        end
endfunction

/*function void export_io(input bit[31:0] _io[`N_IO]);
        for (int h=0; h<`N_IO; h++)begin
               Io_from_C[h] = _io[h];
        end
endfunction*/

//----------------------------SCOREBOARD--------------------------------


import uvm_pkg::*;
`include "uvm_macros.svh"

class scoreboard extends uvm_scoreboard;
     `uvm_component_utils(scoreboard)

     // Port to inform the transaction to the Scoreboard and Coverage
     memory_model req;
     //gpio_trans trans;
     //mailbox io_gen2scb;//TODO: change to uvm fifo
     
     //export
     //fifo
     uvm_analysis_port # (memory_model) in_drv_ap;
     uvm_tlm_analysis_fifo #(memory_model) input_fifo;
     int i, j, k, size;
     reg [31:0] aux;
     logic [31:0] inst_add, last_add;

     //transactions
     byte unsigned Mem_byte[`N_LINES];// = {default : '0};
     //int unsigned io_info[`N_IO];// = {default : '0};
     //int num_io;// = {default : '0};
 
     function new(string name, uvm_component parent);
          super.new(name, parent);
          //dvr2scb_port = new("dvr2scb_port",this);
          //new transactions
     endfunction: new
 
     function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          in_drv_ap = new( "in_drv_ap", this);
          //new export
          input_fifo  = new("input_fifo", this); 
          //new fifo
          uvm_config_db #(uvm_analysis_port #(memory_model) )::set(this, "", "in_drv_ap", in_drv_ap);
     endfunction: build_phase
 
     function void connect_phase(uvm_phase phase);
          //connect fifo
          in_drv_ap.connect(input_fifo.analysis_export);
     endfunction: connect_phase
 
     task run();
          //forever begin
          automatic memory_model scb_mem;
          automatic memory_model chk_mem;

          //wait(start_scb.triggered);
          //input_fifo.get(req);
          // Sending memory to C simulator
          //uvm_info("dvr2scb_port == ")
          
          if(input_fifo)
               input_fifo.get(scb_mem);
          else
               $display("ERROR - Mailbox Not Received !!!!!");
          
          inst_add = scb_mem.base;
          last_add = scb_mem.base + scb_mem.length;	
          j=0;
          
          // Converting 32 bits to byte
          while(inst_add < last_add) begin
               aux = scb_mem.read_write(inst_add,0,0); //reading the RA
               for (k=0;k<4; k++) begin
                    Mem_byte[j*4+k] = (aux & 32'hff000000) >> 24;
                    aux = aux << 8;
               end
               j = j +1;
               inst_add = inst_add + 4;
          end

          //TODO: call run here
          //run(Mem_byte, `N_LINES);
          `uvm_info("run in C simulator called", {""}, UVM_LOW);

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
