
`ifndef SCOREBOARD__SV
`define SCOREBOARD__SV
`define N_LINES 1048576/32

`include "memory_model.sv"

//DPI-C Interface
import "DPI-C" function int run_simulator (input byte unsigned Mem2[`N_LINES], int size);
import "DPI-C" context function void export_mem(input int);
export "DPI-C" function export_sram;

reg[31:0] Mem_from_C[`N_LINES];

function void export_sram(input reg[31:0] _sram[`N_LINES]);
        for (int h=0; h<`N_LINES; h++)begin
              Mem_from_C[h] = _sram[h];
        end
endfunction


//The SCOREBOARD starts here
import uvm_pkg::*;
`include "uvm_macros.svh"

class scoreboard extends uvm_scoreboard;
     `uvm_component_utils(scoreboard)

     uvm_analysis_port #(memory_model) in_drv_ap;
     uvm_tlm_analysis_fifo #(memory_model) scoreboard_port;

     uvm_analysis_port #(memory_model) in_ckr_ap;
     uvm_tlm_analysis_fifo #(memory_model) checker_port;

     int i, j, k, size;
     reg [31:0] aux;
     logic [31:0] inst_add, last_add;

     byte unsigned Mem_byte[`N_LINES];
 
     function new(string name, uvm_component parent);
          super.new(name, parent);
     endfunction: new
 
     function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          in_drv_ap = new( "in_drv_ap", this);
          scoreboard_port  = new("scoreboard_port", this);
          uvm_config_db #(uvm_analysis_port #(memory_model) )::set(this, "", "in_drv_ap", in_drv_ap);
          
          in_ckr_ap = new("in_ckr_ap", this);
          checker_port = new("checker_port", this);
          uvm_config_db #(uvm_analysis_port #(memory_model) )::set(this, "", "in_ckr_ap", in_ckr_ap);
     endfunction: build_phase
 
     function void connect_phase(uvm_phase phase);
          //connect fifo
          in_drv_ap.connect(scoreboard_port.analysis_export);
          in_ckr_ap.connect(checker_port.analysis_export);
     endfunction: connect_phase
 
     task run_phase(uvm_phase phase);
          forever begin
               
               automatic memory_model scb_mem;
               automatic memory_model chk_mem;

               $display("[Scoreboard] Waiting for scoreboard_port request");
               if(scoreboard_port)
                    scoreboard_port.get(scb_mem);
               
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

               $display("[Scoreboard] Call the simulator in C (DPI-C run_simulator function)");
               run_simulator(Mem_byte, `N_LINES);
               $display("[Scoreboard] simulator in C executed");

               
               // Retreiving memory from C simulator
               export_mem(`N_LINES);
          
               $display("[Scoreboard] Simulator executed and memory exported");

               $display("[Scoreboard] Waiting for checker_port request");
               if(checker_port)
                    checker_port.get(chk_mem);

               $display("[Scoreboard] Call checker");

               compare(Mem_from_C, chk_mem);

          end
     endtask: run_phase
 
     virtual function void compare(reg [31:0] scb_mem [`N_LINES], memory_model chk_mem);
          memory_model ram;
          int read_data, i, equal; // file descriptor
          logic [31:0] inst_add, last_add;

          ram = chk_mem;

          inst_add = ram.base;
          last_add = (ram.length/32);
          equal = 0;
          i = 0;
               
          while(last_add) 
          begin
               read_data = ram.read_write(inst_add,0,0); //reading the RAM
               inst_add = inst_add + 4;
               last_add = last_add -1;
                         
               // Comparison word by word of scoreboard and DUT memories
               //scb_mem[i][0] = 0; //modify the memory to check if an error occur
               if ((read_data == scb_mem[i]))
               begin
                    equal = equal + 1;
               end
               else
               begin
                    $display("[Checker] %h: %h", inst_add,scb_mem[i]);
                    $display("[Checker] %h: %h", inst_add,read_data);
               end;
          
               i = i + 1;
               
          end

          if (equal == i)
          begin
               $display("[Checker] Memories are equals!");
          end
          else
          begin
               `uvm_error("CHECKER", "Memories are NOT equals!");
               $display("[Checker] Memories are NOT equals!");
               `uvm_info("CHECKER","Memories are NOT equals!", UVM_HIGH);
          end
          $display(equal);
          $display(i);

     endfunction: compare
endclass: scoreboard


`endif //scoreboard
