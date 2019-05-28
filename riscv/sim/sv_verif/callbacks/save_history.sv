class Save_history_cbs extends Monitor_cbs;
  integer f;

  function new(string path);
    f = $fopen(path,"w");
    $fwrite(f, "        \"t\",");
    $fwrite(f, "      \"pc\",");
    $fwrite(f, "\"data_access\",");
    $fwrite(f, "\"skip\",");
    // $fwrite(f, " \"pc_next\",");
    // $fwrite(f, " \"pc_last\",");
    // $fwrite(f, "\"pc_last2\",");
    // $fwrite(f, "\"pc_plus4\",");
    // $fwrite(f, " \"address\",");
    $fwrite(f, "\"instr\",");
    $fwrite(f, "\"rd\",");
    $fwrite(f, "\"rs1\",");
    $fwrite(f, "\"rs2\",");
    $fwrite(f, "\"imm\",");
    for(int i = 0; i < 32; i++) begin
      $fwrite(f, "%d,", i);
    end
    $fwrite(f,"\n");
  endfunction

  virtual task time_step(int t, ref Timemachine timemachine);
    Snapshot snap;
    super.time_step(t, timemachine);
    snap = timemachine.snapshot[t];

    $fwrite(f, "%d,", t);
    $fwrite(f, "%d,", snap.pc);
    $fwrite(f, "%d,", snap.data_access);
    $fwrite(f, "%d,", snap.skip);
    // $fwrite(f, "%d,", snap.pc_next);
    // $fwrite(f, "%d,", snap.pc_last);
    // $fwrite(f, "%d,", snap.pc_last2);
    // $fwrite(f, "%d,", snap.pc_plus4);
    // $fwrite(f, "%d,", snap.address);
    $fwrite(f, "\"%s\",", snap.instruction);
    $fwrite(f, "%d,", snap.rd);
    $fwrite(f, "%d,", snap.rs1);
    $fwrite(f, "%d,", snap.rs2);
    $fwrite(f, "%d,", snap.imm);
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
