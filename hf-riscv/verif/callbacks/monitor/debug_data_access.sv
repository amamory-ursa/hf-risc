class Debug_data_access_cbs extends Monitor_cbs;
  virtual task data_access();
    Opcode opcode;
    $display("data_access <=================================================");
    $display("opcode, funct3, funct7: %7b %3b %7b",
      tb_top.dut.cpu.opcode,
      tb_top.dut.cpu.funct3,
      tb_top.dut.cpu.funct3);
    if($cast(opcode, tb_top.dut.cpu.inst_in_s[6:0]))
    begin
    $display("opcode:     %s", opcode);
    end
    $display("register 1: ", tb_top.dut.cpu.register_bank.registers[1]);
    $display("address:    %4h", tb_top.dut.cpu.address);
    $display("inst_in_s:  %32b", tb_top.dut.cpu.inst_in_s);
    $display("pc:         %32b", tb_top.dut.cpu.pc);
    $display("---------------------------------");
  endtask
endclass
