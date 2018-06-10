class Assert_addi_cbs extends Monitor_cbs;
  int nErrors;
  logic [31:0] [31:0] registers;

  virtual task post_instruction(Opcode opcode,
                           Instruction instruction,
                           bit[31:0] instr,
                           Snapshot pre_snapshot,
                           Snapshot post_snapshot);
    super.post_instruction(opcode, instruction, instr, pre_snapshot, post_snapshot);
    // if 
      // $display("vv=============================");
      // $display("POST INSTRADDI imm: ", format.imm);
      // $display("POST ADDI rs1: ", format.rs1);
      // $display("POST ADDI rd: ", format.rd);
      // $display("POST pre register[rs1]: %d", pre_snapshot.registers[format.rs1]);
      // $display("POST pre register[rd] : %d", pre_snapshot.registers[format.rd]);
      // $display("POST pos register[rs1]: %d", post_snapshot.registers[format.rs1]);
      // $display("POST pos register[rd] : %d", post_snapshot.registers[format.rd]);
      // $display("^^=============================");
  endtask
endclass
