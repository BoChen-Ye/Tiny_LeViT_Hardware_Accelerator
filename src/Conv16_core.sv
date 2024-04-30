`timescale 1ns / 1ps
import definition::*;

module Conv16_core(
	input clk,rstn,en,
	input [conv16_width-1:0] i_r1,i_r2,i_r3,i_r4,i_r5,i_r6,i_r7,i_r8,
					  i_r9,i_r10,i_r11,i_r12,i_r13,i_r14,i_r15,i_r16,
	input [conv16_width-1:0] i_f1,i_f2,i_f3,                                        
	output [2*conv16_width-1:0] o_sum1,o_sum2,o_sum3,o_sum4,o_sum5,o_sum6,o_sum7,o_sum8                                 
    );                                                                       
	                                            
	logic [2*conv16_width-1:0] psum1_2,psum1_4,psum1_6,psum1_8,psum1_10,psum1_12,psum1_14;
	logic [2*conv16_width-1:0] psum2_1,psum2_3,psum2_5,psum2_7,psum2_9,psum2_11,psum2_13,psum2_15;
	logic [2*conv16_width-1:0] psum3_2,psum3_4,psum3_6,psum3_8,psum3_10,psum3_12,psum3_14,psum3_16;
	                                                                                          
	//pe array                                                                                
	//first row	
	PE_ROW16 u_1_2 (.*,.i_r(i_r2), .i_f(i_f1), .o_psum(psum1_2));	
	PE_ROW16 u_1_4 (.*,.i_r(i_r4), .i_f(i_f1), .o_psum(psum1_4));	
	PE_ROW16 u_1_6 (.*,.i_r(i_r6), .i_f(i_f1), .o_psum(psum1_6));	
	PE_ROW16 u_1_8 (.*,.i_r(i_r8), .i_f(i_f1), .o_psum(psum1_8));	
	PE_ROW16 u_1_10(.*,.i_r(i_r10),.i_f(i_f1), .o_psum(psum1_10));	
	PE_ROW16 u_1_12(.*,.i_r(i_r12),.i_f(i_f1), .o_psum(psum1_12));	
	PE_ROW16 u_1_14(.*,.i_r(i_r14),.i_f(i_f1), .o_psum(psum1_14));
	
	//second row                           
	PE_ROW16 u_2_1 (.*,.i_r(i_r1), .i_f(i_f2), .o_psum(psum2_1));	
	PE_ROW16 u_2_3 (.*,.i_r(i_r3), .i_f(i_f2), .o_psum(psum2_3));	
	PE_ROW16 u_2_5 (.*,.i_r(i_r5), .i_f(i_f2), .o_psum(psum2_5));	
	PE_ROW16 u_2_7 (.*,.i_r(i_r7), .i_f(i_f2), .o_psum(psum2_7));	
	PE_ROW16 u_2_9 (.*,.i_r(i_r9), .i_f(i_f2), .o_psum(psum2_9));	
	PE_ROW16 u_2_11(.*,.i_r(i_r11),.i_f(i_f2), .o_psum(psum2_11));	
	PE_ROW16 u_2_13(.*,.i_r(i_r13),.i_f(i_f2), .o_psum(psum2_13));
	PE_ROW16 u_2_15(.*,.i_r(i_r15),.i_f(i_f2), .o_psum(psum2_15));
	
	//third row                            	
	PE_ROW16 u_3_2 (.*,.i_r(i_r2), .i_f(i_f3), .o_psum(psum3_2));	
	PE_ROW16 u_3_4 (.*,.i_r(i_r4), .i_f(i_f3), .o_psum(psum3_4));	
	PE_ROW16 u_3_6 (.*,.i_r(i_r6), .i_f(i_f3), .o_psum(psum3_6));	
	PE_ROW16 u_3_8 (.*,.i_r(i_r8), .i_f(i_f3), .o_psum(psum3_8));	
	PE_ROW16 u_3_10(.*,.i_r(i_r10),.i_f(i_f3), .o_psum(psum3_10));	
	PE_ROW16 u_3_12(.*,.i_r(i_r12),.i_f(i_f3), .o_psum(psum3_12));	
	PE_ROW16 u_3_14(.*,.i_r(i_r14),.i_f(i_f3), .o_psum(psum3_14));
	PE_ROW16 u_3_16(.*,.i_r(i_r16),.i_f(i_f3), .o_psum(psum3_16));
	
	//output
	assign o_sum1  = 			psum2_1  + psum3_2 ;
	assign o_sum2  = psum1_2  + psum2_3  + psum3_4 ;
	assign o_sum3  = psum1_4  + psum2_5  + psum3_6 ;
	assign o_sum4  = psum1_6  + psum2_7  + psum3_8 ;
	assign o_sum5  = psum1_8  + psum2_9  + psum3_10;
	assign o_sum6  = psum1_10 + psum2_11 + psum3_12;
	assign o_sum7  = psum1_12 + psum2_13 + psum3_14;
	assign o_sum8  = psum1_14 + psum2_15 + psum3_16;
	
endmodule           
