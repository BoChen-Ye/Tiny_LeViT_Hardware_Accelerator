`timescale 1ns / 1ps
//this is a 2-head stage block, include a 2-head attention core 
//and a MLP layer with Residual connection

import definition::*;

module Stage_2head#(
	Q=1,K=2,V=3,att=4,mlp=5)
	(
	input clk,rstn,en,
	input [att_width-1:0] i_stage,
	input  [att_width-1:0] bias_1,bias_2,
	output end_s,
	output [att_width-1:0] o_stage
    );
	
	logic [att_width-1:0] att_out,mlp_out,mlp_out2;
	logic [att_width-1:0] mlp_in;
	logic end_flag;
	
	//attention core example
	Attention_2head #(Q,K,V,att,mlp) 
	u_2head(
		.*,
		.i_2head(i_stage),
		.o_2head(att_out)
	);
	// mlp core example
	MLP_core#(mlp)
	u_MLP_1(
		.en(end_flag),
		.data_in(mlp_in),
		.data_out(mlp_out)
	);
	// mlp core example
	MLP_core#(mlp)
	u_MLP_2(
		.en(end_flag),
		.data_in(mlp_out),
		.data_out(mlp_out2)
	);
	
	//Residual connection
	assign end_s=end_flag;
	assign mlp_in = end_flag?(att_out + i_stage):'d0;
	assign o_stage= mlp_out + mlp_in;
endmodule
