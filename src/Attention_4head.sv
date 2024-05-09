`timescale 1ns / 1ps
//this is a 4-head stage block, include 4 attention core 
//and 4 MLP layer with Residual connection

import definition::*;

module Attention_4head#(
	Q=1,K=2,V=3,att=4,mlp=5)
	(
	input clk,rstn,en,
	input [att_width-1:0] i_4head,
	input  [att_width-1:0] bias_1,bias_2,bias_3,bias_4,
	output end_flag,
	output [att_width-1:0] o_4head
    );
	
	logic end1,end2,end3,end4;
	logic [att_width-1:0] att_out_1, att_out_2, att_out_3, att_out_4;
	logic [att_width-1:0] mlp_in;
	
	//attention core example
	Attention_core #(.conv_Q(Q),.conv_K(K),
					 .conv_V(V),.conv_att(att)) 
	u_att_1(
		.*,
		.i_att(i_4head),
		.att_bias(bias_1),
		.end_flag(end1),
		.o_att(att_out_1)
	);
	
	//attention core example
	Attention_core #(.conv_Q(Q),.conv_K(K),
					 .conv_V(V),.conv_att(att)) 
	u_att_2(
		.*,
		.i_att(i_4head),
		.att_bias(bias_2),
		.end_flag(end2),
		.o_att(att_out_2)
	);
	
	Attention_core #(.conv_Q(Q),.conv_K(K),
					 .conv_V(V),.conv_att(att)) 
	u_att_3(
		.*,
		.i_att(i_4head),
		.att_bias(bias_3),
		.end_flag(end3),
		.o_att(att_out_3)
	);
	
	//attention core example
	Attention_core #(.conv_Q(Q),.conv_K(K),
					 .conv_V(V),.conv_att(att)) 
	u_att_4(
		.*,
		.i_att(i_4head),
		.att_bias(bias_4),
		.end_flag(end4),
		.o_att(att_out_4)
	);
	
	assign mlp_in = (att_out_1 + att_out_2 + att_out_3 + att_out_4)>>2;//shift in case overflow 
	
	// mlp core example
	MLP_core#(mlp)
	u_MLP(
		.en(end1),
		.data_in(mlp_in),
		.data_out(o_4head)
	);
	assign end_flag = end1 & end2 & end3 & end4;
endmodule
