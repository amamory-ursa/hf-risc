`ifndef GENERATOR_UVM
 `define GENERATOR_UVM

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "memory_model.sv"
class memory_sequence extends uvm_sequence#(memory_model);

        `uvm_object_utils(memory_sequence)
	string path;
	memory_model transaction;
	_sequencer seqce;
        //Construtor
        function new(string name="memory_model");
                super.new(name);
		   path = "../scripts/code.txt";
        endfunction

        virtual task body();
	int i;
	//for(i=0;i<inteiro;i++) begin
        
		/*criando uma transaction memory_model*/
                req = memory_model::type_id::create("transaction");

		/*emitindo solicitacao para o sequencer*/
                wait_for_grant();

		/*lendo os valores data de code.txt*/
         	req.read_from_file(path,32'h40000000,'h100000);

		/*envia item para o sequencer*/
                send_request(req);


		/*bloqueia ate o driver chamar item_done*/
                wait_for_item_done();

		/*resposta do driver*/
               // get_response(rsp);
                `uvm_info("SEQUENCE:","Memory_model consumed by DUT",UVM_LOW);

        //end
        endtask	
endclass
`endif


