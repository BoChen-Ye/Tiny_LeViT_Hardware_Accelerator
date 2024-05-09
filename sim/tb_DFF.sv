`timescale 1ns / 1ps

module tb_DFF;
	import definition::*;
	bit clk,rstn;
	logic [15:0] d1,d2;
	logic [15:0] o1,o2;
	
	DFF1#(16) u_ff(
		.*,
		.d_in(d1),
		.d_out(o1)
	);
	
	DFF2#(16) u_ff2(
		.*,
		.d_in(d2),
		.d_out(o2)
	);
	
	always #10 clk <= ~clk;	
	
	initial begin
        rstn <=0;
		d1<='d0;
		d2<='d0;
		#10 rstn <=1;
	end		
			
	initial begin	
        #20 d1 <= 'd1;
			d2 <= 'd4;

			
        #20 d1 <= 'd2;
			d2 <= 'd5;
			
		#20 d1 <= 'd0;
			d2 <= 'd0;
				
	end			
endmodule
