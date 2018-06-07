typedef enum bit [6:0] {
  LOAD    = 7'b00_000_11,
  OPP_IMM = 7'b00_100_11,
  AUIPC   = 7'b00_101_11,
  STORE   = 7'b01_000_11,
  OP      = 7'b01_100_11,
  LUI     = 7'b01_101_11,
  BRANCH  = 7'b11_000_11,
  JALR    = 7'b11_001_11,
  JAL     = 7'b11_011_11,
  SYSTEM  = 7'b11_100_11
}  Opcode;

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

class CoverOpCodes_cbs extends InstrMonitor_cbs;
  CoverOpCodes cov;

  function new;
    this.cov = new;
  endfunction

  virtual task pre_tx(input Config cfg,
                      input bit[31:0] instr);
    Opcode opcode;
    assert(instr[1:0]==2'b11) else
    begin
      $display("Error: instr[1:0] != 2'b11 : %2b", instr[1:0]);
      cfg.nErrors++;
    end
    assert($cast(opcode, instr[6:0])) else
    begin
      $display("Error: opcode not expected: %7b", instr[6:0]);
      $display("instr: %32b", instr[31:0]);
      cfg.nErrors++;
    end
    cov.sample(opcode);
  endtask

endclass
