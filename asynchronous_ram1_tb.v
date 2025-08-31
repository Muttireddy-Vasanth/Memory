// Author: Vasanth, 2022
// Testbench for single-port asynchronous RAM
module asynchronous_ram1_tb();
  reg we_in, enable_in;
  reg [2:0] addr_in;
  wire [15:0] data;
  reg [15:0] tempd;

  integer a, b;

  // Instantiate the DUT
  asynchronous_ram1 DUT(we_in, enable_in, addr_in, data);

  // Drive data bus during write operation
  assign data = (we_in && !enable_in) ? tempd : 16'bz;

  // Initialize inputs
  task initialize();
    begin
      we_in = 1'b0;
      enable_in = 1'b0;
      tempd = 16'h0;
    end
  endtask

  // Set stimulus for address and data
  task stimulus(input [2:0] i, input [15:0] j);
    begin
      addr_in = i;
      tempd = j;
    end
  endtask

  // Enable write mode
  task write();
    begin
      we_in = 1'b1;
      enable_in = 1'b0;
    end
  endtask

  // Enable read mode
  task read();
    begin
      we_in = 1'b0;
      enable_in = 1'b1;
    end
  endtask

  // Simple delay task for simulation timing
  task delay();
    begin
      #10;
    end
  endtask

  // Test procedure
  initial begin
    initialize;
    delay;
    write;
    for (a = 0; a < 8; a = a + 1) begin
      stimulus(a, a);
      delay;
    end
    delay;
    read;

    for (b = 0; b < 8; b = b + 1) begin
      stimulus(b, b);
      delay;
    end
  end

  // Monitor signals during simulation
  initial begin
    $monitor("we_in=%b, enable_in=%b, addr_in=%d, data=%d", we_in, enable_in, addr_in, data);
  end

  // Terminate simulation after 250 time units
  initial begin
    #250;
    $finish;
  end

endmodule
