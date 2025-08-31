// Author: Vasanth, 2022
// RTL for clock buffer
module clock_buffer(
  input mst_clock,
  output buffer_clock
);
  // Buffer instantiation to drive buffer_clock from mst_clock
  buf B1(buffer_clock, mst_clock);

endmodule
