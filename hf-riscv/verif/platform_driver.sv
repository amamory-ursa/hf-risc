`ifndef PLATFORM_DRIVER_SV
 `define PLATFORM_DRIVER_SV

 `include "hfrv_interface.sv"

typedef class platform_driver;

virtual class platform_transaction;
   pure virtual task run(platform_driver cb);
endclass // platform_transaction

class platform_driver;
   virtual hfrv_interface.driver iface;
   mailbox gen2drv;

   function new
     (virtual hfrv_interface.driver iface,
      mailbox gen2drv);
      
      this.iface = iface;
      this.gen2drv = gen2drv;
   endfunction; // new

   task run();
      automatic platform_transaction cmd;
      iface.reset = 1;
      iface.stall = 0;
      #10;
      forever begin
         gen2drv.get(cmd);
         $display("platform driver received cmd");
         cmd.run(this);
      end
   endtask; // run
   
endclass; // platform_driver

class start_cpu extends platform_transaction;
   virtual task run(platform_driver cb);
      $display("starting cpu");
      cb.iface.reset = 0;
   endtask; // run
endclass // start_cpu

class stop_cpu extends platform_transaction;
   virtual task run(platform_driver cb);
      $display("stoping cpu");
      cb.iface.reset = 1;
      #10;
   endtask; // run
endclass // stop_cpu
   
`endif
