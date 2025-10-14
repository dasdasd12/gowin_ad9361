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
    output signed [11-1:0] phase_out,

    output frame_start,
    output frame_end
);

    localparam IDLE_S = 2'b00;
    localparam SYNC_S = 2'b01;
    localparam LOCK_S = 2'b10;
    localparam DATA_S = 2'b11;

    // use time counter to stop carrier sync
    parameter TIMEOUT = 250;
    parameter COUNTER_N = $clog2(TIMEOUT);

    parameter RMAX = 2;
    parameter M = 1;
    parameter N = 5;
    parameter REG_WIDTH = DATA_W + ($clog2(M) + 1) * N - 1;

    wire [REG_WIDTH-1:0] in_i_interpolated, in_q_interpolated;

    cic_interpolator #(
        .WIDTH    (DATA_W),
        .RMAX     (RMAX),
        .M        (M),
        .N        (N),
        .REG_WIDTH(REG_WIDTH)
    ) u_cic_interpolator_i (
        .clk          (clk),
        .rst_n        (rst_n),
        .input_tdata  (in_i),
        .input_tvalid (1'd1),
        .input_tready (in_i_input_tready),
        .output_tdata (in_i_interpolated),
        .output_tvalid(in_i_output_tvalid),
        .output_tready(1'd1),
        .rate         (2'd2)
    );

    cic_interpolator #(
        .WIDTH    (DATA_W),
        .RMAX     (RMAX),
        .M        (M),
        .N        (N),
        .REG_WIDTH(REG_WIDTH)
    ) u_cic_interpolator_q (
        .clk          (clk),
        .rst_n        (rst_n),
        .input_tdata  (in_q),
        .input_tvalid (1'd1),
        .input_tready (in_q_input_tready),
        .output_tdata (in_q_interpolated),
        .output_tvalid(in_q_output_tvalid),
        .output_tready(1'd1),
        .rate         (2'd2)
    );

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
        .THRESH_AC(30),
        .THRESH_DC(50)
    ) u_SignalValid (
        .clk  (clk),
        .rst_n(rst_n),
        .in_i (in_i_interpolated[REG_WIDTH-1-:DATA_W]),
        .in_q (in_q_interpolated[REG_WIDTH-1-:DATA_W]),
        .valid(signal_valid)
    );



    wire signed [DATA_W-1:0] out_i, out_q;
    wire signed [11-1:0] phase;

    Costas #(
        .DATA_W    (DATA_W),
        .DATA_DDS_W(10),
        .ERROR_W   (8)
    ) u_Costas (
        .clk  (clk),
        .rst_n(rst_n && signal_valid),
        .in_i (in_i_interpolated[REG_WIDTH-1-:DATA_W]),
        .in_q (in_q_interpolated[REG_WIDTH-1-:DATA_W]),
        .out_i(out_i),
        .out_q(out_q),
        .phase(phase)
    );

    wire [2:0] phase_high;

    SimpleBitSync8 #(
        .PHASE_W    (11),
        .SIG_CYCLE_N(6)
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
        state_next <= state;  // default to stay in the same state
        if (signal_valid) begin
            case (state)
                IDLE_S: begin
                    state_next <= SYNC_S;
                end
                SYNC_S: begin
                    if (sync_time_out) begin
                        state_next <= LOCK_S;
                    end
                end
                LOCK_S: begin
                    if (bit_out == 3'b100) begin
                        state_next <= DATA_S;
                    end
                end
            endcase
        end else begin
            state_next <= IDLE_S;
        end
    end


    // reg frame, frame_d;
    // always @(*) begin
    //     if (!rst_n) begin
    //         frame <= 1'b0;
    //     end else begin
    //         if (state == LOCK_S && bit_out == 3'b100) begin
    //             frame <= 1'b1;
    //         end else if (~signal_valid) begin
    //             frame <= 1'b0;
    //         end
    //     end
    // end
    // always @(posedge clk or negedge rst_n) begin
    //     if (!rst_n) begin
    //         frame_d <= 1'b0;
    //     end else begin
    //         frame_d <= frame;
    //     end
    // end

    assign frame_start = (state == LOCK_S) && (bit_out == 3'b100);
    assign frame_end   = (state == DATA_S) && !signal_valid;

    assign valid       = (state == DATA_S) && valid_out;

endmodule
