import "DPI-C" function int run (input byte unsigned Mem2[4096], int size);
import "DPI-C" context function void export_mem(input int);
import "DPI-C" context function void send_pc();
import "DPI-C" context function void send_cycles();
export "DPI-C" function export_sram;
export "DPI-C" function get_pc;
export "DPI-C" function get_cycles;

//---------------------------------------------------------------------

typedef enum { in, out } direction;

typedef struct {  
  time t_time;
  bit [7:0] value;
  direction d;
} trans_send_t;


reg[31:0] Mem_from_ag[1024];
reg[31:0] Mem_from_C[1024];
reg[31:0] pc[521235];
int cycles;
mailbox m_box;
mailbox m_box_io;
mailbox m_box_pc;

//--------------------RETREIVE-FROM-C-FUNCTIONS-------------------------

function void get_cycles(input int _cycles);
        cycles = _cycles;
		$display("\nCycles:%d",cycles);
endfunction


function void get_pc(input reg[31:0] _pc[521235]);
        for (int h=0;h<521235; h++)begin
			pc[h] = _pc[h];
        end
endfunction


function void export_sram(input reg[31:0] _sram[1024]);
        for (int h=0;h<1024; h++)begin
			Mem_from_C[h] = _sram[h];
        end
endfunction

//--------------------------DUMMY-AGENT-IO------------------------------

module dummy_ag_IO;

 trans_send_t trans_send;


	initial begin 
		$display("Agent IO -> Data Acquired!!\n");
		
		m_box_io = new();
		m_box_io.put(trans_send);		
		
	end		

endmodule

//--------------------------DUMMY-AGENT-MEMORY--------------------------

module dummy_ag;

reg[31:0] Mem[1024];

initial $readmemh("code.txt", Mem);
	initial begin 
		$display("Agent -> Data Acquired!!\n");

		m_box = new();
		m_box.put(Mem);		
		
	end		

endmodule

//----------------------------SCOREBOARD--------------------------------

module scoreboard;
	int i, j, k, size;
	byte unsigned Mem_byte[4096];
	reg [31:0] aux;
	initial begin 
	
	trans_send_t trans_rec;
	
	$display("Scoreboard Initialized!!");
	
	  if(m_box)
		m_box.get(Mem_from_ag);
	  else
		$display("ERROR - Mailbox Not Received !!!!!");
	  
	  if(m_box_io)
		m_box_io.get(trans_rec);
	  else
		$display("ERROR - Mailbox 2 Not Received !!!!!");
	  
	  
	  $display("Time:%d",trans_rec.t_time);
	  $display("Value:%hhx",trans_rec.value);
	  $display("Direction:%s",trans_rec.d);
	  
	  
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
	send_cycles();
	send_pc();

	m_box.put(Mem_from_C);
	
	m_box_pc = new();
	m_box_pc.put(pc);
	
	$display("\nScoreboard Sent Mailboxes!!");	
		
	end		
endmodule

//-----------------------------DUMMY-CHECKER----------------------------


module dummy_chk;

reg[31:0] Memory_Out[1024];
reg[31:0] PC_Out[521235];

	initial begin 
		$display("Data Acquired by Checker!!\n");
		
      if(m_box)
		m_box.get(Memory_Out);
	  else
		$display("ERROR - Mailbox Not Received !!!!!");	
	  
	  if(m_box_pc)
		m_box_pc.get(PC_Out);
	  else
		$display("ERROR - Mailbox Not Received !!!!!");
	  
	  for (int y=0; y<1024; y++)begin
		$display("Data [%d]:%hhx", y, Memory_Out[y]);
      end
      
      for (int y=0; y<2000; y++)begin
		$display("PC [%d]:%08x", y, PC_Out[y]);
      end
	end		

endmodule

