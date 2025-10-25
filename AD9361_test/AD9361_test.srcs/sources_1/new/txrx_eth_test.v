`timescale 1ns / 100ps

module test_module (
    input                               clk_125m                   ,
    input                               rst_n                      ,

    output reg           [   7: 0]      eth_rx_data                ,
    output                              eth_rx_data_valid          ,
    output               [  15: 0]      eth_rx_data_length         ,
    output reg                          one_pkg_done               ,
    output                              pkg_error                   
);

    assign eth_rx_data_length = 16'd350;
    assign pkg_error = 1'b0;

    reg [15:0] cnt;

    localparam IDLE = 1'b0;
    localparam DATA = 1'b1;

    reg state;

    always @(posedge clk_125m or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 16'd9950;
        end else begin
            case (state)
                
                IDLE: begin 
                    if(cnt == 16'd39999) begin
                        state <= DATA;
                        cnt <= 16'd0;
                        one_pkg_done <= 1'b0;
                    end
                    else 
                        cnt <= cnt + 1'b1;
                end

                DATA: begin
                    if (cnt == 16'd349) begin
                        state <= IDLE;
                        cnt <= 16'd0;
                        one_pkg_done <= 1'b1;
                    end else begin
                        cnt <= cnt + 1'b1;
                    end
                end

            endcase
        end
    end

    always @(posedge clk_125m or negedge rst_n) begin
        if (!rst_n) begin
            eth_rx_data <= 8'd0;
        end else begin
            if (state == DATA) begin
                eth_rx_data <= eth_rx_data + 1'b1;
            end else begin
                eth_rx_data <= 8'd0;
            end
        end
    end

    assign eth_rx_data_valid = (state == DATA) ? 1'b1 : 1'b0;




endmodule