`timescale 1ns/100ps
module uart_rx_cfg (
    input                               clk                        ,
    input                               rst_n                      ,
    input                               uart_rx                    ,
    input                               rx_en                      ,
    output reg                          wr_flag                    ,
    output reg           [  19: 0]      wr_data                    ,
    output                              rd_start                    
);

    wire               [   7: 0]        rx_data                     ;
    wire                                rx_data_valid               ;
    wire                                rx_data_ready               ;

    wire               [  19: 0]        data_out                    ;

    reg                [   2: 0]        bit_cnt                     ;
    
    assign                              data_out                    = bit_cnt == 3'd5 ? wr_data : 20'b0;
    assign                              rd_start                    = data_out==20'hFFFFF  ;


    uart_rx #(
    .CLK_FRE                            (100                       ),
    .BAUD_RATE                          (115200                    ) 
    ) u_uart_rx (
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),
    .rx_data                            (rx_data                   ),
    .rx_data_valid                      (rx_data_valid             ),
    .rx_data_ready                      (rx_en                     ),
    .rx_pin                             (uart_rx                   ) 
    );

    wire               [   3: 0]        hex_data_out                ;
    
    ASCII_rom u_ASCII_rom(
    .ascii_data_in                      (rx_data                   ),
    .hex_data_out                       (hex_data_out              ) 
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 3'b0;
        end
        else if (bit_cnt == 3'd5) begin
            bit_cnt <= 3'b0;
        end
        else if (rx_data_valid) begin
            bit_cnt <= bit_cnt + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_data <= 20'b0;
        end
        else if (rx_data_valid) begin
            wr_data[(5-bit_cnt)*4-1'b1 -: 4] <= hex_data_out;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_flag <= 1'b0;
        end
        else if (bit_cnt == 3'd5 && !rd_start) begin
            wr_flag <= 1'b1;
        end
        else begin
            wr_flag <= 1'b0;
        end
    end

endmodule