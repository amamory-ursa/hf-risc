`timescale 1ns/1ps

`include "hfrv_interface.sv"
`include "dut_top.sv"

module tb_top;
`include "environment.sv"
`include "callbacks/monitor/fake_uart.sv"

   logic clk = 1'b0;

   // clock generator
   always #5 clk = ~clk;

   hfrv_interface iface(.*);
   dut_top dut (.*);

   initial begin
      static environment env = new(iface);
      Fake_uart fake_uart = new;
      env.monitor.cbs.push_back(fake_uart);
      env.run();
   end
   
endmodule // tb_top
