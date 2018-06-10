class Assert_addi_cbs extends Monitor_cbs;
  int nErrors;
  bit verbose;
  
  function new(bit verbose);
    this.verbose = verbose;
  endfunction

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
      bit [31:0] imm = getImm(instr);
      expected = pre_snapshot.registers[decoded.rs1] + imm;
      got = post_snapshot.registers[decoded.rd];
      assert(got === expected) else
      begin
        if (verbose) begin
          $display("ADDI assertion error. Expected: 0x%4h, got: 0x%4h.", expected, got);
          $display("  difference        : %4h", got - expected);
          $display("  imm               : %d", imm);
          $display("  pre_register[rd]  : %d", pre_snapshot.registers[decoded.rd]);
          $display("  pre_register[rs1] : %d", pre_snapshot.registers[decoded.rs1]);
          $display("  post_register[rd] : %d", post_snapshot.registers[decoded.rd]);
          $display("  post_register[rs1]: %d", post_snapshot.registers[decoded.rs1]);
        end
        this.nErrors++;
      end
    end
  endtask

  virtual task terminated();
    super.terminated();
    $display("Assert_addi errors: %d", this.nErrors);
  endtask
endclass
