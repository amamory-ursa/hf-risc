function bit[31:0] getImm(bit[31:0] instr);
  automatic bit[31:0] result = 0;
  case(OpcodeFormat[instr[6:0]])
    R_type: return result;
    I_type: begin
      automatic I_struct decoded = instr;
      result[11:0] = decoded.imm_11_0;
      return result;
    end
    S_type: begin
      automatic S_struct decoded = instr;
      result[11:5] = decoded.imm_11_5;
      result[4:0] = decoded.imm_4_0;
      return result;
    end
    B_type: begin
      automatic B_struct decoded = instr;
      result[12:12] = decoded.imm_12;
      result[10:5]  = decoded.imm_10_5;
      result[4:1]   = decoded.imm_4_1;
      result[11:11] = decoded.imm_11;
      return result;
    end
    U_type: begin
      automatic U_struct decoded = instr;
      result[31:12] = decoded.imm_31_12;
      return result;
    end
    J_type: begin
      automatic J_struct decoded = instr;
      result[20:20] = decoded.imm_20;
      result[10:1]  = decoded.imm_10_1;
      result[11:11] = decoded.imm_11;
      result[19:12] = decoded.imm_19_12;
      return result;
    end
    E_type: return result;
    default: $error("Instruction type not expected for opcode %7b", instr[6:0]);
  endcase
endfunction
