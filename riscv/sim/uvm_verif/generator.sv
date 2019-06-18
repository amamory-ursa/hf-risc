`include "memory_model.sv"
class generator extends uvm_sequence#(memory_model)
        `uvm_object_utils(generator)

        //Construtor
        function new(string name="generator");
                super.new(name);
        endfunction

        virtual task body();
        repeat(2)
        begin
		/*criando uma transaction memory_model*/
                transaction = memory_model::type_id::create("transaction");

		/*emitindo solicitacao para o sequencer*/
                wait_for_grant();

		/*lendo os valores data de code.txt*/
                transaction.read_from_file("code.txt",32'h40000000, 'h100000');

		/*envia item para o sequencer*/
                send_request(transaction);

		/*bloqueia ate o driver chamar item_done*/
                wait_for_item_done();

		/*resposta do driver*/
                get_response(rsp);

        end
        endtask
endclass


