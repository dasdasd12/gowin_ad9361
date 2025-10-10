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

    // use time counter to stop sync
    localparam IDLE_S = 2'b00;
    localparam SYNC_S = 2'b01;
    localparam LOCK_S = 2'b10;

    parameter TIMEOUT = 250;
    parameter COUNTER_N = $clog2(TIMEOUT);

    reg [1:0] state, state_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE_S;
        end else begin
            state <= state_next;
        end
    end


    SignalValid #(
        .DATA_W   (12),
        .THRESH_AC(20000),
        .THRESH_DC(30000)
    ) u_SignalValid (
        .clk  (clk),
        .rst_n(rst_n),
        .in_i (in_i),
        .in_q (in_q),
        .valid(signal_valid)
    );



    wire signed [DATA_W-1:0] out_i, out_q;
    wire signed [11-1:0] phase;

    Cordic #(
        .DATA_W    (DATA_W),
        .DATA_DDS_W(10),
        .PHASE_W   (12),
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

    wire [2:0] phase_high;

    SimpleBitSync8 #(
        .PHASE_W    (11),
        .SIG_CYCLE_N(3)
    ) u_SimpleBitSync8 (
        .clk      (clk),
        .rst_n    (rst_n),
        .phase_in (phase),
        .valid    (valid_in),
        .bit_out  (phase_high),
        .phase_out(phase_out)
    );


    DeltaDecode u_DeltaDecode (
        .clk      (clk),
        .rst_n    (rst_n),
        .valid_in (valid_in),
        .data_in  (phase_high),
        .valid_out(valid_out),
        .data_out (bit_out)
    );



    reg  [COUNTER_N-1:0] time_cnt;
    wire                 sync_time_out = (time_cnt == TIMEOUT - 1);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            time_cnt <= 0;
        end else begin
            if (state == SYNC_S) begin
                if (sync_time_out) begin
                    time_cnt <= 0;
                end else begin
                    time_cnt <= time_cnt + 1;
                end
            end else begin
                time_cnt <= 0;
            end
        end
    end

    always @(*) begin
        state_next = state;  // default to stay in the same state
        if (signal_valid) begin
            case (state)
                IDLE_S: begin
                    state_next = SYNC_S;
                end
                SYNC_S: begin
                    state_next = sync_time_out ? LOCK_S : SYNC_S;
                end
            endcase
        end
    end

    assign valid = (state == LOCK_S) && valid_out;

endmodule
