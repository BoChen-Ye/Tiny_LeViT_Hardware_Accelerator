`timescale 1ns / 1ps
//use 1D systolic array to do convolution, but stride=2 and padding=1
import definition::*;

module PE_ROW8(
	input clk,rstn,en,
	input [conv8_width-1:0] i_f,i_r,
	output [2*conv8_width-1:0] o_psum
    );
	logic en_d1,en_d2;
	logic [conv8_width-1:0] m1,m2,m3,m4;
	logic [conv8_width-1:0] next1,next2,next3,next4;
	logic [conv8_width-1:0] f1,r1,f_in;
	logic [2*conv8_width-1:0] psum;
	logic [2*conv8_width-1:0] mac1,mac2,mac3,mac4;
	enum logic [4:0] {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9} cs,ns;
	logic [4:0] cnt;
	logic [7:0][conv8_width-1:0] buffer_8;
	logic [2:0][conv8_width-1:0] buffer_3;
	logic full;
	
	//pe array
	PE_MAC #(.width(conv8_width)) u_mac1 (.*,.i_f(f_in)  ,.i_m(m1 ),.o_f(next1 ),o_r(),.o_mac(mac1 ));
	PE_MAC #(.width(conv8_width)) u_mac2 (.*,.i_f(next1 ),.i_m(m2 ),.o_f(next2 ),o_r(),.o_mac(mac2 ));
	PE_MAC #(.width(conv8_width)) u_mac3 (.*,.i_f(next2 ),.i_m(m3 ),.o_f(next3 ),o_r(),.o_mac(mac3 ));
	PE_MAC #(.width(conv8_width)) u_mac4 (.*,.i_f(next3 ),.i_m(m4 ),.o_f(next4 ),o_r(),.o_mac(mac4 ));
	
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
	//buffer16 store
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)
			buffer_8<='d0;
		else if(!en_d2)
			buffer_8<='d0;
		else 
			buffer_8[cnt]<=r1;
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
			if(en_d2)
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
		S8 : ns = cs.next;
		S9 : ns = cs.next;
		default: ns = ns;
	  endcase
	end
	
	always_comb begin
	  case(cs)
		S0:begin
			m1<='b0;m2<='b0;m3<='b0;m4<='b0;
			f_in<='b0;
			psum<='b0;
		end
		S3: begin			
			m1<='b0;
			f_in<=buffer_3[0];
		end
		S4: begin			
			m1<=buffer_8[0];m2<=buffer_8[1];
			f_in<=buffer_3[1];
		end
		S5:begin			
			m1<=buffer_8[1];m2<=buffer_8[2];m3<=buffer_8[3];
			f_in<=buffer_3[2];
		end
		S6:begin
			m1<='b0;
			m2<=buffer_8[3];m3<=buffer_8[4];m4<=buffer_8[5];
			psum<=mac1;
		end
        S7:begin
			m2<='b0;
			m3<=buffer_8[5];m4<=buffer_8[6];
			psum<=mac2;
		end
		S8:begin
			m3<='b0;
			m4<=buffer_8[7];
			psum<=mac3;
		end
		S9:begin
			m4<='b0;
			psum<=mac4;
		end
        default:begin
				m1<='b0;m2<='b0;m3<='b0;m4<='b0;
				f_in<='b0;
				psum<='b0;
				end
	  endcase
	end
	//output result
	assign o_psum=psum;
				  
endmodule
