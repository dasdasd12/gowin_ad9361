`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/04 16:04:37 
// Version:                V1.0 
// File Name:              PID.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

module PID #(
    parameter DATA_IN_W  = 12,
    parameter DATA_OUT_W = 12,
    parameter KP         = 1,
    parameter KP_W       = 8,
    parameter KI         = 1,
    parameter KI_W       = 8
) (
    input clk,
    input rst_n,

    input signed [DATA_IN_W-1:0] data_in,

    output reg signed [DATA_OUT_W-1:0] data_out
);

    reg signed  [KI_W+DATA_OUT_W-1:0] data_in_int;

    wire signed [KP_W+DATA_OUT_W-1:0] kp_long = data_in * KP;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_int <= 0;
            data_out    <= 0;
        end else begin
            data_in_int <= data_in_int + data_in * KI;
            data_out    <= kp_long[KP_W+DATA_OUT_W-1:KP_W] + data_in_int[KI_W+DATA_OUT_W-1:KI_W];
        end
    end

endmodule
