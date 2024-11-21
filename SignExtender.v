module SignExtender(in, out);          //done

	//inputs
	input [15:0] in;
	
	//outputs
	output [31:0] out;
	
	// Unit logic
	assign out = {{16{in[15]}}, in};
	
endmodule






