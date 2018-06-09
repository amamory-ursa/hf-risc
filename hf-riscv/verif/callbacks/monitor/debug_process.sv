class Debug_process extends Monitor_cbs;
  integer f, line_length;
  function new(string path);
    f = $fopen(path,"w");
  endfunction
  virtual task mem(virtual hfrv_interface.monitor iface);
    if (iface.mem.address == 32'hf00000d0)
      begin
         $fwrite(f,"%c",iface.mem.data_write[30:24]);
         if (iface.mem.data_write[30:24] == 10)
           line_length = 0;
         else
           line_length = line_length + 1;
      end

    else if (line_length >= 72)
      begin
         $fwrite(f,"\n");
         $fwrite(f,"%c",iface.mem.data_write[30:24]);
         line_length = 0;
      end
  endtask
endclass
