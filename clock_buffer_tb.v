// Author: Vasanth, 2022
// Testbench for clock buffer
module clock_buffer_tb();
  reg mst_clock;
  wire buffer_clock;

  time t1, t2, t3, t4, t5, t6;

  // Instantiate the DUT
  clock_buffer DUT(mst_clock, buffer_clock);

  // Generate master clock with period 20 time units
  initial begin
    mst_clock = 1'b0;
    forever #10 mst_clock = ~mst_clock;
  end

  // Task to record master clock timing
  task mst();
    begin
      @(posedge mst_clock);
      t1 = $time;
      @(posedge mst_clock);
      t2 = $time;
      t3 = t2 - t1;
    end
  endtask

  // Task to record buffer clock timing
  task buff();
    begin
      @(posedge buffer_clock);
      t4 = $time;
      @(posedge buffer_clock);
      t5 = $time;
      t6 = t5 - t4;
    end
  endtask

  // Run mst and buff tasks in parallel
  initial fork
    mst;
    buff;
  join

  // Compare frequency of master and buffer clocks
  initial begin
    #40;
    if (t3 == t6)
      $display("Master time Period=%t \nBuffer Time Period=%t\nBoth have same frequency", t3, t6);
    else
      $display("Master time Period=%t and Buffer time Period=%t have different frequency", t3, t6);
  end

  // Compare phase of master and buffer clocks
  initial begin
    #40;
    if ((t1 == t4) && (t2 == t5))
      $display("Master starts at %t ends at %t \nBuffer starts at %t ends at %t \nBoth have same phase", t1, t2, t4, t5);
    else
      $display("Master and buffer have different phase");
  end

  // End simulation after 100 time units
  initial begin
    #100;
    $finish;
  end

endmodule
