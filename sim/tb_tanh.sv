`timescale 1ns / 1ps

module tb_tanh;
	import definition::*;
	bit clk,rstn,en,end_flag;
	logic [att_width-1:0] i_tanh;
	logic [att_width-1:0] o_tanh;
    
	Tanh u_tanh(
		.*
	);

	always #10 clk <= ~clk;
	 
	initial begin
        rstn <=0;
        i_tanh <= 0;

		en<=0;
        #10 rstn <=1;
			
        #20 i_tanh <='hff940000;
			en<=1;
        #20 i_tanh <='h7c5a0000;
		#20 i_tanh <='hff940000;
		#20 i_tanh <='h7c5a0000;
		#20 i_tanh <='d0;
		#500	en<=0;
    end
endmodule
