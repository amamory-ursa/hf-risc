class Debug_registers_cbs extends Monitor_cbs;

  virtual task time_step(int t, ref Timemachine timemachine);
    Snapshot snap;
    super.time_step(t, timemachine);
    snap = timemachine.snapshot[t];

    foreach (snap.registers[i])
    begin
      $display("register[%d]  : %d", i, snap.registers[i]);
    end
  endtask
endclass
