`timescale 1ns / 1ps

module tb_avg;
	import definition::*;
	bit clk,rstn,en;
	logic [att_width-1:0] i_avg;
	logic end_avg;
	logic [att_width-1:0] o_avg;
	
	Avg_pool#(4)
	u_avg(
		.*
	);
	
	always #10 clk <= ~clk;
	
	initial begin
        rstn <=0;
        i_avg <= 0;
		en<=0;

		#10 rstn <=1;
			
	end
	
	initial begin
        #30 i_avg <='d1;
			en<=1;
		#20 i_avg <='d2;
			
		#20 i_avg <='d3;
			
		#20 i_avg <='d4;
		#20 i_avg <='d0;

		#20 en<=0;
			
    end
endmodule
