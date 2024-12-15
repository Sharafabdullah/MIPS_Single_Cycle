module ProgramCounter (clk, rst, PCin, PCout);
	
	//inputs
	input clk, rst;
	input [31:0] PCin;
	
	//outputs 
	output reg [31:0] PCout;
	
	//Counter logic - sync active high rst
	always@(posedge clk) begin
		if(rst) begin
			PCout <= 32'hffffffff;
		end
		else begin
			PCout <= PCin;
		end
	end
	
endmodule
