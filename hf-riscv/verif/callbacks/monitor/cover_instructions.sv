class CoverInstructions;
  Instruction instruction;

  covergroup Instructions_covergroup;
    coverpoint instruction;
  endgroup

  // Instantiate the covergroup
  function new;
    Instructions_covergroup = new;
  endfunction : new

  // Sample input data
  function void sample(input Instruction instruction);
    this.instruction = instruction;
    Instructions_covergroup.sample();
  endfunction : sample

endclass

class CoverInstructions_cbs extends Monitor_cbs;
  CoverInstructions cov;
  int nErrors;

  function new;
    this.cov = new;
  endfunction

  virtual task time_step(int t, ref Timemachine timemachine);
    super.instruction(t, timemachine);
    cov.sample(timemachine.snapshot[t].instruction);
  endtask

  virtual task terminated();
    super.terminated();
    $display("CoverInstructions errors: %d", this.nErrors);
  endtask
endclass
