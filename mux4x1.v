module mux4x1 #(parameter size = 32) (in1, in2,in3,in4, s, out);    

	// inputs	
	input [1:0] s;
	input [size-1:0] in1, in2, in3, in4;
	
	// outputs
	output [size-1:0] out;

	// Unit logic
	assign out = (~s[1]) ? (~s[0] ? in1:in2) : (~s[0] ? in3:in4);
	
endmodule