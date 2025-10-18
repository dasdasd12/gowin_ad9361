`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/16 20:54:05 
// Version:                V1.0 
// File Name:              FMdemod.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

module FMdemod #(
    parameter DATA_W = 12
) (
    input clk,
    input rst_n,

    input                     valid_in,
    input signed [DATA_W-1:0] i_in,
    input signed [DATA_W-1:0] q_in,

    output                     valid_out,
    output signed [DATA_W-1:0] out
);

    parameter RMAX = 8;
    parameter M = 1;
    parameter N = 1;
    parameter REG_WIDTH = DATA_W + $clog2((RMAX * M)) * N;

    // 两次下采样
    wire signed [REG_WIDTH-1:0] i_dec1_long, q_dec1_long, i_dec2_long, q_dec2_long;
    wire signed [DATA_W-1:0] i_dec1, q_dec1, i_dec2, q_dec2;
    reg signed [DATA_W-1:0] i_dec2_d, q_dec2_d;
    assign i_dec1 = i_dec1_long[REG_WIDTH-1-:DATA_W];
    assign q_dec1 = q_dec1_long[REG_WIDTH-1-:DATA_W];
    assign i_dec2 = i_dec2_long[REG_WIDTH-1-:DATA_W];
    assign q_dec2 = q_dec2_long[REG_WIDTH-1-:DATA_W];

    //////////////////////////////////
    // i
    //////////////////////////////////

    cic_decimator #(
        .WIDTH    (DATA_W),
        .RMAX     (RMAX),
        .M        (M),
        .N        (N),
        .REG_WIDTH(REG_WIDTH)
    ) u_cic_decimator_i1 (
        .clk          (clk),
        .rst_n        (rst_n),
        .input_tdata  (i_in),
        .input_tvalid (1),
        .input_tready (),
        .output_tdata (i_dec1_long),
        .output_tvalid(i_out_valid1),
        .output_tready(i_out_ready1),
        .rate         (RMAX)
    );

    cic_decimator #(
        .WIDTH    (DATA_W),
        .RMAX     (RMAX),
        .M        (M),
        .N        (N),
        .REG_WIDTH(REG_WIDTH)
    ) u_cic_decimator_i2 (
        .clk          (clk),
        .rst_n        (rst_n),
        .input_tdata  (i_dec1),
        .input_tvalid (i_out_valid1),
        .input_tready (i_out_ready1),
        .output_tdata (i_dec2_long),
        .output_tvalid(i_out_valid2),
        .output_tready(1),
        .rate         (RMAX)
    );


    //////////////////////////////////
    // q
    //////////////////////////////////

    cic_decimator #(
        .WIDTH    (DATA_W),
        .RMAX     (RMAX),
        .M        (M),
        .N        (N),
        .REG_WIDTH(REG_WIDTH)
    ) u_cic_decimator_q1 (
        .clk          (clk),
        .rst_n        (rst_n),
        .input_tdata  (q_in),
        .input_tvalid (1),
        .input_tready (),
        .output_tdata (q_dec1_long),
        .output_tvalid(q_out_valid1),
        .output_tready(q_out_ready1),
        .rate         (RMAX)
    );

    cic_decimator #(
        .WIDTH    (DATA_W),
        .RMAX     (RMAX),
        .M        (M),
        .N        (N),
        .REG_WIDTH(REG_WIDTH)
    ) u_cic_decimator_q2 (
        .clk          (clk),
        .rst_n        (rst_n),
        .input_tdata  (q_dec1),
        .input_tvalid (q_out_valid1),
        .input_tready (q_out_ready1),
        .output_tdata (q_dec2_long),
        .output_tvalid(q_out_valid2),
        .output_tready(1),
        .rate         (RMAX)
    );


    // 解调
    reg signed  [2*DATA_W-1-1:0] base_long;
    wire signed [    DATA_W-1:0] base;
    assign base = base_long[2*DATA_W-1-1-:DATA_W];
    reg base_valid;

    always @(posedge clk) begin
        if (!rst_n) begin
            base_long  <= 0;
            base_valid <= 0;
            i_dec2_d   <= 0;
            q_dec2_d   <= 0;
        end else begin
            base_valid <= 0;
            if (i_out_valid2) begin
                // base_demodulated[n - 1] = (i[n - 1] * q[n] - i[n] * q[n - 1])
                base_long  <= i_dec2_d * q_dec2 - i_dec2 * q_dec2_d;
                base_valid <= 1;
                i_dec2_d   <= i_dec2;
                q_dec2_d   <= q_dec2;
            end
        end
    end



    localparam BASE_REG_WIDTH = DATA_W + 10;
    localparam SLID_BITS = 3;

    wire signed [BASE_REG_WIDTH-1:0] out_long;

    cic_decimator #(
        .WIDTH    (DATA_W),
        .RMAX     (16),
        .M        (2),
        .N        (2),
        .REG_WIDTH(BASE_REG_WIDTH)
    ) u_cic_decimator_base (
        .clk          (clk),
        .rst_n        (rst_n),
        .input_tdata  (base),
        .input_tvalid (base_valid),
        .input_tready (),
        .output_tdata (out_long),
        .output_tvalid(valid_out),
        .output_tready(1),
        .rate         (16)
    );



    assign out = out_long[BASE_REG_WIDTH-1-SLID_BITS-:DATA_W];

endmodule
