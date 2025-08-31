// Author: Vasanth, 2022
// RTL for vending machine control unit
// Accepts coins of denomination 1 or 2 rupees
// Product priced Rs.3, output 'prod' asserted on delivery
// Output 'change' asserted if Rs.4 is received to return 1 rupee

module vending_machine(
  input clk,
  input rst,
  input [1:0] coin,    // coin input encoded as {i,j}: 10->1 rupee, 11->2 rupees
  output reg prod,     // Product delivery output
  output reg change    // Change return output
);

  // State encoding
  parameter s0 = 2'b00; // 0 rupees accumulated
  parameter s1 = 2'b01; // 1 or 2 rupees accumulated
  parameter s2 = 2'b10; // 3 rupees accumulated

  reg [1:0] pre, next;

  // Sequential logic for state update
  always @(posedge clk) begin
    if (rst)
      pre <= s0;
    else
      pre <= next;
  end

  // Combinational logic for next state calculation
  always @(*) begin
    next = s0;
    case (pre)
      s0: begin
        if (coin == 2)       // coin == 2 means '10' binary -> 1 rupee coin
          next = s1;
        else if (coin == 3)  // coin == 3 means '11' binary -> 2 rupees coin
          next = s2;
        else
          next = s0;
      end

      s1: begin
        if (coin == 2)
          next = s2;
        else if (coin == 3)
          next = s0;
        else
          next = s1;
      end

      s2: begin
        if ((coin == 2) || (coin == 3))
          next = s0;
        else
          next = s2;
      end

      default: next = s0;
    endcase
  end

  // Output logic based on current state and input coin
  always @(posedge clk) begin
    prod <= 0;
    change <= 0;
    case (pre)
      s1: begin
        if (coin == 3)         // Receiving 2 rupees coin when in s1 state accumulates to 3
          prod <= 1;
      end

      s2: begin
        if (coin == 2) begin   // Receiving 1 rupee coin in s2 state results in total 3
          prod <= 1;
        end else if (coin == 3) begin // Receiving 2 rupees coin in s2 state = 4 Rs
          prod <= 1;
          change <= 1;          // Return 1 rupee coin
        end
      end
    endcase
  end

endmodule
