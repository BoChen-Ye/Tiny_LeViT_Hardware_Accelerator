`timescale 1ns / 1ps
//This is exponential module for Tanh/Softmax activation function
import definition::*;

module Exp(
	input clk,rstn,en,
	input [2*att_width-1:0] i_exp,
	output logic end_flag,
	output [2*att_width-1:0] o_exp
    );
	
	logic [2*att_width-1:0] r_out,r_exp;
	logic [3:0] mux;
	logic [2*att_width-1:0] o_div,w_adder;
	enum logic [3:0] {S0,S1,S2,S3,S4,S5} cs,ns;
	
	divider#(2*att_width,4) 
	u_div(
		.i_up(r_out),
		.i_bo(mux),
		.en(en),
		.cout(o_div),
		.rem()
	);
	always_ff@(posedge clk, negedge rstn) begin
		if(!rstn)
			w_adder<='d0;
		else if(en)	
			w_adder = o_div + 1'd1;
		else
			w_adder<='d0;
	end
	always_ff@(posedge clk, negedge rstn) begin
		if(!rstn)
			end_flag<='d0;
		else if(cs==S4)	
			end_flag = 1'd1;
		else
			end_flag<='d0;
	end
	//FSM
	always_ff@(posedge clk, negedge rstn) begin
		if(!rstn)
			cs <= S0;
		else
			cs <= ns;
	end
	
	always_comb begin
	  ns = S0;
	  case(cs)
		S0 : begin
			if(en)
				ns = S1;
			else
				ns = S0;
			end
		S1 : ns = cs.next;
		S2 : ns = cs.next;
		S3 : ns = cs.next;
		S4 : ns = cs.next;
		S5 : ns = cs.next;
		default: ns = ns;
	  endcase
	end
	
	always_comb begin
	  case(cs)
		S0:begin
			r_out  <= 'd0;
			r_exp  <=  'd0;
			mux    <= 4'd0;
			//end_flag<=1'd0;
		end
		S1:begin
			r_out  <= i_exp;
			mux    <= 4'd2;
		end
		S2:begin
			r_out  <= w_adder;
			mux    <= 4'd3;
		end
		S3:begin
			r_out  <= w_adder;
			mux    <= 4'd4;
		end
		S4:begin
			r_out  <= w_adder;
			mux    <= 4'd1;
			//end_flag<=1'd1;
		end
		S5: begin
			r_exp  <= w_adder;
			mux    <= 4'd0;
			r_out  <= 'd0;
			//end_flag<=1'd0;
		end
		default:begin
			r_out  <=  'd0;
			mux    <= 4'd0;
			r_exp  <=  'd0;
			//end_flag<=1'd0;
		end
	  endcase
	end
	
	assign o_exp = r_exp;
endmodule
