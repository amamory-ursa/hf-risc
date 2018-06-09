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

class CoverOpCodes_cbs extends Monitor_cbs;
  CoverOpCodes cov;
  int nErrors;

  function new;
    this.cov = new;
  endfunction

  virtual task zzz___mem(virtual hfrv_interface.monitor iface);
    Opcode opcode;
    $display("---------------------------------");
    $display("clk");
    if($cast(opcode, tb_top.dut.cpu.inst_in_s[6:0]))
    begin
    $display("opcode:     %s", opcode);
    end
    $display("data_read:  %32b", iface.mem.data_read);
    $display("opcode, funct3, funct7: %7b %3b %7b",
      tb_top.dut.cpu.opcode,
      tb_top.dut.cpu.funct3,
      tb_top.dut.cpu.funct3);
    $display("address:    %4h", tb_top.dut.cpu.address);
    $display("pc:         %32b", tb_top.dut.cpu.pc);
    $display("---------------------------------");
  endtask

  task debug_pre_check();
    $display("data_access <=================================================");
    $display("opcode, funct3, funct7: %7b %3b %7b",
      tb_top.dut.cpu.opcode,
      tb_top.dut.cpu.funct3,
      tb_top.dut.cpu.funct3);
  endtask

  task debug_post_check(Opcode opcode);
    $display("opcode:     %s", opcode);
    $display("register 1: ", tb_top.dut.cpu.register_bank.registers[1]);
    $display("address:    %4h", tb_top.dut.cpu.address);
    $display("inst_in_s:  %32b", tb_top.dut.cpu.inst_in_s);
    $display("pc:         %32b", tb_top.dut.cpu.pc);
    $display("---------------------------------");
  endtask

  virtual task data_access();
    Opcode opcode;
    bit[31:0] instr;

    // debug_pre_check();
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

    // debug_post_check(opcode);
  endtask

endclass
