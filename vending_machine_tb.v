// Author: Vasanth, 2022
// Testbench for vending machine control unit
module vending_machine_tb();
  reg clk, rst;
  reg [1:0] coin;
  wire prod, change;

  // Instantiate the Design Under Test (DUT)
  vending_machine DUT(clk, rst, coin, prod, change);

  // Generate clock with 10 time units period
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  // Task to initialize inputs
  task initialise;
    begin
      rst = 1'b0;
      coin = 2'b00;
    end
  endtask

  // Task to drive coin input on negative clock edge
  task stimulus(input integer i);
    begin
      @(negedge clk);
      coin = i;
    end
  endtask

  // Stimulus process
  initial begin
    initialise;
    stimulus(2); // coin 10b = 1 rupee
    stimulus(3); // coin 11b = 2 rupees
    stimulus(1); // coin 01b = no coin (should be handled)
    stimulus(3);
    stimulus(3);
    stimulus(1);
    stimulus(2);
    stimulus(3);
    stimulus(0);
    stimulus(2);
    stimulus(3);
    stimulus(3);
    stimulus(3);
    stimulus(0);
    rst = 1'b1;  // Assert reset
  end

  // Monitor inputs and outputs
  initial begin
    $monitor("coin=%b, rst=%b, product=%b, change=%b", coin, rst, prod, change);
  end

  // Finish simulation after 200 time units
  initial begin
    #200;
    $finish;
  end

endmodule
