class Debug_registers_cbs extends Monitor_cbs;

  virtual task post_instruction(Opcode opcode,
                           Instruction instruction,
                           bit[31:0] base,
                           Snapshot pre_snapshot,
                           Snapshot post_snapshot);
    super.post_instruction(opcode, instruction, base, pre_snapshot, post_snapshot);
    foreach (pre_snapshot.registers[i])
    begin
      $display("register[%d]  : %d", i, pre_snapshot.registers[i]);
    end
  endtask
endclass
