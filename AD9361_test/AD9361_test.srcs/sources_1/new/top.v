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
    wire                                clk125m                     ;

    clk_wiz_0 u_clk_wiz_0(
      .clk_in1                            (sys_clk                   ),
      .clk_out1                           (clk_125m                  )
    );

    wire               [  15: 0]        data_length                 ;
    wire               [   7: 0]        eth_tx_data                 ;
    wire                                eth_tx_done                 ;
    wire                                eth_tx_data_valid           ;

    wire               [   7: 0]        eth_rx_data                 ;

    wire                                frame_start                 ;
    wire                                frame_end                   ;
    
    ethernet_interface u_ethernet_interface(
      .rst_n                              (rst_n                     ),
      .clk125m                            (clk_125m                  ),

      .data_length                        (data_length               ),
      .tx_data                            (eth_tx_data               ),
      .tx_data_valid                      (eth_tx_data_valid         ),
      .tx_done                            (eth_tx_done               ),

      .frame_start                        (frame_end                 ),

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

    //////////////////////////////////////////////////////////////////////////
    //
    //
    //  //TODO   DATA PROCESSING AND TRANSMMIT MODULE                      
    //
    // 
    //////////////////////////////////////////////////////////////////////////

    wire pkg_end;
    wire pkg_on;
    wire fifo_on;
    wire [7:0] pkg_data;

    reg pkg_end_d1;
    reg pkg_end_d2;

    always @(posedge clk_125m or negedge rst_n) begin
      if(!rst_n) begin
        pkg_end_d1 <= 1'b0;
        pkg_end_d2 <= 1'b0;
      end else begin
        pkg_end_d1 <= pkg_end;
        pkg_end_d2 <= pkg_end_d1;
      end
    end

    reg [9:0] pkg_cnt;

    
    // output declaration of module async_fifo
    wire               [   2: 0]        tx_data_test                ;
    wire               [   7: 0]        pkg_fifo_data               ;
    wire                                tx_data_test_valid          ;
    wire                                refresh                     ;
    
    async_fifo #(
      .DSIZE                              (8                         ),
      .ASIZE                              (4                         ),
      .FALLTHROUGH                        ("FALSE"                   ) 
      ) u_async_fifo(
      .wclk                               (clk_125m                  ),
      .wrst_n                             (rst_n                     ),
      .winc                               (pkg_on                    ),
      .wdata                              (pkg_data                  ),
      .wfull                              (                          ),
      .awfull                             (                          ),
      .rclk                               (data_clk                  ),
      .rrst_n                             (rst_n                     ),
      .rinc                               (fifo_on                   ),
      .rdata                              (pkg_fifo_data             ),
      .rempty                             (                          ),
      .arempty                            (                          ) 
    );

    ConvertBuffer #(
      .IN_W                               (8                         ),
      .OUT_W                              (3                         ) 
    ) u_ConvertBuffer_test(
      .clk                                (data_clk                  ),
      .rst_n                              (refresh                   ),
      .frame_end                          (                          ),
      .in_ready                           (                          ),
      .in_valid                           (pkg_on                    ),
      .in_data                            (pkg_fifo_data             ),
      .out_ready                          (1'b1                      ),
      .out_valid                          (tx_data_test_valid        ),
      .out_data                           (tx_data_test              ) 
    );

    data_mod u_data_mod(
      .clk                                (data_clk                  ),
      .rst_n                              (rst_n                     ),
      .frame_start                        (                          ),
      .frame_end                          (                          ),
      .bit_in                             (tx_data_test              ),
      .data_valid                         (tx_data_valid             ),
      .tx_data_I                          (tx_data_I                 ),
      .tx_data_Q                          (tx_data_Q                 ) 
    );
    

    // output declaration of module Demod
    wire                                valid                       ;
    wire               [   2: 0]        bit_out                     ;
    wire               [11-1: 0]        phase_out                   ;

    reg                                 frame_end_d0                ;
    reg                                 frame_end_d1                ;

    always @(posedge data_clk or negedge rst_n) begin
      if(!rst_n) begin
        frame_end_d0 <= 1'b0;
        frame_end_d1 <= 1'b0;
      end else begin
        frame_end_d0 <= frame_end;
        frame_end_d1 <= frame_end_d0;
      end
    end

    Demod #(
      .DATA_W                             (12                               )                     
    ) u_Demod(
      .clk                                (data_clk                  ),
      .rst_n                              (rst_n_demod               ),
      .in_i                               (rx_data_I                 ),
      .in_q                               (rx_data_Q                 ),
      .valid                              (valid                     ),
      .bit_out                            (bit_out                   ),
      .phase_out                          (phase_out                 ),
      .frame_start                        (frame_start               ),
      .frame_end                          (frame_end                 )
    );

    wire                                valid_328                   ;
    wire                                valid_3212                  ;

    reg                [  12: 0]        data_cnt                    ;

    always @(posedge data_clk or negedge rst_n) begin
      if(!rst_n)
        data_cnt <= 13'd0;
      else if(frame_end)
        data_cnt <= 13'd0;
      else if(valid)
        data_cnt <= data_cnt + 1'b1;
    end

    assign                              valid_328                   = (data_cnt >  12'd3) ? valid : 1'b0;
    assign                              valid_3212                  = (data_cnt <= 12'd3) ? valid : 1'b0;

    // output declaration of module ConvertBuffer
    wire                                out_valid_12                ;
    wire               [  11: 0]        out_data_12                 ;
    
    ConvertBuffer #(
      .IN_W                               (3                         ),
      .OUT_W                              (12                        ),
      .SIZE                               (12                        )
    ) u_ConvertBuffer(
      .clk                                (data_clk                  ),
      .rst_n                              (~frame_end_d1             ),
      .frame_end                          (                          ),
      .in_ready                           (                          ),
      .in_valid                           (valid_3212                ),
      .in_data                            (bit_out                   ),
      .out_ready                          (1'b1                      ),
      .out_valid                          (out_valid_12              ),
      .out_data                           (out_data_12               ) 
    );
    
    async_fifo #(
      .DSIZE                              (12                         ),
      .ASIZE                              (2                          ),
      .FALLTHROUGH                        ("FALSE"                    )
    ) tx_data_num_async_fifo(
      .wclk                               (data_clk                  ),
      .wrst_n                             (rst_n                     ),
      .winc                               (out_valid_12              ),
      .wdata                              (out_data_12               ),
      .wfull                              (                          ),
      .awfull                             (                          ),
      .rclk                               (clk_125m                  ),
      .rrst_n                             (rst_n                     ),
      .rinc                               (eth_tx_done               ),
      .rdata                              (data_length               ),
      .rempty                             (                          ),
      .arempty                            (                          ) 
    );

    // output declaration of module ConvertBuffer
    wire                                out_valid_8                 ;
    wire               [   7: 0]        out_data_8                  ;

    ConvertBuffer #(
      .IN_W                               (3                         ),
      .OUT_W                              (8                         ) 
    ) tx_ConvertBuffer(
      .clk                                (data_clk                  ),
      .rst_n                              (~frame_end_d1             ),
      .frame_end                          (frame_end                 ),
      .in_ready                           (in_ready                  ),
      .in_valid                           (valid_328                 ),
      .in_data                            (bit_out                   ),
      .out_ready                          (1'b1                      ),
      .out_valid                          (out_valid_8               ),
      .out_data                           (out_data_8                ) 
    );
    
    async_fifo #(
      .DSIZE                              (8                         ),
      .ASIZE                              (12                        ),
      .FALLTHROUGH                        ("FALSE"                   ) 
    ) tx_data_async_fifo(
      .wclk                               (data_clk                  ),
      .wrst_n                             (rst_n                     ),
      .winc                               (out_valid_8               ),
      .wdata                              (out_data_8                ),
      .wfull                              (                          ),
      .awfull                             (                          ),
      .rclk                               (clk_125m                  ),
      .rrst_n                             (rst_n                     ),
      .rinc                               (eth_tx_data_valid         ),
      .rdata                              (eth_tx_data               ),
      .rempty                             (                          ),
      .arempty                            (                          ) 
    );

    //////////////////////////////////////////////////////////////////////////
    //
    //
    //  //TODO   DEBUG PORT ILA MODULE                         
    //
    // 
    //////////////////////////////////////////////////////////////////////////

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
      .probe13                            (u_Demod.frame_start       ),
      .probe14                            (u_Demod.state             ),
      .probe15                            (u_data_mod.state          ),
      .probe16                            (u_Demod.u_SignalValid.amp ),
      .probe17                            (u_Demod.u_DeltaDecode.valid_in) 
    );

    ila_0 u_ila_0(
      .clk                                (data_clk                  ),
      .probe0                             (tx_data_I                 ),
      .probe1                             (tx_data_Q                 ),
      .probe2                             (rx_data_I                 ),
      .probe3                             (rx_data_Q                 ),
      .probe4                             (valid                     ),
      .probe5                             (bit_out                   ),  
      .probe6                             (frame_start               ),
      .probe7                             (frame_end                 ),
      .probe8                             (valid_3212                ),
      .probe9                             (valid_328                 ),
      .probe10                            (data_cnt                  ),
      .probe11                            (out_data_12               ),
      .probe12                            (out_valid_12              ),
      .probe13                            (out_data_8                ),
      .probe14                            (out_valid_8               )
    );

    ila_2 u_ila_2(
      .clk                                (clk_125m                  ),
      .probe0                             (eth_tx_data               ),
      .probe1                             (eth_tx_data_valid         ),
      .probe2                             (eth_tx_done               ),
      .probe3                             (data_length               ),
      .probe4                             (u_ethernet_interface.frame_start_d2),
      .probe5                             (out_data_test             ),
      .probe6                             (out_valid_test            ) 
    );
    
endmodule
