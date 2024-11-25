module ProgramCounter (clk, rst,PCEn, PCin, PCout);
	
	//inputs
	input clk, rst, PCEn;
	input [31:0] PCin;
	
	//outputs 
	output reg [31:0] PCout;
	
	//Counter logic - sync active high rst
	always@(posedge clk) begin
		if(rst) begin
			PCout <= 32'hFFFFFFFF;
		end
		//if there is an error - go to 0x0000 where exception
		else if(~PCEn) begin
			PCout <= 32'h000000FF;
		end
		else if(PCin == 32'h00000FFF)begin
			PCout <= 32'h00000000;
		end
		else begin
			PCout <= PCin;
		end
	end
	
endmodule
