typedef struct packed {
  bit[31:25] funct7;
  bit[24:20] rs2;
  bit[19:15] rs1;
  bit[14:12] funct3;
  bit[11:7]  rd;
  bit[6:0]   opcode;
} R_struct;

typedef struct packed {
  bit[31:20] imm_11_0;
  bit[19:15] rs1;
  bit[14:12] funct3;
  bit[11:7]  rd;
  bit[6:0]   opcode;
} I_struct;

typedef struct packed {
  bit[31:25] imm_11_5;
  bit[24:20] rs2;
  bit[19:15] rs1;
  bit[14:12] funct3;
  bit[11:7]  imm_4_0;
  bit[6:0]   opcode;
} S_struct;

typedef struct packed {
  bit[31:31] imm_12;
  bit[30:25] imm_10_5;
  bit[24:20] rs2;
  bit[19:15] rs1;
  bit[14:12] funct3;
  bit[11:8]  imm_4_1;
  bit[7:7]   imm_11;
  bit[6:0]   opcode;
} B_struct;

typedef struct packed {
  bit[31:12] imm_31_12;
  bit[11:7]  rd;
  bit[6:0]   opcode;
} U_struct;

typedef struct packed {
  bit[31:31] imm_20;
  bit[30:21] imm_10_1;
  bit[20:20] imm_11;
  bit[19:12] imm_19_12;
  bit[11:7]  rd;
  bit[6:0]   opcode;
} J_struct;

typedef struct packed {
  bit[31:20] funct12;
  bit[19:15] rs1;
  bit[14:12] funct3;
  bit[11:7]  rd;
  bit[6:0]   opcode;
} E_struct;

typedef enum {
  R_type,
  I_type,
  S_type,
  B_type,
  U_type,
  J_type,
  E_type
} InstrType;
