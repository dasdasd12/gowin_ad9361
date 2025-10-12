`timescale 1ns/100ps

module uart_interface (
    input                               clk                        ,//100M 115200 BULD RATE
    input                               rst_n                      ,
    input                               uart_rx                    ,
    output                              uart_tx                    ,
    //spi refresh ctrl
    input                               rd_done                    ,
    input                [   7: 0]      spi_rd_data_reg            ,
    output               [  11: 0]      addr                       ,
    //spi write ctrl
    output               [  19: 0]      wr_data                    ,
    output                              wr_flag                    ,
    output                              rd_start                   
);
    //SPI read data tx ctrl
  uart_tx_cfg u_uart_tx_cfg (
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),

    .uart_tx                            (uart_tx                   ),
    .rd_done                            (rd_done                   ),
    .spi_rd_data_reg                    (spi_rd_data_reg           ),
    .addr                               (addr                      ),
    .tx_done                            (                          ) 
  );

  uart_rx_cfg u_uart_rx_cfg (
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),
    .rx_en                              (1'b1                      ),
    .uart_rx                            (uart_rx                   ),
    .wr_data                            (wr_data                   ),
    .wr_flag                            (wr_flag                   ),
    .rd_start                           (rd_start                  ) 
  );

endmodule