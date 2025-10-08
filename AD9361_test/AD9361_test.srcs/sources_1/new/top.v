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

//`define ULTRASCALE
`define ZYNQ

module top (

  `ifdef ZYNQ
    input                               clk                        ,
    input                               rst                        ,
  `elsif ULTRASCALE
    input                               clk_p                      ,
    input                               clk_n                      ,
    output                              ldo_on                     ,
  `endif
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

    `ifdef ZYNQ
      assign                              sys_clk                     = clk                  ;
      assign                              rst_n                       = ~rst                 ;
    `elsif ULTRASCALE
      IBUFDS #(
        .DIFF_TERM                          ("FALSE"                   ),
        .IBUF_LOW_PWR                       ("FALSE"                   ) 
      ) IBUFDS_inst (
        .O                                  (sys_clk                   ),
        .I                                  (clk_p                     ),
        .IB                                 (clk_n                     ) 
      );
      assign                              ldo_on                      = 1'b1                 ;
      assign                              rst_n                       = 1'b1                 ;
    `endif




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
  
    // wire                                m_axis_data_tvalid          ;
    // wire               [  31: 0]        m_axis_data_tdata           ;
    // wire                                m_axis_phase_tvalid         ;
    // wire               [  31: 0]        m_axis_phase_tdata          ;

  // `ifdef ZYNQ
  // dds_compiler_1 u_dds_compiler_1 (
  //   .aclk                               (data_clk                  ),
  //   .aresetn                            (rst_n                     ),
  //   .m_axis_data_tvalid                 (m_axis_data_tvalid        ),
  //   .m_axis_data_tdata                  (m_axis_data_tdata         ),
  //   .m_axis_phase_tvalid                (m_axis_phase_tvalid       ),
  //   .m_axis_phase_tdata                 (m_axis_phase_tdata        ) 
  // );
  // `elsif ULTRASCALE
  // dds_compiler_0 u_dds_compiler_0 (
  //   .aclk                               (data_clk                  ),
  //   .aresetn                            (rst_n                     ),
  //   .m_axis_data_tvalid                 (m_axis_data_tvalid        ),
  //   .m_axis_data_tdata                  (m_axis_data_tdata         ),
  //   .m_axis_phase_tvalid                (m_axis_phase_tvalid       ),
  //   .m_axis_phase_tdata                 (m_axis_phase_tdata        ) 
  // );
  // `endif 

  //   assign                              tx_data_valid               = m_axis_data_tvalid   ;
  //   assign                              tx_data_I                   = m_axis_data_tdata[27:16];
  //   assign                              tx_data_Q                   = m_axis_data_tdata[11:0];

  A8pskmod_test u_A8pskmod_test(
      .clk                                (data_clk                  ),
      .rst_n                              (rst_n                     ),
      .tx_data_I                          (tx_data_I                 ),
      .tx_data_Q                          (tx_data_Q                 ) 
    );

    assign tx_data_valid = 1'b1;

    // output declaration of module Demod
    wire                                valid                       ;
    wire               [   2: 0]        bit_out                     ;
    wire               [11-1: 0]        phase_out                   ;
    
    Demod #(
      .DATA_W                             (12                               )                     
    ) u_Demod(
      .clk                                (data_clk                  ),
      .rst_n                              (rst_n                     ),
      .in_i                               (rx_data_I                 ),
      .in_q                               (rx_data_Q                 ),
      .valid                              (valid                     ),
      .bit_out                            (bit_out                   ),
      .phase_out                          (phase_out                 ) 
    );

    ila_1 u_ila_1(
      .clk                                (data_clk                  ),
      .probe0                             (rx_data_valid             ),
      .probe1                             (rx_data_I                 ),
      .probe2                             (rx_data_Q                 ),
      .probe3                             (valid                     ),
      .probe4                             (bit_out                   ),
      .probe5                             (phase_out                 )
    );
    
    
endmodule
