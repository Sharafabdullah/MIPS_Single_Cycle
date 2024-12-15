`timescale 1ns / 1ps

module single_cycle_tb1;

    // Testbench signals
    reg clk, rst;
    wire [31:0] PC;
    
    // Instantiate the single_cycle module
    single_cycle uut (
        .clk(clk),
        .rst(rst),
        .PC(PC)
    );
	 integer cycleCount = 0;
    integer branchTakenCount = 0;
	 integer jumpCount = 0;
	 integer jumpRegCount = 0;
    
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
    
    // Test 1: Run through the instructions
    $display("Running through the instructions...");
    
    // Wait for the processor to execute all instructions
    #550; // You may need to adjust this delay depending on your clock and instructions

	$display("Simulation Results:");
	$display("Total Cycles: %d", cycleCount);
	$display("Branch Taken: %d", branchTakenCount);
   $display("jump Count: %d", jumpCount);
	$display("jump reg Count: %d", jumpRegCount);
    // End of test
    $stop;
  end
  always @(posedge clk) begin
        if(uut.Instruction != 0) begin
		      cycleCount = cycleCount + 1;

            if (uut.BranchTaken) begin
                branchTakenCount = branchTakenCount + 1;
            end

            if(uut.Jump) begin
                jumpCount = jumpCount + 1;
            end
            if(uut.JumpReg) begin
                jumpRegCount = jumpRegCount + 1;
            end
        end
	end
    
    // Monitor signals
    initial begin
        $monitor("Time = %0t | PC = %h | clk = %b | rst = %b", $time, PC, clk, rst);
    end
    
endmodule
