`ifndef TEST_GENERATOR_SV
`define TEST_GENERATOR_SV

`include "../generator.sv"

program automatic test();

	mailbox  	gen2agent;	// Mailbox to driver for cells
	event    	agent2gen;	// Event from driver when done with cell

	initial begin
		generator gen;
		gen = new(gen2agent,agent2gen);
		gen.write_ram();
		gen.read_ram();
	end

endprogram

module top;

	test t1();

endmodule : top 

`endif
