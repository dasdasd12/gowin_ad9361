`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/05 17:09:35 
// Version:                V1.0 
// File Name:              ComplexMul.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

module ComplexMul #(
    parameter DATA_A_W = 12,
    parameter DATA_B_W = 8,

    parameter DATA_OUT_W = DATA_A_W + DATA_B_W
) (
    input clk,
    input rst_n,

    input signed [DATA_A_W-1:0] a_i,
    input signed [DATA_A_W-1:0] a_q,

    input signed [DATA_B_W-1:0] b_i,
    input signed [DATA_B_W-1:0] b_q,

    output reg signed [DATA_OUT_W-1:0] out_i,
    output reg signed [DATA_OUT_W-1:0] out_q
);
    localparam DATA_LONG_W = DATA_A_W + DATA_B_W;

    wire signed [DATA_LONG_W-1:0] out_i_l, out_q_l;

    assign out_i_l = a_i * b_i - a_q * b_q;
    assign out_q_l = a_i * b_q + a_q * b_i;

    // assign out_i   = out_i_l >> (DATA_LONG_W - DATA_OUT_W);
    // assign out_q   = out_q_l >> (DATA_LONG_W - DATA_OUT_W);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_i <= 0;
            out_q <= 0;
        end else begin
            out_i <= out_i_l >> (DATA_LONG_W - DATA_OUT_W);
            out_q <= out_q_l >> (DATA_LONG_W - DATA_OUT_W);
        end
    end

endmodule
