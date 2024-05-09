`timescale 1ns / 1ps
//this is average pooling layer, but only compute 4 number
import definition::*;

module Avg_pool#(val='d4)
(
	input clk,rstn,en,
	input  [att_width-1:0] i_avg,
	output end_avg,
	output [att_width-1:0] o_avg
    );
	
	logic [2*att_width-1:0] sum,total;
	logic [2:0] cnt;

	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)
			sum<='d0;
		else
			sum<=i_avg+sum;
	end
	//counter 
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)
			cnt<='d0;
		else if(!en)
			cnt<='d0;
		else if(en)
			cnt<=cnt+1'd1;
		else
			cnt<=cnt;
	end

	assign total=(cnt==val)?sum:'d0;
	
	divider#(2*att_width,$clog2(val)+1) 
	u_div(
		.i_up(total),
		.i_bo(val),
		.en(end_avg),
		.cout(o_avg),
		.rem()
	);
	
	assign end_avg=(cnt==val)?'d1:'d0;
endmodule
