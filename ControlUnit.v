module controlUnit(OpCode,
                   Funct,
                   RegDst,
                   BranchEq,
                   BranchNeq,
                   InvalidInst,
                   Jump,
                   JumpReg,
                   MemRdEn,
                   MemtoReg,
                   ALUOp,
                   MemWrEn,
                   RegWrEn,
                   ALUSrc1,
                   ALUSrc2);
    
    
    // inputs
    input wire [5:0] OpCode, Funct;
    
    // outputs (signals)
    output reg RegDst, BranchEq,BranchNeq,InvalidInst,Jump,JumpReg, MemRdEn, MemtoReg, MemWrEn, RegWrEn, ALUSrc2, ALUSrc1;

    output reg [3:0] ALUOp; //changed to 4
    
    //! parameters (OpCodes/Functs) added opcodes and funct
    parameter _RType = 6'h0, _addi = 6'h8, _ori = 6'h0D, _xori = 6'h0E,_andi = 6'h0C,
    _slti = 6'h0A, _lw = 6'h23, _sw = 6'h2b,
    _beq = 6'h4,_bnq = 6'h5, _j = 6'h02, _jr = 6'h8, _jal = 6'h3;
    
    parameter _add_ = 6'h20, _sub_ = 6'h22, _and_ = 6'h24, _or_ = 6'h25, _slt_ = 6'h2a,_sgt_ = 6'h29, _xor_ = 6'h26, _nor_ = 6'h27, _sll_ = 6'h00, _srl_ = 6'h02;
    
    
    // unit logic - generate signals
    always @(*) begin
        
        RegDst  = 1'b0; BranchEq  = 1'b0; BranchNeq = 1'b0; MemRdEn  = 1'b0; MemtoReg  = 1'b0; Jump = 1'b0; JumpReg = 1'b0;
        
        MemWrEn = 1'b0; RegWrEn = 1'b0;ALUSrc1 = 1'b0; ALUSrc2 = 1'b0;
        ALUOp   = 4'b1111;
        
        case(OpCode)
            
            _RType : begin
                
                RegDst   = 1'b1;
                BranchEq   = 1'b0;
                BranchNeq   = 1'b0;
                MemRdEn  = 1'b0;
                MemtoReg = 1'b0;
                MemWrEn  = 1'b0;
                RegWrEn  = 1'b1;
                ALUSrc1 = 1'b0;
                ALUSrc2   = 1'b0;
                Z
                case (Funct)
                    
                    _add_ : begin
                        ALUOp = 4'b0000;
                    end
                    
                    _sub_ : begin
                        ALUOp = 4'b0001;
                    end
                    
                    _and_ : begin
                        ALUOp = 4'b0010;
                    end
                    
                    _or_ : begin
                        ALUOp = 4'b0011; //was d
                    end
                    
                    _slt_ : begin
                        ALUOp = 4'b0100;
                    end
                    _sgt_ : begin
                        ALUOp = 4'b1001; //! Notice that It is 1001
                    end
                    
                    //! Added R_type
                    _xor_ : begin
                        ALUOp = 4'b0101;
                    end
                    
                    _nor_ : begin
                        ALUOp = 4'b0110;
                    end
                    
                    _sll_ : begin
                        ALUSrc1 = 1'b1;
                        ALUOp = 4'b0111;
                    end
                    
                    _srl_ : begin
                        ALUSrc1 = 1'b1;
                        ALUOp = 4'b1000;
                    end
                    
                    default: begin
                    ALUOp = 4'b1111;
                    InvalidInst = 1'b1;
                    end
                    
                endcase
            end
            
            _addi : begin
                RegDst   = 1'b0;
                BranchEq   = 1'b0;
                MemRdEn  = 1'b0;
                MemtoReg = 1'b0;
                ALUOp    = 4'b0000;
                MemWrEn  = 1'b0;
                RegWrEn  = 1'b1;
                ALUSrc2   = 1'b1;
            end
            //! Some Added immediates
            _ori : begin
                RegDst   = 1'b0; //0 -> rt
                BranchEq   = 1'b0;
                MemRdEn  = 1'b0;
                MemtoReg = 1'b0;
                ALUOp    = 4'b0011;
                MemWrEn  = 1'b0;
                RegWrEn  = 1'b1;
                ALUSrc2   = 1'b1;
            end
            _xori : begin
                RegDst   = 1'b0;
                BranchEq   = 1'b0;
                MemRdEn  = 1'b0;
                MemtoReg = 1'b0;
                ALUOp    = 4'b0101;
                MemWrEn  = 1'b0;
                RegWrEn  = 1'b1;
                ALUSrc2   = 1'b1;
            end

            _andi : begin
                RegDst   = 1'b0;
                BranchEq   = 1'b0;
                MemRdEn  = 1'b0;
                MemtoReg = 1'b0;
                ALUOp    = 4'b0010;
                MemWrEn  = 1'b0;
                RegWrEn  = 1'b1;
                ALUSrc2   = 1'b1;
            end

            _slti : begin
                RegDst   = 1'b0; 
                BranchEq   = 1'b0;
                MemRdEn  = 1'b0;
                MemtoReg = 1'b0;
                ALUOp    = 4'b0100; //same as slt
                MemWrEn  = 1'b0;
                RegWrEn  = 1'b1;
                ALUSrc2   = 1'b1;
            end
            
            _lw : begin
                RegDst   = 1'b0;//Changed from 1 to zero
                BranchEq   = 1'b0;
                MemRdEn  = 1'b1;//Changed from 0 to 1
                MemtoReg = 1'b1;
                ALUOp    = 4'b0000;
                MemWrEn  = 1'b0;//changed from 1 to 0
                RegWrEn  = 1'b1;
                ALUSrc2   = 1'b1;
            end
            
            _sw : begin
                RegDst  = 1'b0;
                BranchEq  = 1'b0;
                MemRdEn = 1'b0;
                ALUOp   = 4'b0000;
                MemWrEn = 1'b1;
                RegWrEn = 1'b0;
                ALUSrc2  = 1'b1;
            end
            
            _beq : begin
                BranchEq  = 1'b1;
                MemRdEn = 1'b0;
                ALUOp   = 4'b0001;//subtract
                MemWrEn = 1'b0;
                RegWrEn = 1'b0;
                ALUSrc2  = 1'b0; //zero not one
            end

            _bnq : begin
                BranchNeq  = 1'b1;
                MemRdEn = 1'b0;
                ALUOp   = 4'b0001;//subtract
                MemWrEn = 1'b0;
                RegWrEn = 1'b0;
                ALUSrc2  = 1'b0; //zero not one
            end
            _j : begin
                MemRdEn = 1'b0;
                ALUOp   = 4'b1111;
                Jump = 1'b1;
                MemWrEn = 1'b0;
                RegWrEn = 1'b0;
                ALUSrc2  = 1'b0; 
            end
            _jr : begin
                MemRdEn = 1'b0;
                ALUOp   = 4'b1111;
                Jump = 1'b0; //! 
                JumpReg = 1'b1; //! This will be used to set PCsrc = 'b11
                MemWrEn = 1'b0;
                RegWrEn = 1'b0;
                ALUSrc2  = 1'b0; 
            end
            _jal : begin
                MemRdEn = 1'b0;
                ALUOp   = 4'b1111;
                Jump = 1'b1;
                MemWrEn = 1'b0;
                RegWrEn = 1'b1; //to save $ra
                ALUSrc2  = 1'b0; 
            end
            
            
            default: begin
                InvalidInst = 1'b1;
                BranchEq = 1'b0;
                BranchNeq= 1'b0;
            end
            
        endcase
        
    end
    
    
endmodule
