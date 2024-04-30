`timescale 1ns / 1ps
//use 1D systolic array to do convolution, but stride=2 and padding=1
import definition::*;

module PE_ROW4(
	input clk,rstn,en,
	input [conv4_width-1:0] i_f,i_r,
	output [2*conv4_width-1:0] o_psum
    );
	logic en_d1,en_d2;
	logic [conv4_width-1:0] m1,m2;
	logic [conv4_width-1:0] next1,next2;
	logic [conv4_width-1:0] f1,r1,f_in;
	logic [2*conv4_width-1:0] psum;
	logic [2*conv4_width-1:0] mac1,mac2;
	enum logic [4:0] {S0,S1,S2,S3,S4,S5,S6} cs,ns;
	logic [4:0] cnt;
	logic [3:0][conv4_width-1:0] buffer_4;
	logic [2:0][conv4_width-1:0] buffer_3;
	logic full;
	
	//pe array
	PE_MAC #(.width(conv4_width)) u_mac1 (.*,.i_f(f_in),  .i_m(m1 ),.o_f(next1 ),o_r(),.o_mac(mac1 ));
	PE_MAC #(.width(conv4_width)) u_mac2 (.*,.i_f(next1 ),.i_m(m2 ),.o_f(next2 ),o_r(),.o_mac(mac2 ));
	
	//buffer3 store
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)begin
			buffer_3<='d0;
			full<=1'b0;
		end
		else if(!en_d2)
			buffer_3<='d0;
		else if(cnt=='d3)
			full<=1'b1;
		else begin
			buffer_3[cnt]<=f1;
			full<=1'b0;
		end
	end
	//buffer4 store
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)
			buffer_4<='d0;
		else if(!en_d2)
			buffer_4<='d0;
		else 
			buffer_4[cnt]<=r1;
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
			f1<='d0;
			r1<='d0;
			en_d1<='d0;
			en_d2<='d0;
		end
		else begin
			f1<=i_f;			
			r1<=i_r;
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
		default: ns = ns;
	  endcase
	end
	
	always_comb begin
	  case(cs)
		S0:begin
			m1<='b0;m2<='b0;
			f_in<='b0;
			psum<='b0;
		end
		S2: begin			
			m1<='b0;
			f_in<=buffer_3[0];
		end
		S3: begin			
			m1<=buffer_4[0];m2<=buffer_4[1];
			f_in<=buffer_3[1];
		end
		S4:begin			
			m1<=buffer_4[1];m2<=buffer_4[2];
			f_in<=buffer_3[2];
		end
		S5:begin
			m1<='b0;
			m2<=buffer_4[3];
			psum<=mac1;
		end
        S6:begin
			m2<='b0;
			psum<=mac2;
		end
        default:begin
				m1<='b0;m2<='b0;
				f_in<='b0;
				psum<='b0;
				end
	  endcase
	end
	//output result
	assign o_psum=psum;
				  
endmodule
