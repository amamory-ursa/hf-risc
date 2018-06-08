`timescale 1ns/1ps

`include "hfrv_interface.sv"
`include "dut_top.sv"

module tb_top;
`include "environment.sv"
`include "callbacks/monitor/fake_uart.sv"
`include "callbacks/monitor/debug_process.sv"
`include "callbacks/monitor/cover_opcodes.sv"

   logic clk = 1'b0;

   // clock generator
   always #5 clk = ~clk;

   hfrv_interface iface(.*);
   dut_top dut (.*);

   initial begin
      static environment env = new(iface);
      automatic Fake_uart fake_uart = new;
      automatic Debug_process debug_process = new("sv_debug.txt");
      automatic CoverOpCodes_cbs cover_opcodes_cbs = new;
      env.mon.cbs.push_back(fake_uart);
      env.mon.cbs.push_back(debug_process);
      env.mon.cbs.push_back(cover_opcodes_cbs);
      env.run();
   end
   
endmodule // tb_top
