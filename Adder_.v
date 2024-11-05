
module Adder_(in1, in2, out);
	// size parameter
	parameter size = 16;
	// inputs
	input wire [size-1:0] in1, in2;
	// outputs
	output wire [size-1:0] out;
	
	// summation
	assign out = in1 + in2;

endmodule
