`timescale 1ns / 1ps

module tb_2D;
	import definition::*;
	bit clk,rstn,en;
	logic [2*conv4_width-1:0] i_r1,i_r2;
	logic [4*conv4_width-1:0] o_mat;
	
	PE_2D u_pe(
		.*
	);

	always #10 clk <= ~clk;
	 
	initial begin
        rstn <=0;
		
		i_r1 <= 'd0;
		i_r2 <= 'd0;

		#10 rstn <=1;
			en<=1;
	end

	initial begin		
		#30 i_r1 <= 'd1;
			i_r2 <= 'd3;

		#20 i_r1 <= 'd2;
			i_r2 <= 'd4;
		
		#20 i_r1 <= 'd3;
			i_r2 <= 'd5;
		
		#20 i_r1 <= 'd4;
			i_r2 <= 'd6;
		
		#20 i_r1 <= 'd0;
			i_r2 <= 'd0;
			
		#20	en<=0;
    end	
endmodule
