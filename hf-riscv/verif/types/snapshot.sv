typedef logic [31:0] register;
typedef struct {
  bit data_access;

  logic [31:0] address;
  logic [31:0] data_read;
  logic [3:0]  data_we;

  register [0:31] registers;
} Snapshot;
