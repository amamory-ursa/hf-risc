class Assert_addi_cbs extends Monitor_cbs;
  int nErrors;
  logic [31:0] [31:0] registers;

  virtual task instruction(Opcode opcode, Instruction instruction, bit[31:0] instr);
    super.instruction(opcode, instruction, instr);
    if (instruction === ADDI)
    begin
      I format = instr;
      foreach (registers[i]) begin
        registers[i] = tb_top.dut.cpu.register_bank.registers[i];
      end
      $display("ADDI imm: ", format.imm);
      $display("ADDI rs1: ", format.rs1);
      $display("ADDI rd: ", format.rd);
      $display("register[%d]: %d", format.rs1, tb_top.dut.cpu.register_bank.registers[format.rs1]);
      $display("register[%d]: %d", format.rd, tb_top.dut.cpu.register_bank.registers[format.rd]);
      fork
        begin
          @(posedge tb_top.iface.mem.data_access)
          $display("register[%d]=>%d", format.rs1, tb_top.dut.cpu.register_bank.registers[format.rs1]);
          $display("register[%d]=>%d", format.rd, tb_top.dut.cpu.register_bank.registers[format.rd]);
        end
      join_none
      assert(1 === 0) else
      begin
        this.nErrors++;
      end
    end
  endtask

  virtual task terminated();
    super.terminated();
    if (nErrors > 0)
    begin
      $display("Assert_addi errors: %d", this.nErrors);
    end
  endtask
endclass
