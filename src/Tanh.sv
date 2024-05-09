`timescale 1ns / 1ps
//tanh=e^x-e^-x/e^x+e^-x
import definition::*;

module Tanh#(depth=4)(
	input clk,rstn,en,
	input [2*att_width-1:0] i_tanh,
	output end_flag,
	output [att_width-1:0] o_tanh
    );
	
	logic end1,end2;
	logic [2*att_width-1:0] i_exp;
	logic [2*att_width-1:0] exp_pos,exp_neg;
	logic [2*att_width-1:0] r_add,r_sub;
	logic [2*att_width-1:0] o_div,n_in;
	logic [depth-1:0][2*att_width-1:0] buffer;
	logic [2:0] cnt,i;
	logic full;
	logic en_d1,en_d2;
	logic pos_edg;
	//synchronizer
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)begin
			en_d1<='d0;
			en_d2<='d0;
		end
		else begin
			en_d1<=en;
			en_d2<=en_d1;
		end	
	end
	assign pos_edg= ~en_d2 & en_d1;
	//cnt
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)
			cnt<='d0;
		else if(!en)
			cnt<='d0;
		else if(cnt==depth)begin
			cnt<=cnt;
		end
		else if(en)
			cnt<=cnt+1'd1;
		else
			cnt<=cnt;
	end
	assign full=(cnt==depth)?1'b1:1'b0;
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)
			i<='d0;
		else if(!en)
			i<='d0;
		else if(end_flag)
			i<=i+1'd1;
		else
			i<=i;
	end
	//buffer
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)begin
			buffer<='d0;
		end
		else begin
			buffer[cnt]<=i_tanh;
		end
	end
	//exp fuction
	assign n_in={~i_exp[2*att_width-1],~i_exp[2*att_width-2:0]+1'b1};
	Exp u_pos(
		.*,
		.i_exp(i_exp),
		.end_flag(end1),
		.o_exp(exp_pos)
    );
	Exp u_neg(
		.*,
		.i_exp(n_in),
		.end_flag(end2),
		.o_exp(exp_neg)
    );
	
	assign r_add = exp_pos + exp_neg;
	assign r_sub = exp_pos - exp_neg;
	
	divider#(2*att_width,2*att_width) 
	u_div(
		.i_up(r_sub),
		.i_bo(r_add),
		.en(en),
		.cout(o_div),
		.rem()
	);
	
	assign o_tanh=o_div[att_width-1:0];
	assign end_flag=end1&end2;
	
	//FSM
	enum logic [2:0] {S0,S1,S2} cs,ns;
	always_ff@(posedge clk, negedge rstn) begin
		if(!rstn)
			cs <= S0;
		else
			cs <= ns;
	end
	always_comb begin
	  ns = S0;
	  case(cs)
		S0: begin
			if(end1)
				ns = S1;
			else if(i>=depth)
				ns = S2;
			else
				ns = S0;
			end
		S1 : begin
			if(i>=depth)
				ns = S2;
			else
				ns = S0;
			end
		S2 :begin
			if(en)
				ns = S0;
			else
				ns = S2;
			end
		default: ns = ns;
	  endcase
	end
	
	always_comb begin
	  case(cs)
		S0: begin
			if(pos_edg)
				i_exp<=buffer[0];
			else
				i_exp<=i_exp;
		end
		S1: i_exp<=buffer[i];
		S2: i_exp<='d0;
		default: i_exp<='d0;
	  endcase
	end
	
endmodule
