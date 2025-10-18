`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/16 20:57:01 
// Version:                V1.0 
// File Name:              cic_decimator_tb.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

`define FINISH_TIME 1000
`define CYCLE 1
`define CYCLE_HALF 0.5
`define WAIT_CYCLE(n) repeat(n) @(posedge clk)

module cic_decimator_tb ();
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
        $dumpfile("cic_decimator_tb_wave.vcd");
        $dumpvars(0, cic_decimator_tb);
    end

    reg signed [11:0] input_tdata;


    initial begin
        input_tdata = 12'h0;
        `WAIT_CYCLE(400);
        input_tdata = 2047;
        `WAIT_CYCLE(400);
        input_tdata = -2048;
        `WAIT_CYCLE(400);
        $finish;
    end

    parameter WIDTH = 12;
    parameter RMAX = 8;
    parameter M = 1;
    parameter N = 1;
    parameter REG_WIDTH = WIDTH + $clog2((RMAX * M)) * N;
    wire signed [REG_WIDTH-1:0] output_tdata;
    wire signed [    WIDTH-1:0] output_high = output_tdata[REG_WIDTH-1-:WIDTH];
    cic_decimator #(
        .WIDTH    (WIDTH),
        .RMAX     (RMAX),
        .M        (M),
        .N        (N),
        .REG_WIDTH(REG_WIDTH)
    ) cic_decimator_inst (
        .clk          (clk),
        .rst_n        (rst_n),
        .input_tdata  (input_tdata),
        .input_tvalid (1),
        .input_tready (input_tready),
        .output_tdata (output_tdata),
        .output_tvalid(output_tvalid),
        .output_tready(1),
        .rate         (RMAX)
    );

endmodule
