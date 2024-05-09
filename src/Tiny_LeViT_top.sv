`timescale 1ns / 1ps
//this is top module of Tiny_LeViT project
//it has 3 conv core, 4 2-head stage,4 4-head stage and 1 avg pool
import definition::*;

module Tiny_LeViT_top(
	input clk,rstn,en,
	input [conv16_width-1:0] i_r1,i_r2,i_r3,i_r4,i_r5,i_r6,i_r7,i_r8,
					  i_r9,i_r10,i_r11,i_r12,i_r13,i_r14,i_r15,i_r16,
	input [conv16_width-1:0] conv16_f1,conv16_f2,conv16_f3,
	input [conv8_width-1:0] conv8_f1,conv8_f2,conv8_f3,
	input [conv4_width-1:0] conv4_f1,conv4_f2,conv4_f3,
	input [att_width-1:0] bias,
	output end_sig,
	output [att_width-1:0] result
    );
	
	logic [2*conv16_width-1:0] w_1,w_2,w_3,w_4,w_5,w_6,w_7,w_8;
	logic [2*conv8_width-1:0] w_11,w_12,w_13,w_14;
	logic [2*conv4_width-1:0] w_21,w_22;

	logic [att_width-1:0] s1_1,s1_2,s1_3,
						s1_4,s1_5,s1_6,s1_7,s1_8,avg_in;
						
	logic end_1,end_2,end_3,end_4,end_5,end_6,end_7,end_8;
	logic end_conv16,end_conv8,end_conv4,end_avg;
	
	logic en_1,en_2,en_3,en_4,en_5,en_6,en_7,en_8;
	logic en_conv8,en_conv4,en_avg;
 	
	logic [2*conv4_width-1:0] w_22_d2;
	logic [att_width-1:0] s1_1_d1,s1_2_d1,s1_3_d1,s1_4_d1,s1_5_d1,s1_6_d1,s1_7_d1;
	logic en_2_d1;

	//convolution layer
	Conv16_core u_conv16(
		.*,
		.i_f1(conv16_f1),.i_f2(conv16_f2),.i_f3(conv16_f3),
		.o_sum1(w_1),.o_sum2(w_2),.o_sum3(w_3),.o_sum4(w_4),
		.o_sum5(w_5),.o_sum6(w_6),.o_sum7(w_7),.o_sum8(w_8)
	);
	
	Conv8_core u_conv8(
		.*,
		.en(en_conv8),
		.i_f1(conv8_f1),.i_f2(conv8_f2),.i_f3(conv8_f3),
		.i_r1(w_1),.i_r2(w_2),.i_r3(w_3),.i_r4(w_4),
		.i_r5(w_5),.i_r6(w_6),.i_r7(w_7),.i_r8(w_8),
		.o_sum1(w_11),.o_sum2(w_12),.o_sum3(w_13),.o_sum4(w_14)
	);
	
	Conv4_core u_conv4(
		.*,
		.en(en_conv4),
		.i_f1(conv4_f1),.i_f2(conv4_f2),.i_f3(conv4_f3),
		.i_r1(w_11),.i_r2(w_12),.i_r3(w_13),.i_r4(w_14),
		.o_sum1(w_21),.o_sum2(w_22)
	);
	
	//  2-head stage
	Stage_2head#(Q1,K1,V1,att1,mlp1)
	u_s1(
		.*,
		.en(en_1),
		.i_stage(s1_1),
		.bias_1(bias),.bias_2(bias),
		.end_s(end_1),
		.o_stage(s1_2)
	);
	
	Stage_2head#(Q2,K2,V2,att2,mlp2)
	u_s2(
		.*,
		.en(en_2),
		.i_stage(s1_2),
		.bias_1(bias),.bias_2(bias),
		.end_s(end_2),
		.o_stage(s1_3)
	);
	
	Stage_2head#(Q3,K3,V3,att3,mlp3)
	u_s3(
		.*,
		.en(en_3),
		.i_stage(s1_3),
		.bias_1(bias),.bias_2(bias),
		.end_s(end_3),
		.o_stage(s1_4)
	);
	
	Stage_2head#(Q4,K4,V4,att4,mlp4)
	u_s4(
		.*,
		.en(en_4),
		.i_stage(s1_4),
		.bias_1(bias),.bias_2(bias),
		.end_s(end_4),
		.o_stage(s1_5)
	);
	
	//4-head stage
	Stage_4head#(Q5,K5,V5,att5,mlp5)
	u_s5(
		.*,
		.en(en_5),
		.i_stage(s1_5),
		.bias_1(bias),.bias_2(bias),.bias_3(bias),.bias_4(bias),
		.end_s(end_5),
		.o_stage(s1_6)
	);
	
	Stage_4head#(Q6,K6,V6,att6,mlp6)
	u_s6(
		.*,
		.en(en_6),
		.i_stage(s1_6),
		.bias_1(bias),.bias_2(bias),.bias_3(bias),.bias_4(bias),
		.end_s(end_6),
		.o_stage(s1_7)
	);
	
	Stage_4head#(Q7,K7,V7,att7,mlp7)
	u_s7(
		.*,
		.en(en_7),
		.i_stage(s1_7),
		.bias_1(bias),.bias_2(bias),.bias_3(bias),.bias_4(bias),
		.end_s(end_7),
		.o_stage(s1_8)
	);
	
	Stage_4head#(Q8,K8,V8,att8,mlp8)
	u_s8(
		.*,
		.en(en_8),
		.i_stage(s1_8),
		.bias_1(bias),.bias_2(bias),.bias_3(bias),.bias_4(bias),
		.end_s(end_8),
		.o_stage(avg_in)
	);
	
	// average pooling
	Avg_pool#(4) 
	u_avg(
		.*,
		.en(en_avg),
		.i_avg(avg_in),
		.end_avg(end_avg),
		.o_avg(result)
	);

	//synchronizer

	
	DFF2#(2*conv4_width) u_ff2_1(.*,.d_in(w_22),.d_out(w_22_d2));
	DFF2#(att_width) u_sff1(.*,.d_in(s1_1),.d_out(s1_1_d1));
	DFF1#(att_width) u_sff2(.*,.d_in(s1_2),.d_out(s1_2_d1));
	DFF1#(att_width) u_sff3(.*,.d_in(s1_3),.d_out(s1_3_d1));
	DFF1#(att_width) u_sff4(.*,.d_in(s1_4),.d_out(s1_4_d1));
	DFF1#(att_width) u_sff5(.*,.d_in(s1_5),.d_out(s1_5_d1));
	DFF1#(att_width) u_sff6(.*,.d_in(s1_6),.d_out(s1_6_d1));
	DFF1#(att_width) u_sff7(.*,.d_in(s1_7),.d_out(s1_7_d1));

	//enable generate
	Enable u_en_conv8(.*,.in_s(end_conv16),.in_e(end_conv8),.o_en(en_conv8),.o_en_d1());
	Enable u_en_conv4(.*,.in_s(end_conv8),.in_e(end_conv4),.o_en(en_conv4),.o_en_d1());
	Enable u_en_1(.*,.in_s(end_conv4),.in_e(end_1),.o_en(en_1),.o_en_d1());
	Enable u_en_2(.*,.in_s(end_1),.in_e(end_2),.o_en(en_2),.o_en_d1(en_2_d1));
	Enable u_en_3(.*,.in_s(end_2),.in_e(end_3),.o_en(en_3),.o_en_d1());
	Enable u_en_4(.*,.in_s(end_3),.in_e(end_4),.o_en(en_4),.o_en_d1());
	Enable u_en_5(.*,.in_s(end_4),.in_e(end_5),.o_en(en_5),.o_en_d1());
	Enable u_en_6(.*,.in_s(end_5),.in_e(end_6),.o_en(en_6),.o_en_d1());
	Enable u_en_7(.*,.in_s(end_6),.in_e(end_7),.o_en(en_7),.o_en_d1());
	Enable u_en_8(.*,.in_s(end_7),.in_e(end_8),.o_en(en_8),.o_en_d1());	
	Enable u_en_avg(.*,.in_s(end_8),.in_e(end_avg),.o_en(en_avg),.o_en_d1());
	
	
	
	//end signal
	assign s1_1 = w_21 | w_22_d2;
	assign end_sig = end_avg;
endmodule
