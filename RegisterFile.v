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
    
    // inputs
    input wire clk, rst, WrEn;
    input wire [4:0] RdReg1, RdReg2, WrReg;
    input wire [31:0] WrData;
    
    // outputs
    output reg [31:0] RdData1, RdData2;
    
    // register file (registers)
    reg [31:0] registers [0:31];

    localparam zero = 0, at = 1, gp = 28, sp = 29, fp = 30, ra = 31;
    localparam v0 = 2, v1 = 3, a0 = 4, a1= 5, a2 = 6, a3 = 7;
    localparam t0 = 8, t1 = 9, t2 = 10, t3= 11, t4 = 12, t5 = 13, t6= 14, t7 = 15;
    localparam s0 = 16, s1 = 17, s2 = 18, s3= 19, s4 = 20, s5 = 21, s6= 22, s7 = 23;
    localparam t8 = 24, t9 = 25, k0 = 26, k1 = 27;

    // Read from the register file
    always @(*) begin
        RdData1 = registers[RdReg1];
        RdData2 = registers[RdReg2];
    end
    
    // Active-high synchronous reset
    always @(posedge clk or posedge rst) begin : Write_on_register_file_block
        integer i;
        
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 0; // Reset all registers
            end
        end else if (WrEn && WrReg != 5'b00000) begin // Prevent writing to register 0
            registers[WrReg] <= WrData;
        end
    end
    
endmodule
