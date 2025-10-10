`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/05 17:03:04 
// Version:                V1.0 
// File Name:              Cordic.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

module Cordic #(
    parameter DATA_W     = 12,
    parameter DATA_DDS_W = 10,
    parameter PHASE_W    = 12,
    parameter ERROR_W    = 8
) (
    input clk,
    input rst_n,

    input signed [DATA_W-1:0] in_i,
    input signed [DATA_W-1:0] in_q,

    output signed [DATA_W-1:0] out_i,
    output signed [DATA_W-1:0] out_q,

    output signed [ERROR_W+3-1:0] phase
);

    wire [PHASE_W-1:0] phase_inc_delta;
    wire [DATA_DDS_W-1:0] sin, cos;

    DDS #(
        .DATA_W        (DATA_DDS_W),
        .PHASE_W       (PHASE_W),
        .ROM_ADDR_W    (8),
        .phase_inc_base(0)
    ) u_DDS (
        .clk            (clk),
        .rst_n          (rst_n),
        .phase_inc_delta(phase_inc_delta),
        .sin            (sin),
        .cos            (cos)
    );


    ComplexMul #(
        .DATA_A_W  (DATA_W),
        .DATA_B_W  (DATA_DDS_W),
        .DATA_OUT_W(DATA_W)
    ) u_ComplexMul (
        .clk  (clk),
        .rst_n(rst_n),

        .a_i  (in_i),
        .a_q  (in_q),
        .b_i  (cos),
        .b_q  (sin),
        .out_i(out_i),
        .out_q(out_q)
    );

    wire signed [ERROR_W-1:0] error;

    CordicError8 #(
        .DATA_W (DATA_W),
        .ADDR_W (8),
        .ERROR_W(ERROR_W)
    ) u_CordicError8 (
        .clk      (clk),
        .rst_n    (rst_n),
        .x_in     (out_i),
        .y_in     (out_q),
        .error_out(error),
        .phase_out(phase)
    );


    PID #(
        .DATA_IN_W (ERROR_W),
        .DATA_OUT_W(PHASE_W),
        .KP        (1),
        .KP_W      (6 - 4),
        .KI        (1),
        .KI_W      (12 - 4),
        .KI_W_WHOLE(14)
    ) u_PID (
        .clk     (clk),
        .rst_n   (rst_n),
        .data_in (error),
        .data_out(phase_inc_delta)
    );

endmodule
