`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/10 15:14:11 
// Version:                V1.0 
// File Name:              SignalValid.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

module SignalValid #(
    parameter DATA_W    = 12,
    parameter THRESH_AC = 100,
    parameter THRESH_DC = 100
) (
    input clk,
    input rst_n,

    input signed [DATA_W-1:0] in_i,
    input signed [DATA_W-1:0] in_q,

    output valid
);
    // parameter VALID_LEN = 32;
    // parameter THRESH_VALID = 20;
    parameter AVE_LEN = 32;
    parameter EXTRA_W = $clog2(AVE_LEN);
    parameter SKIP_N = 10;

    parameter AMP_W = 2 * DATA_W - 1;

    wire [DATA_W-1:0] in_i_abs, in_q_abs;
    assign in_i_abs = in_i[DATA_W-1] ? -in_i : in_i;
    assign in_q_abs = in_q[DATA_W-1] ? -in_q : in_q;

    wire [AMP_W-1:0] amp;
    assign amp = in_i_abs * in_i_abs + in_q_abs * in_q_abs;

    wire [AMP_W-SKIP_N-1:0] amp_short;
    assign amp_short = amp >> SKIP_N;

    reg [AMP_W-SKIP_N-1:0] amp_mem[0:AVE_LEN-1], amp_ac_mem[0:AVE_LEN-1];
    reg [AMP_W-SKIP_N+EXTRA_W-1:0] amp_dc, amp_ac;

    wire [AMP_W-SKIP_N-1:0] amp_dc_short = amp_dc >> EXTRA_W;

    // always @(posedge clk or negedge rst_n) begin
    //     if (!rst_n) begin
    //         amp_div <= 0;
    //     end else begin
    //         amp_div <= (amp_short > amp_dc_short) ? (amp_short - amp_dc_short) : (amp_dc_short - amp_short);
    //     end
    // end

    function [AMP_W-SKIP_N-1:0] get_ac_amp;
        input [AMP_W-SKIP_N-1:0] a, b;
        begin
            if (a > b) begin
                get_ac_amp = a - b;
            end else begin
                get_ac_amp = b - a;
            end
        end
    endfunction

    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < AVE_LEN; i = i + 1) begin
                amp_mem[i]    <= 0;
                amp_ac_mem[i] <= 0;
            end
            amp_dc <= 0;
            amp_ac <= 0;
        end else begin
            for (i = 0; i < AVE_LEN - 1; i = i + 1) begin
                amp_mem[i]    <= amp_mem[i+1];
                amp_ac_mem[i] <= amp_ac_mem[i+1];
            end
            amp_mem[AVE_LEN-1]    <= amp_short;
            amp_dc                <= (amp_dc - amp_mem[0]) + amp_short;

            amp_ac_mem[AVE_LEN-1] <= get_ac_amp(amp_short, amp_dc_short);
            amp_ac                <= (amp_ac - amp_ac_mem[0]) + get_ac_amp(amp_short, amp_dc_short);
        end
    end

    reg [3:0] valid_mem;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_mem <= 0;
        end else begin
            valid_mem <= {valid_mem[2:0], (amp_ac < THRESH_AC) && (amp_dc > THRESH_DC)};
        end
    end

    assign valid = &valid_mem;

    // reg     [VALID_LEN-1:0] valid_mem;
    // // reg                     valid;
    // integer                 j;
    // always @(posedge clk or negedge rst_n) begin
    //     if (!rst_n) begin
    //         for (j = 0; j < VALID_LEN; j = j + 1) begin
    //             valid_mem[j] <= 0;
    //         end
    //     end else begin
    //         for (j = 0; j < VALID_LEN - 1; j = j + 1) begin
    //             valid_mem[j] <= valid_mem[j+1];
    //         end
    //         // amp的低频高而高频低，则认为信号有效
    //         valid_mem[VALID_LEN-1] <= (amp_ac < THRESH_AC) && (amp_dc > THRESH_DC);
    //     end
    // end

    // integer k;
    // function [$clog2(VALID_LEN)-1:0] get_countones;
    //     input [VALID_LEN-1:0] a;
    //     begin
    //         get_countones = 0;
    //         for (k = 0; k < VALID_LEN; k = k + 1) begin
    //             get_countones = get_countones + a[k];
    //         end
    //     end
    // endfunction

    // always @(posedge clk or negedge rst_n) begin
    //     if (!rst_n) begin
    //         valid <= 0;
    //     end else begin
    //         valid <= get_countones(valid_mem) > THRESH_VALID;
    //     end
    // end
endmodule
