`timescale 1ns / 1ps

import definition::*;

module FIFO
#(parameter depth=16)
(
	input clk,rstn,//时钟和复位信号
	input wr_en,rd_en,//使能信号
	input  [width-1:0]data_in,//输入数据
	output logic [width-1:0]data_out,//输出数据
	output logic empty,full//空满标志
);


logic   [width-1:0] ram[depth-1:0];//dual port　RAM
logic   [$clog2(depth):0] wr_ptr,rd_ptr;//写和读指针
logic   [$clog2(depth):0] counter;//用来判断空满

always_ff@(posedge clk or negedge rstn)
begin
	if(!rstn)
	begin
		counter<=0;
		data_out<=0;
		wr_ptr<=0;
		rd_ptr<=0;
	end
	else
	begin
		case({wr_en,rd_en})
		2'b00: counter<=counter;
		2'b01: 
        begin
			data_out<=ram[rd_ptr];//先进先出，因此读的话依旧按照次序来
		    counter<=counter-1;
		    rd_ptr<=(rd_ptr==width-1)?0:rd_ptr+1;
		end
		2'b10:
        begin
		    ram[wr_ptr]<=data_in;//写操作
		    counter<=counter+1;
		    wr_ptr<=(wr_ptr==width-1)?0:wr_ptr+1;
		end
		2'b11:
        begin
		    ram[wr_ptr]<=data_in;//读写同时进行，此时counter不增加
		    data_out<=ram[rd_ptr];
		    wr_ptr<=(wr_ptr==width-1)?0:wr_ptr+1;
		    rd_ptr<=(rd_ptr==width-1)?0:rd_ptr+1;
		end 
		endcase
	end
end

assign empty=(counter==0)?1:0;
assign full =(counter==width-1)?1:0;

endmodule




