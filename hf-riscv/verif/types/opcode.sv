typedef enum logic [6:0] {
  OPCD_LUI   = 7'b01_101_11,
  OPCD_AUIPC = 7'b00_101_11,
  OPCD_JAL   = 7'b11_011_11,
  OPCD_JALR  = 7'b11_001_11,
  BRANCH     = 7'b11_000_11,
  LOAD       = 7'b00_000_11,
  STORE      = 7'b01_000_11,
  OPP_IMM    = 7'b00_100_11,
  OP         = 7'b01_100_11,
  SYSTEM     = 7'b11_100_11
}  Opcode;

logic [31:0] OpcodeMask[Opcode];
initial begin
  OpcodeMask[OPCD_LUI]   = 32'b0000000_00000_00000_000_00000_1111111;
  OpcodeMask[OPCD_AUIPC] = 32'b0000000_00000_00000_000_00000_1111111;
  OpcodeMask[OPCD_JAL]   = 32'b0000000_00000_00000_000_00000_1111111;
  OpcodeMask[OPCD_JALR]  = 32'b0000000_00000_00000_111_00000_1111111;
  OpcodeMask[BRANCH]     = 32'b0000000_00000_00000_111_00000_1111111;
  OpcodeMask[LOAD]       = 32'b0000000_00000_00000_111_00000_1111111;
  OpcodeMask[STORE]      = 32'b0000000_00000_00000_111_00000_1111111;
  OpcodeMask[OPP_IMM]    = 32'b0000000_00000_00000_111_00000_1111111;
  OpcodeMask[OP]         = 32'b1111111_00000_00000_111_00000_1111111;
  OpcodeMask[SYSTEM]     = 32'b1111111_11111_11111_111_11111_1111111;
end

// SLLI, SRLI and SRAI mix OPP_IMM and OP: OPP_IMM OPCODE with OP mask.
// Because of that, SRAI is always mistaken as SRLI
logic [31:0] OpcodeMask_SR_I
                      = 32'b1111111_00000_00000_111_00000_1111111;

InstrType OpcodeFormat[Opcode];
initial begin
  OpcodeFormat[OPCD_LUI]   = U_type;
  OpcodeFormat[OPCD_AUIPC] = U_type;
  OpcodeFormat[OPCD_JAL]   = J_type;
  OpcodeFormat[OPCD_JALR]  = I_type;
  OpcodeFormat[BRANCH]     = B_type;
  OpcodeFormat[LOAD]       = I_type;
  OpcodeFormat[STORE]      = S_type;
  OpcodeFormat[OPP_IMM]    = I_type;
  OpcodeFormat[OP]         = R_type;
  OpcodeFormat[SYSTEM]     = R_type;
end
