`ifndef MEMORY_MODEL_UVM
 `define MEMORY_MODEL_UVM

class memory_model extends uvm_sequence_item;
    // Memory information
    rand logic [31:0] data[integer];
    rand logic [31:0] base;
    rand integer      length;

    // Control information
    bit from_file = 1;

    // Analysis information
    // something here?

    ///////////////////////////////////////////
    // Utility and Field macros,
    `uvm_object_utils_begin(memory_model)
        `uvm_field_int(data,UVM_ALL_ON)
        `uvm_field_int(base,UVM_ALL_ON)
        `uvm_field_int(length,UVM_ALL_ON)
    `uvm_object_utils_end

    ///////////////////////////////////////////
    // Constructor
    function new(string name = "memory_model");
        super.new(name);
    endfunction: new
    
    ///////////////////////////////////////////
    // Reads the content from a file
    function read_from_file(string filename, logic [31:0] base, integer length);
        logic [31:0] inst_add, celing, write_data;
        int          code, i, r;
        int          instruction;

        this.base = base;
        this.length = length;

        if(filename != "") begin
            code = $fopen(filename,"r");
            if(code) begin
                inst_add = base;
                celing = base+length;

                while(!$feof(code) && inst_add < celing) begin
                    r = $fscanf(code,"%h\n",instruction);
                    write_data = read_write(inst_add, instruction, 'hF);
                    inst_add = inst_add + 4;
                end
                $fclose(code);
            end
        end
    endfunction: read_from_file

    ///////////////////////////////////////////
    // Read or Write something inside the transaction
    function logic [31:0] read_write(logic [31:0] address,
                                     logic [31:0] w_data,
                                     logic [3:0]  we);
        logic [31:0] read_data;
        logic [31:0] offset;
        logic [31:0] mask;

        mask = {{8{we[3]}}, {8{we[2]}}, {8{we[1]}}, {8{we[0]}}};
        offset = address - base;
        offset = {offset[31:2], 2'b00};
      
        if (offset < length) begin
            offset = {2'b00, offset[31:2]};
            
            if (data.exists(offset))
            read_data = data[offset];
            else
            read_data = {32{1'b0}};
            
            if (we != 4'h0)
            data[offset] = (read_data & ~mask) | (w_data & mask);          
        end
        else read_data = {32{1'bz}};
        return read_data;
    endfunction: read_write

endclass: memory_model

 `endif