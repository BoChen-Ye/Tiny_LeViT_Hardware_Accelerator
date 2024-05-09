`timescale 1ns / 1ps

module tb_exp;
	import definition::*;
	bit clk,rstn,en,end_flag;
	logic [2*att_width-1:0] i_exp,o_exp;
	
	Exp u_exp(
		.*
	);
	
	always #10 clk <= ~clk;
	 
	initial begin
        rstn <=0;
        i_exp <= 0;
		o_exp <= 0;
		en<=0;
        #10 rstn <=1;
			
        #20 i_exp <='d10;
			en<=1;
		#100 en<=0;
        #40 i_exp <='d20;
			en<=1;
		#100 en<=0;	
		#40 i_exp <='d30;
			en<=1;	
		#100 i_exp <='d0;
			en<=0;
    end
	
endmodule
