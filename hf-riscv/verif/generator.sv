`ifndef GENERATOR_SV
 `define GENERATOR_SV

 `include "memory.sv"

class generator;

   memory_model ram;    
   mailbox      gen2agent;  // Mailbox to driver for cells
   event        dut_terminated;  // Event from monitor when terminated program execution
   event        sb_terminated;
   string       path;
    
   function new(input mailbox gen2agent,
                input event dut_terminated,
                input event sb_terminated);
      this.gen2agent = gen2agent;
      this.dut_terminated = dut_terminated;
      this.sb_terminated = sb_terminated;
      this.path = "code.txt";
   endfunction : new

   task run();
      begin
         ram = new(path, 32'h40000000, 'h100000);
         $display("sending program to agent");
         gen2agent.put(ram);

         fork;   
            wait(dut_terminated.triggered);
            wait(sb_terminated.triggered);
         join;
         
         $stop;
      end
   endtask // run


endclass : generator

`endif
