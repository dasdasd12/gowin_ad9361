`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/17 10:07:03 
// Version:                V1.0 
// File Name:              FMdemod_tb.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

`define FINISH_TIME 1000
`define CYCLE 1
`define CYCLE_HALF 0.5
`define WAIT_CYCLE(n) repeat(n) @(posedge clk);

module FMdemod_tb ();
    reg clk;
    reg rst_n;

    initial begin
        clk = 1'b1;
        forever #`CYCLE_HALF clk = ~clk;
    end
    initial begin
        rst_n = 1'b0;
        #2.5 rst_n = 1'b1;
    end
    initial begin
        $dumpfile("FMdemod_tb_wave.vcd");
        $dumpvars(0, FMdemod_tb);
    end

    parameter DATA_W = 12;
    parameter N = 400_000;

    reg signed [DATA_W*2-1:0] in_array[0:N-1];
    reg signed [DATA_W-1:0] in_i, in_q;

    reg     valid_in;

    integer i;

    initial begin
        {in_i, in_q} = 0;
        valid_in     = 1'b0;
        $readmemh("./tb/fm_modulated_signal.txt", in_array);
        `WAIT_CYCLE(10);
        for (i = 0; i < N; i = i + 1) begin
            {in_i, in_q} = in_array[i];
            valid_in     = 1'b1;
            `WAIT_CYCLE(1);
            valid_in = 1'b0;
            `WAIT_CYCLE(1);
        end
        {in_i, in_q} = 0;
        #50;
        $finish;
    end

    wire [DATA_W-1:0] out;

    FMdemod #(
        .DATA_W(DATA_W)
    ) u_FMdemod (
        .clk      (clk),
        .rst_n    (rst_n),
        .valid_in (valid_in),
        .i_in     (in_i),
        .q_in     (in_q),
        .valid_out(valid_out),
        .out      (out)
    );


endmodule
