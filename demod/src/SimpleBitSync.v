`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/05 22:33:34 
// Version:                V1.0 
// File Name:              SimpleBitSync.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

module SimpleBitSync8 #(
    parameter PHASE_W     = 11,
    parameter SIG_CYCLE_N = 6
) (
    input clk,
    input rst_n,

    input [PHASE_W-1:0] phase_in,

    output                   valid,
    output reg [        2:0] bit_out,
    output reg [PHASE_W-1:0] phase_out
);

    localparam HALF_CYCLE_N = (SIG_CYCLE_N >> 1) + 1;

    reg  [$clog2(SIG_CYCLE_N+1)-1:0] counter;
    wire [                      2:0] bit_in = phase_in[PHASE_W-1:PHASE_W-3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter   <= 0;
            bit_out   <= 0;
            phase_out <= 0;
        end else begin
            bit_out   <= bit_in;
            phase_out <= phase_in;

            if ((bit_out != bit_in) && (bit_out + 1 != bit_in) && (bit_out - 1 != bit_in)) begin
                counter <= HALF_CYCLE_N - 1;
            end else if (counter == SIG_CYCLE_N - 1) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    assign valid = (counter == SIG_CYCLE_N - 1);

endmodule
