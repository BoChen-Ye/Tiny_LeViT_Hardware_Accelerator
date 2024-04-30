`timescale 1ns / 1ps
import definition::*;

module Conv4_core(
	input clk,rstn,en,
	input [conv4_width-1:0] i_r1,i_r2,i_r3,i_r4,
	input [conv4_width-1:0] i_f1,i_f2,i_f3,                                        
	output [2*conv4_width-1:0] o_sum1,o_sum2                                 
    );                                                                       
	                                            
	logic [2*conv4_width-1:0] psum1_2;
	logic [2*conv4_width-1:0] psum2_1,psum2_3;
	logic [2*conv4_width-1:0] psum3_2,psum3_4;
	                                                                                          
	//pe array                                                                                
	//first row	
	PE_ROW4 u_1_2 (.*,.i_r(i_r2), .i_f(i_f1), .o_psum(psum1_2));	
		
	//second row                           
	PE_ROW4 u_2_1 (.*,.i_r(i_r1), .i_f(i_f2), .o_psum(psum2_1));	
	PE_ROW4 u_2_3 (.*,.i_r(i_r3), .i_f(i_f2), .o_psum(psum2_3));	
	
	//third row                            	
	PE_ROW4 u_3_2 (.*,.i_r(i_r2), .i_f(i_f3), .o_psum(psum3_2));	
	PE_ROW4 u_3_4 (.*,.i_r(i_r4), .i_f(i_f3), .o_psum(psum3_4));	
	
	//output
	assign o_sum1  = 			psum2_1  + psum3_2 ;
	assign o_sum2  = psum1_2  + psum2_3  + psum3_4 ;
	
endmodule           
