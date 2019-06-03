`ifndef GENERATOR_SV
 `define GENERATOR_SV

 `include "memory.sv"

class generator;

   memory_model ram;    
   mailbox      gen2agent;  // Mailbox to driver for cells
   event        terminated;  // Event from monitor when terminated program execution
   event end_chkr;
   string       path;
   function new(input mailbox gen2agent,
                input event terminated,
                input event end_chkr);
      this.gen2agent = gen2agent;
      this.terminated = terminated;
      this.end_chkr = end_chkr;
      this.path = "code.txt";
   endfunction : new

   task run();
      begin
         $display("generating ram");
         ram = new(path, 32'h40000000, 'h100000);
         gen2agent.put(ram);
         // Waiting DUT to finish
         //@(terminated);
         // Waiting Checker module to finish
         @(end_chkr);
         // Finishing simulation
         $finish;
      end
   endtask // run

endclass : generator

`endif
