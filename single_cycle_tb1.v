`timescale 1ns / 1ps

module single_cycle_tb1;

    // Testbench signals
    reg clk, rst;
    wire [15:0] PC;
    
    // Instantiate the single_cycle module
    single_cycle uut (
        .clk(clk),
        .rst(rst),
        .PC(PC)
    );
    
    // Clock generation
    always begin
        #5 clk = ~clk;  // Generate clock with period of 10 time units
    end
    
    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
       // Apply reset
    $display("Applying reset...");
    rst = 1;
    #10;
    rst = 0;
    #10;
    
    // Test 1: Run through the 15 instructions
    $display("Running through the 15 instructions...");
    
    // Wait for the processor to execute all instructions
    #4550; // You may need to adjust this delay depending on your clock and instructions

    // End of test
    $stop;
  end
  
    
    // Monitor signals
    initial begin
        $monitor("Time = %0t | PC = %h | clk = %b | rst = %b", $time, PC, clk, rst);
    end
    
endmodule
