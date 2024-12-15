module RegisterFile (                             
    clk,
    rst,
    WrEn,
    RdReg1,
    RdReg2,
    WrReg,
    WrData,
    RdData1,
    RdData2
);
    // Inputs
    input wire clk, rst, WrEn;
    input wire [4:0] RdReg1, RdReg2, WrReg;
    input wire [31:0] WrData;
    
    // Outputs
    output [31:0] RdData1, RdData2;
    
    // Register file (32 registers of 32 bits each)
    reg [31:0] registers [0:31];

    assign RdData1 = registers[RdReg1];
    assign RdData2 = registers[RdReg2];

    
    always @(posedge clk) begin: named_block
        integer i;
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 0; // Reset all registers to 0
            end
        end 
        else if (WrEn && WrReg != 5'b00000) begin
            registers[WrReg] <= WrData; // Write to the register if WrEn is asserted and not R0
        end
    end

endmodule
