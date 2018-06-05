`ifndef GPIO_SV
 `define GPIO_SV

 `include "hfrv_interface.sv"

typedef enum { in, out } direction;

class gpio_trans;
  rand time t_time;
  rand bit [7:0] value;
  	   direction d;

  constraint time_valid
    {t_time < 100000;   //100us
     t_time >   5000; } //5us

endclass

class gpio_cfg;
  rand time init_time;
  rand int num_io;

  constraint num_io_valid
    {num_io < 64;
     num_io > 8; }
  constraint init_time_valid
    {init_time > 1000000;  //1ms
     init_time < 2000000;} //2ms
  
endclass

class gpio_gen;
  rand gpio_cfg cfg;
  rand gpio_trans trans;

  mailbox gen2driv;

  function new(mailbox gen2driv);
    this.gen2driv = gen2driv;
    cfg = new;
  	if( !cfg.randomize() ) $fatal("randomization failed");
  endfunction

  task run();
  	$display("GPIO: num_io = %d, init_time = %d", cfg.num_io, cfg.init_time);
  	#cfg.init_time;
    repeat(cfg.num_io) begin
      trans = new();
      if( !trans.randomize() ) $fatal("randomization failed");
      trans.d = in;
      #trans.t_time;
      gen2driv.put(trans);
    end
  endtask

endclass


class gpio_drv;

  virtual hfrv_interface.gpio gpio;
  mailbox gen2driv;
  mailbox driv2ckr;

  function new(virtual hfrv_interface.gpio vif, mailbox gen2driv, mailbox driv2ckr);
    this.gpio = vif;
    this.gen2driv = gen2driv;
    this.driv2ckr = driv2ckr;
  endfunction


  task run;
  	gpio.extio_in = 0;
    forever begin
      gpio_trans trans;
      gen2driv.get(trans);
      gpio.extio_in = trans.value;
      trans.t_time = $time;
      driv2ckr.put(trans);
    end
  endtask

endclass


`endif