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
`include "callbacks/RV32I_INSTR_ADDI_cbs.sv"
`include "callbacks/RV32I_INSTR_SLTI_cbs.sv"
`include "callbacks/RV32I_INSTR_SLTIU_cbs.sv"
`include "callbacks/RV32I_INSTR_ANDI_cbs.sv"
`include "callbacks/RV32I_INSTR_ORI_cbs.sv"
`include "callbacks/RV32I_INSTR_XORI_cbs.sv"
`include "callbacks/RV32I_INSTR_SLLI_cbs.sv"
`include "callbacks/RV32I_INSTR_SRLI_cbs.sv"
`include "callbacks/RV32I_INSTR_SRAI_cbs.sv"
`include "callbacks/RV32I_INSTR_LUI_cbs.sv"
`include "callbacks/RV32I_INSTR_AUIPC_cbs.sv"
`include "callbacks/RV32I_INSTR_ADD_cbs.sv"
`include "callbacks/RV32I_INSTR_SUB_cbs.sv"
`include "callbacks/RV32I_INSTR_SLT_cbs.sv"
`include "callbacks/RV32I_INSTR_SLTU_cbs.sv"
`include "callbacks/RV32I_INSTR_AND_cbs.sv"
`include "callbacks/RV32I_INSTR_OR_cbs.sv"
`include "callbacks/RV32I_INSTR_XOR_cbs.sv"
`include "callbacks/RV32I_INSTR_SLL_cbs.sv"
`include "callbacks/RV32I_INSTR_SRL_cbs.sv"
`include "callbacks/RV32I_INSTR_SRA_cbs.sv"
`include "callbacks/debug_instruction.sv"
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
      automatic RV32I_INSTR_ADDI_cbs       obj_RV32I_INSTR_ADDI_cbs = new(verbose);
      automatic RV32I_INSTR_SLTI_cbs       obj_RV32I_INSTR_SLTI_cbs = new(verbose);
      automatic RV32I_INSTR_SLTIU_cbs      obj_RV32I_INSTR_SLTIU_cbs = new(verbose);
      automatic RV32I_INSTR_ANDI_cbs       obj_RV32I_INSTR_ANDI_cbs = new(verbose);
      automatic RV32I_INSTR_ORI_cbs        obj_RV32I_INSTR_ORI_cbs = new(verbose);
      automatic RV32I_INSTR_XORI_cbs       obj_RV32I_INSTR_XORI_cbs = new(verbose);
      automatic RV32I_INSTR_SLLI_cbs       obj_RV32I_INSTR_SLLI_cbs = new(verbose);
      automatic RV32I_INSTR_SRLI_cbs       obj_RV32I_INSTR_SRLI_cbs = new(verbose);
      automatic RV32I_INSTR_SRAI_cbs       obj_RV32I_INSTR_SRAI_cbs = new(verbose);
      automatic RV32I_INSTR_LUI_cbs        obj_RV32I_INSTR_LUI_cbs = new(verbose);
      automatic RV32I_INSTR_AUIPC_cbs      obj_RV32I_INSTR_AUIPC_cbs = new(verbose);
      automatic RV32I_INSTR_ADD_cbs        obj_RV32I_INSTR_ADD_cbs = new(verbose);
      automatic RV32I_INSTR_SUB_cbs        obj_RV32I_INSTR_SUB_cbs = new(verbose);
      automatic RV32I_INSTR_SLT_cbs        obj_RV32I_INSTR_SLT_cbs = new(verbose);
      automatic RV32I_INSTR_SLTU_cbs       obj_RV32I_INSTR_SLTU_cbs = new(verbose);
      automatic RV32I_INSTR_AND_cbs        obj_RV32I_INSTR_AND_cbs = new(verbose);
      automatic RV32I_INSTR_OR_cbs         obj_RV32I_INSTR_OR_cbs = new(verbose);
      automatic RV32I_INSTR_XOR_cbs        obj_RV32I_INSTR_XOR_cbs = new(verbose);
      automatic RV32I_INSTR_SLL_cbs        obj_RV32I_INSTR_SLL_cbs = new(verbose);
      automatic RV32I_INSTR_SRL_cbs        obj_RV32I_INSTR_SRL_cbs = new(verbose);
      automatic RV32I_INSTR_SRA_cbs        obj_RV32I_INSTR_SRA_cbs = new(verbose);
      automatic Debug_instruction_cbs      debug_instruction_cbs = new;
      automatic Debug_registers_cbs        debug_registers_cbs = new;
      automatic Save_history_cbs           save_history_cbs = new("history.csv");
      automatic Debug_uart                 debug_uart = new("sv_debug.txt");
      env.gen.path = "code.txt";
      env.mon.cbs.push_back(cover_instructions_cbs);
      env.mon.cbs.push_back(cover_opcodes_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_ADDI_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_SLTI_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_SLTIU_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_ANDI_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_ORI_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_XORI_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_SLLI_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_SRLI_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_SRAI_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_LUI_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_AUIPC_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_ADD_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_SUB_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_SLT_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_SLTU_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_AND_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_OR_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_XOR_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_SLL_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_SRL_cbs);
      env.mon.cbs.push_back(obj_RV32I_INSTR_SRA_cbs);
      // env.mon.cbs.push_back(debug_instruction_cbs);
      // env.mon.cbs.push_back(debug_registers_cbs);
      env.mon.cbs.push_back(save_history_cbs);
      env.mon.cbs.push_back(debug_uart);
      env.iog.filename = "";
      env.iog.gen_cfg();
      env.run();
   end

endmodule // tb_top
