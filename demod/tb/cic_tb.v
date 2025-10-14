`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/11 19:58:16 
// Version:                V1.0 
// File Name:              cic_tb.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

module cic_tb ();

    parameter DATA_W = 12;
    parameter RMAX = 2;
    parameter M = 2;
    parameter N = 4;
    parameter REG_WIDTH = DATA_W + ($clog2(M) + 1) * N - 1;

    reg clk;
    reg rst_n;

    initial begin
        clk = 1'b1;
        forever #0.5 clk = ~clk;
    end
    initial begin
        rst_n = 1'b0;
        #5 rst_n = 1'b1;
    end

    initial begin
        #220 $finish;
    end

    initial begin
        // waveform dump
        $dumpfile("cic_wave.vcd");
        $dumpvars(0, cic_tb);
    end


    reg  [   DATA_W-1:0] input_tdata;
    wire [REG_WIDTH-1:0] output_tdata;
    wire [   DATA_W-1:0] output_short;
    assign output_short = output_tdata[REG_WIDTH-1-:DATA_W];
    wire output_tvalid;

    initial begin
        input_tdata = 100;
        #40 input_tdata = 2047;
        #40 input_tdata = -2048;
    end

    // wire [$clog2(RMAX+1)-1:0] rate;

    cic_interpolator #(
        .WIDTH    (DATA_W),
        .RMAX     (RMAX),
        .M        (M),
        .N        (N),
        .REG_WIDTH(REG_WIDTH)
    ) u_cic_interpolator (
        .clk          (clk),
        .rst_n        (rst_n),
        .input_tdata  (input_tdata),
        .input_tvalid (1'b1),
        .input_tready (input_tready),
        .output_tdata (output_tdata),
        .output_tvalid(output_tvalid),
        .output_tready(1'b1),
        .rate         (2'd2)
    );


endmodule
