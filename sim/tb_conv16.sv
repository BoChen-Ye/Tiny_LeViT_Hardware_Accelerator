`timescale 1ns / 1ps

module tb_conv16;
	import definition::*;
	bit clk,rstn,en;
	logic [conv16_width-1:0] i_r1,i_r2,i_r3,i_r4,i_r5,i_r6,i_r7,
					  i_r8,i_r9,i_r10,i_r11,i_r12,i_r13,i_r14,i_r15,i_r16;
	logic [conv16_width-1:0] i_f1,i_f2,i_f3;
	logic [2*conv16_width-1:0] o_sum1,o_sum2,o_sum3,o_sum4,o_sum5,o_sum6,o_sum7,o_sum8;
	logic end_conv16;
	Conv16_core u_conv(
		.*
	);
	
	always #10 clk <= ~clk;
	 
	initial begin
        rstn <=0;
		
        i_f1 <= 'd0;
		i_f2 <= 'd0;
		i_f3 <= 'd0;
		
		i_r1 <= 'd0;
		i_r2 <= 'd0;
		i_r3 <= 'd0;
		i_r4 <= 'd0;
		i_r5 <= 'd0;
		i_r6 <= 'd0;
		i_r7 <= 'd0;
		i_r8 <= 'd0;
		i_r9 <= 'd0;
		i_r10<= 'd0;
		i_r11<= 'd0;
		i_r12<= 'd0;
		i_r13<= 'd0;
		i_r14<= 'd0;
		i_r15<= 'd0;
		i_r16<= 'd0;
		#10 rstn <=1;
			en<=1;
		
	end
	
	initial begin	
        #30 i_f1 <= 'd1;
			i_f2 <= 'd4;
			i_f3 <= 'd7;
			
        #20 i_f1 <= 'd2;
			i_f2 <= 'd5;
			i_f3 <= 'd8;
			
		#20 i_f1 <= 'd3;
			i_f2 <= 'd6;
			i_f3 <= 'd9;
			
		#20 i_f1 <= 'd0;
			i_f2 <= 'd0;
			i_f3 <= 'd0;	
	end
	initial begin		
		#30 i_r1 <= 'd1;
			i_r2 <= 'd1;
			i_r3 <= 'd1;
			i_r4 <= 'd1;
			i_r5 <= 'd1;
			i_r6 <= 'd1;
			i_r7 <= 'd1;
			i_r8 <= 'd1;
			i_r9 <= 'd1;
			i_r10<= 'd1;
			i_r11<= 'd1;
			i_r12<= 'd1;
			i_r13<= 'd1;
			i_r14<= 'd1;
			i_r15<= 'd1;
			i_r16<= 'd1;
		#20 i_r1 <= 'd2;
			i_r2 <= 'd2;
			i_r3 <= 'd2;
			i_r4 <= 'd2;
			i_r5 <= 'd2;
			i_r6 <= 'd2;
			i_r7 <= 'd2;
			i_r8 <= 'd2;
			i_r9 <= 'd2;
			i_r10<= 'd2;
			i_r11<= 'd2;
			i_r12<= 'd2;
			i_r13<= 'd2;
			i_r14<= 'd2;
			i_r15<= 'd2;
			i_r16<= 'd2;
		#20 i_r1 <= 'd3;
			i_r2 <= 'd3;
			i_r3 <= 'd3;
			i_r4 <= 'd3;
			i_r5 <= 'd3;
			i_r6 <= 'd3;
			i_r7 <= 'd3;
			i_r8 <= 'd3;
			i_r9 <= 'd3;
			i_r10<= 'd3;
			i_r11<= 'd3;
			i_r12<= 'd3;
			i_r13<= 'd3;
			i_r14<= 'd3;
			i_r15<= 'd3;
			i_r16<= 'd3;
		#20 i_r1 <= 'd4;
			i_r2 <= 'd4;
			i_r3 <= 'd4;
			i_r4 <= 'd4;
			i_r5 <= 'd4;
			i_r6 <= 'd4;
		    i_r7 <= 'd4;
		    i_r8 <= 'd4;
		    i_r9 <= 'd4;
		    i_r10<= 'd4;
		    i_r11<= 'd4;
		    i_r12<= 'd4;
		    i_r13<= 'd4;
		    i_r14<= 'd4;
			i_r15<= 'd4;
			i_r16<= 'd4;
		#20 i_r1 <= 'd5;
			i_r2 <= 'd5;
			i_r3 <= 'd5;
			i_r4 <= 'd5;
			i_r5 <= 'd5;
			i_r6 <= 'd5;
		    i_r7 <= 'd5;
		    i_r8 <= 'd5;
		    i_r9 <= 'd5;
		    i_r10<= 'd5;
		    i_r11<= 'd5;
		    i_r12<= 'd5;
		    i_r13<= 'd5;
		    i_r14<= 'd5;
			i_r15<= 'd5;
			i_r16<= 'd5;
		#20 i_r1 <= 'd6;
			i_r2 <= 'd6;
			i_r3 <= 'd6;
			i_r4 <= 'd6;
			i_r5 <= 'd6;
			i_r6 <= 'd6;
		    i_r7 <= 'd6;
		    i_r8 <= 'd6;
		    i_r9 <= 'd6;
		    i_r10<= 'd6;
		    i_r11<= 'd6;
		    i_r12<= 'd6;
		    i_r13<= 'd6;
		    i_r14<= 'd6;
			i_r15<= 'd6;
			i_r16<= 'd6;
		#20 i_r1 <= 'd7;
			i_r2 <= 'd7;
			i_r3 <= 'd7;
			i_r4 <= 'd7;
			i_r5 <= 'd7;
			i_r6 <= 'd7;
		    i_r7 <= 'd7;
		    i_r8 <= 'd7;
		    i_r9 <= 'd7;
		    i_r10<= 'd7;
		    i_r11<= 'd7;
		    i_r12<= 'd7;
		    i_r13<= 'd7;
		    i_r14<= 'd7;
			i_r15<= 'd7;
			i_r16<= 'd7;
		#20 i_r1 <= 'd8;
			i_r2 <= 'd8;
			i_r3 <= 'd8;
			i_r4 <= 'd8;
			i_r5 <= 'd8;
			i_r6 <= 'd8;
		    i_r7 <= 'd8;
		    i_r8 <= 'd8;
		    i_r9 <= 'd8;
		    i_r10<= 'd8;
		    i_r11<= 'd8;
		    i_r12<= 'd8;
		    i_r13<= 'd8;
		    i_r14<= 'd8;
			i_r15<= 'd8;
			i_r16<= 'd8;
		#20 i_r1 <= 'd9;
			i_r2 <= 'd9;
			i_r3 <= 'd9;
			i_r4 <= 'd9;
			i_r5 <= 'd9;
			i_r6 <= 'd9;
		    i_r7 <= 'd9;
		    i_r8 <= 'd9;
		    i_r9 <= 'd9;
		    i_r10<= 'd9;
		    i_r11<= 'd9;
		    i_r12<= 'd9;
		    i_r13<= 'd9;
		    i_r14<= 'd9;
			i_r15<= 'd9;
			i_r16<= 'd9;
		#20 i_r1 <= 'd10;
			i_r2 <= 'd10;
			i_r3 <= 'd10;
			i_r4 <= 'd10;
			i_r5 <= 'd10;
			i_r6 <= 'd10;
		    i_r7 <= 'd10;
		    i_r8 <= 'd10;
		    i_r9 <= 'd10;
		    i_r10<= 'd10;
		    i_r11<= 'd10;
		    i_r12<= 'd10;
		    i_r13<= 'd10;
		    i_r14<= 'd10;
			i_r15<= 'd10;
			i_r16<= 'd10;
		#20 i_r1 <= 'd11;
			i_r2 <= 'd11;
			i_r3 <= 'd11;
			i_r4 <= 'd11;
			i_r5 <= 'd11;
			i_r6 <= 'd11;
		    i_r7 <= 'd11;
		    i_r8 <= 'd11;
		    i_r9 <= 'd11;
		    i_r10<= 'd11;
		    i_r11<= 'd11;
		    i_r12<= 'd11;
		    i_r13<= 'd11;
		    i_r14<= 'd11;
			i_r15<= 'd11;
			i_r16<= 'd11;
		#20 i_r1 <= 'd12;
			i_r2 <= 'd12;
			i_r3 <= 'd12;
			i_r4 <= 'd12;
			i_r5 <= 'd12;
			i_r6 <= 'd12;
		    i_r7 <= 'd12;
		    i_r8 <= 'd12;
		    i_r9 <= 'd12;
		    i_r10<= 'd12;
		    i_r11<= 'd12;
		    i_r12<= 'd12;
		    i_r13<= 'd12;
		    i_r14<= 'd12;
			i_r15<= 'd12;
			i_r16<= 'd12;
		#20 i_r1 <= 'd13;
			i_r2 <= 'd13;
			i_r3 <= 'd13;
			i_r4 <= 'd13;
			i_r5 <= 'd13;
			i_r6 <= 'd13;
		    i_r7 <= 'd13;
		    i_r8 <= 'd13;
		    i_r9 <= 'd13;
		    i_r10<= 'd13;
		    i_r11<= 'd13;
		    i_r12<= 'd13;
		    i_r13<= 'd13;
		    i_r14<= 'd13;
			i_r15<= 'd13;
			i_r16<= 'd13;
		#20 i_r1 <= 'd14;
			i_r2 <= 'd14;
			i_r3 <= 'd14;
			i_r4 <= 'd14;
			i_r5 <= 'd14;
			i_r6 <= 'd14;
		    i_r7 <= 'd14;
		    i_r8 <= 'd14;
		    i_r9 <= 'd14;
		    i_r10<= 'd14;
		    i_r11<= 'd14;
		    i_r12<= 'd14;
		    i_r13<= 'd14;
		    i_r14<= 'd14;
			i_r15<= 'd14;
			i_r16<= 'd14;
		#20 i_r1 <= 'd15;
			i_r2 <= 'd15;
			i_r3 <= 'd15;
			i_r4 <= 'd15;
			i_r5 <= 'd15;
			i_r6 <= 'd15;
		    i_r7 <= 'd15;
		    i_r8 <= 'd15;
		    i_r9 <= 'd15;
		    i_r10<= 'd15;
		    i_r11<= 'd15;
		    i_r12<= 'd15;
		    i_r13<= 'd15;
		    i_r14<= 'd15;
			i_r15<= 'd15;
			i_r16<= 'd15;
		#20 i_r1 <= 'd16;
			i_r2 <= 'd16;
			i_r3 <= 'd16;
			i_r4 <= 'd16;
			i_r5 <= 'd16;
			i_r6 <= 'd16;
		    i_r7 <= 'd16;
		    i_r8 <= 'd16;
		    i_r9 <= 'd16;
		    i_r10<= 'd16;
		    i_r11<= 'd16;
		    i_r12<= 'd16;
		    i_r13<= 'd16;
		    i_r14<= 'd16;
			i_r15<= 'd16;
			i_r16<= 'd16;
		#20 i_r1 <= 'd0;
			i_r2 <= 'd0;
			i_r3 <= 'd0;
			i_r4 <= 'd0;
			i_r5 <= 'd0;
			i_r6 <= 'd0;
		    i_r7 <= 'd0;
		    i_r8 <= 'd0;
		    i_r9 <= 'd0;
		    i_r10<= 'd0;
		    i_r11<= 'd0;
		    i_r12<= 'd0;
		    i_r13<= 'd0;
		    i_r14<= 'd0;
			i_r15<= 'd0;
			i_r16<= 'd0;
		#20	en<=0;
    end
endmodule
