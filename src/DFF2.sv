`timescale 1ns / 1ps
//this is a D Flip-flop which can delay 1 cycle of data
import definition::*;

module DFF2#(width=8)(
	input clk,rstn,
	input [width-1:0] d_in,
	output logic [width-1:0] d_out
);

	logic [width-1:0] d_d1;
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)begin
			d_out<='d0;
			d_d1<= 'd0;
		end
		else begin
			d_d1<=d_in;
			d_out<=d_d1;
		end	
	end
	
endmodule
