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

    parameter WIDTH = 12;
    parameter RMAX = 2;
    parameter M = 1;
    parameter N = 3;
    parameter REG_WIDTH = WIDTH + 2;

    reg  [    WIDTH-1:0] input_tdata;
    wire [REG_WIDTH-1:0] output_tdata;
    wire [    WIDTH-1:0] output_short;
    assign output_short = output_tdata[REG_WIDTH-1-:WIDTH];
    wire output_tvalid;

    initial begin
        input_tdata = 100;
        #40 input_tdata = 2047;
        #40 input_tdata = -2048;
    end

    // wire [$clog2(RMAX+1)-1:0] rate;

    cic_interpolator #(
        .WIDTH    (WIDTH),
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
