`timescale 1ns / 1ps
//use 1D systolic array to do convolution, but stride=2 and padding=1
import definition::*;

module PE_ROW16(
	input clk,rstn,en,
	input [conv16_width-1:0] i_f,i_r,
	output logic end_pe,
	output [2*conv16_width-1:0] o_psum
    );
	logic en_d1,en_d2;
	logic [conv16_width-1:0] m1,m2,m3,m4,m5,m6,m7,m8;
	logic [conv16_width-1:0] next1,next2,next3,next4,next5,next6,next7,next8;
	logic [conv16_width-1:0] f1,r1,f_in;
	logic [2*conv16_width-1:0] psum;
	logic [2*conv16_width-1:0] mac1,mac2,mac3,mac4,mac5,mac6,mac7,mac8;
	enum logic [3:0] {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13} cs,ns;
	logic [4:0] cnt;
	logic [15:0][conv16_width-1:0] buffer_16;
	logic [2:0][conv16_width-1:0] buffer_3;
	logic full;
	
	//pe array
	PE_MAC #(.width(conv16_width)) u_mac1 (.*,.i_f(f_in),  .i_m(m1 ),.o_f(next1 ),.o_r(),.o_mac(mac1 ));
	PE_MAC #(.width(conv16_width)) u_mac2 (.*,.i_f(next1 ),.i_m(m2 ),.o_f(next2 ),.o_r(),.o_mac(mac2 ));
	PE_MAC #(.width(conv16_width)) u_mac3 (.*,.i_f(next2 ),.i_m(m3 ),.o_f(next3 ),.o_r(),.o_mac(mac3 ));
	PE_MAC #(.width(conv16_width)) u_mac4 (.*,.i_f(next3 ),.i_m(m4 ),.o_f(next4 ),.o_r(),.o_mac(mac4 ));
	PE_MAC #(.width(conv16_width)) u_mac5 (.*,.i_f(next4 ),.i_m(m5 ),.o_f(next5 ),.o_r(),.o_mac(mac5 ));
	PE_MAC #(.width(conv16_width)) u_mac6 (.*,.i_f(next5 ),.i_m(m6 ),.o_f(next6 ),.o_r(),.o_mac(mac6 ));
	PE_MAC #(.width(conv16_width)) u_mac7 (.*,.i_f(next6 ),.i_m(m7 ),.o_f(next7 ),.o_r(),.o_mac(mac7 ));
	PE_MAC #(.width(conv16_width)) u_mac8 (.*,.i_f(next7 ),.i_m(m8 ),.o_f(next8 ),.o_r(),.o_mac(mac8 ));
	
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
			buffer_16<='d0;
		else if(!en_d2)
			buffer_16<='d0;
		else 
			buffer_16[cnt]<=r1;
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
			if(full)
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
		S10: ns = cs.next;
		S11: ns = cs.next;
		S12: ns = cs.next;
		S13: ns = cs.next;
		default: ns = ns;
	  endcase
	end
	
	always_comb begin
	  case(cs)
		S0:begin
			m1<='b0;m2<='b0;m3<='b0;m4<='b0;
			m5<='b0;m6<='b0;m7<='b0;m8<='b0;
			f_in<='b0;
			psum<='b0;
			end_pe<=1'b0;
		end
		S3: begin			
			m1<='b0;
			f_in<=buffer_3[0];
		end
		S4: begin			
			m1<=buffer_16[0];m2<=buffer_16[1];
			f_in<=buffer_3[1];
		end
		S5:begin			
			m1<=buffer_16[1];m2<=buffer_16[2];m3<=buffer_16[3];
			f_in<=buffer_3[2];
			
		end
		S6:begin
			m1<='b0;
			m2<=buffer_16[3];m3<=buffer_16[4];m4<=buffer_16[5];
			psum<=mac1;
			end_pe<=1'b1;
		end
        S7:begin
			m2<='b0;
			m3<=buffer_16[5];m4<=buffer_16[6];m5<=buffer_16[7];
			psum<=mac2;
		end
		S8:begin
			m3<='b0;
			m4<=buffer_16[7];m5<=buffer_16[8];m6<=buffer_16[9];
			psum<=mac3;
		end
		S9:begin
			m4<='b0;
			m5<=buffer_16[9];m6<=buffer_16[10];m7<=buffer_16[11];
			psum<=mac4;
		end
		S10:begin
			m5<='b0;
			m6<=buffer_16[11];m7<=buffer_16[12];m8<=buffer_16[13];
			psum<=mac5;
		end
		S11:begin
			m6<='b0;
			m7<=buffer_16[13];m8<=buffer_16[14];
			psum<=mac6;
		end
		S12:begin
			m7<='b0;
			m8<=buffer_16[15];
			psum<=mac7;
		end
		S13:begin
			m8<='b0;
			psum<=mac8;
		end
        default:begin
				m1<='b0;m2<='b0;m3<='b0;m4<='b0;
				m5<='b0;m6<='b0;m7<='b0;m8<='b0;
				f_in<='b0;
				psum<='b0;
				end_pe<=1'b0;
				end
	  endcase
	end
	//output result
	assign o_psum=psum;
				  
endmodule
