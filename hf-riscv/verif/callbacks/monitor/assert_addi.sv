class Assert_addi_cbs extends Monitor_cbs;
  int nErrors;
  logic [31:0] [31:0] registers;

  virtual task post_instruction(Opcode opcode,
                           Instruction instruction,
                           bit[31:0] instr,
                           Snapshot pre_snapshot,
                           Snapshot post_snapshot);
    super.post_instruction(opcode, instruction, instr, pre_snapshot, post_snapshot);
    if (instruction === ADDI)
    begin
      I_struct decoded = instr;
      $display("vv=============================");
      $display("POST ADDI imm: ", decoded.imm);
      $display("POST ADDI rs1: ", decoded.rs1);
      $display("POST ADDI rd: ", decoded.rd);
      $display("POST pre register[rs1]: %d", pre_snapshot.registers[decoded.rs1]);
      $display("POST pre register[rd] : %d", pre_snapshot.registers[decoded.rd]);
      $display("POST pos register[rs1]: %d", post_snapshot.registers[decoded.rs1]);
      $display("POST pos register[rd] : %d", post_snapshot.registers[decoded.rd]);
      $display("^^=============================");
    end
  endtask

  virtual task terminated();
    super.terminated();
    if (nErrors > 0)
    begin
      $display("Assert_addi errors: %d", this.nErrors);
    end
  endtask
endclass
