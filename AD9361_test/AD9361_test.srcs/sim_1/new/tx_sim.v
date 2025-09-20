`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/11 10:14:30
// Design Name: 
// Module Name: tx_sim
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


module tx_sim(

    );

    reg                                 clk                         ;
    reg                                 rst                         ;

    reg                                 rx_clk_in_p                 ;
    reg                                 rx_clk_in_n                 ;
    reg                                 spi_do                      ;

    // output declaration of module top

    initial begin
        clk         = 1'b0;
        rst         = 1'b1;
        rx_clk_in_p = 1'b0;
        rx_clk_in_n = 1'b1;
        spi_do      = 1'b0;
        #100
        rst         = 1'b0;
    end

    always #5 clk = ~clk;
    always #15 rx_clk_in_p = ~rx_clk_in_p;
    always #15 rx_clk_in_n = ~rx_clk_in_n;
    always #200 spi_do =~spi_do;
    
    // output declaration of module top
    wire                                uart_tx                     ;
    wire                                spi_di                      ;
    wire                                spi_enb                     ;
    wire                                spi_clk                     ;
    wire                                tx_clk_out_p                ;
    wire                                tx_clk_out_n                ;
    wire                                tx_frame_out_p              ;
    wire                                tx_frame_out_n              ;
    wire               [   5: 0]        tx_data_out_p               ;
    wire               [   5: 0]        tx_data_out_n               ;
    wire               [   3: 0]        ctrl_in                     ;
    wire                                txnrx                       ;
    wire                                enable                      ;
    wire                                en_agc                      ;
    wire                                sync_in                     ;
    wire                                resetb                      ;
    
    top u_top(
    .clk                                (clk                       ),
    .rst                                (rst                       ),
    .uart_tx                            (uart_tx                   ),
    .spi_do                             (spi_do                    ),
    .spi_di                             (spi_di                    ),
    .spi_enb                            (spi_enb                   ),
    .spi_clk                            (spi_clk                   ),
    .rx_clk_in_p                        (rx_clk_in_p               ),
    .rx_clk_in_n                        (rx_clk_in_n               ),
    .rx_frame_in_p                      (                          ),
    .rx_frame_in_n                      (                          ),
    .rx_data_in_p                       (                          ),
    .rx_data_in_n                       (                          ),
    .tx_clk_out_p                       (tx_clk_out_p              ),
    .tx_clk_out_n                       (tx_clk_out_n              ),
    .tx_frame_out_p                     (tx_frame_out_p            ),
    .tx_frame_out_n                     (tx_frame_out_n            ),
    .tx_data_out_p                      (tx_data_out_p             ),
    .tx_data_out_n                      (tx_data_out_n             ),
    .ctrl_in                            (ctrl_in                   ),
    .txnrx                              (txnrx                     ),
    .enable                             (enable                    ),
    .en_agc                             (en_agc                    ),
    .sync_in                            (sync_in                   ),
    .resetb                             (resetb                    ) 
    );

    uart_rx uart_tt(
        .clk                                (clk                       ),
        .rst_n                              (~rst                      ),
        .rx_data                            (rx_data                   ),
        .rx_data_valid                      (rx_data_valid             ),
        .rx_data_ready                      (rx_data_ready             ),
        .rx_pin                             (uart_rx                   )
    );
    
    
    
endmodule
