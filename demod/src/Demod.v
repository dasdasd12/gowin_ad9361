`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/05 23:17:15 
// Version:                V1.0 
// File Name:              Demod.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

module Demod #(
    parameter DATA_W = 12
) (
    input clk,
    input rst_n,

    input signed [DATA_W-1:0] in_i,
    input signed [DATA_W-1:0] in_q,

    output                 valid,
    output signed [   2:0] bit_out,
    output signed [11-1:0] phase_out
);

    // todo: add lock detect; test with worse input signal

    wire signed [DATA_W-1:0] out_i, out_q;
    wire signed [11-1:0] phase;

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


    SimpleBitSync8 #(
        .PHASE_W    (11),
        .SIG_CYCLE_N(3)
    ) u_SimpleBitSync8 (
        .clk      (clk),
        .rst_n    (rst_n),
        .phase_in (phase),
        .valid    (valid),
        .bit_out  (bit_out),
        .phase_out(phase_out)
    );

endmodule
