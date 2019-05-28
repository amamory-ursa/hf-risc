class CoverOpCodes;
  Opcode opcode;

  covergroup OpCodes_covergroup;
    coverpoint opcode;
  endgroup

  // Instantiate the covergroup
  function new;
    OpCodes_covergroup = new;
  endfunction : new

  // Sample input data
  function void sample(input Opcode opcode);
    this.opcode = opcode;
    OpCodes_covergroup.sample();
  endfunction : sample

endclass

class CoverOpCodes_cbs extends Monitor_cbs;
  CoverOpCodes cov;
  int nErrors;

  function new;
    this.cov = new;
  endfunction

  virtual task time_step(int t, ref Timemachine timemachine);
    Opcode opcode;
    Instruction instruction;
    Snapshot snap;
    super.time_step(t, timemachine);

    snap = timemachine.snapshot[t];
    if (snap.skip || t == 0)
      return;
    assert(snap.base[1:0]==2'b11) else
    begin
      $display("t:%1d Error: base[1:0] != 2'b11 : %2b", t, snap.base[1:0]);
      this.nErrors++;
    end
    assert($cast(opcode, snap.base[6:0])) else
    begin
      $display("t:%1d Error: opcode not expected: %7b", t, snap.base[6:0]);
      $display("base     : %32b", snap.base);
      this.nErrors++;
    end
    if ($cast(opcode, snap.base[6:0])) begin
      assert($cast(snap.base, snap.base & OpcodeMask[opcode])) else
      begin
        $display("t:%1d Error: intruction not expected: %32b", t, snap.base);
        this.nErrors++;
      end
    end
    cov.sample(opcode);
  endtask

  virtual task terminated();
    super.terminated();
    $display("CoverOpCodes errors:                               %d", this.nErrors);
  endtask
endclass
