class Debug_post_instruction_cbs extends Monitor_cbs;
  int nErrors;
  logic [31:0] [31:0] registers;

  virtual task post_instruction(Opcode opcode,
                           Instruction instruction,
                           bit[31:0] instr,
                           Snapshot pre_snapshot,
                           Snapshot post_snapshot);
    super.post_instruction(opcode, instruction, instr, pre_snapshot, post_snapshot);
    case(OpcodeFormat[opcode])
      R_type: begin
        R_struct decoded = instr;
      end
      I_type: begin
        I_struct decoded = instr;
        $display("v=============================");
        $display("POST INSTR I");
        $display("pre_register[rd]  : %d", pre_snapshot.registers[decoded.rd]);
        $display("pre_register[rs1] : %d", pre_snapshot.registers[decoded.rs1]);
        $display("pre_imm           : %d", decoded.imm);
        $display("post_register[rd] : %d", post_snapshot.registers[decoded.rd]);
        $display("post_register[rs1]: %d", post_snapshot.registers[decoded.rs1]);
        $display("^=============================");
      end
      S_type: begin
        S_struct decoded = instr;
      end
      B_type: begin
        B_struct decoded = instr;
      end
      U_type: begin
        U_struct decoded = instr;
      end
      J_type: begin
        J_struct decoded = instr;
      end
      E_type: begin
        E_struct decoded = instr;
      end
      default: $error("Instruction type not expected for opcode %7b", opcode);
    endcase
  endtask
endclass
