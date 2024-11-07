module ProgramCounter (clk, rst,PCEn, PCin, PCout);
	
	//inputs
	input clk, rst, PCEn;
	input [15:0] PCin;
	
	//outputs 
	output reg [15:0] PCout;
	
	//Counter logic - sync active high rst
	always@(posedge clk) begin
		if(rst) begin
			PCout <= 16'h0000;
		end
		//if there is an error - go to 0x0000 where exception
		else if(~PCEn) begin
			PCout <= 16'h0000;
		end
		else begin
			PCout <= PCin;
		end
	end
	
endmodule
