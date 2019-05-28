`define N_LINES 1048576/32
`define N_IO 512
 `include "gpio.sv"

//-----------------------C-INTERFACE-------------------------------------

import "DPI-C" function int run (input byte unsigned Mem2[`N_LINES], input int unsigned io[`N_LINES], int size, int io_size);
import "DPI-C" context function void export_mem(input int);
export "DPI-C" function export_sram;

import "DPI-C" context function void export_io_c(input int);
export "DPI-C" function export_io;

//---------------------------------------------------------------------

reg[31:0] Mem_from_C[`N_LINES];
bit[31:0] Io_from_C[`N_IO];

//--------------------RETREIVE-FROM-C-FUNCTIONS-------------------------

//---Pull-Memory------------------------

function void export_sram(input reg[31:0] _sram[`N_LINES]);
        for (int h=0; h<`N_LINES; h++)begin
			Mem_from_C[h] = _sram[h];
        end
endfunction

function void export_io(input bit[31:0] _io[`N_IO]);
        for (int h=0; h<`N_IO; h++)begin
			Io_from_C[h] = _io[h];
        end
endfunction

//----------------------------SCOREBOARD--------------------------------

class scoreboard;
		int i, j, k, size;
		byte unsigned Mem_byte[`N_LINES];
		reg [31:0] aux;
		logic [31:0] inst_add, last_add;
		int read_data;
		int num_io;
		int unsigned io_info[`N_IO];

		mailbox agt2scb;
		mailbox scb2chk;
		mailbox io_gen2scb;
		
		event   start_scb;
		event   end_scb;

		gpio_trans trans;
	
		function new (mailbox agt2scb, mailbox scb2chk, mailbox io_gen2scb, input event start_scb, input event end_scb);
		  this.agt2scb = agt2scb;
		  this.scb2chk = scb2chk;
		  this.io_gen2scb = io_gen2scb;
		  this.start_scb = start_scb;
		  this.end_scb = end_scb;
		endfunction // new
	
	task run_scoreboard();
		begin
			automatic memory_model scb_mem;
			automatic memory_model chk_mem;
						
			wait(start_scb.triggered);
					
			  if(agt2scb)
				agt2scb.get(scb_mem);
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

			io_gen2scb.get(trans);
			num_io = trans.value;
			io_info[0] = trans.value;
			io_info[1] = trans.t_time;
			j = 2;
			for(i = 0; i < num_io; i++) begin
				io_gen2scb.get(trans);
				io_info[j] = trans.value;
				io_info[j+1] = trans.t_time;
				j = j + 2;
			end
			
			
			// Sending memory to C simulator
			run(Mem_byte, io_info, `N_LINES, num_io);
			
			// Retreiving memory from C simulator
			export_mem(`N_LINES);
			export_io_c(num_io);
			
			// Sending scoreboard memory to Checker module			
			scb2chk.put(Mem_from_C);
			scb2chk.put(Io_from_C);
									
			->end_scb;
			
		end
	endtask	
endclass


