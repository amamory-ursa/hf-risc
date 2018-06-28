`timescale 1ns/1ps

`include "hfrv_interface.sv"
`include "dut_top.sv"

module tb_top;
`include "environment.sv"

   logic clk = 1'b0;

   // clock generator
   always #5 clk = ~clk;

   hfrv_interface iface(.*);
   dut_top dut (.*);
   //scoreboard scb();
	
   initial begin
      static environment env = new(iface);
      env.run();
   end
   
endmodule // tb_top
