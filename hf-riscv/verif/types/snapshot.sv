typedef logic [31:0] register;


// This struct holds information of a single point in time
// It is filled at timemachine.sv
typedef struct packed{

  // flag, indicates a load or store instruction
  logic data_access;

  // 32 bits read from memory
  // if not a data access, should contain
  // the instruction to be executed, but
  // must be reorderd first. The reordered
  // version is the 'base' field.
  logic [31:0] data_read;

  // current memory address
  logic [31:0] pc;

  // refered as instr in the riscv reference
  // base is just data_read reordered
  //   when code.txt is loaded into memory,
  //   it has different endianess, so we
  //   must divide it in 4 [7:0] chunks
  //   and reverse the order of these 4 chunks
  //   like this: base[31:24] = data_read[7:0]
  //   It is filled at getBase (timemachine.sv)
  logic [31:0] base;

  // the register bank, an array of arrays
  register [0:31] registers;

  // enum of opcodes (see opcode.sv)
  Opcode opcode;

  // enum of instructions (see instruction.sv)
  Instruction instruction;

  // if set, current snapshot should be disconsidered
  // this happens in 2 situations:
  //  - a previous jump is in execution and current instruction is pipeline junk
  //  - previous instruction was a data access
  bit skip;

  logic [4:0] rd;
  logic [4:0] rs1;
  logic [4:0] rs2;

  // when filled, imm already has correct signed extension and zero temination
  //   for those formats that have those, of course.
  //   So, you can just use this field as is.
  //   Filled at timemachine.sv, getImm()
  logic [31:0] imm;

} Snapshot;
