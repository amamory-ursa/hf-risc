`ifndef GENERATOR_UVM
 `define GENERATOR_UVM

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "memory_model.sv"
class generator extends uvm_sequence#(memory_model);

        `uvm_object_utils(generator)
	string path;
	memory_model transaction;
	_sequencer seqce;
        //Construtor
        function new(string name="generator");
                super.new(name);
		   path = "code.txt";
        endfunction

        virtual task body();
        repeat(2)
        begin

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
                get_response(rsp);

        end
        endtask	
endclass
`endif


