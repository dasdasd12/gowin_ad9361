`timescale 1ns / 100ps

module tx_data3to8 (
    input                               clk                        ,
    input                               rst_n                      ,

    input                               frame_start                ,
    input                               frame_end                  ,

    input                [   2: 0]      data_in                    ,
    input                               data_in_valid              ,

    output reg           [   7: 0]      data_out                   ,
    output reg                          data_out_valid              
);
    
    localparam IDLE = 3'd0;
    localparam OUT1 = 3'd1;
    localparam OUT2 = 3'd2;
    localparam OUT3 = 3'd3;
    localparam DONE = 3'd4;

    reg                 [   2: 0]      state                       ;

    reg                [   2: 0]        cnt                         ;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
            cnt   <= 3'd0;
        end
        else begin
            case(state)
                IDLE: begin
                    if(frame_start) begin
                        state <= OUT1;
                    end
                    else begin
                        state <= IDLE;
                    end
                end

                OUT1: begin
                    if (frame_end) begin
                        state <= IDLE;
                        cnt   <= 3'd0;
                    end
                    else if (!frame_end) begin
                        if (cnt == 3'd2) begin
                            state <= OUT2;
                            cnt   <= 3'd0;
                        end
                        else begin
                            state <= OUT1;
                            cnt   <= cnt + 3'd1;
                        end
                    end
                end

                OUT2: begin
                    if (frame_end) begin
                        state <= IDLE;
                        cnt   <= 3'd0;
                    end
                    else if (!frame_end) begin
                        if (cnt == 3'd2) begin
                            state <= OUT3;
                            cnt   <= 3'd0;
                        end
                        else begin
                            state <= OUT2;
                            cnt   <= cnt + 3'd1;
                        end
                    end
                end

                OUT3: begin
                    if (frame_end) begin
                        state <= IDLE;
                        cnt   <= 3'd0;
                    end
                    else if (!frame_end) begin
                        if (cnt == 3'd2) begin
                            state <= OUT1;
                            cnt   <= 3'd0;
                        end
                        else begin
                            state <= OUT3;
                            cnt   <= cnt + 3'd1;
                        end
                    end
                end

                default: begin
                    state          <= IDLE;
                    cnt            <= 3'd0;
                end
            endcase
        end
    end

endmodule