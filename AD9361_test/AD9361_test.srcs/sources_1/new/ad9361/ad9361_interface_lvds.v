`timescale 1ns / 100ps


module ad9361_interface_lvds (
    input                               clk                        ,
    input                               rst_n                      ,
    output                              data_clk                   ,//data_ref_clk
    output               [   7: 0]      ctrl_out_led               ,//led show ctrl_out   

    input                               tx_data_valid              ,//tx data valid
    input                [  11: 0]      tx_data_I                  ,//input data 
    input                [  11: 0]      tx_data_Q                  ,//input data

    output                              rx_data_valid              ,
    output               [  11: 0]      rx_data_I                  ,//output data
    output               [  11: 0]      rx_data_Q                  ,//output data

    //uart cfg
    input                [  11: 0]      addr                       ,
    output                              rd_done                    ,
    output               [   7: 0]      spi_rd_data_reg            ,

    input                [  19: 0]      wr_data                    ,
    input                               wr_flag                    ,
    input                               rd_start                   ,

    //spi for ad9361
    input                               spi_do                     ,
    output                              spi_di                     ,
    output                              spi_enb                    ,
    output                              spi_clk                    ,

    //ad9361 interface
    input                               rx_clk_in_p                ,
    input                               rx_clk_in_n                ,
    input                               rx_frame_in_p              ,
    input                               rx_frame_in_n              ,
    input                [   5: 0]      rx_data_in_p               ,
    input                [   5: 0]      rx_data_in_n               ,

    output                              tx_clk_out_p               ,
    output                              tx_clk_out_n               ,
    output                              tx_frame_out_p             ,
    output                              tx_frame_out_n             ,
    output               [   5: 0]      tx_data_out_p              ,
    output               [   5: 0]      tx_data_out_n              ,

    input                [   7: 0]      ctrl_out                   ,//out of 9361
    output               [   3: 0]      ctrl_in                    ,//in of 9361
    output                              txnrx                      ,
    output                              enable                     ,
    //output                              ldo_on                     ,
    output                              en_agc                     ,
    output                              sync_in                    ,
    output                              resetb                      

);

    wire                                init_done                   ;

    wire                                ref_clk200m                 ;
    wire                                locked                      ;

    wire                                data_clk_out                ;

  `ifdef ZYNQ
  //输入数据延迟控制时钟
  clk_wiz_1 u_clk_wiz_1 (
    .clk_out1                           (ref_clk200m               ),
    .resetn                             (rst_n                     ),
    .locked                             (locked                    ),
    .clk_in1                            (clk                       ) 
  );
  //输出时钟相位控制
  clk_wiz_2 u_clk_wiz_2 (
    .clk_out1                           (data_clk_out              ),
    .clk_in1                            (data_clk                  ) 
  );

  `endif

  spi_reg_cfg u_spi_reg_cfg (
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),
    .addr                               (addr                      ),

    .spi_enb                            (spi_enb                   ),
    .spi_clk                            (spi_clk                   ),
    .spi_di                             (spi_di                    ),
    .spi_do                             (spi_do                    ),

    //.spi_rd_data                        (spi_rd_data               ),

    .init_done                          (init_done                 ),
    .rd_done                            (rd_done                   ),
    .spi_rd_data_reg                    (spi_rd_data_reg           ),

    .wr_flag                            (wr_flag                   ),
    .wr_data                            (wr_data                   ),
    .rd_start                           (rd_start                  ) 
  );

  `ifdef ZYNQ
  OBUFDS #(
    .IOSTANDARD                         ("LVDS_25"                 ) // Specify the output I/O standard
  ) OBUFDS_inst_clk (
    .O                                  (tx_clk_out_p              ),// Diff_p output
    .OB                                 (tx_clk_out_n              ),// Diff_n output
    .I                                  (data_clk_out              ) // Buffer input
  );
  `endif

  ad9361_phy u_ad9361_phy (
    .ref_clk200m                        (ref_clk200m               ),
    .rst_n                              (rst_n                     ),
    .data_clk                           (data_clk                  ),

    .rx_clk_in_p                        (rx_clk_in_p               ),
    .rx_clk_in_n                        (rx_clk_in_n               ),
    .rx_data_in_p                       (rx_data_in_p              ),
    .rx_data_in_n                       (rx_data_in_n              ),
    .rx_frame_in_p                      (rx_frame_in_p             ),
    .rx_frame_in_n                      (rx_frame_in_n             ),
    .adc_d1q1_valid                     (rx_data_valid             ),
    .adc_data_d1                        (rx_data_I                 ),
    .adc_data_q1                        (rx_data_Q                 ),

    .tx_frame_out_p                     (tx_frame_out_p            ),
    .tx_frame_out_n                     (tx_frame_out_n            ),
    .tx_data_out_p                      (tx_data_out_p             ),
    .tx_data_out_n                      (tx_data_out_n             ),
    .dac_valid                          (tx_data_valid             ),
    .dac_data_d1                        (tx_data_I                 ),
    .dac_data_q1                        (tx_data_Q                 ),

    .idelay_en                          (6'b111_111                ),
    .idelay_tap                         (4'd0                      ),
    .phy_mode                           (1'b1                      ) 
  );

    assign                              resetb                      = rst_n                ;
    assign                              txnrx                       = init_done            ;
    assign                              enable                      = init_done            ;
    assign                              en_agc                      = 1'b0                 ;
    assign                              sync_in                     = 1'b1                 ;

    assign                              ctrl_out_led                = ~ctrl_out            ;

endmodule