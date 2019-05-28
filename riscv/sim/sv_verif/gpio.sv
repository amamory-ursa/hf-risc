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
     t_time >  20000; } //20us

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
       mailbox gen2scb;
       string filename;

  int interval;
  int value[integer];

  function new(mailbox gen2driv, mailbox gen2scb);
    this.gen2driv = gen2driv;
    this.gen2scb = gen2scb;
    cfg = new;
  endfunction

  task gen_cfg();
    if(filename != "") begin
      int code, i, r;
      int r_int;

      if(filename != "") begin
        code = $fopen(filename,"r");
        if(code) begin
          cfg = new();
          r = $fscanf(code,"init_time = %d\n", cfg.init_time);
          r = $fscanf(code,"interval = %d\n", interval);
          r = $fscanf(code,"io_num = %d\n", cfg.num_io);

          i = 0;
          while(!$feof(code)) begin
            r = $fscanf(code,"%d\n",r_int);
            value[i] = r_int;
            i++;
          end
          $fclose(code);
        end
      end
    end
    else
      if( !cfg.randomize() ) $fatal("randomization failed");
  endtask

  task run();
    int i;

    $display("GPIO: num_io = %d, init_time = %d", cfg.num_io, cfg.init_time);
    //#cfg.init_time;
    trans = new();
    trans.value = cfg.num_io;
    trans.d = in;
    trans.t_time = cfg.init_time;
    gen2driv.put(trans);
    gen2scb.put(trans);
    i = 0;
    repeat(cfg.num_io) begin
      trans = new();
      if (value.exists(i)) begin
        trans.value = value[i];
        trans.t_time = interval;
      end
      else
        if( !trans.randomize() ) $fatal("randomization failed");
      trans.d = in;
      i++;
      //#trans.t_time;
      gen2driv.put(trans);
      gen2scb.put(trans);
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
      #trans.t_time;
      gpio.extio_in = trans.value;
      trans.t_time = $time;
    end
  endtask

endclass


`endif