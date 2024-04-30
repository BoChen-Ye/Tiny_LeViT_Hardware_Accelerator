`timescale 1ns / 1ps

import definition::*;

module PE_MAC #(width=8)
(
	input clk,rstn,
	input [width-1:0] i_f,i_m,
	output logic [width-1:0] o_f,o_r,
	output logic [2*width-1:0] o_mac
);

logic [2*width-1:0] multi;

assign multi = i_f * i_m;

always_ff@(posedge clk or negedge rstn)begin
	if(!rstn)begin
		o_mac  <= 'b0;
		o_f  <= 'b0;
		o_r  <= 'b0;		
	end
	else begin	
		o_f <= i_f;
		o_r <= i_m;
		o_mac  <= multi + o_mac;		
	end
end

endmodule