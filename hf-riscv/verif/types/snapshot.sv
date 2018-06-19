typedef logic [31:0] register;

typedef struct packed{

  logic data_access;
  logic [31:0] data_read;
  
  logic [31:0] pc;

  logic [31:0] base;
  register [0:31] registers;

  Opcode opcode;
  Instruction instruction;
  bit skip;

  logic [4:0] rd;
  logic [4:0] rs1;
  logic [4:0] rs2;
  logic [31:0] imm;
  
} Snapshot;
