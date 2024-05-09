`timescale 1ns / 1ps

module tb_2head;
	import definition::*;
	bit clk,rstn,en;
	logic [att_width-1:0] i_2head;
	logic [att_width-1:0] bias_1,bias_2;
	logic end_flag;
	logic [att_width-1:0] o_2head;
	
	Attention_2head#(1,2,3,4,5)
	u_2head(
		.*
	);
		
	always #10 clk <= ~clk;
	
	initial begin
        rstn <=0;
        i_2head <= 0;
		bias_1<=0;
		bias_2<=0;
		en<=0;

		#10 rstn <=1;
			en<=1;
	end
	
	initial begin
        #30 i_2head <='d1;
			bias_1<='d4;
			bias_2<='d4;
		#20 i_2head <='d2;
			bias_1<='d5;
			bias_2<='d5;
		#20 i_2head <='d3;
			bias_1<='d6;
			bias_2<='d6;
		#20 i_2head <='d4;
			bias_1<='d7;
			bias_2<='d7;
		#20 i_2head <='d0;
			bias_1<='d0;
			bias_2<='d0;
		#1000 en<=0;
			
    end
endmodule
