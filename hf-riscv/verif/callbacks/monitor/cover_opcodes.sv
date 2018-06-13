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

    snap = timemachine[t];
    assert(snap.base[1:0]==2'b11) else
    begin
      $display("Error: base[1:0] != 2'b11 : %2b", base[1:0]);
      this.nErrors++;
    end
    assert($cast(opcode, base[6:0])) else
    begin
      $display("Error: opcode not expected: %7b", base[6:0]);
      $display("base: %32b", base[31:0]);
      this.nErrors++;
    end
    if ($cast(opcode, base[6:0])) begin
      assert($cast(base, base & OpcodeMask[opcode])) else
      begin
        $display("Error: intruction not expected: %32b", base);
        this.nErrors++;
      end
    end
    cov.sample(opcode);
  endtask

  virtual task terminated();
    super.terminated();
    $display("CoverOpCodes errors: %d", this.nErrors);
  endtask
endclass
