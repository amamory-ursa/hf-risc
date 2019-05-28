
`timescale 1ns/1ns

interface interface_busmux_mem (input bit clock_in);

  //variable declarations
  logic[31:0] address, data_read, data_write;
  logic[3:0] data_we;

endinterface
