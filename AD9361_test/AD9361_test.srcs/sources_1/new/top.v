`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/10 11:31:28
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

`define ZYNQ
// `define GOWIN

module top (
    input                               clk                        ,
    input                               rst                        ,
    input                               rst_demod                  ,
    //uart 
    input                               uart_rx                    ,
    output                              uart_tx                    ,

    //spi
    input                               spi_do                     ,
    output                              spi_di                     ,
    output                              spi_enb                    ,
    output                              spi_clk                    ,
    //ad9361
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

    output                              en_agc                     ,
    output                              sync_in                    ,
    output                              resetb                     ,

    output               [   7: 0]      ctrl_out_led                
);
    
    wire                                sys_clk                     ;
    wire                                rst_n                       ;
    wire                                rst_n_demod                 ;

    assign                              sys_clk                     = clk                  ;
    assign                              rst_n                       = ~rst                 ;
    assign                              rst_n_demod                 = ~rst_demod           ;
    
    //////////////////////////////////////////////////////////////////////////
    //
    //
    //  //TODO    AD9361 CONFIG AND INTERFACE MODULE                          
    //
    // 
    //////////////////////////////////////////////////////////////////////////

    //output declaration of module uart_interface
    wire                                uart_tx_busy                ;
    wire                                uart_rx_valid               ;
    wire               [   7: 0]        uart_rx_data                ;

    wire               [  11: 0]        addr                        ;
    wire                                rd_done                     ;
    wire               [   7: 0]        spi_rd_data_reg             ;
    wire               [  19: 0]        wr_data                     ;
    wire                                wr_flag                     ;
    wire                                rd_start                    ;

    uart_interface u_uart_interface (
      .clk                                (sys_clk                   ),
      .rst_n                              (rst_n                     ),

      .uart_rx                            (uart_rx                   ),
      .uart_tx                            (uart_tx                   ),

      .rd_done                            (rd_done                   ),
      .spi_rd_data_reg                    (spi_rd_data_reg           ),
      .addr                               (addr                      ),
      .wr_data                            (wr_data                   ),
      .wr_flag                            (wr_flag                   ),
      .rd_start                           (rd_start                  ) 
    );

    // output declaration of module ad9361_interface_lvds
    wire                                data_clk                    ;
    
    wire                                rx_data_valid               ;
    wire               [  11: 0]        rx_data_I                   ;
    wire               [  11: 0]        rx_data_Q                   ;

    wire                                tx_data_valid               ;
    wire               [  11: 0]        tx_data_I                   ;
    wire               [  11: 0]        tx_data_Q                   ;

    ad9361_interface_lvds u_ad9361_interface_lvds(
      .clk                                (sys_clk                   ),
      .rst_n                              (rst_n                     ),

      .data_clk                           (data_clk                  ),
      .ctrl_out_led                       (ctrl_out_led              ),

      .tx_data_valid                      (tx_data_valid             ),
      .tx_data_I                          (tx_data_Q                 ),
      .tx_data_Q                          (tx_data_I                 ),

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

      .rx_clk_in_p                        (rx_clk_in_p               ),
      .rx_clk_in_n                        (rx_clk_in_n               ),
      .rx_frame_in_p                      (rx_frame_in_p             ),
      .rx_frame_in_n                      (rx_frame_in_n             ),
      .rx_data_in_p                       (rx_data_in_p              ),
      .rx_data_in_n                       (rx_data_in_n              ),

      .tx_clk_out_p                       (tx_clk_out_p              ),
      .tx_clk_out_n                       (tx_clk_out_n              ),
      .tx_frame_out_p                     (tx_frame_out_p            ),
      .tx_frame_out_n                     (tx_frame_out_n            ),
      .tx_data_out_p                      (tx_data_out_p             ),
      .tx_data_out_n                      (tx_data_out_n             ),

      .ctrl_out                           (ctrl_out                  ),
      .ctrl_in                            (ctrl_in                   ),
      .txnrx                              (txnrx                     ),
      .enable                             (enable                    ),
      .en_agc                             (en_agc                    ),
      .sync_in                            (sync_in                   ),
      .resetb                             (resetb                    ) 
    );

    //////////////////////////////////////////////////////////////////////////
    //
    //
    //  //TODO    ETHERNET INTERFACE TX AND RX MODULE                          
    //
    // 
    //////////////////////////////////////////////////////////////////////////

    // output declaration of module ethernet_interface
    wire                                clk_125m                     ;   //this clock is used for debug

    clk_wiz_0 u_clk_wiz_0(
      .clk_in1                            (sys_clk                   ),
      .clk_out1                           (clk_125m                  )
    );

    wire               [  15: 0]        eth_tx_data_length          ;
    wire               [   7: 0]        eth_tx_data                 ;
    wire                                eth_tx_done                 ;
    wire                                eth_tx_data_valid           ;
    wire                                eth_tx_start                ;

    
    ethernet_interface u_ethernet_interface(
      .rst_n                              (rst_n                     ),
      .clk125m                            (clk_125m                  ),

      .data_length                        (eth_tx_data_length        ),
      .tx_data                            (eth_tx_data               ),
      .tx_data_valid                      (eth_tx_data_valid         ),
      .tx_done                            (eth_tx_done               ),
      .frame_start                        (eth_tx_start              ),

      .rx_data                            (                          ),
      //ethernet interface
      .e_rst_n                            (e_rst_n                   ),
      .mdc                                (mdc                       ),
      .mdio                               (mdio                      ),
      .rgmii_rxd                          (rgmii_rxd                 ),
      .rgmii_rx_ctl                       (rgmii_rx_ctl              ),
      .rgmii_rx_clk                       (rgmii_rx_clk              ),
      .rgmii_txd                          (rgmii_txd                 ),
      .rgmii_tx_ctl                       (rgmii_tx_ctl              ),
      .rgmii_tx_clk                       (rgmii_tx_clk              ) 
    );

    //////////////////////////////////////////////////////////////////////////
    //
    //
    //  //TODO   DATA PROCESSING AND TRANSMMIT MODULE                      
    //
    // 
    //////////////////////////////////////////////////////////////////////////
    
    // output declaration of module test_module
    wire               [   7: 0]        eth_rx_data                 ;
    wire                                eth_rx_data_valid           ;
    wire               [  15: 0]        eth_rx_data_length          ;
    wire                                one_pkg_done                ;
    wire                                pkg_error                   ;
    
    test_module u_test_module(
      .clk_125m                           (clk_125m                  ),
      .rst_n                              (rst_n                     ),

      .eth_rx_data                        (eth_rx_data               ),
      .eth_rx_data_valid                  (eth_rx_data_valid         ),
      .eth_rx_data_length                 (eth_rx_data_length        ),
      .one_pkg_done                       (one_pkg_done              ),
      .pkg_error                          (pkg_error                 ) 
    );

    mod_data u_mod_data(
      .clk_125m                           (clk_125m                  ),
      .data_clk                           (data_clk                  ),
      .rst_n                              (rst_n                     ),

      .eth_rx_data                        (eth_rx_data               ),
      .eth_rx_data_valid                  (eth_rx_data_valid         ),
      .eth_rx_data_length                 (eth_rx_data_length        ),
      .one_pkg_done                       (one_pkg_done              ),
      .pkg_error                          (pkg_error                 ),

      .tx_data_I                          (tx_data_I                 ),
      .tx_data_Q                          (tx_data_Q                 ),
      .tx_data_valid                      (tx_data_valid             ) 
    );   
    
    demod_data u_demod_data(
      .clk_125m                           (clk_125m                  ),
      .data_clk                           (data_clk                  ),
      .rst_n                              (rst_n                     ),
      .rst_n_demod                        (rst_n_demod               ),

      .rx_data_I                          (rx_data_I                 ),
      .rx_data_Q                          (rx_data_Q                 ),

      .eth_tx_start                       (eth_tx_start              ),
      .eth_tx_data_valid                  (eth_tx_data_valid         ),
      .eth_tx_data                        (eth_tx_data               ),
      .eth_tx_data_length                 (eth_tx_data_length        ),
      .eth_tx_done                        (eth_tx_done               ) 
    );

    `ifdef ZYNQ

    //////////////////////////////////////////////////////////////////////////
    //
    //
    //  //TODO   DEBUG PORT ILA MODULE                         
    //
    // 
    //////////////////////////////////////////////////////////////////////////

    // ila_1 u_ila_1(
    //   .clk                                (data_clk                  ),
    //   .probe0                             (rx_data_valid             ),
    //   .probe1                             (rx_data_I                 ),
    //   .probe2                             (rx_data_Q                 ),
    //   .probe3                             (u_demod_data.valid                     ),
    //   .probe4                             (u_demod_data.bit_out                   ),
    //   .probe5                             (u_demod_data.phase_out                 ),
    //   .probe6                             (tx_data_I                 ),
    //   .probe7                             (tx_data_Q                 ),
    //   .probe8                             (u_demod_data.u_Demod.out_i             ),
    //   .probe9                             (u_demod_data.u_Demod.out_q             ),
    //   .probe10                            (u_demod_data.u_Demod.u_Costas.u_PID.data_in_int),
    //   .probe11                            (u_demod_data.u_Demod.u_SignalValid.amp_dc),
    //   .probe12                            (u_demod_data.u_Demod.u_SignalValid.amp_ac),
    //   .probe13                            (u_demod_data.u_Demod.frame_start       ),
    //   .probe14                            (u_demod_data.u_Demod.state             ),
    //   .probe15                            (u_demod_data.u_Demod.u_SignalValid.amp ),
    //   .probe16                            (u_demod_data.u_Demod.u_DeltaDecode.valid_in) 
    // );

    ila_0 u_ila_0(
      .clk                                (data_clk                  ),
      .probe0                             (tx_data_I                 ),
      .probe1                             (tx_data_Q                 ),
      .probe2                             (rx_data_I                 ),
      .probe3                             (rx_data_Q                 ),
      .probe4                             (u_demod_data.valid        ),
      .probe5                             (u_demod_data.bit_out      ),  
      .probe6                             (u_demod_data.frame_start  ),
      .probe7                             (u_demod_data.frame_end    ),
      .probe8                             (u_demod_data.valid_3212   ),
      .probe9                             (u_demod_data.valid_328    ),
      .probe10                            (u_demod_data.data_cnt     ),
      .probe11                            (u_demod_data.out_data_12  ),
      .probe12                            (u_demod_data.out_valid_12 ),
      .probe13                            (u_demod_data.out_data_8   ),
      .probe14                            (u_demod_data.out_valid_8  ),
      .probe15                            (u_demod_data.byte_cnt     ),
      .probe16                            (u_demod_data.convert_done_8)
    );

    ila_2 u_ila_2(
      .clk                                (clk_125m                  ),
      .probe0                             (eth_tx_data               ),
      .probe1                             (eth_tx_data_valid         ),
      .probe2                             (eth_tx_done               ),
      .probe3                             (eth_tx_data_length        ),
      .probe4                             (u_ethernet_interface.frame_start_d2),
      .probe5                             (eth_rx_data             ),
      .probe6                             (eth_rx_data_valid       ),
      .probe7                             (eth_rx_data_length      ),
      .probe8                             (one_pkg_done            ),
      .probe9                             (pkg_error               )
    );

    `endif
    
endmodule
