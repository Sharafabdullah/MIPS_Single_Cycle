`timescale 1ns/1ps

module CU_tb;

    // Declare testbench signals
    reg [5:0] OpCode, Funct;
    wire RegDst, BranchEq, BranchNeq, InvalidInst, Jump, JumpReg;
    wire MemRdEn, MemtoReg, MemWrEn, RegWrEn, ALUSrc1, ALUSrc2;
    wire [3:0] ALUOp;

    // Instantiate the Control Unit
    ControlUnit CU (
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

    // Test vectors
    initial begin
        // Test R-type (add)
        OpCode = 6'h0; Funct = 6'h20; #10;
        $display("R-Type (add): RegDst=%b, ALUOp=%b", RegDst, ALUOp);

        // Test R-type (sub)
        OpCode = 6'h0; Funct = 6'h22; #10;
        $display("R-Type (sub): RegDst=%b, ALUOp=%b", RegDst, ALUOp);

        // Test addi
        OpCode = 6'h8; Funct = 6'h0; #10;
        $display("addi: RegDst=%b, ALUOp=%b", RegDst, ALUOp);

        // Test ori
        OpCode = 6'hD; Funct = 6'h0; #10;
        $display("ori: RegDst=%b, ALUOp=%b", RegDst, ALUOp);

        // Test lw
        OpCode = 6'h23; Funct = 6'h0; #10;
        $display("lw: MemRdEn=%b, MemtoReg=%b, ALUOp=%b", MemRdEn, MemtoReg, ALUOp);

        // Test sw
        OpCode = 6'h2B; Funct = 6'h0; #10;
        $display("sw: MemWrEn=%b, ALUOp=%b", MemWrEn, ALUOp);

        // Test beq
        OpCode = 6'h4; Funct = 6'h0; #10;
        $display("beq: BranchEq=%b, ALUOp=%b", BranchEq, ALUOp);

        // Test bne
        OpCode = 6'h5; Funct = 6'h0; #10;
        $display("bne: BranchNeq=%b, ALUOp=%b", BranchNeq, ALUOp);

        // Test jump
        OpCode = 6'h2; Funct = 6'h0; #10;
        $display("jump: Jump=%b", Jump);

        // Test jr
        OpCode = 6'h8; Funct = 6'h0; #10;
        $display("jr: JumpReg=%b", JumpReg);

        // Test invalid instruction
        OpCode = 6'hFF; Funct = 6'hFF; #10;
        $display("Invalid Instruction: InvalidInst=%b", InvalidInst);

        $finish;
    end

endmodule
