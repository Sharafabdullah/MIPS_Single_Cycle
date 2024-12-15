module ALU (operand1, operand2, opSel, result, zero, overflow);   
    
    parameter data_width = 32;
    parameter sel_width = 4;
    
    // Inputs
    input signed [data_width - 1 : 0] operand1, operand2;
    output reg overflow;
    
    input [sel_width - 1 : 0] opSel;
    
    // Outputs
    output reg [data_width - 1 : 0] result;
    output reg zero;
    
    // Operation Parameters
    parameter   _ADD  = 4'b0000, _SUB  = 4'b0001, _AND = 4'b0010,
                _OR   = 4'b0011, _SLT  = 4'b0100, _XOR = 4'b0101,
                _NOR  = 4'b0110, _SLL  = 4'b0111, _SRL = 4'b1000,
                _SGT  = 4'b1001;    
    
    // Perform Operation
    always @ (*) begin
        overflow = 0; // Default no overflow
        case(opSel)
            _ADD: begin
                result = operand1 + operand2;
                // Detect signed overflow for addition
                overflow = (~operand1[data_width-1] & ~operand2[data_width-1] & result[data_width-1]) |
                           (operand1[data_width-1] & operand2[data_width-1] & ~result[data_width-1]);
            end
            _SUB: begin
                result = operand1 - operand2;
                // Detect signed overflow for subtraction
                overflow = (~operand1[data_width-1] & operand2[data_width-1] & result[data_width-1]) |
                           (operand1[data_width-1] & ~operand2[data_width-1] & ~result[data_width-1]);
            end
            _AND: result = operand1 & operand2;
            _OR : result = operand1 | operand2;
            _SLT: result = (operand1 < operand2) ? 1 : 0;
            _XOR: result = operand1 ^ operand2; 
            _NOR: result = ~(operand1 | operand2); // NOR operation

            _SLL: result = operand2 << $unsigned(operand1);  // SLL - shift left logical
            _SRL: result = operand2 >> $unsigned(operand1);  // SRL - shift right logical
            
            _SGT: result = (operand1 > operand2) ? 1 : 0;
            default: result = {data_width{1'b0}}; // Set to zero if no match
        endcase
    
        // Zero flag logic
        zero = (result == {data_width{1'b0}});
    
        // Zero flag logic
        zero = (result == {data_width{1'b0}});
    end

endmodule
