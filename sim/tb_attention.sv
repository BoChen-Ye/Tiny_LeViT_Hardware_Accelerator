`timescale 1ns / 1ps


module tb_attention;
	import definition::*;
	bit clk,rstn,en;
	logic [att_width-1:0] i_att,att_bias,o_att;
	logic end_flag;
	Attention_core#(.conv_Q(1),.conv_K('d2),.conv_V('d3),.conv_att('d4)) 
	u_att(
		.*
	);
	
	always #10 clk <= ~clk;
	
	initial begin
        rstn <=0;
        i_att <= 0;
		att_bias<=0;
		o_att <= 0;
		en<=0;

		#10 rstn <=1;
			en<=1;
	end
	
	initial begin
        #30 i_att <='d1;
			att_bias<='d4;
		#20 i_att <='d2;
			att_bias<='d5;
		#20 i_att <='d3;
			att_bias<='d6;
		#20 i_att <='d4;
			att_bias<='d7;
		#20 i_att <='d0;
			att_bias<='d0;
		#1000 en<=0;
			
    end
endmodule
