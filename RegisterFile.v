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
    output reg [31:0] RdData1, RdData2;
    
    // Register file (32 registers of 32 bits each)
    reg [31:0] registers [0:31];

    // Read from the register file with bypass logic
    always @(*) begin
        // Read port 1
        if (WrEn && (WrReg == RdReg1) && (WrReg != 5'b00000)) 
            RdData1 = WrData; // Forward write data if RAW hazard
        else
            RdData1 = (RdReg1 == 5'b00000) ? 32'b0 : registers[RdReg1];

        // Read port 2
        if (WrEn && (WrReg == RdReg2) && (WrReg != 5'b00000)) 
            RdData2 = WrData; // Forward write data if RAW hazard
        else
            RdData2 = (RdReg2 == 5'b00000) ? 32'b0 : registers[RdReg2];
    end
    
    // Write to the register file with synchronous reset
    always @(posedge clk) begin : Write_on_register_file_block
        integer i;
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 0; // Reset all registers to 0
            end
        end else if (WrEn && WrReg != 5'b00000) begin
            registers[WrReg] <= WrData; // Write to the register if WrEn is asserted and not R0
        end
    end

endmodule
