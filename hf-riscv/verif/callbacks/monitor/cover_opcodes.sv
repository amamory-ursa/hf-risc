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

  virtual task data_access();
    Opcode opcode;
    bit[31:0] instr;
    super.data_access();

    $cast(instr,tb_top.dut.cpu.inst_in_s);

    assert(instr[1:0]==2'b11) else
    begin
      $display("Error: instr[1:0] != 2'b11 : %2b", instr[1:0]);
      this.nErrors++;
    end
    assert($cast(opcode, instr[6:0])) else
    begin
      $display("Error: opcode not expected: %7b", instr[6:0]);
      $display("instr: %32b", instr[31:0]);
      this.nErrors++;
    end
    cov.sample(opcode);

  endtask
endclass
