module singe_cycle(clk,
                   rst,
                   PC);
    
    //inputs
    input clk, rst;
    
    //!PC 0x0000 - 0xFFFF
    output [15:0] PC, nextPC, PCPlus4; 
    
    wire [31:0] Instruction, WrData, RdData1, RdData2, ExtImm, ALUin2, ALURes, MemRdData;
    wire [15:0] Imm;

    //!Changed AdderResult -> BranchAddr
    wire [5:0] OpCode, Funct, BranchAddr;
    wire [4:0] rs, rt, rd, WrReg, shamt; //! added shamt
    wire [3:0] ALUOp; //!changed to 4 bits

    wire [15:0] JAddr, JRAdrr;
    assign JAddr = {Instruction[13:0], 2'b00}; // J const
    assign JRAdrr = RdData1[15:0]; // This first 16 bits of rs 

    wire RegDst, Branch, MemRdEn, MemtoReg, MemWrEn, RegWrEn,ALUSrc1, ALUSrc2, zero, Jump, JumpReg; //! Added ALUSrc1, Jump, JumpReg

    wire BranchTaken;
    wire [1:0] PCsrc; //changed to 2 bits
    
    assign OpCode = Instruction[31:26];
    assign rs     = Instruction[25:21];
    assign rt     = Instruction[20:16];
    assign rd     = Instruction[15:11];
    
    
    assign Imm   = Instruction[15:0];
    assign Funct = Instruction[5:0];
    assign shamt = Instruction[10:6]; 
    
    wire PCEn; //!Added Enable to the PC so that we can halt the CPU
    ProgramCounter_	 pc(
    .clk(clk),
    .rst(rst),
    .PCEn(PCEn)
    .PCin(nextPC),
    .PCout(PC)
    );
    
    //Add 4 as it is byte addressed - 
    Adder_ #(.size(16)) PCAdder(
    .in1(PC),
    .in2(16'b4),
    .out(PCPlus4)
    );
    
    //Changed instMem name and it is 4 word one byte each
    //what should be done when the address is not aligned ? 
    // how to fetch 4 bytes in one cycle? - prefetch using fifo or 
    // dividing the memory into 4 and assembling in one cycle
    InstMem IM(
    .address(PC),
    .clock(clk),
    .q(Instruction)
    );
    
    
    ControlUnit CU(
    .OpCode(OpCode),
    .Funct(Funct),
    .RegDst(RegDst),
    .BranchEq(BranchEq),
    .BranchNeq(BranchNeq),
    .InvalidInst(InvalidInst),
    .Jump(Jump),
    .JumpReg(JumpReg),
    .MemRdEn(MemRdEn),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrEn(MemWrEn),
    .RegWrEn(RegWrEn),
    .ALUSrc1(ALUSrc1),
    .ALUSrc2(ALUSrc2)
    );
    
    wire [4:0] WrRegInter;
    mux2x1 #(5) RFInter(
    .in1(rt),
    .in2(rd),
    .s(RegDst),
    .out(WrRegInter)
    ); //corrected WrReg
    
    // If there is jal -> write at the register 31
    mux2x1 #(5) RFMux(
    .in1(WrRegInter),
    .in2(5'b11111),
    .s(Jump & RegWrEn),
    .out(WrReg)
    );
    
    
    
    RegisterFile RF(
    .clk(clk),
    .rst(rst),
    .WrEn(RegWrEn),
    .rdReg1(rs),
    .rdReg2(rt),
    .WrReg(WrReg),
    .WrData(WrData),
    .RdData1(RdData1),
    .RdData2(RdData2)
    );
    
    SignExtender SignExtend(
    .in(Imm),
    .out(ExtImm)
    );

    //! Added mux
    mux2x1 #(32) ALUMux1(
        .in1(RdData1),
        .in2(shamt),
        .s(ALUSrc1), 
        .out(ALUin1)
    );
    
    mux2x1 #(32) ALUMux2(
    .in1(RdData2),
    .in2(ExtImm),
    .s(ALUSrc2),
    .out(ALUin2)
    );
    
    ALU Alu(
    .operand1(ALUin1),
    .operand2(ALUin2),
    .opSel(ALUOp),
    .result(ALURes),
    .zero(zero)
    );
    
    //Branch taken?
    assign BranchTaken = ((zero & BranchEq) | (zero=='b0 & BranchNeq));

    //Determine PCsrc
    always @(*) begin
        PCsrc = 2'b00;
        if(BranchTaken) begin
            PCsrc = 2'b01;
        end
        else if(Jump) begin
            PCsrc = 2'b10;
        end
        else if(JumpReg) begin
            PCsrc = 2'b11;
        end
        else begin
            PCsrc = 2'b00;
        end
    end

    // ANDGate branchAnd(
    // .in1(zero),
    // .in2(Branch),
    // .out(PCsrc));
    
    adder branchAdder(
    .in1(PCPlus4),
    .in2(Imm[15:0]),
    .out(BranchAddr)
    );
    
    DataMem DM(
    .address(ALURes[9:0]), //! 1k words - 4kB
    .clock(clk), .data(RdData2),
    .rden(MemRdEn),
    .wren(MemWrEn)
    .q(MemRdData)
    );
    
    wire [31:0] WrDataInter;
    mux2x1 #(32) WBMux1(
    .in1(ALURes),
    .in2(MemRdData),
    .s(MemtoReg),
    .out(WrDataInter)
    ); //swapped MemRdData and ALURes

    //! Added if there is JAL 
    mux2x1 #(32) WBMux2(
    .in1(WrDataInter), 
    .in2(nextPC),
    .s(Jump & RegWrEn),
    .out(WrData)
    );
    
    mux4x1 #(16) PCMux(
    .in1(PCPlus4),
    .in2(BranchAddr),
    .in3(JAddr),
    .in4(JRAddr),
    .s(PCsrc),
    .out(nextPC)
    );
    
    
endmodule
    
