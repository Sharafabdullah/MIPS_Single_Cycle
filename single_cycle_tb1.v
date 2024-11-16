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
        #10 rst = 0;  // Release reset after 10 time units
        
        // Test with no reset (normal operation)
        #100;  // Run for 100 time units
        
        // Test with reset again
        rst = 1;  // Apply reset
        #10 rst = 0;  // Release reset
        
        // Test case to check program counter behavior
        #50;  // Run for 50 more time units
        
        // End simulation
        $finish;
    end
    
    // Monitor signals
    initial begin
        $monitor("Time = %0t | PC = %h | clk = %b | rst = %b", $time, PC, clk, rst);
    end
    
endmodule
