`timescale 1ns/1ps

`include "hfrv_interface.sv"
`include "dut_top.sv"

module tb_top;
`include "types/instructions_formats.sv"
`include "types/snapshot.sv"
`include "types/opcode.sv"
`include "types/instruction.sv"
`include "types/getimm.sv"
`include "environment.sv"
`include "callbacks/monitor/cover_instructions.sv"
`include "callbacks/monitor/cover_opcodes.sv"
`include "callbacks/monitor/assert_addi.sv"
`include "callbacks/monitor/assert_lui.sv"
`include "callbacks/monitor/debug_data_access.sv"
`include "callbacks/monitor/debug_instruction.sv"
`include "callbacks/monitor/debug_mem.sv"
`include "callbacks/monitor/debug_post_instruction.sv"
`include "callbacks/monitor/debug_process.sv"

   logic clk = 1'b0;

   // clock generator
   always #5 clk = ~clk;

   hfrv_interface iface(.*);
   dut_top dut (.*);

   initial begin
      static environment env = new(iface);
      automatic CoverInstructions_cbs      cover_instructions_cbs = new;
      automatic CoverOpCodes_cbs           cover_opcodes_cbs = new;
      automatic Assert_addi_cbs            assert_addi_cbs = new;
      automatic Assert_lui_cbs             assert_lui_cbs = new;
      automatic Debug_data_access_cbs      debug_data_access_cbs = new;
      automatic Debug_instruction_cbs      debug_instruction_cbs = new;
      automatic Debug_mem_cbs              debug_mem_cbs = new;
      automatic Debug_post_instruction_cbs debug_post_instruction_cbs = new;
      automatic Debug_process              debug_process = new("sv_debug.txt");
      env.mon.cbs.push_back(cover_instructions_cbs);
      env.mon.cbs.push_back(cover_opcodes_cbs);
      env.mon.cbs.push_back(assert_addi_cbs);
      env.mon.cbs.push_back(assert_lui_cbs);
      // env.mon.cbs.push_back(debug_data_access_cbs);
      // env.mon.cbs.push_back(debug_instruction_cbs);
      // env.mon.cbs.push_back(debug_mem_cbs);
      // env.mon.cbs.push_back(debug_post_instruction_cbs);
      env.mon.cbs.push_back(debug_process);
      env.run();
   end

endmodule // tb_top
