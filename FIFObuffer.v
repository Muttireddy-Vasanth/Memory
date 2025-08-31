// Author: Vasanth, 2022
// RTL for 16x8 FIFO memory buffer
module FIFObuffer(
  input Clk,
  input RD,
  input WR,
  input Rst,
  input [7:0] dataIn,
  output reg [7:0] dataOut,
  output FULL,
  output EMPTY
);

  reg [3:0] fifo_cnt;
  reg [7:0] FIFO[15:0];
  reg [3:0] readCounter, writeCounter;
  integer i;

  // Synchronous logic for write, read, and reset
  always @(posedge Clk) begin
    if (Rst) begin
      for (i = 0; i < 16; i = i + 1) begin
        FIFO[i] <= 0;
      end
      dataOut <= 0;
      readCounter <= 0;
      writeCounter <= 0;
    end else begin
      if (WR == 1'b1 && !FULL) begin
        FIFO[writeCounter] <= dataIn;
        writeCounter <= writeCounter + 1;
      end

      if (RD == 1'b1 && !EMPTY) begin
        dataOut <= FIFO[readCounter];
        readCounter <= readCounter + 1;
      end
    end
  end

  // Full and empty flags
  assign FULL = (fifo_cnt == 16) ? 1'b1 : 1'b0;
  assign EMPTY = (fifo_cnt == 0) ? 1'b1 : 1'b0;

  // FIFO count management
  always @(posedge Clk) begin
    if (Rst) begin
      fifo_cnt <= 0;
    end else begin
      case ({WR, RD})
        2'b10: // Write only
          fifo_cnt <= (fifo_cnt == 16) ? 16 : fifo_cnt + 1;
        2'b01: // Read only
          fifo_cnt <= (fifo_cnt == 0) ? 0 : fifo_cnt - 1;
        default:
          fifo_cnt <= fifo_cnt;
      endcase
    end
  end

endmodule
