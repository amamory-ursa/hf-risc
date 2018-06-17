class Assert_lui_cbs extends Monitor_cbs;
  int failed;
  int passed;
  bit verbose;

  function new(bit verbose);
    this.verbose = verbose;
  endfunction

  virtual task post_instruction(Opcode opcode,
                           Instruction instruction,
                           bit[31:0] base,
                           Snapshot pre_snapshot,
                           Snapshot post_snapshot);
    super.post_instruction(opcode, instruction, base, pre_snapshot, post_snapshot);
    if (instruction === LUI)
    begin
      U_struct decoded = base;
      bit [31:0] expected;
      bit [31:0] got;
      bit [31:0] imm = getImm(base);
      expected = imm;
      got = post_snapshot.registers[decoded.rd];
      assert(got === expected) this.passed++; else
      begin
        if (verbose) begin
          $display("LUI assertion error. Expected: 0x%4h, got: 0x%4h.", expected, got);
          $display("  difference        : %4h", got - expected);
          $display("  imm               : %d", imm);
          $display("  pre_register[rd]  : %d", pre_snapshot.registers[decoded.rd]);
          $display("  post_register[rd] : %d", post_snapshot.registers[decoded.rd]);
        end
        this.failed++;
      end
    end
  endtask

  virtual task terminated();
    super.terminated();
    $display("Assert_lui passed: %d, failed: %d", this.passed, this.failed);
  endtask
endclass
