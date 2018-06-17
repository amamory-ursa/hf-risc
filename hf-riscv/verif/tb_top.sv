`timescale 1ns/1ps

`include "hfrv_interface.sv"
`include "dut_top.sv"

module tb_top;
`include "types/base_formats.sv"
`include "types/instruction.sv"
`include "types/opcode.sv"
`include "types/snapshot.sv"
`include "types/timemachine.sv"
`include "environment.sv"
`include "callbacks/cover_instructions.sv"
`include "callbacks/cover_opcodes.sv"
`include "callbacks/assert_addi.sv"
`include "callbacks/assert_lui.sv"
`include "callbacks/debug_instruction.sv"
`include "callbacks/debug_address.sv"
`include "callbacks/debug_registers.sv"
`include "callbacks/save_history.sv"
`include "callbacks/debug_uart.sv"

   logic clk = 1'b0;

   // clock generator
   always #5 clk = ~clk;

   hfrv_interface iface(.*);
   dut_top dut (.*);

   initial begin
      static bit verbose = 1;
      static environment env = new(iface);
      automatic CoverInstructions_cbs      cover_instructions_cbs = new;
      automatic CoverOpCodes_cbs           cover_opcodes_cbs = new;
      automatic Assert_addi_cbs            assert_addi_cbs = new(verbose);
      automatic Assert_lui_cbs             assert_lui_cbs = new(verbose);
      automatic Debug_instruction_cbs      debug_instruction_cbs = new;
      automatic Debug_address_cbs          debug_address_cbs = new;
      automatic Debug_registers_cbs        debug_registers_cbs = new;
      automatic Save_history_cbs           save_history_cbs = new("history.csv");
      automatic Debug_uart                 debug_uart = new("sv_debug.txt");
      env.mon.cbs.push_back(cover_instructions_cbs);
      env.mon.cbs.push_back(cover_opcodes_cbs);
      env.mon.cbs.push_back(assert_addi_cbs);
      env.mon.cbs.push_back(assert_lui_cbs);
      env.mon.cbs.push_back(debug_instruction_cbs);
      // env.mon.cbs.push_back(debug_address_cbs);
      // env.mon.cbs.push_back(debug_registers_cbs);
      env.mon.cbs.push_back(save_history_cbs);
      env.mon.cbs.push_back(debug_uart);
      env.run();
   end

endmodule // tb_top
