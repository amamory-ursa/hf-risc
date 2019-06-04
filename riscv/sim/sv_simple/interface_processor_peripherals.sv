
`timescale 1ns/1ns

interface interface_processor_peripherals (input bit clock_in);

  logic reset, stall_sig;
  logic[31:0] address, data_read, data_write;
  logic[3:0] data_we;
  logic[7:0] ext_irq, ext_orq;

endinterface
