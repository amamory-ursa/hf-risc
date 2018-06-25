class RV32I_INSTR_SUB_cbs extends Monitor_cbs;
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
    past = timemachine.snapshot[t-1];

    if ((!past.skip) && past.instruction === SUB)
    begin
      logic [31:0] expected;
      logic [31:0] got;
      expected = past.registers[past.rs1] - past.registers[past.rs2];
      got = now.registers[past.rd];
      assert(got === expected) this.passed++; else
      begin
        if (verbose) begin
          $display("t:%1d %s assertion error. Expected: 0x%4h, got: 0x%4h.",
          t, past.instruction, expected, got);
        end
        this.failed++;
      end
    end
  endtask

  virtual task terminated();
    super.terminated();
    $display("RV32I_INSTR_SUB\tpassed: %d, failed: %d", this.passed, this.failed);
  endtask
endclass
