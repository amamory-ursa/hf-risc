`ifndef GENERATOR_SV
`define GENERATOR_SV

`include "memory.sv"

class generator;

	memory_model ram;		
	mailbox  	gen2agent;	// Mailbox to driver for cells
	event    	agent2gen;	// Event from driver when done with cell
      
	function new(input mailbox gen2agent,
		input event agent2gen);
		this.gen2agent = gen2agent;
		this.agent2gen = agent2gen;
		ram = new({},'h00000000);
	endfunction : new

	task write_ram();
		int code, i, r; // file descriptor
        int instruction, write_data;
		logic [31:0] inst_add;
		code = $fopen("code.txt","r");	
		inst_add = 'h00000000;
		while(! $feof(code)) begin
			r = $fscanf(code,"%h\n",instruction);
			write_data = ram.read_write(inst_add,instruction,'hF); //writing in the RAM
			inst_add = inst_add + 1;
		end
		$fclose(code);
		//@agent2gen; // Wait for agent to finish with it
	endtask : write_ram

   	task read_ram();
		int read_data; // file descriptor
		logic [31:0] inst_add;		
		inst_add = 'h00000000;
		while(inst_add != (ram.data.size)) begin
			read_data = ram.read_write(inst_add,0,0); //reading the RAM
			inst_add = inst_add + 1;
			$display("%h: %h",inst_add,read_data);
		end 
	endtask : read_ram

endclass : generator

`endif
