`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/18 15:01:35 
// Version:                V1.0 
// File Name:              async_fifo_tb.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

`define FINISH_TIME 1000
`define CYCLE 1
`define CYCLE_HALF 0.5
`define WAIT_CYCLE(n) repeat(n) @(posedge clk);

module async_fifo_tb ();
    reg clk, rclk;
    reg rst_n;

    initial begin
        rclk = 1'b1;
        forever #`CYCLE rclk = ~rclk;
    end
    initial begin
        clk = 1'b1;
        forever #`CYCLE_HALF clk = ~clk;
    end
    initial begin
        rst_n = 1'b0;
        #2.5 rst_n = 1'b1;
    end
    initial begin
        $dumpfile("async_fifo_tb_wave.vcd");
        $dumpvars(0, async_fifo_tb);
        #`FINISH_TIME $finish;
    end

    // output declaration of module async_fifo
    parameter DSIZE = 8;
    reg  [DSIZE-1:0] wdata;
    wire             wfull;
    wire             awfull;
    wire [DSIZE-1:0] rdata;
    wire             rempty;
    wire             arempty;
    wire             need_pause;

    reg              winc;
    initial begin
        winc = 1'b1;
        `WAIT_CYCLE(295)
        winc = 1'b0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) wdata <= 0;
        else wdata <= wdata + 1;
    end

    async_fifo #(
        .DSIZE      (8),
        .ASIZE      (6),
        .FALLTHROUGH("TRUE")
    ) u_async_fifo (
        .wclk      (clk),
        .wrst_n    (rst_n),
        .winc      (winc),
        .wdata     (wdata),
        .wfull     (wfull),
        .awfull    (awfull),
        .rclk      (rclk),
        .rrst_n    (rst_n),
        .rinc      (1),
        .rdata     (rdata),
        .rempty    (rempty),
        .arempty   (arempty),
        .need_pause(need_pause)
    );

    wire pause;

    gen_pause #(
        .CD_CYCLE(10)
    ) u_gen_pause (
        .clk       (clk),
        .rst_n     (rst_n),
        .need_pause(need_pause),
        .pause     (pause)
    );


endmodule
