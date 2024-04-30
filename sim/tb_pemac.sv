`timescale 1ns / 1ps

module tb_pemac;
	import definition::*;
	bit clk,rstn;
	logic [width-1:0] i_m,i_f,o_next;
	logic [2*width-1:0] o_mac;
	
	PE_MAC u_mac(
		.*	
	);
	
	 always #10 clk <= ~clk;
	 
	 initial begin
        rstn <=0;
        i_m <= 0;
		i_f <= 0;

        #10 rstn <=1;
			
        #20 i_m <='d2;
			i_f <='d1;
			
        #20 i_m <='d3;
			i_f <='d2;
			
		#20 i_m <='d4;
			i_f <='d3;
		
		#20 i_m <='d4;
			i_f <='d0;
			
		#20 i_m <='d5;
			i_f <='d0;
			
		#20 i_m <='d0;
			i_f <='d0;
			
    end
endmodule
