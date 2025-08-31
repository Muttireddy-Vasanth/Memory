`timescale 1ms/1us
// Author: Vasanth, 2022
// Testbench for 101 overlapping Moore FSM sequence detector
module seq_det_tb();
  // Testbench global variables
  reg din, clock, reset;
  wire dout;

  // Parameter constant for clock cycle
  parameter CYCLE = 0.03906;

  // DUT Instantiation
  seq_det SQD(
    .seq_in(din),
    .clock(clock),
    .reset(reset),
    .det_o(dout)
  );

  // Generate clock using parameter "CYCLE"
  initial begin
    clock = 0;
    forever begin
      #(CYCLE/2);
      clock = ~clock;
    end
  end

  // Task to initialize input din
  task initialize();
    begin
      din = 0;
    end
  endtask

  // Delay task
  task delay(input integer i);
    begin
      #i;
    end
  endtask

  // Task to reset DUT
  task RESET();
    begin
      delay(5);
      reset = 1'b1;
      delay(10);
      reset = 1'b0;
    end
  endtask

  // Task provides input data to design on negedge of clock
  task stimulus(input data);
    begin
      @(negedge clock);
      din = data;
    end
  endtask

  // Monitor changes in inputs, output, and internal state
  initial begin
    $monitor("Reset=%b, state=%b, Din=%b, Output Dout=%b",
             reset, SQD.state, din, dout);
  end

  // Display message when correct output is asserted
  always @(SQD.state or dout) begin
    if (SQD.state == 2'b11 && dout == 1)
      $display("Correct output at state %b", SQD.state);
  end

  // Generate stimulus sequence with overlapping sequence
  initial begin
    initialize;
    RESET;
    stimulus(0);
    stimulus(1);
    stimulus(0);
    stimulus(1);
    stimulus(0);
    stimulus(1);
    stimulus(1);
    RESET;
    stimulus(1);
    stimulus(0);
    stimulus(1);
    stimulus(1);
    delay(10);
    $finish;
  end

endmodule
