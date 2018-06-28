`define N_LINES 1048576/32

//-----------------------C-INTERFACE-------------------------------------

import "DPI-C" function int run (input byte unsigned Mem2[`N_LINES], int size);
import "DPI-C" context function void export_mem(input int);
export "DPI-C" function export_sram;

//---------------------------------------------------------------------

reg[31:0] Mem_from_C[`N_LINES];





//--------------------RETREIVE-FROM-C-FUNCTIONS-------------------------

//---Pull-Memory------------------------

function void export_sram(input reg[31:0] _sram[`N_LINES]);
        for (int h=0;h<`N_LINES; h++)begin
			Mem_from_C[h] = _sram[h];
			//$display("[%d] = %h", h, Mem_from_C[h]);
        end
endfunction

//----------------------------SCOREBOARD--------------------------------

class scoreboard;
		int i, j, k, size;
		byte unsigned Mem_byte[`N_LINES];
		reg [31:0] aux;
		logic [31:0] inst_add, last_add;
		int read_data;   

		mailbox agt2scb;
		mailbox scb2chk;
		
		event   start_scb;
		event   end_scb;
	
		function new (mailbox agt2scb, mailbox scb2chk, input event start_scb, input event end_scb);
		  this.agt2scb = agt2scb;
		  this.scb2chk = scb2chk;
		  this.start_scb = start_scb;
		  this.end_scb = end_scb;
		endfunction // new
	
	task run_scoreboard();
		begin
			automatic memory_model scb_mem;
			automatic memory_model chk_mem;
			
			$display("Waiting start scoreboard!!");
			
			wait(start_scb.triggered);
			
			$display("Scoreboard Initialized!!");
			
			  if(agt2scb)
				agt2scb.get(scb_mem);
			  else
				$display("ERROR - Mailbox Not Received !!!!!");		  
			  
			inst_add = scb_mem.base;
			last_add = scb_mem.base + scb_mem.length;	
			j=0;
			
			while(inst_add < last_add) begin
				aux = scb_mem.read_write(inst_add,0,0); //reading the RA
				for (k=0;k<4; k++) begin
					Mem_byte[j*4+k] = (aux & 32'hff000000) >> 24;
					aux = aux << 8;
				end
				j = j +1;
				inst_add = inst_add + 4;
			end 
			
			run(Mem_byte,`N_LINES);
			
			export_mem(`N_LINES);	
						
			scb2chk.put(Mem_from_C);
						
			$display("\nScoreboard Sent Mailboxes!!");
			
			->end_scb;
			
		end
	endtask	
endclass


