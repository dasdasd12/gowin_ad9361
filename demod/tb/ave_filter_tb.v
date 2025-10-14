`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/13 20:40:27 
// Version:                V1.0 
// File Name:              ave_filter_tb.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

`define FINISH_TIME 1000
`define CYCLE 1
`define CYCLE_HALF 0.5
`define WAIT_CYCLE(n) repeat(n) @(posedge clk);

module ave_filter_tb ();
    reg clk;
    reg rst_n;

    initial begin
        clk = 1'b1;
        forever #`CYCLE_HALF clk = ~clk;
    end
    initial begin
        rst_n = 1'b0;
        #2.5 rst_n = 1'b1;
    end
    initial begin
        $dumpfile("ave_filter_tb_wave.vcd");
        $dumpvars(0, ave_filter_tb);
        #`FINISH_TIME $finish;
    end

    // output declaration of module ave_filter
    parameter WIDTH = 8;
    reg  [WIDTH-1:0] data_in;
    wire [WIDTH-1:0] data_out;


    initial begin
        data_in = 0;
        #100;
        data_in = 8'd10;
        #50;
        data_in = 8'd127;
        #50;

    end

    ave_filter #(
        .LENGTH(128),
        .WIDTH (8)
    ) u_ave_filter (
        .clk     (clk),
        .rst_n   (rst_n),
        .en      (1),
        .data_in (data_in),
        .data_out(data_out)
    );


endmodule
