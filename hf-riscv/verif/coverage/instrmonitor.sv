class InstrMonitor_cbs;
  virtual task pre_tx(input Config cfg,
                      input bit[31:0] instr);
  endtask: pre_tx
endclass
