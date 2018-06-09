class Debug_mem_cbs extends Monitor_cbs;

  virtual task mem(virtual hfrv_interface.monitor iface);
    Opcode opcode;
    $display("---------------------------------");
    $display("clk");
    if($cast(opcode, tb_top.dut.cpu.inst_in_s[6:0]))
    begin
    $display("opcode:     %s", opcode);
    end
    // $display("data_read:  %32b", iface.mem.data_read);
    $display("opcode, funct3, funct7: %7b %3b %7b",
      tb_top.dut.cpu.opcode,
      tb_top.dut.cpu.funct3,
      tb_top.dut.cpu.funct3);
    $display("address:    %4h", tb_top.dut.cpu.address);
    $display("pc:         %32b", tb_top.dut.cpu.pc);
    $display("---------------------------------");
  endtask
endclass
