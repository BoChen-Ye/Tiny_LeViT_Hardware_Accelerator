`timescale 1ns / 1ps

package definition;
	
	parameter conv16_width=8;
	parameter conv8_width=16;
	parameter conv4_width=32;
	parameter att_width=32;
	parameter mlp_w=32;


	parameter HW=4;
	parameter   Q1=1,  Q2=2,   Q3=3   ,Q4=4 ;
	parameter   K1=2,  K2=4,   K3=4   ,K4=4 ;
	parameter   V1=3,  V2=6,   V3=6   ,V4=6 ;
	parameter att1=4,att2=8, att3=8 ,att4=8 ;
	parameter mlp1=3,mlp2=3,mlp3=3,mlp4=3;
	parameter   Q5=5 ,  Q6=5 ,  Q7=5 ,  Q8=5 ;
	parameter   K5=4 ,  K6=4 ,  K7=4 ,  K8=4 ;
	parameter   V5=6 ,  V6=6 ,  V7=6 ,  V8=6 ;
	parameter att5=8 ,att6=8 ,att7=8 ,att8=8 ;
	parameter mlp5=3,mlp6=3,mlp7=3,mlp8=3;
	
endpackage
