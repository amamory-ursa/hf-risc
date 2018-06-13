class Timemachine;
  Snapshot snapshot[$];

  function int step(logic data_access,
                    logic [31:0] address, data_read, data_we,
                    register [0:31] registers);
    automatic Snapshot snap;
    automatic int timecounter;
    snap.data_access = data_access;
    snap.address = address;
    snap.data_read = data_read;
    snap.data_we = data_we;
    foreach (snap.registers[i]) begin
      snap.registers[i] = registers[i];
    end
    snap.base = getBase(snap);

    this.snapshot.push_back(snap);
    timecounter = this.snapshot.size()-1;

    if (this.isInstruction(timecounter))
    begin
      // snap.opcode = getOpcode(snap);
      // snap.instruction = getInstruction(snap);
    end
    return timecounter;
  endfunction

  function bit isInstruction(int timecounter);
    if (snapshot[timecounter].data_access == 1)
      return 1;
    if (timecounter > 0)
      if (snapshot[timecounter-1].data_access == 1)
        return 1;
    return 0;
  endfunction

endclass

function Instruction getInstruction(Snapshot snap);
  automatic Opcode opcode = getOpcode(snap);
  automatic Instruction instruction;
  automatic logic [31:0] base = getBase(snap);

  assert($cast(instruction, base & OpcodeMask[opcode]));
  // SLLI, SRLI and SRAI mix OPP_IMM and OP: OPP_IMM OPCODE with OP mask.
  // Because of that, SRAI is always mistaken as SRLI
  if (instruction === SRLI) begin
    $cast(instruction, base & OpcodeMask_SR_I);
  end
  return instruction;

endfunction

function Opcode getOpcode(Snapshot snap);
  automatic Opcode result;
  automatic logic [31:0] base = getBase(snap);
  $cast(result, base[6:0]);
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
  automatic logic [31:0] base = getBase(snap);
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
