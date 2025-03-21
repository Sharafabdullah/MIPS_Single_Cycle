`timescale 1ns / 1ps

module ALU_tb;
    
    // Parameters
    parameter data_width = 32;
    parameter sel_width = 4;

    // Inputs to the ALU
    reg [data_width - 1 : 0] operand1, operand2;
    reg [sel_width - 1 : 0] opSel;
    
    // Outputs from the ALU
    wire [data_width - 1 : 0] result;
    wire zero;
    
    // Instantiate the ALU module
    ALU #(data_width, sel_width) uut (
        .operand1(operand1), 
        .operand2(operand2), 
        .opSel(opSel), 
        .result(result), 
        .zero(zero)
    );
    
    // Task to display results
    task display;
        input [sel_width - 1 : 0] opSel;
        begin
            #10; // Wait for outputs to settle
            $display("Time: %0t | opSel: %b | operand1: %h | operand2: %h | result: %h | zero: %b", 
                     $time, opSel, operand1, operand2, result, zero);
        end
    endtask
    
    // Test cases
    initial begin
        $display("Starting ALU Testbench...");
        
        // Test ADD
        operand1 = 32'h0000000A; 
        operand2 = 32'h00000005; 
        opSel = 4'b0000; // _ADD
        display(opSel);

        // Test SUB
        operand1 = 32'h0000000F;
        operand2 = 32'h00000005;
        opSel = 4'b0001; // _SUB
        display(opSel);

        // Test AND
        operand1 = 32'h0F0F0F0F;
        operand2 = 32'hF0F0F0F0;
        opSel = 4'b0010; // _AND
        display(opSel);

        // Test OR
        operand1 = 32'h0F0F0F0F;
        operand2 = 32'hF0F0F0F0;
        opSel = 4'b0011; // _OR
        display(opSel);

        // Test SLT
        operand1 = 32'h0000000A;
        operand2 = 32'h0000000B;
        opSel = 4'b0100; // _SLT (set less than)
        display(opSel);

        // Test XOR
        operand1 = 32'hFFFFFFFF;
        operand2 = 32'hAAAAAAAA;
        opSel = 4'b0101; // _XOR
        display(opSel);

        // Test NOR
        operand1 = 32'h00000000;
        operand2 = 32'hFFFFFFFF;
        opSel = 4'b0110; // _NOR
        display(opSel);

        // Test SLL (shift left logical)
        operand1 = 32'h00000001;
        operand2 = 32'h00000004; // Shift by 4 bits
        opSel = 4'b0111; // _SLL
        display(opSel);

        // Test SRL (shift right logical)
        operand1 = 32'h00000002;
        operand2 = 32'h00000010; // Shift by 2 bits
        opSel = 4'b1000; // _SRL
        display(opSel);

        // Test SGT (set greater than)
        operand1 = 32'h0000000F;
        operand2 = 32'h0000000A;
        opSel = 4'b1001; // _SGT
        display(opSel);

        // Test Default case (invalid opSel)
        operand1 = 32'h12345678;
        operand2 = 32'h87654321;
        opSel = 4'b1111; // Invalid operation
        display(opSel);
        
        $display("ALU Testbench Completed.");
        $stop;
    end

endmodule
