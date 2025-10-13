`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/13 09:08:22 
// Version:                V1.0 
// File Name:              Buffer.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

`define ROUTATE_ADD1(x, len) ((x) == (len)-1 ? 0 : (x)+1)

module ConvertFIFO #(
    parameter IN_W  = 8,
    parameter OUT_W = 3,
    parameter DEPTH = 16
) (
    input clk,
    input rst_n,

    input            frame_end,
    input            in_valid,
    input [IN_W-1:0] in_data,

    input              out_ready,
    output             out_valid,
    output [OUT_W-1:0] out_data
);

    parameter CONVERT_TYPE = (IN_W > OUT_W) ? "DOWN" : "UP";  // DOWN: 8->3, UP: 3->8

    parameter BIG_W = CONVERT_TYPE == "DOWN" ? IN_W : OUT_W;

    localparam WRITE_S = 1'b0;
    localparam READ_S = 1'b1;
    reg state, next_state;

    reg [$clog2(DEPTH)-1:0] ptr_wr, ptr_rd;

    reg              we;
    reg  [BIG_W-1:0] data_in;
    wire [BIG_W-1:0] data_out;

    RAM #(
        .DATA_W(BIG_W),
        .DEPTH (DEPTH)
    ) ram_inst (
        .clk     (clk),
        .rst_n   (rst_n),
        .we      (we),
        .addr    (state == WRITE_S ? ptr_wr : ptr_rd),
        .data_in (data_in),
        .data_out(data_out)
    );

    reg [IN_W*OUT_W-1:0] data_temp;

    // write logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ptr_wr <= 'b0;
        end else begin
            if (state == WRITE_S) begin
                if (CONVERT_TYPE == "DOWN") begin
                    // Down Conversion (e.g., 8-bit to 3-bit)
                    if (in_valid) begin
                        ptr_wr <= ptr_wr + 1'b1;
                    end
                end else begin
                    // Up Conversion (e.g., 3-bit to 8-bit)
                    if (in_valid) begin

                    end
                end
            end
        end
    end




    // fsm
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= WRITE_S;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            WRITE_S: begin
                if (frame_end) begin
                    next_state = READ_S;
                end
            end
            READ_S: begin
                if (ptr_rd == ptr_wr) begin
                    next_state = WRITE_S;
                end
            end
        endcase
    end



endmodule





module ConvertBuffer #(
    parameter IN_W  = 8,
    parameter OUT_W = 3,
    parameter SIZE  = IN_W * OUT_W
) (
    input clk,
    input rst_n,

    input frame_end,

    output            in_ready,
    input             in_valid,
    input  [IN_W-1:0] in_data,

    input              out_ready,
    output             out_valid,
    output [OUT_W-1:0] out_data
);

    reg [SIZE-1:0] buffer, buffer_valid;
    reg  [ $clog2(SIZE/IN_W):0] in_data_count;
    reg  [$clog2(SIZE/OUT_W):0] out_data_count;

    wire                        out_valid_low = buffer_valid[out_data_count*OUT_W] == 1;
    wire                        out_valid_high = buffer_valid[out_data_count*OUT_W+OUT_W-1] == 1;

    wire                        has_data_left = out_valid_low & ~out_valid_high;

    reg                         frame_end_to_solve;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            frame_end_to_solve <= 1'b0;
        end else begin
            if (frame_end) begin
                frame_end_to_solve <= 1'b1;
            end else if (~out_valid_high & out_ready) begin
                frame_end_to_solve <= 1'b0;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer         <= {SIZE{1'b0}};
            buffer_valid   <= {SIZE{1'b0}};
            in_data_count  <= 'b0;
            out_data_count <= 'b0;
        end else begin
            if (in_valid && in_ready) begin
                buffer[in_data_count*IN_W+:IN_W]       <= in_data;
                buffer_valid[in_data_count*IN_W+:IN_W] <= {IN_W{1'b1}};
                in_data_count                          <= `ROUTATE_ADD1(in_data_count, SIZE / IN_W);
            end
            if (out_valid && out_ready) begin
                out_data_count                            <= `ROUTATE_ADD1(out_data_count, SIZE / OUT_W);
                buffer_valid[out_data_count*OUT_W+:OUT_W] <= {OUT_W{1'b0}};
            end
            if (frame_end_to_solve & has_data_left & out_ready) begin
                out_data_count <= 'b0;
                in_data_count  <= 'b0;
                buffer         <= {SIZE{1'b0}};
                buffer_valid   <= {SIZE{1'b0}};
            end
        end
    end

    assign in_ready  = frame_end_to_solve ? 0 : (buffer_valid[in_data_count*IN_W+IN_W-1] == 0);

    assign out_data  = buffer[out_data_count*OUT_W+:OUT_W];
    assign out_valid = (frame_end_to_solve & has_data_left) ? 1'b1 : out_valid_high;

endmodule


module FIFO #(
    parameter DATA_W = 8,
    parameter DEPTH  = 16

) (
    input clk,
    input rst_n,

    input                          we,
    input      [$clog2(DEPTH)-1:0] addr,
    input      [       DATA_W-1:0] data_in,
    output reg [       DATA_W-1:0] data_out
);

    reg [DATA_W-1:0] mem[DEPTH-1:0];

    initial begin
        integer i;
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = {DATA_W{1'b0}};
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= {DATA_W{1'b0}};
        end else begin
            if (we) begin
                mem[addr] <= data_in;
            end else begin
                data_out <= mem[addr];
            end
        end
    end


endmodule





module RAM #(
    parameter DATA_W = 8,
    parameter DEPTH  = 16

) (
    input clk,
    input rst_n,

    input                          we,
    input      [$clog2(DEPTH)-1:0] addr,
    input      [       DATA_W-1:0] data_in,
    output reg [       DATA_W-1:0] data_out
);

    reg [DATA_W-1:0] mem[DEPTH-1:0];

    initial begin
        integer i;
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = {DATA_W{1'b0}};
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= {DATA_W{1'b0}};
        end else begin
            if (we) begin
                mem[addr] <= data_in;
            end else begin
                data_out <= mem[addr];
            end
        end
    end


endmodule


// module Pingpong_RAM #(
//     parameter DATA_W = 8,
//     parameter DEPTH  = 16
// ) (
//     input clk,
//     input rst_n,

//     input change_flag,

//     input                     we,
//     input [$clog2(DEPTH)-1:0] addr_w,
//     input [       DATA_W-1:0] data_w,

//     input  [$clog2(DEPTH)-1:0] addr_r,
//     output [       DATA_W-1:0] data_r

// );

//     reg ram_choice;
//     always @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             ram_choice <= 1'b0;
//         end else if (change_flag) begin
//             ram_choice <= ~ram_choice;
//         end
//     end

//     wire [DATA_W-1:0] data_out0, data_out1;

//     RAM #(
//         .DATA_W(DATA_W),
//         .DEPTH (DEPTH)
//     ) ram0 (
//         .clk     (clk),
//         .rst_n   (rst_n),
//         .we      (ram_choice ? we : 1'b0),
//         .addr    (ram_choice ? addr_w : addr_r),
//         .data_in (data_w),
//         .data_out(data_out0)
//     );

//     RAM #(
//         .DATA_W(DATA_W),
//         .DEPTH (DEPTH)
//     ) ram1 (
//         .clk     (clk),
//         .rst_n   (rst_n),
//         .we      (ram_choice ? 1'b0 : we),
//         .addr    (ram_choice ? addr_r : addr_w),
//         .data_in (data_w),
//         .data_out(data_out1)
//     );

//     assign data_r = ram_choice ? data_out0 : data_out1;

// endmodule
