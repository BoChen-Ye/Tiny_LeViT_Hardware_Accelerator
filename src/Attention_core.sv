`timescale 1ns / 1ps
//this is attention block of Tiny LeViT.
import definition::*;

module Attention_core#(
	conv_Q='d1,
	conv_K='d2,
	conv_V='d3,
	conv_att='d4
)
(
	input  clk,rstn,en,
	input  [att_width-1:0] i_att,
	input  [att_width-1:0] att_bias,
	output end_flag,
	output [att_width-1:0] o_att
);

	logic [HW-1:0][att_width-1:0] bias;
	logic [att_width-1:0] K;
	logic [att_width-1:0] Q;
	logic [2*att_width-1:0] i_v;
	logic [HW-1:0][att_width-1:0] V;
	logic [HW-1:0] cnt,cnt2,cnt3,i;
	logic [2*att_width-1:0] mult_KQ,mult_KQ_d1;
	logic [2*att_width-1:0] i_tanh,mul_tanh;
	logic [att_width-1:0] o_tanh;
	logic [HW-1:0][att_width-1:0] rf_tanh;
	logic [2*att_width-1:0] o_ReLU,o_tv;
	logic en_d1,en_d2;
	logic f_kq,f_tanh,f_v;
	logic en_tanh,en_v;
	
	
	//matrix multiply
	PE_2D#(att_width) 
	u_kq(
		.*,
		.i_r1(K),
		.i_r2(Q),
		.o_flag(f_kq),
		.o_mat(mult_KQ)
	);
	//tanh module
	Tanh#(HW)
	u_tanh(
		.*,
		.en(en_tanh),
		.end_flag(f_tanh)
	);
	//2D PE 
	PE_2D#(2*att_width)
	u_v(
		.*,
		.en(en_v),
		.i_r1(mul_tanh),
		.i_r2(i_v),
		.o_flag(f_v),
		.o_mat(o_tv)
	);
	//synchronizer
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)begin
			en_d1<='d0;
			en_d2<='d0;
			mult_KQ_d1<='d0;
		end
		else begin
			en_d1<=en;
			en_d2<=en_d1;
			mult_KQ_d1<=mult_KQ;
		end	
	end
	//Conv1*1, Q,K,V
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)begin
			K <= 'd0;
			Q <= 'd0;
			V <= 'd0;
			bias<='d0;
		end
		else begin
			K <= i_att * conv_K;
			Q <= i_att * conv_Q;
			V[cnt] <= i_att * conv_V;
			bias[cnt]<=att_bias;
		end
	end
	//counter for V buffer
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)
			cnt<='d0;
		else if(!en)
			cnt<='d0;
		else if(cnt=='d4)begin
			cnt<=cnt;
		end
		else if(en_d1)
			cnt<=cnt+1'd1;
		else
			cnt<=cnt;
	end
	//counter i for bias buffer
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)
			i<='d0;
		else if(!en)
			i<='d0;
		else if(i=='d4)
			i<=i;
		else if(f_kq)
			i<=i+1'd1;
		else
			i<=i;
	end
	
	//counter 2 for tanh result buffer
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)begin
			cnt2<='d0;
		end
		else if(!en)
			cnt2<='d0;
		else if(f_tanh)
			cnt2<=cnt2+1'd1;
		else
			cnt2<=cnt2;
	end
	//counter3 for pe2 input
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)
			cnt3<='d0;
		else if(!en)
			cnt3<='d0;
		else if(cnt3==HW)
			cnt3<=cnt3;
		else if(en&&en_v)
			cnt3<=cnt3+1'd1;
		else
			cnt3<=cnt3;
	end
	//
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)
			rf_tanh<='d0;
		else
			rf_tanh[cnt2]<=o_tanh;
	end
	//ReLU
	assign o_ReLU = (o_tv[2*att_width-1]==0)?o_tv:'d0;
	//output
	assign o_att = conv_att * (o_ReLU>>1);//shift in case overflow 
	assign end_flag = f_v;
	//FSM
	enum logic [3:0] {IDLE,TANH,ex1,MULTI_V} cs,ns;
	always_ff@(posedge clk, negedge rstn) begin
		if(!rstn)
			cs <= IDLE;
		else
			cs <= ns;
	end
	
	always_comb begin
	  ns = IDLE;
	  case(cs)
		IDLE: begin
			if(f_kq)
				ns = TANH;
			else
				ns = IDLE;
		end
		TANH: begin
			if(cnt2==HW)
				ns = ex1;
			else
				ns = TANH;
		end
		ex1: ns = cs.next;
		MULTI_V : begin
			if(cnt3=='d4)
				ns = IDLE;
			else
				ns = MULTI_V;
		end
		default: ns = ns;
	  endcase
	end
	
	always_comb begin
	  case(cs)
		IDLE:begin
			i_tanh<='d0;
			rf_tanh<='d0;
			i_v<='d0;
			mul_tanh<='d0;
			en_tanh<=1'b0;
			en_v<=1'b0;
		end
		TANH:begin
			en_tanh<=1'b1;
			i_tanh<=mult_KQ_d1+bias[i-1];
		end
		ex1:en_v<=1'b1;
		MULTI_V :begin
			en_tanh<=1'b0;
			mul_tanh<=rf_tanh[cnt3-1];
			i_v<=V[cnt3-1];
			
		end
		default:begin
			i_tanh<='d0;
			rf_tanh<='d0;
			i_v<='d0;
			mul_tanh<='d0;
			en_tanh<=1'b0;
			en_v<=1'b0;
		end
	  endcase
	end
endmodule