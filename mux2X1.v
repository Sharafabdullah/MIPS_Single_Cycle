module mux2X1 #(parameter size = 32) (in1, in2, s, out);             //19-11  found a syntax error with the name it was - mux2x1 - 

	// inputs	
	input s;
	input [size-1:0] in1, in2;
	
	// outputs
	output [size-1:0] out;

	// Unit logic
	assign out = (~s) ? in1 : in2;
	
endmodule