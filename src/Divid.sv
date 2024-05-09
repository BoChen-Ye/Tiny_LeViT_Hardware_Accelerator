`timescale 1ns / 1ps
//combinational divide function
import definition::*;

module divider#(divid_up=16,divid_bo=4)(
    //input clk,rstn,
    input [divid_up-1:0] i_up,
    input [divid_bo-1:0] i_bo,
	input en,
    output reg [divid_up-1:0] cout,
    output reg [divid_up-1:0] rem
);
 
    integer i;
    reg [divid_up-1:0] 	 up_reg;
    reg [2*divid_bo-1:0] bo_reg;
    reg [2*divid_up-1:0] tmp_up;
    reg [2*divid_up-1:0] tmp_bo;
	reg [divid_up-1:0] 	 zero_reg;
 
    always_comb begin
        up_reg = en?i_up:'d0;
        bo_reg = en?i_bo:'d0;
		zero_reg ='d0;
    end
 
    always_comb begin
        tmp_up = {zero_reg, up_reg};
        tmp_bo = {bo_reg, zero_reg};
		if(up_reg=='d0&&bo_reg=='d0)
			tmp_up<='d0;
		else if(up_reg<=bo_reg)
			tmp_up<='d1;
		else begin
			for(i=0;i<divid_up;i=i+1)
                tmp_up = tmp_up << 1;
                if(tmp_up >= tmp_bo)
            	    tmp_up = tmp_up - tmp_bo +1;
                else
            	    tmp_up = tmp_up;
		end
    end
 
    assign cout = tmp_up[divid_up-1:0];
    assign rem  = tmp_up[2*divid_up-1:divid_up];

 
endmodule
