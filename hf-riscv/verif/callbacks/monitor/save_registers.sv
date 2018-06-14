class Save_registers_cbs extends Monitor_cbs;
  integer f;

  function new(string path);
    f = $fopen(path,"w");
  endfunction

  virtual task time_step(int t, ref Timemachine timemachine);
    Snapshot snap;
    super.time_step(t, timemachine);
    snap = timemachine.snapshot[t];

    $fwrite(f, "%d,%d", t, snap.address);
    foreach (snap.registers[i]) begin
      $fwrite(f, "%d,", snap.registers[i]);
    end
    $fwrite(f,"\n");
  endtask

  virtual task terminated();
    super.terminated();
    $fclose(f);
  endtask
endclass
