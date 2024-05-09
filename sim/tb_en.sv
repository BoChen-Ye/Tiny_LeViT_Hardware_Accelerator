`timescale 1ns / 1ps
module tb_en;
	import definition::*;
	bit clk,rstn;
	logic in_s,in_e,o_en;

	
	Enable u_en(
		.*
	);

	
	always #10 clk <= ~clk;	
	
	initial begin
        rstn <=0;
		in_s<='d0;
		in_e<='d0;
		#10 rstn <=1;
	end		
			
	initial begin	
        #20 in_s <= 'd1;
		#50 in_s <= 'd0;
        #90 in_e <= 'd1;

		#40 
			in_e <= 'd0;
				
	end			
endmodule
