// Author: Vasanth, 2022
// Testbench for 16x8 asynchronous dual-port RAM memory
module asyn_dual_ram_tb();
  parameter RAM_WIDTH = 16,
            RAM_DEPTH = 8,
            ADDR_SIZE = 3;

  reg wr_en, rd_en, wr_clk, rd_clk, clr;
  reg [RAM_WIDTH-1:0] data_in;
  reg [ADDR_SIZE-1:0] rd_ad, wr_ad;
  wire [RAM_WIDTH-1:0] data_out;

  reg [RAM_WIDTH-1:0] mem [RAM_DEPTH-1:0]; // Optional reference memory

  // Instantiate the DUT
  asyn_dual_ram DUT(wr_en, rd_en, wr_clk, rd_clk, clr, rd_ad, wr_ad, data_in, data_out);

  // Write clock generation: 25ns period (40 MHz)
  initial begin
    wr_clk = 1'b0;
    forever #20 wr_clk = ~wr_clk;
  end

  // Read clock generation: 20ns period (50 MHz)
  initial begin
    rd_clk = 1'b0;
    forever #10 rd_clk = ~rd_clk;
  end

  // Initialize inputs
  task initialise();
    begin
      wr_en = 1'b0;
      rd_en = 1'b0;
      clr = 1'b0;
      data_in = 0;
      rd_ad = 0;
      wr_ad = 0;
    end
  endtask

  // Enable write mode
  task write();
    begin
      wr_en = 1'b1;
      rd_en = 1'b0;
    end
  endtask

  // Enable read mode
  task read();
    begin
      wr_en = 1'b0;
      rd_en = 1'b1;
    end
  endtask

  // Write data to RAM at address i
  task write_data(input [ADDR_SIZE-1:0] i, input [RAM_WIDTH-1:0] j);
    begin
      wr_ad = i;
      data_in = j;
      #80; // wait for write cycle
    end
  endtask

  // Read data from RAM at address k
  task read_data(input [ADDR_SIZE-1:0] k);
    begin
      rd_ad = k;
      #40; // wait for read cycle
    end
  endtask

  // Test stimulus
  initial begin
    initialise;
    write;

    // Write data to various addresses
    write_data(0, 9);
    write_data(1, 19);
    write_data(4, 14);
    write_data(6, 25);

    #40;
    read;

    // Read data from addresses and assert clear at some point
    read_data(0);
    read_data(1);
    read_data(4);

    clr = 1'b1;   // Assert clear

    read_data(6); // Read after clear to verify reset

  end

  // Monitor signals
  initial begin
    $monitor("wr_en=%b, rd_en=%b, clr=%b, rd_ad=%b, wr_ad=%b, data_in=%b, data_out=%b",
             wr_en, rd_en, clr, rd_ad, wr_ad, data_in, data_out);
  end

  // End simulation after 1000 time units
  initial begin
    #1000;
    $finish;
  end

endmodule
