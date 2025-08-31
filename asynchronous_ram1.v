// Author: Vasanth, 2022
// RTL for single-port asynchronous RAM

module asynchronous_ram1(
  input we_in,           // Write enable
  input enable_in,       // Read enable
  input [2:0] addr_in,   // Address input (3-bit for 8 locations)
  inout [15:0] data      // Bidirectional data bus
);

  // Declare 8 locations of 16-bit wide memory
  reg [15:0] mem[7:0];
  reg [15:0] data_out;

  // Write logic: on change of inputs
  always @(*) begin
    if (we_in && !enable_in) begin
      mem[addr_in] = data;  // Write data to memory at addr_in
    end
  end

  // Read logic: tri-state data bus
  assign data = (enable_in && !we_in) ? mem[addr_in] : 16'bz;

endmodule
