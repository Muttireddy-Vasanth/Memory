// Author: Vasanth, 2022
// RTL for 16x8 synchronous dual-port RAM memory
module syn_dual_ram(
  input clk,
  input wr_en,
  input rd_en,
  input rst,
  input [3:0] rd_ad,
  input [3:0] wr_ad,
  input [7:0] data_in,
  output reg [7:0] data_out
);
  parameter RAM_WIDTH = 8;
  parameter RAM_DEPTH = 16;
  parameter ADDR_SIZE = 4;

  // Memory array declaration
  reg [RAM_WIDTH-1:0] mem[RAM_DEPTH-1:0];
  integer i;

  // Initialize output to high impedance
  initial begin
    data_out = 'bz;
  end

  always @(posedge clk) begin
    if (rst) begin
      // Reset memory content and output
      for (i = 0; i < RAM_DEPTH; i = i + 1)
        mem[i] <= 0;
      data_out <= 0;
    end
    else begin
      if (wr_en) begin
        // Write data to memory at write address
        mem[wr_ad] <= data_in;
      end
      else if (rd_en) begin
        // Read data from memory at read address
        data_out <= mem[rd_ad];
      end
    end
  end

endmodule
