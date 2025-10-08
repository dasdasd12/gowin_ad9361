`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/04 20:01:51 
// Version:                V1.0 
// File Name:              DDS.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

module DDS #(
    parameter DATA_W         = 10,
    parameter PHASE_W        = 10,
    parameter ROM_ADDR_W     = 8,
    parameter phase_inc_base = 10000
) (
    input clk,
    input rst_n,

    input signed [PHASE_W-1:0] phase_inc_delta,

    output reg signed [DATA_W-1:0] sin,
    output reg signed [DATA_W-1:0] cos
);
    parameter ROM_ADDR_MAX = (1 << ROM_ADDR_W) - 1;

    reg signed [PHASE_W-1:0] phase;
    wire       [        1:0] quarter = phase[PHASE_W-1:PHASE_W-2];

    reg        [        1:0] quarter_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            quarter_d <= 0;
        end else begin
            quarter_d <= quarter;
        end
    end


    reg [ROM_ADDR_W-1:0] sin_addr, cos_addr;
    always @(*) begin
        if (quarter == 0) begin
            sin_addr = phase[PHASE_W-3:PHASE_W-ROM_ADDR_W-2];
            cos_addr = ROM_ADDR_MAX - phase[PHASE_W-3:PHASE_W-ROM_ADDR_W-2];
        end else if (quarter == 1) begin
            sin_addr = ROM_ADDR_MAX - phase[PHASE_W-3:PHASE_W-ROM_ADDR_W-2];
            cos_addr = phase[PHASE_W-3:PHASE_W-ROM_ADDR_W-2];
        end else if (quarter == 2) begin
            sin_addr = phase[PHASE_W-3:PHASE_W-ROM_ADDR_W-2];
            cos_addr = ROM_ADDR_MAX - phase[PHASE_W-3:PHASE_W-ROM_ADDR_W-2];
        end else begin
            sin_addr = ROM_ADDR_MAX - phase[PHASE_W-3:PHASE_W-ROM_ADDR_W-2];
            cos_addr = phase[PHASE_W-3:PHASE_W-ROM_ADDR_W-2];
        end
    end

    reg [DATA_W-1-1:0] sin_ori, cos_ori;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sin <= 0;
            cos <= 0;
        end else begin
            if (quarter_d == 0) begin
                sin = {1'b0, sin_ori};
                cos = {1'b0, cos_ori};
            end else if (quarter_d == 1) begin
                sin = {1'b0, sin_ori};
                cos = -{1'b0, cos_ori};
            end else if (quarter_d == 2) begin
                sin = -{1'b0, sin_ori};
                cos = -{1'b0, cos_ori};
            end else begin
                sin = -{1'b0, sin_ori};
                cos = {1'b0, cos_ori};
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase <= 0;
        end else begin
            phase <= phase + phase_inc_base + phase_inc_delta;
        end
    end

    ROM_DULE #(
        .DATA_W   (DATA_W - 1),
        .ADDR_W   (ROM_ADDR_W),
        .INIT_FILE("C:/program1/Program/2019.1vivado_project/demod/src/data/sine_rom.txt")
    ) sin_rom (
        .clk  (clk),
        .rst_n(rst_n),

        .addr1    (sin_addr),
        .data_out1(sin_ori),
        .addr2    (cos_addr),
        .data_out2(cos_ori)
    );

endmodule
