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
      bit [31:0] expected;
      bit [31:0] got;
      expected = pre_snapshot.registers[decoded.rs1] + decoded.imm;
      got = post_snapshot.registers[decoded.rd];
      assert(got === expected) else
      begin
        $display("ADDI assertion error. Expected: 0x%4h, got: 0x%4h.", expected, got);
        $display("  pre_register[rd]  : %d", pre_snapshot.registers[decoded.rd]);
        $display("  pre_register[rs1] : %d", pre_snapshot.registers[decoded.rs1]);
        $display("  pre_imm           : %d", decoded.imm);
        $display("  post_register[rd] : %d", post_snapshot.registers[decoded.rd]);
        $display("  post_register[rs1]: %d", post_snapshot.registers[decoded.rs1]);
        this.nErrors++;
      end
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
