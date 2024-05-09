`timescale 1ns / 1ps
//this is enable module for generate en signal

import definition::*;

module Enable(
	input clk,rstn,
	input in_s,in_e,
	output o_en,o_en_d1
    );
	logic en1;
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)
			en1<=1'b0;
		else if(in_s)
			en1<=1'b1;
		else if(in_e)
			en1<=1'b0;
	end
	assign o_en = en1 | in_s;
	assign o_en_d1 = en1;
endmodule
