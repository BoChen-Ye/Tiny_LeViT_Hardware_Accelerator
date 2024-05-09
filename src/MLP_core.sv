`timescale 1ns / 1ps
//this is MLP layer which is use 1D Conv of Tiny LeViT
import definition::*;
module MLP_core#(K=3)
(	input en,
	input [mlp_w-1:0] data_in,
	output[mlp_w-1:0] data_out
    );
	
	assign data_out=en? data_in * K: 'd0;
	
endmodule
