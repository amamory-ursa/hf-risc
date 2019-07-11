`ifndef __RANDOM_INSTRUCTION_SV
`define __RANDOM_INSTRUCTION_SV

//////////////////////////////////////////////////////
// instructions are defined in the following grammar   
//
//    INSTR: INSTR_R | INSTR_I
//
//    INSTR_R: instruction_itype ' ' register ', ' register + ', ' + register
//    INSTR_I: instruction_itype ' ' register ', ' register + ', ' + imm
//
//    REG: registers
//
//    register: x0, x1, ...
//    instruction_rtype: ADD, SUB, ...
//    instruction_itype: ADDI, SUBI, ...
//    imm: 0x0, 0x1, 0x2, ...
//
/////////////////////////////////////////////////////

//enumeration for R-TYPE instructions' opcode of RV32I spec. 
typedef enum {
  //RTYPE
  ADD  = 100, SUB = 101, SLL = 102, SLT = 103,
  SLTU = 104, XOR = 105, SRL = 106, SRA = 107,

  //ITYPE
  LB = 200, LH = 201, LW = 202, LBU = 203, LHU = 204,
  ADDI = 205, SLTI = 206, SLTIU = 207, XORI = 208,
  ORI = 209, ANDI = 210,  
  
  SLLI = 211, SRLI = 212, SRAI = 213,

  //UTYPE
  LUI = 300, AUIPC = 301,

  //STYPE
  SB  = 400, SH = 401, SW = 402,

  //BTYPE 
  BEQ = 500, BNE = 501, BLT = 502, 
  BGE = 503, BLTU = 504, BGEU = 505, 

  //JTYPE
  JAL  = 600
} opcode;

//format of instructions
typedef enum{
  RTYPE = 1, //  |funct||rs2||rs1||3|| rd|| op  |
  ITYPE = 2, //  |imm       ||rs1||3|| rd|| op  |
  UTYPE = 3, //  |imm               || rd|| op  |
  STYPE = 4, //  |imm  ||rs2||rs1||3||imm|| op  |
  BTYPE = 5, //  |imm  ||rs2||rs1||3||imm|| op  | (same as STYPE)
  JTYPE = 6, //  |imm               || rd|| op  | (same as UTYPE)
  NULL = 0   // This is not a type. It is used for constrained random generation.
} itype;

//target arch. available registers.
typedef enum {
  zero = 0, //x0: hardwired zero-value
  ra = 1,   //x1: return address
  sp = 2,   //x2: stack pointer
  gp = 3,   //x3: global pointer
  tp = 4,   //x4: thread pointer
  t0 = 5, t1 = 6, t2 = 7,         // temporaries
  t3 =28, t4 =29, t5 =30, t6 =31, //
  s0 = 8,   //x8: saved register (alt. framepointer - fp)
  s1 = 9,   //x9: saved register
  s2 =18, s3 =19, s4 =20, //
  s5 =21, s6 =22, s7 =23, //
  s8 =24, s9 =25, s10=26, // saved registers
  s11=27,                 //
  a0 =10, a1=11, //x10 and x11: function args/return values
  a2 =12, a3=13, //
  a4 =14, a5=15, // function arguments
  a6 =16, a7=17  //
} register;

//base class: all instruction classes inherit from it
class random_instruction;

  //type of the instruction (see "itype" enumeration)
  rand itype it;

  //opcode (all instructions)
  rand opcode opcode;
  constraint instruction_opcode{
    (it == RTYPE) -> { opcode >= 100; opcode < 200;}
    (it == ITYPE) -> { opcode >= 200; opcode < 300;}
    (it == UTYPE) -> { opcode >= 300; opcode < 400;}
    (it == STYPE) -> { opcode >= 400; opcode < 500;}
    (it == BTYPE) -> { opcode >= 500; opcode < 600;}
    (it == JTYPE) -> { opcode >= 600; opcode < 700;}
  }

  //destinarion reg. (all instructions
  rand register rd; //all registers, no constraint

  //rs1 for RTYPE, BTYPE, STYPE and ITYPE
  rand register rs1; //all registers, no constraint

  //rs2 for RTYPE, BTYPE and STYPE
  rand register rs2; //all registers, no constraint

  //immediate field
  rand logic [19:0] imm;
  constraint imm_i{
    (it == ITYPE) -> { imm[19:13] == 0; } //7-bit imm 
    (it == STYPE) -> { imm[19:8]  == 0; } //12-bit imm
    (it == BTYPE) -> { imm[19:8]  == 0; } //12-bit imm
    //UTYPE = 20-bit imm
    //JTYPE = 20-bit imm
  }

  //ctor.
  //function new(itype t);
  //    this.it = t;
  //endfunction
  
  //print
  function string toString();

      string s = "";

      case(this.it)

          //RTYPE = 1, |funct||rs2||rs1||3|| rd|| op  |
          RTYPE: begin 
            // %0s %0d, %0d, %0d"
            s = {"  ", this.opcode.name, " ",
                 this.rd.name, ", ",
                 this.rs1.name, ", ",
                 this.rs2.name, "\n"};
            return s;
          end

          // ITYPE = 2, |imm       ||rs1||3|| rd|| op  |
          ITYPE: begin 
            //"%0s %d, %d, 0x%h"
            s = {"  ", this.opcode.name, " ",
                 this.rd.name, ", ",
                 this.rs1.name, ", ",
                 this.imm, "\n"};
            return s;
          end
 
          // STYPE = 4, |imm  ||rs2||rs1||3||imm|| op  |
          // BTYPE = 5, |imm  ||rs2||rs1||3||imm|| op  |
          STYPE: begin 
            //"%0s %d, %d, 0x%h
            s = {"  ", this.opcode.name, " ",
                 this.rs1.name, ", ",
                 this.rs2.name, ", ",
                 this.imm, "\n"};
            return s;
          end

          BTYPE: begin 
            //"%0s %0d, %d, 0x%h"
            s = {"  ", this.opcode.name, " ", 
                 this.rs1.name, ", ",
                 this.rs2.name, ", ",
                 this.imm, "\n"};
            return s;
          end

          // UTYPE = 3, |imm               || rd|| op  |
          // JTYPE = 6  |imm               || rd|| op  |
          JTYPE: begin 
            //"%0s %0d, 0x%h"
            s = {"  ", this.opcode.name, " ",
                 this.rd.name, ", ",
                 this.imm, "\n"};
            return s;
          end

          UTYPE: begin
            //"%0s %0d, 0x%h"
            s = {"  ", this.opcode.name, " ",
                 this.rd.name, ", ", this.imm, "\n"};
            return s;
          end

      endcase
  endfunction
   
endclass

`endif //__RANDOM_INSTRUCTION_SV
