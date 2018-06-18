import "DPI-C" function int run (input byte unsigned Mem2[4096], int size);
import "DPI-C" context function void export_mem(input int);
export "DPI-C" function export_sram;




reg[31:0] Mem_from_ag[1024];
reg[31:0] Mem_from_C[1024];
mailbox m_box;



function void export_sram(input reg[31:0] _sram[1024]);
        for (int h=0;h<1024; h++)begin
        Mem_from_C[h] = _sram[h];
        end
endfunction





module dummy_ag;

reg[31:0] Mem[1024];

initial $readmemh("code.txt", Mem);
	initial begin 
		$display("Agent -> Data Acquired!!\n");

		m_box = new();
		m_box.put(Mem);		
		
	end		

endmodule


module scoreboard;
	int i, j, k, size;
	byte unsigned Mem_byte[4096];
	reg [31:0] aux;
	initial begin 
	
	$display("Scoreboard Initialized!!");
	
	  if(m_box)
	  m_box.get(Mem_from_ag);
	  else
	  $display("ERROR - Mailbox Not Received !!!!!");
	  
	  
	  size = $size(Mem_byte);
		
	   for (j=0;j<size; j++)begin
			aux = Mem_from_ag[j];
			for (k=0;k<4; k++) begin
				Mem_byte[j*4+k] = (aux & 32'hff000000) >> 24;
				aux = aux << 8;
			end
		end		
	  	  

      run(Mem_byte, 4096);

	    
	export_mem(1024);

	m_box.put(Mem_from_C);
	$display("Scoreboard Sent Mailbox!!");	
		
	end		
endmodule


module dummy_chk;

reg[31:0] Memory_Out[1024];

	initial begin 
		$display("Data Acquired by Checker!!\n");
		
      if(m_box)
	  m_box.get(Memory_Out);
	  else
	  $display("ERROR - Mailbox Not Received !!!!!");	
	  
	  for (int y=0; y<1024; y++)begin
	  $display("Data [%d]:%hhx", y, Memory_Out[y]);
      end
	end		

endmodule

