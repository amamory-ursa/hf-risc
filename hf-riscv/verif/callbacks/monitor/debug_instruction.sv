class Debug_instruction_cbs extends Monitor_cbs;
  bit[31:0] imm;

  virtual task instruction(Opcode opcode, Instruction instruction, bit[31:0] instr);
    super.instruction(opcode, instruction, instr);
    imm = getImm(instr);
    case(OpcodeFormat[opcode])
      R_type: begin
        R_struct decoded = instr;
        $display("DBG INSTR: %s, rd: %d, rs1: %d, rs2:%d",
          instruction,
          decoded.rd,
          decoded.rs1,
          decoded.rs2);
      end
      I_type: begin
        I_struct decoded = instr;
        $display("DBG INSTR: %s, rd[%d]: 0x%4h, rs1[%d]: 0x%4h, imm: %d",
          instruction,
          decoded.rd,
          tb_top.dut.cpu.register_bank.registers[decoded.rd],
          decoded.rs1,
          tb_top.dut.cpu.register_bank.registers[decoded.rs1],
          imm);
      end
      S_type: begin
        S_struct decoded = instr;
        $display("DBG INSTR: %s, rs1: %d, rs2:%d, imm: %d",
          instruction,
          decoded.rs1,
          decoded.rs2,
          imm);
      end
      B_type: begin
        B_struct decoded = instr;
        $display("DBG INSTR: %s,rs1: %d, rs2:%d, imm: %d",
          instruction,
          decoded.rs1,
          decoded.rs2,
          imm);
      end
      U_type: begin
        U_struct decoded = instr;
        $display("DBG INSTR: %s, rd: %d, imm: %d",
          instruction,
          decoded.rd,
          imm);
      end
      J_type: begin
        J_struct decoded = instr;
        $display("DBG INSTR: %s, rd: %d, imm: %d",
          instruction,
          decoded.rd,
          imm);
      end
      E_type: begin
        E_struct decoded = instr;
        $display("DBG INSTR: %s",
          instruction);
      end
      default: $error("Instruction type not expected for opcode %7b", opcode);
    endcase
  endtask
endclass
