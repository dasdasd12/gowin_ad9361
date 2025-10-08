`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/04 16:11:59
// Design Name: 
// Module Name: top
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


module top(
    input                               clk                        ,

    //uart
    input                               uart_rx                    ,
    output                              uart_tx                    ,

    //spi
    input                               spi_do                     ,
    output                              spi_di                     ,
    output                              spi_enb                    ,
    output                              spi_clk                    ,
    //ad9361
    input                               rx_clk_in                  ,
    input                               rx_frame_in                ,
    input                [  11: 0]      rx_data_in                 ,

    output                              tx_clk_out                 ,
    output                              tx_frame_out               ,
    output               [  11: 0]      tx_data_out                ,

    input                [   7: 0]      ctrl_out                   ,//out of 9361
    output               [   3: 0]      ctrl_in                    ,//in of 9361
    output                              txnrx                      ,
    output                              enable                     ,
    output                              en_agc                     ,
    output                              sync_in                    ,
    output                              resetb                     ,

    output               [   7: 0]      ctrl_out_led                
    );

    wire                                rst_n                       ;
    wire                                tx_clk_out_0                ;

    assign                              rst_n                       = 1'b1                 ;

    // output declaration of module uart_interface
    wire                                rd_done                     ;
    wire               [  11: 0]        addr                        ;
    wire               [  19: 0]        wr_data                     ;
    wire                                wr_flag                     ;
    wire                                rd_start                    ;
    wire               [   7: 0]        spi_rd_data_reg             ;

    uart_interface u_uart_interface(
        .clk                                (clk                       ),
        .rst_n                              (rst_n                     ),

        .uart_rx                            (uart_rx                   ),
        .uart_tx                            (uart_tx                   ),
        //command for ad9361_interface_cmos
        .rd_done                            (rd_done                   ),
        .spi_rd_data_reg                    (spi_rd_data_reg           ),
        .addr                               (addr                      ),
        .wr_data                            (wr_data                   ),
        .wr_flag                            (wr_flag                   ),
        .rd_start                           (rd_start                  ) 
    );

    // output declaration of module ad9361_interface_cmos
    wire                                data_clk                    ;
    wire               [  12: 0]        idelay_en                   ;
    wire               [   4: 0]        idelay_tap                  ;
    wire                                phy_mode                    ;

    wire                                rx_data_valid               ;
    wire               [  11: 0]        rx_data_I                   ;
    wire               [  11: 0]        rx_data_Q                   ;

    wire                                tx_data_valid               ;
    wire               [  11: 0]        tx_data_I                   ;
    wire               [  11: 0]        tx_data_Q                   ;

    assign phy_mode                   = 1'b1                  ;//1R1T
    assign idelay_tap                 = 5'd10                 ;
    assign idelay_en                  = 13'b1_1111_1111_1111  ;
    
    ad9361_interface_cmos u_ad9361_interface_cmos(
        .clk                                (clk                       ),
        .rst_n                              (rst_n                     ),

        .data_clk                           (data_clk                  ),
        .idelay_en                          (idelay_en                 ),
        .idelay_tap                         (idelay_tap                ),
        .phy_mode                           (phy_mode                  ),      //1R1T
        .ctrl_out_led                       (ctrl_out_led              ),

        .tx_data_valid                      (tx_data_valid             ),
        .tx_data_I                          (tx_data_I                 ),
        .tx_data_Q                          (tx_data_Q                 ),

        .rx_data_valid                      (rx_data_valid             ),
        .rx_data_I                          (rx_data_I                 ),
        .rx_data_Q                          (rx_data_Q                 ),

        .addr                               (addr                      ),
        .rd_done                            (rd_done                   ),
        .spi_rd_data_reg                    (spi_rd_data_reg           ),
        .wr_data                            (wr_data                   ),
        .wr_flag                            (wr_flag                   ),
        .rd_start                           (rd_start                  ),

        .spi_do                             (spi_do                    ),
        .spi_di                             (spi_di                    ),
        .spi_enb                            (spi_enb                   ),
        .spi_clk                            (spi_clk                   ),

        .rx_clk_in                          (rx_clk_in                 ),
        .rx_frame_in                        (rx_frame_in               ),
        .rx_data_in                         (rx_data_in                ),

        .tx_clk_out                         (tx_clk_out                ),       //phase is ajudstable
        .tx_frame_out                       (tx_frame_out              ),
        .tx_data_out                        (tx_data_out               ),

        .ctrl_out                           (ctrl_out                  ),
        .ctrl_in                            (ctrl_in                   ),
        .txnrx                              (txnrx                     ),
        .enable                             (enable                    ),
        .en_agc                             (en_agc                    ),
        .sync_in                            (sync_in                   ),
        .resetb                             (resetb                    ) 
    );
    
    //tx_test 
    wire                                m_axis_data_tvalid          ;
    wire               [  31: 0]        m_axis_data_tdata           ;

    dds_compiler_0 u_dds_compiler_0 (
      .aclk                               (clk                       ),
      .aresetn                            (rst_n                     ),
      .m_axis_data_tvalid                 (m_axis_data_tvalid        ),
      .m_axis_data_tdata                  (m_axis_data_tdata         ),
      .m_axis_phase_tvalid                (                          ),
      .m_axis_phase_tdata                 (                          ) 
    );

    assign                              tx_data_valid               = m_axis_data_tvalid   ;
    assign                              tx_data_I                   = m_axis_data_tdata[27:16];
    assign                              tx_data_Q                   = m_axis_data_tdata[11:0];

    // clk_wiz_0 u_clk_wiz_0 (
    //     .clk_out1                           (tx_clk_out                ),
    //     .clk_in1                            (data_clk                  ) // input wire clk_in1
    // );

    ila_0 u_ila_0 (
        .clk                                (data_clk                       ),// input wire clk

        .probe0                             (u_ad9361_interface_cmos.u_ad9361_cmos.u_cmos_tx.tx_data_posedge_reg                 ),// input wire [0:0]  probe3 
        .probe1                             (u_ad9361_interface_cmos.u_ad9361_cmos.u_cmos_tx.tx_data_negedge_reg                 ),// input wire [11:0]  probe4 
        .probe2                             (u_ad9361_interface_cmos.init_done                                                   ),
        .probe3                             (rd_done                                                                             )
    );


endmodule
