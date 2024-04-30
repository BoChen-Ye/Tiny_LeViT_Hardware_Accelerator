`timescale 1ns / 1ps
//this is attention block of Tiny LeViT.
import definition::*;

module Attention_core(
	input clk,rstn,en,
	input  [att_width-1:0] i_att,
	input  [att_width-1:0] att_bias,
	output [att_width-1:0] o_att
);

	logic [HW-1:0][att_width-1:0] bias;
	logic [att_width-1:0] K;
	logic [att_width-1:0] Q;
	logic [HW-1:0][att_width-1:0] V;
	logic [HW-1:0] cnt;
	logic [2*att_width-1:0] mult_KQ;
	logic o_sfm;
	//logic [HW-1:0][2*width:0] mac_KQ;
	
	//matrix multiply
	PE_2D u_kq(
		.*,
		.i_r1(K),
		.i_r2(Q),
		.o_mat(mult_KQ)
	);
	PE_2D u_v(
		.*,
		.i_r1(o_tanh),
		.i_r2(v),
		.o_mat(o_tv)
	);
	//MAC
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)
			i_tanh<='d0;
		else
			i_tanh<=mult_KQ+att_bias;
	end
	
	//Conv1*1, Q,K,V
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)begin
			K <= 'd0;
			Q <= 'd0;
			V <= 'd0;
		end
		else begin
			K <= i_att * conv_K;
			Q <= i_att * conv_Q;
			V[cnt] <= i_att * conv_V;
		end
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
	
	//softmax
	Tanh u_tanh(
		.*,
		.i_tanh()
	);
	//ReLU
	assign o_ReLU = (o_tv>'d0)?o_tv:'d0;
	//output
	assign o_att = conv_att * o_ReLU;
endmodule