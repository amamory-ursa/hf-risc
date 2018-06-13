class Assert_addi_cbs extends Monitor_cbs;
  int failed;
  int passed;
  bit verbose;

  function new(bit verbose);
    this.verbose = verbose;
  endfunction

  virtual task time_step(int timecounter,
                         Timemachine timemachine);
    super.time_step(int timecounter,
                    Timemachine timemachine);
    Instruction instruction = getInstruction(timemachine[timecounter]);
    logic [31:0] base = getInstr(timemachine[timecounter]);
    if (instruction === ADDI)
    begin
      I_struct decoded = base;
      bit [31:0] expected;
      bit [31:0] got;
      bit [31:0] imm = getImm(base);
      expected = pre_snapshot.registers[decoded.rs1] + imm;
      got = post_snapshot.registers[decoded.rd];
      assert(got === expected) this.passed ++; else
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
        this.failed++;
      end
    end
  endtask

  virtual task terminated();
    super.terminated();
    $display("Assert_addi passed: %d, failed: %d", this.passed, this.failed);
  endtask
endclass
