class Fake_uart extends Monitor_cbs;
  string line;
  function new();
    this.line = "";
  endfunction
  virtual task mem(virtual hfrv_interface.monitor iface, mailbox msgout);
    if(iface.mem.address == 32'hf00000d0) begin
       automatic byte char = iface.mem.data_write[30:24];
       iface.mem.data_read <= {32{1'b0}};
       if (char != 8'h0A)
         line = {line, char};

       if (char == 8'h0A || line.len() == 72) begin
          msgout.put(line);
          line = "";
       end
    end
  endtask
endclass
