class Debug_registers_cbs extends Monitor_cbs;

  virtual task time_step(int t, ref Timemachine timemachine);
    Snapshot snap;
    int i;
    super.time_step(t, timemachine);
    snap = timemachine.snapshot[t];

    i=0;
    $display("%d:%8h %d:%8h %d:%8h %d:%8h %d:%8h %d:%8h %d:%8h %d:%8h"
      ,i+0, snap.registers[i+0]
      ,i+1, snap.registers[i+1]
      ,i+2, snap.registers[i+2]
      ,i+3, snap.registers[i+3]
      ,i+4, snap.registers[i+4]
      ,i+5, snap.registers[i+5]
      ,i+6, snap.registers[i+6]
      ,i+7, snap.registers[i+7]
    );
    i=8;
    $display("%d:%8h %d:%8h %d:%8h %d:%8h %d:%8h %d:%8h %d:%8h %d:%8h"
      ,i+0, snap.registers[i+0]
      ,i+1, snap.registers[i+1]
      ,i+2, snap.registers[i+2]
      ,i+3, snap.registers[i+3]
      ,i+4, snap.registers[i+4]
      ,i+5, snap.registers[i+5]
      ,i+6, snap.registers[i+6]
      ,i+7, snap.registers[i+7]
    );
    i=16;
    $display("%d:%8h %d:%8h %d:%8h %d:%8h %d:%8h %d:%8h %d:%8h %d:%8h"
      ,i+0, snap.registers[i+0]
      ,i+1, snap.registers[i+1]
      ,i+2, snap.registers[i+2]
      ,i+3, snap.registers[i+3]
      ,i+4, snap.registers[i+4]
      ,i+5, snap.registers[i+5]
      ,i+6, snap.registers[i+6]
      ,i+7, snap.registers[i+7]
    );
    i=24;
    $display("%d:%8h %d:%8h %d:%8h %d:%8h %d:%8h %d:%8h %d:%8h %d:%8h"
      ,i+0, snap.registers[i+0]
      ,i+1, snap.registers[i+1]
      ,i+2, snap.registers[i+2]
      ,i+3, snap.registers[i+3]
      ,i+4, snap.registers[i+4]
      ,i+5, snap.registers[i+5]
      ,i+6, snap.registers[i+6]
      ,i+7, snap.registers[i+7]
    );
  endtask
endclass
