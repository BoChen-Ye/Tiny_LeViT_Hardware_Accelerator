`timescale 1ns / 1ps
//use 2D systolic array to do matrix multiplication(2x2)
import definition::*;
module PE_2D(
	input clk,rstn,en,
	input [conv4_width-1:0] i_r1,i_r2,
	output [2*conv4_width-1:0] o_mat
    );
	
	logic en_d1,en_d2;
	logic [conv4_width-1:0] r1,r2;
	logic [conv4_width-1:0] m1,m2,or1,or2;
	logic [conv4_width-1:0] f1,f2,of1,of2;
	logic [2*conv4_width-1:0] mac11,mac12,mac21,mac22;
	enum logic [3:0] {S0,S1,S2,S3,S4,S5,S6,S7} cs,ns;
	logic [1:0][conv4_width-1:0] buffer0;
	logic [1:0][conv4_width-1:0] buffer1;
	logic [2:0] cnt;
	logic [2*conv4_width-1:0] psum;
	logic full;
	//2D PE array
	PE_MAC #(.width(conv4_width)) u_mac11 (.*,.i_f(f1),  .i_m(m1 ) ,.o_f(of1),.o_r(or1),.o_mac(mac11));
	PE_MAC #(.width(conv4_width)) u_mac12 (.*,.i_f(of1), .i_m(m2 ) ,.o_f()   ,.o_r(or2),.o_mac(mac12));
	PE_MAC #(.width(conv4_width)) u_mac21 (.*,.i_f(f2),  .i_m(or1) ,.o_f(of2),.o_r()   ,.o_mac(mac21));
	PE_MAC #(.width(conv4_width)) u_mac22 (.*,.i_f(of2), .i_m(or2) ,.o_f()   ,.o_r()   ,.o_mac(mac22));
	
	//buffer
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)begin
			buffer0<='d0;
			buffer1<='d0;
			full<=1'b0;
		end
		else if(!en_d2)begin
			buffer0<='d0;
			buffer1<='d0;
		end
		else begin
			buffer0[cnt]<=r1;
			buffer1[cnt]<=r2;
			full<=1'b0;
		end
	end
	//counter
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)
			cnt<='d0;
		else if(!en_d2)
			cnt<='d0;
		else if(en_d2)
			cnt<=cnt+1'd1;
		else
			cnt<=cnt;
	end
	
	//synchronizer
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)begin
			r1<='d0;
			r2<='d0;
			en_d1<='d0;
			en_d2<='d0;
		end
		else begin
			r1<=i_r1;			
			r2<=i_r2;
			en_d1<=en;
			en_d2<=en_d1;
		end	
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
		S0: begin
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
		S6 : ns = cs.next;
		S7 : ns = cs.next;
		default: ns = ns;
	  endcase
	end
	
	always_comb begin
	  case(cs)
		S0:begin
			m1<='b0;
			m2<='b0;
			f1<='b0;
			f2<='b0;
			psum<='b0;
		end
		S2: begin			
			m1<=buffer1[0];
			m2<='b0;
			f1<=buffer0[0];
			f2<='b0;
		end
		S3: begin			
			m1<=r2;
			m2<=buffer1[1];
			f1<=buffer0[1];
			f2<=r1;
		end
		S4:begin			
			m1<='b0;
			m2<=r2;
			f1<='b0;
			f2<=r1;
			psum<=mac11;
		end
		S5:begin
			f2<='b0;
			m2<='b0;
			psum<=mac12;
		end
		S6: psum<=mac21;
		S7: psum<=mac22;
        default:begin
				m1<='b0;
				m2<='b0;
				f1<='b0;
				f2<='b0;
				psum<='b0;
				end
	  endcase
	end

	assign o_mat=psum;

endmodule
