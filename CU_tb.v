`timescale 1ns / 1ps

module CU_tb;
    // Inputs
    reg [5:0] OpCode, Funct;

    // Outputs
    wire RegDst, BranchEq, BranchNeq, InvalidInst, Jump, JumpReg;
    wire MemRdEn, MemtoReg, MemWrEn, RegWrEn, ALUSrc1, ALUSrc2;
    wire [3:0] ALUOp;

    // Instantiate the Control Unit
    ControlUnit dut (   
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

    // Test Procedure
    initial begin
        // Display Header
        $display("Time\tOpCode\tFunct\tRegDst\tALUOp\tMemRdEn\tMemWrEn\tBranchEq\tJump\tJumpReg\tInvalidInst");
        $monitor("%0t\t%h\t%h\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", 
                 $time, OpCode, Funct, RegDst, ALUOp, MemRdEn, MemWrEn, BranchEq, Jump, JumpReg, InvalidInst);

        // Initialize Inputs
        OpCode = 6'b000000; Funct = 6'b000000;

        // R-type Instructions
        OpCode = 6'h00; Funct = 6'h20; #10; // add
        OpCode = 6'h00; Funct = 6'h22; #10; // sub
        OpCode = 6'h00; Funct = 6'h24; #10; // and
        OpCode = 6'h00; Funct = 6'h25; #10; // or
        OpCode = 6'h00; Funct = 6'h2a; #10; // slt
        OpCode = 6'h00; Funct = 6'h00; #10; // sll
        OpCode = 6'h00; Funct = 6'h08; #10; // jr

        // I-type Instructions
        OpCode = 6'h08; Funct = 6'bxxxxxx; #10; // addi
        OpCode = 6'h0C; Funct = 6'bxxxxxx; #10; // andi
        OpCode = 6'h0D; Funct = 6'bxxxxxx; #10; // ori
        OpCode = 6'h0E; Funct = 6'bxxxxxx; #10; // xori
        OpCode = 6'h0A; Funct = 6'bxxxxxx; #10; // slti
        OpCode = 6'h23; Funct = 6'bxxxxxx; #10; // lw
        OpCode = 6'h2B; Funct = 6'bxxxxxx; #10; // sw
        OpCode = 6'h04; Funct = 6'bxxxxxx; #10; // beq
        OpCode = 6'h05; Funct = 6'bxxxxxx; #10; // bne

        // J-type Instructions
        OpCode = 6'h02; Funct = 6'bxxxxxx; #10; // j
        OpCode = 6'h03; Funct = 6'bxxxxxx; #10; // jal

        // Invalid Instruction
        OpCode = 6'h3F; Funct = 6'bxxxxxx; #10; // Invalid

        // Finish simulation
        $finish;
    end
endmodule
