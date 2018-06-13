class Debug_instruction_cbs extends Monitor_cbs;
  virtual task time_step(int t, ref Timemachine timemachine);
    Snapshot snap;
    super.time_step(t, timemachine);
    snap = timemachine.snapshot[t];

    $display("aslkdjflsakjfd");
    if (!timemachine.isInstruction(t))
      return;
    if (!snap.opcode)
      return;

    case(OpcodeFormat[snap.opcode])
      R_type: begin
        R_struct decoded = snap.base;
        $display("%s, rd: %d, rs1: %d, rs2:%d",
          snap.instruction,
          decoded.rd,
          decoded.rs1,
          decoded.rs2);
      end
      I_type: begin
        I_struct decoded = snap.base;
        $display("%s, rd: %d, rs1: %d, imm: %d",
          snap.instruction,
          decoded.rd,
          decoded.rs1,
          snap.imm);
      end
      S_type: begin
        S_struct decoded = snap.base;
        $display("%s, rs1: %d, rs2: %d, imm: %d",
          snap.instruction,
          decoded.rs1,
          decoded.rs2,
          snap.imm);
      end
      B_type: begin
        B_struct decoded = snap.base;
        $display("%s, rs1: %d, rs2: %d, imm: %d",
          snap.instruction,
          decoded.rs1,
          decoded.rs2,
          snap.imm);
      end
      U_type: begin
        U_struct decoded = snap.base;
        $display("%s, rd: %d, imm: %d",
          snap.instruction,
          decoded.rd,
          snap.imm);
      end
      J_type: begin
        J_struct decoded = snap.base;
        $display("%s, rd: %d, imm: %d",
          snap.instruction,
          decoded.rd,
          snap.imm);
      end
      E_type: begin
        E_struct decoded = snap.base;
        $display("%s",
          snap.instruction);
      end
      default: $error("Instruction type not expected for opcode %7b", snap.base[6:0]);
    endcase
  endtask
endclass
