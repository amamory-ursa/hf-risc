class DutMonitor;
  virtual dut_top adut;
  Config cfg;
  CoverOpCodes_cbs cbs;

  function new(Config cfg);
    //this.adut = mydut;
    this.cfg = cfg;
    this.cbs = new;
  endfunction : new


  task run(input bit[31:0] instr,
           input bit[31:0] pc,
           input bit[31:0] address);
    begin
      this.cbs.pre_tx(this.cfg, instr);//dut.cpu.inst_in_s);
      // $display("errors: ", cfg.nErrors);
    end
  endtask
endclass
