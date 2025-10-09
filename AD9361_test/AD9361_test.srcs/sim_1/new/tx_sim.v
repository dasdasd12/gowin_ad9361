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
    reg                [   7: 0]        tx_data                     ;
    reg                                 tx_data_valid               ;
    wire tx_data_ready;

    // output declaration of module top

    task send1word;
        input [7:0] data;
        begin
            tx_data_valid = 1'b1;
            tx_data = data;
            repeat(3) @(negedge clk);
            wait(tx_data_ready);
            tx_data_valid = 1'b0;
        end
    endtask

    task send_string;
        input integer word_num;
        input [8*256-1:0] data; // 支持最长256字节，可根据需要调整
        integer i;
        begin
            for(i=0;i<word_num;i=i+1) begin
                send1word(data[8*(word_num-i)-1 -: 8]);
            end
        end
    endtask

    // parameter WORD_NUM = 5;
    // reg [7:0] tx_data_array[0:WORD_NUM-1] = "00811";
    integer j;

    initial begin
        tx_data = 8'h0;
        tx_data_valid = 1'b0;
        clk = 1'b0;
        rst = 1'b1;
        rx_clk_in_p = 1'b0;
        rx_clk_in_n = 1'b1;
        spi_do = 1'b0;
        #100
        rst = 1'b0;
        // #2000000

        // for(j=0;j<WORD_NUM;j=j+1) begin
        //     tx_data = tx_data_array[j];
        //     send1word(tx_data);
        // end
        // send_string(5,"00811");
        // wait(u_top.u_spi_reg_cfg.spi_wr_end);
        // send_string(5,"fffff");

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
    wire                                uart_rx                     ;
    wire                                rx_data_ready               ;
    
    top u_top(
    .clk                                (clk                       ),
    .rst                                (rst                       ),
    .uart_tx                            (uart_rx                   ),
    .uart_rx                            (uart_tx                   ),
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

    uart_tx #(
        .CLK_FRE(100),
        .BAUD_RATE(115200)
    )
    uart_tt(
    .clk                                (clk                       ),
    .rst_n                              (~rst                      ),
    .tx_data                            (tx_data                   ),
    .tx_data_valid                      (tx_data_valid             ),
    .tx_data_ready                      (tx_data_ready             ),
    .tx_pin                             (uart_tx                   ) 
    );
    
    
    
endmodule
