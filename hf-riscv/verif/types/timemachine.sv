typedef struct packed {
  bit jumped;
  logic [31:0] to;
} jumpStruct;


// This class is just a shell to Snapshot snapshot[$],
//   so it can be passed around as a reference.
//   It also has the step method, that fills the snapshot.
//   Normally, step() would be a constructor in snapshot.sv, but
//   some we must look back in time to fill some fields.
//   The rest of the code are auxiliary functions to fill them.
class Timemachine;
  // Each snaphot has info on instruction, pc and registers bank at a point in time
  Snapshot snapshot[$];

  // builds a new snapshot and pushes into snapshot[$]
  function int step(logic data_access,          // data_access -> flag to load,store
                    logic [31:0] data_read, pc, // data_read -> logic [31:0] instr
                    register [0:31] registers);
    automatic Snapshot snap;
    automatic int timecounter;
    automatic jumpStruct jump; // jump.to, jump.jumped
    timecounter = this.snapshot.size(); //next == size

    // start filling snap fields

    snap.data_access = data_access;
    snap.data_read = data_read;
    snap.pc = pc;

    // base reorders data_read (also called instr): base[31:24] = data_read[7:0] etc
    snap.base = getBase(snap);

    // fills snap.registers
    foreach (snap.registers[i]) begin
      snap.registers[i] = registers[i];
    end

    // tries to fill snap.opcode
    if ($cast(snap.opcode, snap.base[6:0]));
    begin
      if (snap.opcode)
      begin
        // tries to fill snap.instruction
        if ($cast(snap.instruction, snap.base & OpcodeMask[snap.opcode]));
        begin
          // Special case
          // SLLI, SRLI and SRAI mix OPP_IMM and OP: OPP_IMM OPCODE with OP mask.
          // Because of that, SRAI is always mistaken as SRLI
          if (snap.instruction === SRLI)
          begin
            $cast(snap.instruction, snap.base & OpcodeMask_SR_I);
          end

          // if we could identify snap.opcode and snap.instruction
          //   then we fill rd, rs1, rs2 and imm
          snap.rd = snap.base[11:7];
          snap.rs1 = snap.base[19:15];
          snap.rs2 = snap.base[24:20];
          snap.imm = getImm(snap);
        end
      end
    end

    // snap.skip indicates current instruction should be disconsidered
    //   this happens when any of 2 previous instructions were a data_access, like load and store
    if (isDataAccess(timecounter))
      snap.skip = 1;


    // if there was a jump or a branch in pipeline, and if that
    //   jump or branch was followed,
    //   then we should disconsider the current instruction too
    jump = isJumped(timecounter);
    if (jump.jumped) // a jump occurred
      snap.skip = 1;

    // snap is filled, push it to the snaphots queue
    this.snapshot.push_back(snap);

    // timecounter is the current point in time
    return timecounter;
  endfunction

  // look back in time 2 steps
  //   there was a data_access (load,store)?
  //   if so we should disconsider current snap
  function bit isDataAccess(int timecounter);
    // check t-1
    if (timecounter > 0 && snapshot[timecounter-1].skip == 0)
      if (snapshot[timecounter-1].opcode == LOAD || snapshot[timecounter-1].opcode == STORE)
        return 1;
    // check t-2
    if (timecounter > 1 && snapshot[timecounter-2].skip == 0)
      if (snapshot[timecounter-2].opcode == LOAD || snapshot[timecounter-2].opcode == STORE)
        // ugly hack: sometimes STORE skips 1 step, sometimes 2
        //   comparing [t-1].pc and [t-2].pc seems to differ both cases,
        //   but it's a strange thing to rely on
        if (snapshot[timecounter-1].pc == snapshot[timecounter-2].pc)
          return 1;
    return 0;
  endfunction

  // look back in time 3 steps
  //   check for jumps and branches
  //   if found
  //     return a struct that indicates:
  //     jump.jumped: there was a jump
  //     jump.to    : destination address
  function jumpStruct isJumped(int timecounter);
    jumpStruct j = 0;
    for (int i=1; i<3; i++) //checks t-1 and t-2
    begin
      if (timecounter < i) // program starting, we can't look to times less than 0
        return 0;
      j = checkJump(snapshot[timecounter-i]);   // fills the jump struct
      if (j.to != snapshot[timecounter-i].pc+4) // ignore jump to pc+4 (which would be silly, by the way)
        if (j.jumped == 1)
          return j;
    end
    return 0;
  endfunction
endclass

// check if the instruction at snap was a jump
//   if so, where to?
//     return a struct that indicates:
//     jump.jumped: there was a jump
//     jump.to    : destination address
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


// reorder data_read, it comes with different endianess from code.txt
function logic [31:0] getBase(Snapshot snap);
  logic [31:0] result;
  result[31:24] = snap.data_read[7:0];
  result[23:16] = snap.data_read[15:8];
  result[15:8]  = snap.data_read[23:16];
  result[7:0]   = snap.data_read[31:24];
  return result;
endfunction

// Uses opcode (base[6:0]) do figure instruction format
//   from that, read imm fields, put it in correct order
//   and fill 0 bits and sign extension bits
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
