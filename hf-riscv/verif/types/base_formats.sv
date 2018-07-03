typedef struct packed {
  logic [31:25] funct7;
  logic [24:20] rs2;
  logic [19:15] rs1;
  logic [14:12] funct3;
  logic [11:7]  rd;
  logic [6:0]   opcode;
} R_struct;

typedef struct packed {
  logic [31:20] imm_11_0;
  logic [19:15] rs1;
  logic [14:12] funct3;
  logic [11:7]  rd;
  logic [6:0]   opcode;
} I_struct;

typedef struct packed {
  logic [31:25] imm_11_5;
  logic [24:20] rs2;
  logic [19:15] rs1;
  logic [14:12] funct3;
  logic [11:7]  imm_4_0;
  logic [6:0]   opcode;
} S_struct;

typedef struct packed {
  logic [31:31] imm_12;
  logic [30:25] imm_10_5;
  logic [24:20] rs2;
  logic [19:15] rs1;
  logic [14:12] funct3;
  logic [11:8]  imm_4_1;
  logic [7:7]   imm_11;
  logic [6:0]   opcode;
} B_struct;

typedef struct packed {
  logic [31:12] imm_31_12;
  logic [11:7]  rd;
  logic [6:0]   opcode;
} U_struct;

typedef struct packed {
  logic [31:31] imm_20;
  logic [30:21] imm_10_1;
  logic [20:20] imm_11;
  logic [19:12] imm_19_12;
  logic [11:7]  rd;
  logic [6:0]   opcode;
} J_struct;

typedef struct packed {
  logic [31:20] funct12;
  logic [19:15] rs1;
  logic [14:12] funct3;
  logic [11:7]  rd;
  logic [6:0]   opcode;
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
