`ifndef GENERATOR_SV
 `define GENERATOR_SV

 `include "memory.sv"

class generator;

   memory_model ram;    
   mailbox      gen2agent;  // Mailbox to driver for cells
   event        terminated;  // Event from monitor when terminated program execution
   
   function new(input mailbox gen2agent,
                input event terminated);
      this.gen2agent = gen2agent;
      this.terminated = terminated;
   endfunction : new

   task run();
      forever begin
         ram = new("code.txt", 32'h40000000, 'h100000);
         $display("sending program to agent");
         gen2agent.put(ram);
         @(terminated);
      end
   endtask // run


endclass : generator

`endif
