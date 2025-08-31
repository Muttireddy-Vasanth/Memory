// Author: Vasanth, 2022
// Testbench for 16x8 synchronous dual-port RAM memory
module syn_dual_ram_tb();
  parameter RAM_WIDTH = 8,
            RAM_DEPTH = 16,
            ADDR_SIZE = 4;

  reg clk, wr_en, rd_en, rst;
  reg [RAM_WIDTH-1:0] data_in;
  reg [ADDR_SIZE-1:0] rd_ad, wr_ad;
  wire [RAM_WIDTH-1:0] data_out;

  // Internal memory array for reference (optional)
  reg [RAM_WIDTH-1:0] mem[RAM_DEPTH-1:0];

  // Instantiate the DUT (Device Under Test)
  syn_dual_ram DUT(clk, wr_en, rd_en, rst, rd_ad, wr_ad, data_in, data_out);

  // Clock generation: 100MHz clock with 10ns period
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  // Task to initialize inputs
  task initialise();
    begin
      wr_en  = 1'b0;
      rd_en  = 1'b0;
      rst    = 1'b0;
      data_in = 0;
      rd_ad  = 0;
      wr_ad  = 0;
    end
  endtask

  // Task to enable write mode
  task write();
    begin
      @(negedge clk);
      wr_en = 1'b1;
      rd_en = 1'b0;
    end
  endtask

  // Task to enable read mode
  task read();
    begin
      @(negedge clk);
      wr_en = 1'b0;
      rd_en = 1'b1;
    end
  endtask

  // Task to write data to specified address
  task write_data(input [ADDR_SIZE-1:0] i, input [RAM_WIDTH-1:0] j);
    begin
      @(negedge clk);
      wr_ad = i;
      data_in = j;
    end
  endtask

  // Task to set read address
  task read_data(input [ADDR_SIZE-1:0] k);
    begin
      @(negedge clk);
      rd_ad = k;
    end
  endtask

  // Task to insert delay of 10 time units
  task delay();
    begin
      #10;
    end
  endtask

  integer m, n;

  // Test stimulus process
  initial begin
    initialise;
    write;
    // Write data sequence with reset asserted at m
