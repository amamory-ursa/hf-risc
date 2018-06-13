class Assert_addi_cbs extends Monitor_cbs;
  int failed;
  int passed;
  bit verbose;

  function new(bit verbose);
    this.verbose = verbose;
  endfunction

  virtual task time_step(int t, ref Timemachine timemachine);
    Snapshot past;
    Snapshot now;
    super.time_step(t, timemachine);
    now = timemachine.snapshot[t];
    past = timemachine.snapshot[t-3];

    if (past.instruction === ADDI)
    begin
      I_struct decoded = past.base;
      logic [31:0] expected;
      logic [31:0] got;
      expected = past.registers[past.rs1] + past.imm;
      got = now.registers[now.rd];
      assert(got === expected) this.passed ++; else
      begin
        if (verbose) begin
          $display("ADDI assertion error. Expected: 0x%4h, got: 0x%4h.", expected, got);
          $display("  difference : %4h (%d)", got - expected, got - expected);
          $display("  past.imm   : %d", past.imm);
          $display("  past[rd]   : %d", past.registers[past.rd]);
          $display("  past[rs1]  : %d", past.registers[past.rs1]);
          $display("  now[rd]    : %d", now.registers[now.rd]);
          $display("  now[rs1]   : %d", now.registers[now.rs1]);
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
