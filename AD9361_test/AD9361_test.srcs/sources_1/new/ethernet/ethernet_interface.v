`timescale 1ns/100ps

module ethernet_control (

    input                               sys_clk                    ,
    input                               rst_n                      ,

    output                              e_rst_n                    ,

    output                              mdc                        ,
    inout                               mdio                       ,

    input                [   3: 0]      rgmii_rx_d                 ,
    input                               rgmii_rx_ctl               ,
    input                               rgmii_rx_clk               ,

    output               [   3: 0]      rgmii_tx_d                 ,
    output                              rgmii_tx_ctl               ,
    output                              rgmii_tx_clk                

);

    parameter                           BOARD_MAC                   = 48'h11_45_14_19_19_81     ;//开发板MAC地址
    parameter                           BOARD_IP                    = {8'd192,8'd168,8'd3,8'd2}	;//开发板IP地址
    parameter                           BOARD_PORT                  = 16'h8000                  ;//开发板IP地址-端口 
    parameter                           DES_MAC                     = 48'hff_ff_ff_ff_ff_ff     ;//目的MAC地址
    parameter                           DES_IP                      = {8'd192,8'd168,8'd3,8'd3} ;//目的IP地址
    parameter                           DES_PORT                    = 16'h8000                  ;//目的IP地址-端口 
    parameter                           DATA_SIZE                   = 16'd256                   ;//数据包长度 46~1500 B


    assign                              e_rst_n                     = rst_n               ;

    assign                              mdc                         = 1'b1                 ;
    assign                              mdio                        = 1'b1                 ;

    wire                                clk_125M                    ;

    wire                                locked                      ;

    //add pll ip here

    //add pll ip here

    // output declaration of module GMII_send
    wire               [   7: 0]        GMII_TXD                    ;
    wire                                GMII_TXEN                   ;
    wire                                GMII_TXER                   ;
    
    GMII_send #(
        .BOARD_MAC                          (BOARD_MAC                 ),
        .BOARD_IP                           (BOARD_IP                  ),
        .BOARD_PORT                         (BOARD_PORT                ),
        .DES_MAC                            (DES_MAC                   ),
        .DES_IP                             (DES_IP                    ),
        .DES_PORT                           (DES_PORT                  ),
        .DATA_SIZE                          (DATA_SIZE                 ) 
    ) u_GMII_send(
        .rst_n                              (rst_n                     ),
        .GMII_GTXCLK                        (clk_125M                  ),
        .GMII_TXD                           (GMII_TXD                  ),
        .GMII_TXEN                          (GMII_TXEN                 ),
        .GMII_TXER                          (GMII_TXER                 ) 
    );
   
   gmii_to_rgmii tx_gmii_to_rgmii(
        .reset_n                            (rst_n                     ),
        .gmii_tx_clk                        (clk_125M                  ),
        .gmii_txd                           (GMII_TXD                  ),
        .gmii_txen                          (GMII_TXEN                 ),
        .gmii_txer                          (GMII_TXER                 ),
        .rgmii_tx_clk                       (rgmii_tx_clk              ),
        .rgmii_txd                          (rgmii_tx_d                ),
        .rgmii_txen                         (rgmii_tx_ctl              ) 
   );
   
    

endmodule