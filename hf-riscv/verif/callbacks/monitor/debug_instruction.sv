class Debug_instruction_cbs extends Monitor_cbs;

  virtual task data_access();
    Opcode opcode;
    Instruction instruction;
    bit[31:0] instr;
    super.data_access();

    $cast(instr,tb_top.dut.cpu.inst_in_s);

    if ($cast(opcode, instr[6:0])) begin
      if($cast(instruction, instr & OpcodeMask[opcode]))
      begin
        $display("instruction: %s", instruction);
      end
    end
  endtask
endclass
