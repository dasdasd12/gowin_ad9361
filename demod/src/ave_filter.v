`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/04 16:43:22
// Design Name: 
// Module Name: ave_filter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ave_filter #(
    parameter LENGTH = 128,
    parameter WIDTH  = 10
) (
    input                    clk,
    input                    rst_n,
    input                    en,
    input signed [WIDTH-1:0] data_in,

    output signed [WIDTH-1:0] data_out
);

    reg signed [               WIDTH-1:0] mem [LENGTH-1:0];
    reg signed [$clog2(LENGTH)+WIDTH-1:0] sum;

    integer i, j;
    initial begin
        for (i = 0; i < LENGTH; i = i + 1) begin
            mem[i] = {WIDTH{1'b0}};
        end
        sum <= {WIDTH{1'b0}};
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < LENGTH; j = j + 1) begin
                mem[j] = {WIDTH{1'b0}};
            end
            sum <= {WIDTH{1'b0}};
        end else if (en) begin
            for (j = LENGTH - 1; j > 0; j = j - 1) begin
                mem[j] <= mem[j-1];
            end
            mem[0] <= data_in;
            sum    <= sum - mem[LENGTH-1] + data_in;
        end
    end

    assign data_out = sum >> $clog2(LENGTH);

endmodule
