module single_cycle(clk,
                   rst,
                   PC);
    
    //inputs
    input clk, rst;
    
    //!PC 0x0000 - 0xFFFF

    output [31:0] PC;
    reg [31:0] nextPC;
	 wire [31:0] PCPlus1; 
    
    wire [31:0] Instruction, WrData, RdData1, RdData2, ExtImm,ALUin1, ALUin2, ALURes, MemRdData;
    wire [15:0] Imm;

    //!Changed AdderResult -> BranchAddr and changed to match PC
    wire [5:0] OpCode, Funct;
    wire [31:0] BranchAddr;
    wire [4:0] rs, rt, rd, WrReg, shamt; //! added shamt
    wire [3:0] ALUOp; //!changed to 4 bits

    wire [31:0] JAddr, JRAddr;
    // assign JAddr = {Instruction[13:0], 2'b00}; // J const

    assign JAddr = {PCPlus1[31:26], Instruction[25:0]};
    assign JRAddr = RdData1[31:0]; // The bits read from $rs

    wire RegDst, MemRdEn, MemtoReg, MemWrEn, RegWrEn,ALUSrc1, ALUSrc2, zero, Jump, JumpReg, BranchEq, BranchNeq; //! Added ALUSrc1, Jump, JumpReg, removed Branch and added BranchEq & BranchNeq

    wire BranchTaken, InvalidInst, MemoryOutOfBounds, Overflow;
    reg Exception; //added to ensure there is no errors
    reg [2:0] PCsrc; //changed to 2 bits - it's reg to allow always block - not a reg
    
    assign OpCode = Instruction[31:26];
    assign rs     = Instruction[25:21];
    assign rt     = Instruction[20:16];
    assign rd     = Instruction[15:11];
    
    
    assign Imm   = Instruction[15:0];
    assign Funct = Instruction[5:0];
    assign shamt = Instruction[10:6]; 

   assign MemoryOutOfBounds = (MemRdEn || MemWrEn) && (ALURes>10'h3ff);
//    assign Exception = InvalidInst || MemoryOutOfBounds || Overflow;
    always @(posedge clk) begin
        if(rst) Exception = 1'b0;
        else if(PC != 32'hffffffff) Exception = InvalidInst || MemoryOutOfBounds || Overflow;
    end
    ProgramCounter  pc(
    .clk(clk),
    .rst(rst),
    .PCin(nextPC),
    .PCout(PC)
    );
    
    //Add 4 if it is byte addressed / 1 if it is word addressed
    Adder #(.size(32)) PCAdder(
    .in1(PC),
    .in2(32'b1), ////!!!!
    .out(PCPlus1)
    );
    
    InstMem IM(
    .address(nextPC),
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
    mux2X1 #(5) RFInter_(
    .in1(rt),
    .in2(rd),
    .s(RegDst),
    .out(WrRegInter)
    ); //corrected WrReg
    
    // If there is jal -> write at the register 31 (ra)
    mux2X1 #(5) RFMux_(
    .in1(WrRegInter),
    .in2(5'b11111),
    .s(Jump & RegWrEn),
    .out(WrReg)
    );
    
    
    
    RegisterFile RF(
    .clk(clk),
    .rst(rst),
    .WrEn(RegWrEn),
    .RdReg1(rs),
    .RdReg2(rt),
    .WrReg(WrReg),
    .WrData(WrData),
    .RdData1(RdData1),
    .RdData2(RdData2)
    );
    
    SignExtender SignExtend_(
    .in(Imm),
    .out(ExtImm)
    );

    //! Added mux
    mux2X1 #(32) ALUMux1_(
        .in1(RdData1),
        .in2({27'b0,shamt}), //19-11 first bug - shamt must be extended             
        .s(ALUSrc1), 
        .out(ALUin1)
    );
    
    mux2X1 #(32) ALUMux2_(
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
    .overflow(Overflow),
    .zero(zero)
    );
    
    //Branch taken?
    assign BranchTaken = ((zero & BranchEq) | (zero=='b0 & BranchNeq));

    //Determine PCsrc
    always @(*) begin
        PCsrc = 3'b000;
        if(Exception) begin
            PCsrc = 3'b111;
        end
        else if(BranchTaken) begin
            PCsrc = 3'b001;
        end
        else if(Jump) begin
            PCsrc = 3'b010;
        end
        else if(JumpReg) begin
            PCsrc = 3'b011;
        end
        else begin
            PCsrc = 3'b000;
        end
    end

    
    Adder #(32) branchAdder_(
    .in1(PCPlus1),
    .in2(ExtImm), //changes to ExtImm
    .out(BranchAddr)
    );
    
    DataMem DM_(
    .address(ALURes[9:0]), //! 1k words - 4kB
    .inclock(~clk), .data(RdData2),
    .rden(MemRdEn),
    .wren(MemWrEn),
    .q(MemRdData)
    );
	 

    // DataMem DM_(
	// .address(ALURes[9:0]),
	// .data(RdData2),
	// .inclock(clk),
	// .we(MemWrEn),
	// .q(MemRdData));
    
    wire [31:0] WrDataInter;
    mux2X1 #(32) WBMux1_(
    .in1(ALURes),
    .in2(MemRdData),
    .s(MemtoReg),
    .out(WrDataInter)
    ); //swapped MemRdData and ALURes

    //! Added if there is JAL 
    mux2X1 #(32) WBMux2_(
    .in1(WrDataInter), 
    .in2(PCPlus1),
    .s(Jump & RegWrEn),
    .out(WrData)
    );
    
    // mux4x1 #(32) PCMux_(
    // .in1(PCPlus1),
    // .in2(BranchAddr),
    // .in3(JAddr),
    // .in4(JRAddr),
    // .s(PCsrc),
    // .out(nextPC)
    // );
    always @(*) begin
        case(PCsrc)
            3'b000: nextPC <= PCPlus1;
            3'b001: nextPC <= BranchAddr;
            3'b010: nextPC <= JAddr;
            3'b011: nextPC <= JRAddr;
            3'b111: nextPC <= 32'h000003f0;
        endcase
    end
    
    
endmodule
    
