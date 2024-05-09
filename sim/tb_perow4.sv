`timescale 1ns / 1ps

module tb_perow4;
	import definition::*;
	bit clk,rstn,en,end_pe;
	logic [conv4_width-1:0] i_r,i_f;
	logic [2*conv4_width-1:0] o_psum;
	PE_ROW4 u_row(
		.*
	);
	
	 always #10 clk <= ~clk;
	 
	 initial begin
        rstn <=0;
        i_r <= 0;
		i_f <= 0;

        #10 rstn <=1;
			en<=1;
        #20 i_r <= 'd1;
			i_f <='d1;
			
        #20 i_r <= 'd2;
			i_f <='d2;
			
		#20 i_r <= 'd3;
			i_f <='d3;
		
		#20 i_r <= 'd4;	
			i_f <= 'd0;
			
		#20 i_r <= 0;
			i_f <='d0;
		#20	en<=0;
			
    end
endmodule
