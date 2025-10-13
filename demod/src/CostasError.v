`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/04 21:58:26 
// Version:                V1.0 
// File Name:              CostasError.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

//  \ | /
//   \|/
//  --X--  
//   /|\
//  / | \

module CostasError8 #(
    parameter DATA_W  = 12,  // 数据位宽
    parameter ADDR_W  = 8,   // 单个地址位宽
    parameter ERROR_W = 8
) (
    input clk,
    input rst_n,

    input signed [DATA_W-1:0] x_in,
    input signed [DATA_W-1:0] y_in,

    output reg signed [  ERROR_W-1:0] error_out,
    output reg signed [ERROR_W+3-1:0] phase_out
);

    function [$clog2(DATA_W)-1:0] get_leading_0s;
        input [DATA_W-2:0] data_in;
        integer i;
        reg     found_one;
        begin
            get_leading_0s = 0;
            found_one      = 0;
            for (i = DATA_W - 2; i >= 0; i = i - 1) begin
                if (data_in[i] == 0) begin
                    if (!found_one) begin
                        get_leading_0s = get_leading_0s + 1;
                    end
                end else begin
                    found_one = 1;
                end
            end
        end
    endfunction


    wire [DATA_W-2:0] x_abs, y_abs;
    assign x_abs = x_in[DATA_W-1] ? -x_in : x_in;
    assign y_abs = y_in[DATA_W-1] ? -y_in : y_in;


    wire [$clog2(DATA_W)-1:0] x_lz, y_lz, lz;
    assign x_lz = get_leading_0s(x_abs);
    assign y_lz = get_leading_0s(y_abs);

    wire bigger;
    assign bigger = x_abs >= y_abs;
    assign lz     = bigger ? x_lz : y_lz;


    reg                      bigger_d;
    reg [$clog2(DATA_W)-1:0] lz_d;
    reg [DATA_W-2:0] x_abs_d, y_abs_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bigger_d <= 0;
            lz_d     <= 0;
            x_abs_d  <= 0;
            y_abs_d  <= 0;
        end else begin
            bigger_d <= bigger;
            lz_d     <= lz;
            x_abs_d  <= x_abs;
            y_abs_d  <= y_abs;
        end
    end



    wire [DATA_W-2:0] x_moved, y_moved;
    assign x_moved = (x_abs_d << lz_d) >> (DATA_W - ADDR_W - 1);
    assign y_moved = (y_abs_d << lz_d) >> (DATA_W - ADDR_W - 1);

    wire [ADDR_W*2-1:0] rom_addr;
    wire [ ERROR_W-1:0] rom_data;

    assign rom_addr = bigger_d ? {x_moved[ADDR_W-1:0], y_moved[ADDR_W-1:0]} : {y_moved[ADDR_W-1:0], x_moved[ADDR_W-1:0]};

    ROM #(
        .DATA_W   (ERROR_W),
        .ADDR_W   (ADDR_W * 2 - 1),
        .INIT_FILE(`ATAN_ROM_PATH)
    ) atan_rom (
        .clk  (clk),
        .rst_n(rst_n),

        .addr    (rom_addr[ADDR_W*2-2:0]),  // 截掉必定为1的最高位
        .data_out(rom_data)
    );

    reg x_sign_d, y_sign_d, x_sign_d1, y_sign_d1, bigger_d1;
    always @(posedge clk) begin
        if (!rst_n) begin
            x_sign_d  <= 0;
            y_sign_d  <= 0;

            bigger_d1 <= 0;
            x_sign_d1 <= 0;
            y_sign_d1 <= 0;
        end else begin
            x_sign_d  <= x_in[DATA_W-1];
            y_sign_d  <= y_in[DATA_W-1];

            bigger_d1 <= bigger_d;
            x_sign_d1 <= x_sign_d;
            y_sign_d1 <= y_sign_d;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            error_out <= 0;
            phase_out <= 0;
        end else begin
            if (bigger_d1) begin
                // x_abs >= y_abs
                if (y_sign_d1) begin
                    if (x_sign_d1) begin
                        // x < 0, y < 0
                        error_out <= (1 << (ERROR_W - 1)) - rom_data;
                        phase_out <= -(1 << (ERROR_W + 2)) + rom_data;
                    end else begin
                        // x > 0, y < 0
                        error_out <= (1 << (ERROR_W - 1)) + rom_data;
                        phase_out <= -rom_data;
                    end
                end else begin
                    if (x_sign_d1) begin
                        // x < 0, y > 0
                        error_out <= (1 << (ERROR_W - 1)) + rom_data;
                        phase_out <= (1 << (ERROR_W + 2)) - rom_data;
                    end else begin
                        // x > 0, y > 0
                        error_out <= (1 << (ERROR_W - 1)) - rom_data;
                        phase_out <= rom_data;
                    end
                end
            end else begin
                // x_abs < y_abs
                if (y_sign_d1) begin
                    if (x_sign_d1) begin
                        // x < 0, y < 0
                        error_out <= (1 << (ERROR_W - 1)) + rom_data;
                        phase_out <= -(1 << (ERROR_W + 1)) - rom_data;
                    end else begin
                        // x > 0, y < 0
                        error_out <= (1 << (ERROR_W - 1)) - rom_data;
                        phase_out <= -(1 << (ERROR_W + 1)) + rom_data;
                    end
                end else begin
                    if (x_sign_d1) begin
                        // x < 0, y > 0
                        error_out <= (1 << (ERROR_W - 1)) - rom_data;
                        phase_out <= (1 << (ERROR_W + 1)) + rom_data;
                    end else begin
                        // x > 0, y > 0
                        error_out <= (1 << (ERROR_W - 1)) + rom_data;
                        phase_out <= (1 << (ERROR_W + 1)) - rom_data;
                    end
                end
            end
        end
    end
endmodule
