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

module top (
    input                               clk                        ,
    input                               rst                        ,
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

    assign                              sys_clk                     = clk                  ;
    assign                              rst_n                       = ~rst                 ;

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

    // output declaration of module ethernet_interface
    wire                                clk125m                     ;
    wire               [   7: 0]        eth_tx_data                 ;
    wire               [   7: 0]        eth_rx_data                 ;
    wire                                eth_tx_data_valid           ;
    wire                                frame_start                 ;
    wire                                frame_end                   ;
    
    ethernet_interface u_ethernet_interface(
      .rst_n                              (rst_n                     ),
      .clk125m                            (clk125m                   ),

      .tx_data                            (eth_tx_data               ),
      .frame_start                        (frame_end                 ),
      .tx_data_valid                      (eth_tx_data_valid         ),

      .rx_data                            (eth_rx_data               ),
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


    
    // A8pskmod_test u_A8pskmod_test(
    //   .clk                                (data_clk                  ),
    //   .rst_n                              (rst_n                     ),
    //   .tx_data_I                          (tx_data_I                 ),
    //   .tx_data_Q                          (tx_data_Q                 ) 
    // );

    // assign                              tx_data_valid               = 1'b1                 ;
    
    // output declaration of module data_mod

    wire                                data_valid                  ;
    
    data_mod u_data_mod(
      .clk                                (data_clk                  ),
      .rst_n                              (rst_n                     ),
      .frame_start                        (                          ),
      .frame_end                          (                          ),
      .bit_in                             (                          ),
      .data_valid                         (tx_data_valid             ),
      .tx_data_I                          (tx_data_I                 ),
      .tx_data_Q                          (tx_data_Q                 ) 
    );
    

    // output declaration of module Demod
    wire                                valid                       ;
    wire               [   2: 0]        bit_out                     ;
    wire               [11-1: 0]        phase_out                   ;

    reg                                 sample_clk                  ;

    always @(posedge data_clk or negedge rst_n) begin
      if(!rst_n)
        sample_clk <= 1'b0;
      else 
        sample_clk <= ~sample_clk;
    end

    Demod #(
      .DATA_W                             (12                               )                     
    ) u_Demod(
      .clk                                (data_clk                  ),
      .rst_n                              (rst_n                     ),
      .in_i                               (rx_data_I                 ),
      .in_q                               (rx_data_Q                 ),
      .valid                              (valid                     ),
      .bit_out                            (bit_out                   ),
      .phase_out                          (phase_out                 ),
      .frame_start                        (frame_start               ),
      .frame_end                          (frame_end                 )
    );

    // output declaration of module ConvertBuffer
    wire in_ready;
    wire out_valid;
    
    ConvertBuffer #(
      .IN_W                               (3                         ),
      .OUT_W                              (12                        ) 
    ) u_ConvertBuffer(
      .clk                                (data_clk                  ),
      .rst_n                              (rst_n                     ),
      .frame_end                          (                          ),
      .in_ready                           (                          ),
      .in_valid                           (                          ),
      .in_data                            (                          ),
      .out_ready                          (                          ),
      .out_valid                          (                          ),
      .out_data                           (                          ) 
    );
    

    // output declaration of module ConvertBuffer
    
    ConvertBuffer #(
      .IN_W                               (3                         ),
      .OUT_W                              (8                         ) 
    ) tx_ConvertBuffer(
      .clk                                (data_clk                  ),
      .rst_n                              (rst_n                     ),
      .frame_end                          (frame_end                 ),
      .in_ready                           (in_ready                  ),
      .in_valid                           (valid                     ),
      .in_data                            (bit_out                   ),
      .out_ready                          (1'b1                      ),
      .out_valid                          (out_valid                 ),
      .out_data                           (                  ) 
    );

    // output declaration of module async_fifo
    wire                                wfull                       ;
    wire                                awfull                      ;
    wire                                rempty                      ;
    wire                                arempty                     ;
    
    async_fifo #(
      .DSIZE                              (8                         ),
      .ASIZE                              (4                         ) 
    ) u_async_fifo(
      .wclk                               (data_clk                  ),
      .wrst_n                             (rst_n                     ),
      .winc                               (out_valid                 ),
      .wdata                              (out_data                  ),
      .wfull                              (                          ),
      .awfull                             (                          ),
      .rclk                               (clk_125m                  ),
      .rrst_n                             (rst_n                     ),
      .rinc                               (eth_tx_data_valid         ),
      .rdata                              (eth_tx_data               ),
      .rempty                             (                          ),
      .arempty                            (                          ) 
    );
    

    ila_1 u_ila_1(
      .clk                                (data_clk                  ),
      .probe0                             (rx_data_valid             ),
      .probe1                             (rx_data_I                 ),
      .probe2                             (rx_data_Q                 ),
      .probe3                             (valid                     ),
      .probe4                             (bit_out                   ),
      .probe5                             (phase_out                 ),
      .probe6                             (tx_data_I                 ),
      .probe7                             (tx_data_Q                 ),
      .probe8                             (u_Demod.out_i             ),
      .probe9                             (u_Demod.out_q             ),
      .probe10                            (u_Demod.u_Costas.u_PID.data_in_int),
      .probe11                            (u_Demod.u_SignalValid.amp_dc),
      .probe12                            (u_Demod.u_SignalValid.amp_ac),
      .probe13                            (frame_start                 ),
      .probe14                            (frame_end                   ),
      .probe15                            (u_data_mod.state            ),
      .probe16                            (u_Demod.u_SignalValid.amp)
    );
    
endmodule
