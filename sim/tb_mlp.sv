`timescale 1ns / 1ps

module tb_mlp;
	import definition::*;
	logic en;
	logic [mlp_w-1:0] data_in;
	logic [mlp_w-1:0] data_out;
	
	MLP_core#(5) u_mlp
	(
		.*
	);
	
	initial begin
		data_in <= 0;
		en<=0;
	end
	
	initial begin
        #30 data_in <='d1;
			en<=1;
		#20 data_in <='d2;
			
		#20 data_in <='d3;
			
		#20 data_in <='d4;
			en<=0;
		#20 data_in <='d5;
			
    end
	
endmodule
