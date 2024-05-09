`timescale 1ns / 1ps
import definition::*;

module Conv8_core(
	input clk,rstn,en,
	input [conv8_width-1:0] i_r1,i_r2,i_r3,i_r4,i_r5,i_r6,i_r7,i_r8,
	input [conv8_width-1:0] i_f1,i_f2,i_f3,          
	output end_conv8,
	output [2*conv8_width-1:0] o_sum1,o_sum2,o_sum3,o_sum4                                 
    );                                                                       
	                                            
	logic [2*conv8_width-1:0] psum1_2,psum1_4,psum1_6;
	logic [2*conv8_width-1:0] psum2_1,psum2_3,psum2_5,psum2_7;
	logic [2*conv8_width-1:0] psum3_2,psum3_4,psum3_6,psum3_8;
	logic end1,end2,end3,end4,end5,end6,end7,end8,end9,end10,end11;                                                                                          
	//pe array                                                                                
	//first row	
	PE_ROW8 u_1_2 (.*,.i_r(i_r2), .i_f(i_f1),.end_pe(end1), .o_psum(psum1_2));	
	PE_ROW8 u_1_4 (.*,.i_r(i_r4), .i_f(i_f1),.end_pe(end2), .o_psum(psum1_4));	
	PE_ROW8 u_1_6 (.*,.i_r(i_r6), .i_f(i_f1),.end_pe(end3), .o_psum(psum1_6));	
											
	//second row                            
	PE_ROW8 u_2_1 (.*,.i_r(i_r1), .i_f(i_f2),.end_pe(end4), .o_psum(psum2_1));	
	PE_ROW8 u_2_3 (.*,.i_r(i_r3), .i_f(i_f2),.end_pe(end5), .o_psum(psum2_3));	
	PE_ROW8 u_2_5 (.*,.i_r(i_r5), .i_f(i_f2),.end_pe(end6), .o_psum(psum2_5));	
	PE_ROW8 u_2_7 (.*,.i_r(i_r7), .i_f(i_f2),.end_pe(end7), .o_psum(psum2_7));	
											
	//third row                            	 
	PE_ROW8 u_3_2 (.*,.i_r(i_r2), .i_f(i_f3),.end_pe(end8), .o_psum(psum3_2));	
	PE_ROW8 u_3_4 (.*,.i_r(i_r4), .i_f(i_f3),.end_pe(end9), .o_psum(psum3_4));	
	PE_ROW8 u_3_6 (.*,.i_r(i_r6), .i_f(i_f3),.end_pe(end10), .o_psum(psum3_6));	
	PE_ROW8 u_3_8 (.*,.i_r(i_r8), .i_f(i_f3),.end_pe(end11), .o_psum(psum3_8));	
	
	//output
	assign o_sum1  = 			psum2_1  + psum3_2 ;
	assign o_sum2  = psum1_2  + psum2_3  + psum3_4 ;
	assign o_sum3  = psum1_4  + psum2_5  + psum3_6 ;
	assign o_sum4  = psum1_6  + psum2_7  + psum3_8 ;
	assign end_conv8 = end1 & end4 & end8;
endmodule           
