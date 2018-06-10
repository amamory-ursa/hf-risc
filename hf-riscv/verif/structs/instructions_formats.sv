typedef struct packed {
  bit[6:0] funct7;
  bit[4:0] rs2;
  bit[4:0] rs1;
  bit[2:0] funct3;
  bit[4:0] rd;
  bit[6:0] opcode;
} R;

typedef struct packed {
  bit[11:0] imm;
  bit[4:0] rs1;
  bit[2:0] funct3;
  bit[4:0] rd;
  bit[6:0] opcode;
} I;

typedef struct packed {
  bit[31:12] imm;
  bit[4:0] rd;
  bit[6:0] opcode;
} U;
