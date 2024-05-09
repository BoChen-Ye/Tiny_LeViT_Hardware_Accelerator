`timescale 1ns / 1ps
//this is a 2-head attention block, include 2 attention core 
//and 1 MLP layer with Residual connection

import definition::*;

module Attention_2head#(
	Q=1,K=2,V=3,att=4,mlp=5)
	(
	input clk,rstn,en,
	input [att_width-1:0] i_2head,
	input  [att_width-1:0] bias_1,bias_2,
	output end_flag,
	output [att_width-1:0] o_2head
    );
	
	logic end1,end2;
	logic [att_width-1:0] att_out_1, att_out_2;
	logic [att_width-1:0] mlp_in;
	
	//attention core example
	Attention_core #(.conv_Q(Q),.conv_K(K),
					 .conv_V(V),.conv_att(att)) 
	u_att_1(
		.*,
		.i_att(i_2head),
		.att_bias(bias_1),
		.end_flag(end1),
		.o_att(att_out_1)
	);
	
	//attention core example
	Attention_core #(.conv_Q(Q),.conv_K(K),
					 .conv_V(V),.conv_att(att)) 
	u_att_2(
		.*,
		.i_att(i_2head),
		.att_bias(bias_2),
		.end_flag(end2),
		.o_att(att_out_2)
	);
	
	assign mlp_in = att_out_1 + att_out_2;
	
	// mlp core example
	MLP_core#(mlp)
	u_MLP(
		.en(end1),
		.data_in(mlp_in),
		.data_out(o_2head)
	);
	assign end_flag = end1 & end2;
endmodule
