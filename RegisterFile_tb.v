`timescale 1ns / 1ps

module RegisterFile_tb;
    // Inputs
    reg clk;
    reg rst;
    reg WrEn;
    reg [4:0] RdReg1;
    reg [4:0] RdReg2;
    reg [4:0] WrReg;
    reg [31:0] WrData;
    
    // Outputs
    wire [31:0] RdData1;
    wire [31:0] RdData2;
    
    // Test case counter
    integer test_case;
    
    // Instantiate the Register File
    RegisterFile dut (
        .clk(clk),
        .rst(rst),
        .WrEn(WrEn),
        .RdReg1(RdReg1),
        .RdReg2(RdReg2),
        .WrReg(WrReg),
        .WrData(WrData),
        .RdData1(RdData1),
        .RdData2(RdData2)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize Inputs
        test_case = 0;
        rst = 0;
        WrEn = 0;
        RdReg1 = 0;
        RdReg2 = 0;
        WrReg = 0;
        WrData = 0;
        
        // Display header
        $display("Starting Register File Tests");
        $display("Time\tTest\tRdReg1\tRdReg2\tWrReg\tWrData\tRdData1\tRdData2");
        
        // Test Case 1: Reset
        test_case = 1;
        $display("\nTest Case %0d: Reset Test", test_case);
        rst = 1;
        @(posedge clk);
        #1; // Wait for outputs to settle
        // Check if all registers are zero
        RdReg1 = 5'd31; // Check last register
        RdReg2 = 5'd16; // Check middle register
        #1;
        if (RdData1 !== 32'h0 || RdData2 !== 32'h0) begin
            $display("ERROR: Reset failed! RdData1=%h, RdData2=%h", RdData1, RdData2);
        end
        rst = 0;
        
        // Test Case 2: Write and Read Different Registers
        test_case = 2;
        $display("\nTest Case %0d: Write and Read Different Registers", test_case);
        @(posedge clk);
        WrEn = 1;
        WrReg = 5'd5;
        WrData = 32'hA5A5A5A5;
        @(posedge clk);
        WrReg = 5'd10;
        WrData = 32'h5A5A5A5A;
        @(posedge clk);
        WrEn = 0;
        RdReg1 = 5'd5;
        RdReg2 = 5'd10;
        #1;
        $display("%0t\t%0d\t%0d\t%0d\t%0d\t%h\t%h\t%h", 
                 $time, test_case, RdReg1, RdReg2, WrReg, WrData, RdData1, RdData2);
        
        // Test Case 3: Write to Register 0 (should be ignored)
        test_case = 3;
        $display("\nTest Case %0d: Write to Register 0", test_case);
        @(posedge clk);
        WrEn = 1;
        WrReg = 5'd0;
        WrData = 32'hFFFFFFFF;
        @(posedge clk);
        WrEn = 0;
        RdReg1 = 5'd0;
        #1;
        if (RdData1 !== 32'h0) begin
            $display("ERROR: Register 0 was modified! RdData1=%h", RdData1);
        end
        
        // Test Case 4: Write with WrEn=0 (should be ignored)
        test_case = 4;
        $display("\nTest Case %0d: Write with WrEn=0", test_case);
        @(posedge clk);
        WrEn = 0;
        WrReg = 5'd15;
        WrData = 32'hAAAAAAAA;
        @(posedge clk);
        RdReg1 = 5'd15;
        #1;
        if (RdData1 !== 32'h0) begin
            $display("ERROR: Write occurred with WrEn=0! RdData1=%h", RdData1);
        end
        
        // Test Case 5: Simultaneous Read and Write to Same Register
        test_case = 5;
        $display("\nTest Case %0d: Simultaneous Read and Write", test_case);
        @(posedge clk);
        WrEn = 1;
        WrReg = 5'd20;
        WrData = 32'h12345678;
        RdReg1 = 5'd20;
        RdReg2 = 5'd20;
        @(posedge clk);
        #1;
        $display("%0t\t%0d\t%0d\t%0d\t%0d\t%h\t%h\t%h", 
                 $time, test_case, RdReg1, RdReg2, WrReg, WrData, RdData1, RdData2);
        
        // End simulation
        #20;
        $display("\nRegister File Tests Completed");
        $finish;
    end
    
    // Optional: Dump waveforms
    initial begin
        $dumpfile("RegisterFile_tb.vcd");
        $dumpvars(0, RegisterFile_tb);
    end
endmodule