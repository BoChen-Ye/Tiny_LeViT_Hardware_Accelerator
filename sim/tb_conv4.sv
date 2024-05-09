`timescale 1ns / 1ps

module tb_conv4;
	import definition::*;
	bit clk,rstn,en;
	logic [conv4_width-1:0] i_r1,i_r2,i_r3,i_r4;
	logic [conv4_width-1:0] i_f1,i_f2,i_f3;
	logic [2*conv4_width-1:0] o_sum1,o_sum2;
	logic end_conv4;
	
	Conv4_core u_conv(
		.*
	);
	
	always #10 clk <= ~clk;
	 
	initial begin
        rstn <=0;
		
        i_f1 <= 'd0;
		i_f2 <= 'd0;
		i_f3 <= 'd0;
		
		i_r1 <= 'd0;
		i_r2 <= 'd0;
		i_r3 <= 'd0;
		i_r4 <= 'd0;
		#10 rstn <=1;
			en<=1;
		
	end
	
	initial begin	
        #30 i_f1 <= 'd1;
			i_f2 <= 'd4;
			i_f3 <= 'd7;
			
        #20 i_f1 <= 'd2;
			i_f2 <= 'd5;
			i_f3 <= 'd8;
			
		#20 i_f1 <= 'd3;
			i_f2 <= 'd6;
			i_f3 <= 'd9;
			
		#20 i_f1 <= 'd0;
			i_f2 <= 'd0;
			i_f3 <= 'd0;	
	end
	initial begin		
		#30 i_r1 <= 'd1;
			i_r2 <= 'd1;
			i_r3 <= 'd1;
			i_r4 <= 'd1;

		#20 i_r1 <= 'd2;
			i_r2 <= 'd2;
			i_r3 <= 'd2;
			i_r4 <= 'd2;

		#20 i_r1 <= 'd3;
			i_r2 <= 'd3;
			i_r3 <= 'd3;
			i_r4 <= 'd3;

		#20 i_r1 <= 'd4;
			i_r2 <= 'd4;
			i_r3 <= 'd4;
			i_r4 <= 'd4;
		
		#20 i_r1 <= 'd0;
			i_r2 <= 'd0;
			i_r3 <= 'd0;
			i_r4 <= 'd0;

		#20	en<=0;
    end
endmodule
