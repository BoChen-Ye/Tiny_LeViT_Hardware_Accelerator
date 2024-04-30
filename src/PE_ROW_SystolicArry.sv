`timescale 1ns / 1ps
//use 1D systolic array and no stride and padding.
import definition::*;

module PE_ROW_sa(
	input clk,rstn,en,
	input [conv16_width-1:0] i_f,i_r,
	output [2*conv16_width-1:0] o_psum
    );
	
	logic [conv16_width-1:0] m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14;
	logic [conv16_width-1:0] next1,next2,next3,next4,next5,next6,next7,
					next8,next9,next10,next11,next12,next13,next14;
	logic [conv16_width-1:0] f1,r1;
	logic [2*conv16_width-1:0] psum;
	logic [2*conv16_width-1:0] mac1,mac2,mac3,mac4,mac5,mac6,mac7,mac8,mac9,mac10,mac11,mac12,mac13,mac14;
	enum logic [4:0] {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17} cs,ns;
	
	//pe array
	PE_MAC #(.width(conv16_width)) u_mac1 (.*,.i_f(f1),    .i_m(m1 ),.o_f(next1 ),.o_r(),.o_mac(mac1 ));
	PE_MAC #(.width(conv16_width)) u_mac2 (.*,.i_f(next1 ),.i_m(m2 ),.o_f(next2 ),.o_r(),.o_mac(mac2 ));
	PE_MAC #(.width(conv16_width)) u_mac3 (.*,.i_f(next2 ),.i_m(m3 ),.o_f(next3 ),.o_r(),.o_mac(mac3 ));
	PE_MAC #(.width(conv16_width)) u_mac4 (.*,.i_f(next3 ),.i_m(m4 ),.o_f(next4 ),.o_r(),.o_mac(mac4 ));
	PE_MAC #(.width(conv16_width)) u_mac5 (.*,.i_f(next4 ),.i_m(m5 ),.o_f(next5 ),.o_r(),.o_mac(mac5 ));
	PE_MAC #(.width(conv16_width)) u_mac6 (.*,.i_f(next5 ),.i_m(m6 ),.o_f(next6 ),.o_r(),.o_mac(mac6 ));
	PE_MAC #(.width(conv16_width)) u_mac7 (.*,.i_f(next6 ),.i_m(m7 ),.o_f(next7 ),.o_r(),.o_mac(mac7 ));
	PE_MAC #(.width(conv16_width)) u_mac8 (.*,.i_f(next7 ),.i_m(m8 ),.o_f(next8 ),.o_r(),.o_mac(mac8 ));
	PE_MAC #(.width(conv16_width)) u_mac9 (.*,.i_f(next8 ),.i_m(m9 ),.o_f(next9 ),.o_r(),.o_mac(mac9 ));
	PE_MAC #(.width(conv16_width)) u_mac10(.*,.i_f(next9 ),.i_m(m10),.o_f(next10),.o_r(),.o_mac(mac10));
	PE_MAC #(.width(conv16_width)) u_mac11(.*,.i_f(next10),.i_m(m11),.o_f(next11),.o_r(),.o_mac(mac11));
	PE_MAC #(.width(conv16_width)) u_mac12(.*,.i_f(next11),.i_m(m12),.o_f(next12),.o_r(),.o_mac(mac12));
	PE_MAC #(.width(conv16_width)) u_mac13(.*,.i_f(next12),.i_m(m13),.o_f(next13),.o_r(),.o_mac(mac13));
	PE_MAC #(.width(conv16_width)) u_mac14(.*,.i_f(next13),.i_m(m14),.o_f(next14),.o_r(),.o_mac(mac14));            
	
	//synchronizer
	always_ff@(posedge clk, negedge rstn)begin
		if(!rstn)begin
			f1<='d0;
			r1<='d0;						
		end
		else begin
			f1<=i_f;			
			r1<=i_r;					
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
		S8 : ns = cs.next;
		S9 : ns = cs.next;
		S10: ns = cs.next;
		S11: ns = cs.next;
		S12: ns = cs.next;
		S13: ns = cs.next;
		S14: ns = cs.next;
		S15: ns = cs.next;
		S16: ns = cs.next;
		S17: ns = cs.next;
		default: ns = ns;
	  endcase
	end
	
	always_comb begin
	  case(cs)
		S0:begin
			m1<='b0;m2<='b0;m3<='b0;m4<='b0;m5<='b0;m6<='b0;m7<='b0;
			m8<='b0;m9<='b0;m10<='b0;m11<='b0;m12<='b0;m13<='b0;m14<='b0;
			psum<='b0;
		end
		S1:begin
			m1<=r1;
		end 
		S2:begin
			m1<=r1;m2<=r1;
		end 
		S3:begin
			m1<=r1;m2<=r1;m3<=r1;
		end
		S4:begin
			m1<='b0;
			m2<=r1;m3<=r1;m4<=r1;
			psum<=mac1;
		end
        S5:begin
			m2<='b0;
			m3<=r1;m4<=r1;m5<=r1;
			psum<=mac2;
		end
		S6:begin
			m3<='b0;
			m4<=r1;m5<=r1;m6<=r1;
			psum<=mac3;
		end
		S7:begin
			m4<='b0;
			m5<=r1;m6<=r1;m7<=r1;
			psum<=mac4;
		end
		S8:begin
			m5<='b0;
			m6<=r1;m7<=r1;m8<=r1;
			psum<=mac5;
		end
		S9:begin
			m6<='b0;
			m7<=r1;m8<=r1;m9<=r1;
			psum<=mac6;
		end
		S10:begin
			m7<='b0;
			m8<=r1;m9<=r1;m10<=r1;
			psum<=mac7;
		end
		S11:begin
			m8<='b0;
			m9<=r1;m10<=r1;m11<=r1;
			psum<=mac8;
		end
		S12:begin
			m9<='b0;
			m10<=r1;m11<=r1;m12<=r1;
			psum<=mac9;
		end
		S13:begin
			m10<='b0;
			m11<=r1;m12<=r1;m13<=r1;
			psum<=mac10;
		end
		S14:begin
			m11<='b0;
			m12<=r1;m13<=r1;m14<=r1;
			psum<=mac11;
		end
		S15:begin
			m12<='b0;
			m13<=r1;m14<=r1;
			psum<=mac12;
		end
		S16:begin
			m13<='b0;
			m14<=r1;
			psum<=mac13;
		end
		S17:begin
			m14<='b0;
			psum<=mac14;
		end
        default:begin
				m1<='b0;m2<='b0;m3<='b0;m4<='b0;m5<='b0;m6<='b0;m7<='b0;
				m8<='b0;m9<='b0;m10<='b0;m11<='b0;m12<='b0;m13<='b0;m14<='b0;
				end
	  endcase
	end
	//output result
	assign o_psum=psum;
				  
endmodule
