`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/10 14:24:36 
// Version:                V1.0 
// File Name:              DeltaDecode.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

module DeltaDecode (
    input clk,
    input rst_n,

    input       valid_in,
    input [2:0] data_in,

    output reg       valid_out,
    output reg [2:0] data_out
);

    reg [2:0] data_in_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 0;
            data_out  <= 0;
            data_in_d <= 0;
        end else begin
            valid_out <= 0;
            if (valid_in) begin
                valid_out <= 1;
                data_out  <= data_in - data_in_d;
                data_in_d <= data_in;
            end
        end
    end


endmodule
