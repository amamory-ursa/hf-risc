`ifndef GENERATOR_SV
 `define GENERATOR_SV

 `include "memory.sv"

class generator;

   memory_model ram;    
   mailbox      gen2agent;  // Mailbox to driver for cells
   event        terminated;  // Event from monitor when terminated program execution
   event end_chkr;
     
   function new(input mailbox gen2agent,
                input event terminated,
                input event end_chkr);
      this.gen2agent = gen2agent;
      this.terminated = terminated;
      this.end_chkr = end_chkr;
   endfunction : new

   task run();
      forever begin
         ram = new("code.txt", 32'h40000000, 'h100000);
         $display("sending program to agent");
         gen2agent.put(ram);
         @(terminated);
         @(end_chkr);
         $finish;
      end
   endtask // run


endclass : generator

`endif
