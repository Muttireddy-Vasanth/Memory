// Author: Vasanth, 2022
// RTL for 16x8 asynchronous dual-port RAM memory
module asyn_dual_ram(
  input wr_en,
  input rd_en,
  input wr_clk,
  input rd_clk,
  input clr,
  input [15:0] data_in,
  input [2:0] rd_ad,
  input [2:0] wr_ad,
  output reg [15:0] data_out
);
  parameter RAM_WIDTH = 16;
  parameter RAM_DEPTH = 8;
  parameter ADDR_SIZE = 3;

  reg [RAM_WIDTH-1:0] mem[RAM_DEPTH-1:0];
  integer i;

  // Write logic: triggered on rising edge of write clock or clear
  always @(posedge wr_clk or posedge clr) begin
    if (clr) begin
      // Clear memory content on reset
      for (i = 0; i < RAM_DEPTH; i = i + 1)
        mem[i] <= 0;
    end else if (wr_en) begin
      // Write data at write address
      mem[wr_ad] <= data_in;
    end
  end

  // Read logic: triggered on rising edge of read clock or clear
  always @(posedge rd_clk or posedge clr) begin
    if (clr) begin
      data_out <= 0;
    end else if (rd_en) begin
      // Read data from read address
      data_out <= mem[rd_ad];
    end
  end

endmodule
