class Termination_monitor extends Monitor_cbs;
  event terminated;

  function new(ref event terminated);
    this.terminated = terminated;
  endfunction

  virtual task mem(virtual hfrv_interface.monitor iface, mailbox msgout);
    if (iface.mem.address == 32'he0000000 && iface.mem.data_we != 4'h0)
    begin
      iface.mem.data_read <= {32{1'b0}};
      ->terminated;
    end
  endtask

endclass