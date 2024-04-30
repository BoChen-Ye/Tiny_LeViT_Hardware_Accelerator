`timescale 1ns / 1ps

module tb_fifo;
	import definition::*;
    logic clk, rstn;
    logic wr_en, rd_en;
    logic  full, empty;
    logic [width-1 : 0] data_in;
    logic [width-1 : 0] data_out;

    //例化
    FIFO myfifo(
        .*
    );

    initial begin
        rstn = 1;
        wr_en = 0;
        rd_en = 0;


        repeat(2) @(negedge clk);  
        rstn = 0;

        @(negedge clk);  
        rstn = 1;

        @(negedge clk);  
        data_in = {$random}%60;
        wr_en = 1;

        repeat(2) @ (negedge clk);
        data_in = {$random}%60;

        @(negedge clk);
        wr_en = 0;
        rd_en = 1;

        repeat(4) @ (negedge clk);
        rd_en = 0;
        wr_en = 1;
        data_in = {$random}%60;

        repeat(5) @ (negedge clk);
        data_in = {$random}%60;

        repeat(2) @ (negedge clk);
        wr_en = 0;
        rd_en = 1;

        repeat(2) @ (negedge clk);
        rd_en = 0;
        wr_en = 1;
        data_in = {$random}%60;

        repeat(3) @ (negedge clk);
        wr_en = 0;

        #50 $finish;
    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
endmodule
