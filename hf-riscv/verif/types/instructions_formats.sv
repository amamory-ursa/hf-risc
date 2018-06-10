typedef struct packed {
  bit[6:0] funct7;
  bit[4:0] rs2;
  bit[4:0] rs1;
  bit[2:0] funct3;
  bit[4:0] rd;
  bit[6:0] opcode;
} R_struct;

typedef struct packed {
  bit[11:0] imm;
  bit[4:0] rs1;
  bit[2:0] funct3;
  bit[4:0] rd;
  bit[6:0] opcode;
} I_struct;

typedef struct packed {
  bit[31:0] todo;
} S_struct;

typedef struct packed {
  bit[31:0] todo;
} B_struct;

typedef struct packed {
  bit[31:12] imm;
  bit[4:0] rd;
  bit[6:0] opcode;
} U_struct;

typedef struct packed {
  bit[31:0] todo;
} J_struct;

typedef struct packed {
  bit[11:0] funct12;
  bit[4:0] rs1;
  bit[2:0] funct3;
  bit[4:0] rd;
  bit[6:0] opcode;
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