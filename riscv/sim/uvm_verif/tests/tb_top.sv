`timescale 1ns/1ps

`include "../uvm_src/hfrv_interface.sv"
`include "../uvm_src/dut_top.sv"

module tb_top;
`include "../uvm_src/randomtest/base_formats.sv"
`include "../uvm_src/randomtest/instruction.sv"
`include "../uvm_src/randomtest/opcode.sv"

   logic clk = 1'b0;

   // clock generator
   always #5 clk = ~clk;

   hfrv_interface iface(.*);
   dut_top dut (.*);
   //scoreboard scb();
	
   initial begin
      static bit verbose = 1;


   end

endmodule // tb_top
