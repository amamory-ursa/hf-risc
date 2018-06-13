function logic [31:0] toInstr(logic [31:0] data_access);
  logic [31:0] result;
  result = {<<4{data_access}};
  return result;
endfunction

class Timemachine;
  Snapshot snapshot[$];

  function bit isInstruction(int timecounter);
    if (snapshot[timecounter].data_access == 1)
      return 1;
    if (timecounter > 0)
      if (snapshot[timecounter-1].data_access == 1)
        return 1;
    return 0;
  endfunction

  // function Opcode getOpcode(int timecounter);
  //   logic [31:0] instr = toInstr()
  //   $cast(instr,tb_top.dut.cpu.inst_in_s);
  //   if ($cast(opcode, instr[6:0])) begin
  //     if ($cast(instruction, instr & OpcodeMask[opcode]))
  //     begin
  //       // SLLI, SRLI and SRAI mix OPP_IMM and OP: OPP_IMM OPCODE with OP mask.
  //       // Because of that, SRAI is always mistaken as SRLI
  //       if (instruction === SRLI) begin
  //         $cast(instruction, instr & OpcodeMask_SR_I);
  //       end
  //       foreach (cbs[i]) begin
  //         cbs[i].instruction(opcode, instruction, instr);
  //       end
  //     end
  //   end
  // endfunction
endclass
