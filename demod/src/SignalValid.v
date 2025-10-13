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

    input [DATA_W-1:0] in_i,
    input [DATA_W-1:0] in_q,

    output valid
);
    parameter AVE_LEN = 32;

    parameter ABS_W = 7;
    parameter ADDR_W = ABS_W * 2;
    parameter SQRT_W = ABS_W + 1;

    reg [ABS_W-1:0] in_i_abs, in_q_abs;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            in_i_abs <= 0;
            in_q_abs <= 0;
        end else begin
            in_i_abs <= in_i[DATA_W-1] ? ~in_i[DATA_W-2-:ABS_W] : in_i[DATA_W-2-:ABS_W];
            in_q_abs <= in_q[DATA_W-1] ? ~in_q[DATA_W-2-:ABS_W] : in_q[DATA_W-2-:ABS_W];
        end
    end

    wire [SQRT_W-1:0] amp, amp_dc, amp_ac;

    ROM #(
        .DATA_W   (SQRT_W),
        .ADDR_W   (ADDR_W),
        .INIT_FILE(`SQRT_ROM_PATH)
    ) u_ROM (
        .clk     (clk),
        .rst_n   (rst_n),
        .addr    ({in_i_abs, in_q_abs}),
        .data_out(amp)
    );

    // movAvg #(
    //     .WIDTH (DATA_W),
    //     .WINDOW(AVE_LEN)
    // ) u_movAvg_dc (
    //     .clock (clk),
    //     .reset (~rst_n),
    //     .ivalid(1'd1),
    //     .idata (amp),
    //     .ovalid(),
    //     .odata (amp_dc)
    // );

    // movAvg #(
    //     .WIDTH (DATA_W),
    //     .WINDOW(AVE_LEN)
    // ) u_movAvg_ac (
    //     .clock (clk),
    //     .reset (~rst_n),
    //     .ivalid(1'd1),
    //     .idata ((amp_dc > amp) ? (amp_dc - amp) : (amp - amp_dc)),
    //     .ovalid(),
    //     .odata (amp_ac)
    // );


    ave_filter #(
        .LENGTH(AVE_LEN),
        .WIDTH (SQRT_W)
    ) u_ave_filter_dc (
        .clk     (clk),
        .rst_n   (rst_n),
        .en      (1),
        .data_in (amp),
        .data_out(amp_dc)
    );

    ave_filter #(
        .LENGTH(AVE_LEN),
        .WIDTH (SQRT_W)
    ) u_ave_filter_ac (
        .clk     (clk),
        .rst_n   (rst_n),
        .en      (1),
        .data_in ((amp_dc > amp) ? (amp_dc - amp) : (amp - amp_dc)),
        .data_out(amp_ac)
    );


    reg [3:0] valid_mem;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_mem <= 0;
        end else begin
            valid_mem <= {valid_mem[2:0], (amp_ac < THRESH_AC) && (amp_dc > THRESH_DC)};
        end
    end

    assign valid = &valid_mem;


endmodule
