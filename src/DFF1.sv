`timescale 1ns / 1ps
//this is a D Flip-flop which can delay 1 cycle of data
import definition::*;

module DFF1#(width=8)(
	input clk,rstn,
	input [width-1:0] d_in,
	output logic [width-1:0] d_out
);

	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)begin
			d_out<='d0;
		end
		else begin
			d_out<=d_in;
		end	
	end
	
endmodule