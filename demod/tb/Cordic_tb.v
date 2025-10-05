`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/05 19:33:59 
// Version:                V1.0 
// File Name:              Cordic_tb.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

module Cordic_tb ();
    reg clk;
    reg rst_n;

    initial begin
        clk = 1'b1;
        forever #0.5 clk = ~clk;
    end
    initial begin
        rst_n = 1'b0;
        #1 rst_n = 1'b1;
    end

    initial begin
        $dumpfile("cordic_wave.vcd");  // 指定生成的波形文件名为 "wave.vcd"
        $dumpvars(0, Cordic_tb);  // 记录所有层次的信号
    end


    parameter DATA_W = 12;
    parameter N = 5_000;

    reg signed [DATA_W*2-1:0] in_array[0:N-1];
    reg signed [DATA_W-1:0] in_i, in_q;
    wire signed [DATA_W-1:0] out_i, out_q;
    wire signed [11-1:0] phase;
    integer              i;

    initial begin
        $readmemh("./tb/tx_signal.hex", in_array);
        for (i = 0; i < N; i = i + 1) begin
            {in_i, in_q} = in_array[i];
            #1;
        end
        #10;
        $finish;
    end

    Cordic #(
        .DATA_W    (DATA_W),
        .DATA_DDS_W(10),
        .PHASE_W   (10),
        .ERROR_W   (8)
    ) u_Cordic (
        .clk  (clk),
        .rst_n(rst_n),
        .in_i (in_i),
        .in_q (in_q),
        .out_i(out_i),
        .out_q(out_q),
        .phase(phase)
    );

    wire [2:0] phase_high = phase[10:8];


endmodule
