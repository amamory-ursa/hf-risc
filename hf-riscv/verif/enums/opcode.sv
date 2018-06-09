typedef enum bit [6:0] {
  LOAD    = 7'b00_000_11,
  OPP_IMM = 7'b00_100_11,
  AUIPC   = 7'b00_101_11,
  STORE   = 7'b01_000_11,
  OP      = 7'b01_100_11,
  LUI     = 7'b01_101_11,
  BRANCH  = 7'b11_000_11,
  JALR    = 7'b11_001_11,
  JAL     = 7'b11_011_11,
  SYSTEM  = 7'b11_100_11
}  Opcode;
