`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/18 15:23:30 
// Version:                V1.0 
// File Name:              gen_pause.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

module gen_pause #(
    parameter CD_CYCLE = 100
) (
    input clk,
    input rst_n,

    input      need_pause,
    output reg pause
);

    parameter COUNT_W = $clog2(CD_CYCLE);
    reg [COUNT_W-1:0] cd_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pause    <= 0;
            cd_count <= 0;
        end else begin
            pause = 0;
            if (cd_count == 0) begin
                if (need_pause) begin
                    pause    <= 1'b1;
                    cd_count <= CD_CYCLE;
                end
            end else begin
                cd_count <= cd_count - 1;
            end
        end
    end

endmodule
