typedef struct packed {
  bit jumped;
  logic [31:0] to;
} jumpStruct;

class Timemachine;
  Snapshot snapshot[$];
  
  // builds a new snapshot and pushes into snapshot[$]
  function int step(logic data_access,
                    logic [31:0] address, data_read, data_we,
                    pc,
                    register [0:31] registers);
    automatic Snapshot snap;
    automatic int timecounter;
    automatic jumpStruct jump;
    timecounter = this.snapshot.size(); //next == size
    snap.data_access = data_access;
    snap.address = address;
    snap.data_read = data_read;
    snap.data_we = data_we;
    
    snap.pc = pc;

    snap.base = getBase(snap);
    foreach (snap.registers[i]) begin
      snap.registers[i] = registers[i];
    end
    
    if ($cast(snap.opcode, snap.base[6:0]));
    begin
      if (snap.opcode)
      begin
        if ($cast(snap.instruction, snap.base & OpcodeMask[snap.opcode]));
        begin
          // SLLI, SRLI and SRAI mix OPP_IMM and OP: OPP_IMM OPCODE with OP mask.
          // Because of that, SRAI is always mistaken as SRLI
          if (snap.instruction === SRLI)
          begin
            $cast(snap.instruction, snap.base & OpcodeMask_SR_I);
          end

          snap.rd = snap.base[11:7];
          snap.rs1 = snap.base[19:15];
          snap.rs2 = snap.base[24:20];
          snap.imm = getImm(snap);
        end
      end
    end

    if (isDataAccess(timecounter))
      snap.skip = 1;

    jump = isJumped(timecounter);
    if (jump.jumped)
      if (jump.to != snap.pc)
        snap.skip = 1;
    
    this.snapshot.push_back(snap);
    return timecounter;
  endfunction

  function bit isDataAccess(int timecounter);
    // check t-1
    if (timecounter > 0)
      if (snapshot[timecounter-1].data_access == 1)
        return 1;
    // check t-2
    if (timecounter > 1)
      if (snapshot[timecounter-2].data_access == 1)
        return 1;
    return 0;
  endfunction

  function jumpStruct isJumped(int timecounter);
    jumpStruct j = 0;
    for (int i=1; i<3; i++)
    begin
      if (timecounter < i) // program starting
        return 0;
      j = checkJump(snapshot[timecounter-i]);
      if (j.to != snapshot[timecounter-i].pc+4) // ignore jump to pc+4
        if (j.jumped == 1)
          return j;
    end
    return 0;
  endfunction
endclass

function jumpStruct checkJump(Snapshot snap);
  automatic jumpStruct result = 0; //didn't jump
  if (snap.skip == 1) //ignore skiped instructions
    return result;
  case(snap.instruction)
    JAL:begin
      result.jumped = 1;
      result.to = snap.imm;
    end
    JALR:begin
      result.jumped = 1;
      result.to = snap.registers[snap.rs1] + signed'(snap.imm);
      result.to[0] = 0;
    end
    BEQ:begin
      if (snap.registers[snap.rs1] === snap.registers[snap.rs2])
      begin
        result.jumped = 1;
        result.to = snap.pc + signed'(snap.imm);
      end
    end
    BNE:begin
      if (snap.registers[snap.rs1] !== snap.registers[snap.rs2])
      begin
        result.jumped = 1;
        result.to = snap.pc + signed'(snap.imm);
      end
    end
    BLT:begin
      if (signed'(snap.registers[snap.rs1]) < signed'(snap.registers[snap.rs2]))
      begin
        result.jumped = 1;
        result.to = snap.pc + signed'(snap.imm);
      end
    end
    BGE:begin
      if (signed'(snap.registers[snap.rs1]) >= signed'(snap.registers[snap.rs2]))
      begin
        result.jumped = 1;
        result.to = snap.pc + signed'(snap.imm);
      end
    end
    BLTU:begin
      if (snap.registers[snap.rs1] < snap.registers[snap.rs2])
      begin
        result.jumped = 1;
        result.to = snap.pc + signed'(snap.imm);
      end
    end
    BGEU:begin
      if (snap.registers[snap.rs1] >= snap.registers[snap.rs2])
      begin
        result.jumped = 1;
        result.to = snap.pc + signed'(snap.imm);
      end
    end
  endcase
  return result;
endfunction

function logic [31:0] getBase(Snapshot snap);
  logic [31:0] result;
  result[31:24] = snap.data_read[7:0];
  result[23:16] = snap.data_read[15:8];
  result[15:8]  = snap.data_read[23:16];
  result[7:0]   = snap.data_read[31:24];
  return result;
endfunction

function logic [31:0] getImm(Snapshot snap);
  automatic logic [31:0] result = 0;
  automatic logic [31:0] base = snap.base;

  case(OpcodeFormat[base[6:0]])
    R_type: return result;
    I_type: begin
      result[31:11] = {21{base[31]}}; //sign extension
      result[10:5]  = base[30:25];
      result[4:1]   = base[24:21];
      result[0]     = base[20];
      return result;
    end
    S_type: begin
      result[31:11] = {21{base[31]}}; //sign extension
      result[10:5]  = base[30:25];
      result[4:1]   = base[11:8];
      result[0]     = base[7];
      return result;
    end
    B_type: begin
      result[31:12] = {20{base[31]}}; //sign extension
      result[11]    = base[7];
      result[10:5]  = base[30:25];
      result[4:1]   = base[11:8];
      result[0]     = 0;
      return result;
    end
    U_type: begin
      result[31]    = base[31];
      result[30:20] = base[30:20];
      result[19:12] = base[19:12];
      result[11:0]  = 0;
      return result;
    end
    J_type: begin
      result[31:20] = {12{base[31]}}; //sign extension
      result[19:12] = base[19:12];
      result[11]    = base[20];
      result[10:5]  = base[30:25];
      result[4:1]   = base[24:21];
      result[0]     = 0;
      return result;
    end
    E_type: return result;
    default: $error("Instruction type not expected for opcode %7b", base[6:0]);
  endcase
endfunction
