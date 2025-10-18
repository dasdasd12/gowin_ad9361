// distributed under the mit license
// https://opensource.org/licenses/mit-license.php

`timescale 1 ns / 1 ps `default_nettype none

module async_fifo #(
    parameter DSIZE        = 8,
    parameter ASIZE        = 4,
    parameter FALLTHROUGH  = "TRUE",                 // First word fall-through without latency
    parameter PAUSE_THRESH = (1 << (ASIZE + 1)) / 3  // 默认2/3的pause帧门限
) (
    input  wire             wclk,
    input  wire             wrst_n,
    input  wire             winc,
    input  wire [DSIZE-1:0] wdata,
    output wire             wfull,
    output wire             awfull,
    input  wire             rclk,
    input  wire             rrst_n,
    input  wire             rinc,
    output wire [DSIZE-1:0] rdata,
    output wire             rempty,
    output wire             arempty,
    output wire             need_pause
);

    wire [ASIZE-1:0] waddr, raddr;
    wire [ASIZE : 0] wptr, rptr, wq2_rptr, rq2_wptr;

    // The module synchronizing the read point
    // from read to write domain
    sync_r2w #(ASIZE) sync_r2w (
        .wq2_rptr(wq2_rptr),
        .rptr    (rptr),
        .wclk    (wclk),
        .wrst_n  (wrst_n)
    );

    // The module synchronizing the write point
    // from write to read domain
    sync_w2r #(ASIZE) sync_w2r (
        .rq2_wptr(rq2_wptr),
        .wptr    (wptr),
        .rclk    (rclk),
        .rrst_n  (rrst_n)
    );

    // The module handling the write requests
    wptr_full #(ASIZE) wptr_full (
        .awfull  (awfull),
        .wfull   (wfull),
        .waddr   (waddr),
        .wptr    (wptr),
        .wq2_rptr(wq2_rptr),
        .winc    (winc),
        .wclk    (wclk),
        .wrst_n  (wrst_n)
    );

    // The DC-RAM
    fifomem #(DSIZE, ASIZE, FALLTHROUGH) fifomem (
        .rclken(rinc),
        .rclk  (rclk),
        .rdata (rdata),
        .wdata (wdata),
        .waddr (waddr),
        .raddr (raddr),
        .wclken(winc),
        .wfull (wfull),
        .wclk  (wclk)
    );

    // The module handling read requests
    rptr_empty #(ASIZE) rptr_empty (
        .arempty (arempty),
        .rempty  (rempty),
        .raddr   (raddr),
        .rptr    (rptr),
        .rq2_wptr(rq2_wptr),
        .rinc    (rinc),
        .rclk    (rclk),
        .rrst_n  (rrst_n)
    );

    // 使用wptr与wq2_rptr，在写时钟域计算需要暂停信号
    wire [ASIZE : 0] wptr_bin, rptr_bin;
    gray2bin #(
        .DATA_W(ASIZE + 1)
    ) gray2bin_inst (
        .clk  (wclk),
        .rst_n(wrst_n),
        .gray (wptr),
        .bin  (wptr_bin)
    );

    gray2bin #(
        .DATA_W(ASIZE + 1)
    ) gray2bin_inst2 (
        .clk  (wclk),
        .rst_n(wrst_n),
        .gray (wq2_rptr),
        .bin  (rptr_bin)
    );

    // 计算FIFO中数据的数量
    wire [ASIZE:0] diff;
    assign diff       = wptr_bin - rptr_bin;

    // 计算need_pause信号
    assign need_pause = (diff >= PAUSE_THRESH);

endmodule

`resetall
