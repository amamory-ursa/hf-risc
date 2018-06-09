class Debug_instruction_cbs extends Monitor_cbs;

  virtual task instruction(Opcode opcode, Instruction instruction, bit[31:0] instr);
    super.instruction(opcode, instruction, instr);
    $display("instruction: %s", instruction);
  endtask
endclass
