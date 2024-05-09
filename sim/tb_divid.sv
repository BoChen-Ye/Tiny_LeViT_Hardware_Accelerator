`timescale 1ns / 1ps
import definition::*;
 
module tb_divid;  
	parameter divid_up=32,divid_bo=4;
	logic [divid_up-1:0] i_up;  
	logic [divid_bo-1:0] i_bo; 
	logic en; 
	logic [divid_up-1:0] cout;  
	logic [divid_up-1:0] rem;  
	
	divider#(divid_up,4) u_dv  
	(  
		.*
		//.done(done)  
	); 

	initial  
	begin  
		en=1;
		i_up = 'd0;  
		i_bo = 'd0;
		#10 i_up = 'd25;  
			i_bo = 'd5;  
          
		#100 i_up = 'd31;  
			 i_bo = 'd3;  
          
		#100 i_up = 'd100;  
			 i_bo = 'd5;     
          
		#100 $stop;  
end  
  
 
  
endmodule
