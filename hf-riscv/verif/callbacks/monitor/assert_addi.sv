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
    Snapshot temp;
    int steps = 2;
    super.time_step(t, timemachine);
    now = timemachine.snapshot[t];
    past = timemachine.snapshot[t-steps];

    if (timemachine.isInstruction(t-steps) && past.instruction === ADDI)
    begin
      I_struct decoded = past.base;
      logic [31:0] expected;
      logic [31:0] got;
      expected = past.registers[past.rs1] + past.imm;
      got = now.registers[past.rd];
      assert(got === expected) this.passed ++; else
      begin
        if (verbose) begin
          $display("ADDI assertion error. Expected: 0x%4h, got: 0x%4h.", expected, got);
          // $display("  difference : %4h (%d)", got - expected, got - expected);
          temp = timemachine.snapshot[t-0];
          $display("  t-0[rd %2d]    : %d", past.rd, temp.registers[past.rd]);
          temp = timemachine.snapshot[t-1];
          $display("  t-1[rd %2d]    : %d", past.rd, temp.registers[past.rd]);
          temp = timemachine.snapshot[t-2];
          $display("  t-2[rd %2d]    : %d", past.rd, temp.registers[past.rd]);
          temp = timemachine.snapshot[t-3];
          $display("  t-3[rd %2d]    : %d", past.rd, temp.registers[past.rd]);
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
