class Debug_uart extends Monitor_cbs;
  integer f, line_length;

  function new(string path);
    f = $fopen(path,"w");
  endfunction

  virtual task uart(virtual hfrv_interface.monitor iface);
    $fwrite(f,"%c",iface.mem.data_write[30:24]);
    if (iface.mem.data_write[30:24] == 10)
      line_length = 0;
    else
      line_length = line_length + 1;

    if (line_length >= 72) begin
      $fwrite(f,"\n");
      line_length = 0;
    end
  endtask
endclass
