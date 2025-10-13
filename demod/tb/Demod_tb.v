`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/05 19:33:59 
// Version:                V1.0 
// File Name:              Costas_tb.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 
`ifdef __ICARUS__
`include "../src/roms.vh"
`endif
module Demod_tb ();
    reg clk;
    reg rst_n;

    initial begin
        clk = 1'b1;
        forever #0.5 clk = ~clk;
    end
    initial begin
        rst_n = 1'b0;
        #2.5 rst_n = 1'b1;
    end

    initial begin
        $dumpfile("demod_wave.vcd");  // 指定生成的波形文件名为 "wave.vcd"
        $dumpvars(0, Demod_tb);  // 记录所有层次的信号
    end

    initial begin
        #1000;
        force u_Demod.signal_valid = 1'b0;
        #20;
        release u_Demod.signal_valid;
    end

    parameter DATA_W = 12;
    parameter N = 4_000;

    reg signed [DATA_W*2-1:0] in_array[0:N-1];
    reg signed [DATA_W-1:0] in_i, in_q;
    wire signed [DATA_W-1:0] out_i, out_q;
    wire signed [11-1:0] phase;
    integer              i;

    initial begin
        // $readmemh("./tb/tx_signal.hex", in_array);
        $readmemh("C:/program1/Program/2019.1vivado_project/demod/tb/tx_signal.hex", in_array);
        for (i = 0; i < N; i = i + 1) begin
            {in_i, in_q} = in_array[i];
            #2;
        end
        {in_i, in_q} = 0;
        #500;
        $finish;
    end

    wire          valid;
    wire [   2:0] bit_out;
    wire [11-1:0] phase_out;

    Demod #(
        .DATA_W(12)
    ) u_Demod (
        .clk        (clk),
        .rst_n      (rst_n),
        .in_i       (in_i),
        .in_q       (in_q),
        .valid      (valid),
        .bit_out    (bit_out),
        .phase_out  (phase_out),
        .frame_start(frame_start),
        .frame_end  (frame_end)
    );

    // Demod #(
    //     .DATA_W(DATA_W)
    // ) u_Demod (
    //     .clk      (clk),
    //     .rst_n    (rst_n),
    //     .in_i     (in_i),
    //     .in_q     (in_q),
    //     .valid    (valid),
    //     .bit_out  (bit_out),
    //     .phase_out(phase)
    // );

    // Costas #(
    //     .DATA_W    (DATA_W),
    //     .DATA_DDS_W(10),
    //     .PHASE_W   (10),
    //     .ERROR_W   (8)
    // ) u_Costas (
    //     .clk  (clk),
    //     .rst_n(rst_n),
    //     .in_i (in_i),
    //     .in_q (in_q),
    //     .out_i(out_i),
    //     .out_q(out_q),
    //     .phase(phase)
    // );

    // wire [2:0] phase_high = phase[10:8];


endmodule
