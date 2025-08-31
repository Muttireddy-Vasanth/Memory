// Author: Vasanth, 2022
// RTL for 101 overlapping Moore FSM sequence detector
module seq_det(
  input seq_in,
  input clock,
  input reset,
  output det_o
);

  // Declare states as parameters
  parameter IDLE   = 2'b00,
            STATE1 = 2'b01,
            STATE2 = 2'b10,
            STATE3 = 2'b11;

  // Internal registers for present and next state
  reg [1:0] state, next_state;

  // Sequential logic for present state with active high asynchronous reset
  always @(posedge clock or posedge reset) begin
    if (reset)
      state <= IDLE;
    else
      state <= next_state;
  end

  // Combinational logic for next state
  always @(state, seq_in) begin
    case(state)
      IDLE:    next_state = (seq_in == 1) ? STATE1 : IDLE;
      STATE1:  next_state = (seq_in == 0) ? STATE2 : STATE1;
      STATE2:  next_state = (seq_in == 1) ? STATE3 : IDLE;
      STATE3:  next_state = (seq_in == 1) ? STATE1 : STATE2;
      default: next_state = IDLE;
    endcase
  end

  // Moore output logic
  assign det_o = (state == STATE3) ? 1'b1 : 1'b0;

endmodule
