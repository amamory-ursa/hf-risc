class Debug_address_cbs extends Monitor_cbs;

  virtual task time_step(int t, ref Timemachine timemachine);
    Snapshot snap;
    int i;
    super.time_step(t, timemachine);
    snap = timemachine.snapshot[t];

    $display("address: %8h %d", snap.address, snap.address);
  endtask
endclass
