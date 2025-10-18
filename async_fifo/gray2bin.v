`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/18 14:12:10 
// Version:                V1.0 
// File Name:              gray2bin.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

module gray2bin #(
    parameter DATA_W = 10
) (
    input clk,
    input rst_n,

    input  wire [DATA_W-1:0] gray,
    output reg  [DATA_W-1:0] bin
);

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bin <= 0;
        end else begin
            bin[DATA_W-1] = gray[DATA_W-1];
            for (i = DATA_W - 2; i >= 0; i = i - 1) begin
                bin[i] = bin[i+1] ^ gray[i];
            end
        end
    end

endmodule
