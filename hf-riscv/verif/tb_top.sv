`include "hfrv_interface.sv"
`include "dut_top.sv"

module tp_top;
`include "environment.sv"

   logic clk = 1'b0;

   // clock generator
   always #5 clk = ~clk;

   hfrv_interface iface(.*);
   dut_top dut (.*);

   initial begin
      static environment env = new(iface);
      env.run();
   end
   
endmodule // tp_top
