// Author: Vasanth, 2022
// Testbench for 16x8 FIFO memory buffer
module FIFObuffer_tb();
  // Inputs
  reg Clk;
  reg [7:0] dataIn;
  reg RD, WR, Rst;
  // Outputs
  wire [7:0] dataOut;
  wire FULL;
  wire EMPTY;

  integer i; // Integer for loop iteration

  // Instantiate the Unit Under Test (UUT)
  FIFObuffer uut (
    .Clk(Clk),
    .dataIn(dataIn),
    .RD(RD),
    .WR(WR),
    .dataOut(dataOut),
    .Rst(Rst),
    .FULL(FULL),
    .EMPTY(EMPTY)
  );

  // Generate clock signal with a period of 10 time units
  initial begin
    Clk = 1'b0;
    forever #5 Clk = ~Clk;
  end

  // Task to initialize inputs
  task initialise;
    begin
      dataIn = 8'b0;
      RD = 1'b0;
      WR = 1'b0;
      Rst = 1'b0;
      #10;
    end
  endtask

  // Task to reset the FIFO
  task reset;
    begin
      @(negedge Clk);
      Rst = 1'b1;
      #10;
      Rst = 1'b0;
      #10;
    end
  endtask

  // Task to write data into FIFO
  task write(input integer j);
    begin
      @(negedge Clk);
      dataIn = j;
    end
  endtask

  // Test procedure
  initial begin
    initialise;
    reset;
    WR = 1'b1;
    for (i = 0; i < 18; i = i + 1) begin
      write(i);
    end
    #10;
    WR = 1'b0;
    RD = 1'b1;
  end

  // Monitor signals
  initial begin
    $monitor("Clk=%b, dataIn=%b, RD=%b, WR=%b, dataOut=%b, Rst=%b, EMPTY=%b, FULL=%b",
             Clk, dataIn, RD, WR, dataOut, Rst, EMPTY, FULL);
  end

  // End simulation after 400 time units
  initial begin
    #400;
    $finish;
  end

endmodule
