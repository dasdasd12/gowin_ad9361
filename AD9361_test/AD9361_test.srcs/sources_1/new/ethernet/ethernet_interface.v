`timescale 1ns/100ps

module ethernet_interface (

    input                               rst_n                      ,

    output                              clk125m                    ,

    input                [   7: 0]      tx_data                    ,
    input                               frame_start                ,
    output                              tx_data_valid              ,


    output               [   7: 0]      rx_data                    ,
    //RGMII interface  
    output                              e_rst_n                    ,
    output                              mdc                        ,
    inout                               mdio                       ,

    input                [   3: 0]      rgmii_rxd                  ,
    input                               rgmii_rx_ctl               ,
    input                               rgmii_rx_clk               ,

    output               [   3: 0]      rgmii_txd                  ,
    output                              rgmii_tx_ctl               ,
    output                              rgmii_tx_clk                

);

    parameter LOCAL_MAC  = 48'h00_0a_35_01_fe_c0;
    parameter LOCAL_IP   = 32'hc0_a8_00_02;
    parameter LOCAL_PORT = 16'd5000;
    parameter DST_MAC    = 48'hFF_FF_FF_FF_FF_FF;
    parameter DST_IP     = 32'hc0_a8_00_03;
    parameter DST_PORT   = 16'd6102;

    assign                              e_rst_n                     = rst_n                ;
    assign                              mdc                         = 1'b1                 ;
    assign                              mdio                        = 1'b1                 ;

    // output declaration of module eth_udp_tx_gmii
    wire                                gmii_tx_clk                 ;
    wire               [   7: 0]        gmii_txd                    ;
    wire                                gmii_txen                   ;

    wire                                tx_done                     ;

    wire               [  15: 0]        data_length                 ;
   
    eth_udp_tx_gmii u_eth_udp_tx_gmii(
        .clk125m                            (clk125m                   ),
        .reset_p                            (rst_n                     ),

        .tx_en_pulse                        (frame_start               ),
        .tx_done                            (tx_done                   ),

        .dst_mac                            (DST_MAC                   ),
        .src_mac                            (LOCAL_MAC                 ),
        .dst_ip                             (DST_IP                    ),
        .src_ip                             (LOCAL_IP                  ),
        .dst_port                           (DST_PORT                  ),
        .src_port                           (LOCAL_PORT                ),


        .data_length                        (data_length               ),
        .payload_req_o                      (tx_data_valid             ),
        .payload_dat_i                      (tx_data                   ),

        .gmii_tx_clk                        (gmii_tx_clk               ),
        .gmii_txd                           (gmii_txd                  ),
        .gmii_txen                          (gmii_txen                 ) 
    );
   
    gmii_to_rgmii tx_gmii_to_rgmii(
        .reset_n                            (                          ),
        .gmii_tx_clk                        (gmii_tx_clk               ),
        .gmii_txd                           (gmii_txd                  ),
        .gmii_txen                          (gmii_txen                 ),
        .gmii_txer                          (1'b0                      ),
        .rgmii_tx_clk                       (rgmii_tx_clk              ),
        .rgmii_txd                          (rgmii_txd                 ),
        .rgmii_txen                         (rgmii_tx_ctl              ) 
    );

    // output declaration of module eth_udp_rx_gmii
    wire                                gmii_rx_clk                 ;
    wire                                gmii_rx_rxd                 ;
    wire                                gmii_rxdv                   ;

    wire               [  15: 0]        rx_data_length              ;
    wire                                payload_valid_o             ;
    wire               [   7: 0]        payload_dat_o               ;

    wire                                one_pkt_done                ;
    wire                                pkt_error                   ;
    wire               [  31: 0]        debug_crc_check             ;
    
    eth_udp_rx_gmii u_eth_udp_rx_gmii(
        .reset_p                            (rst_n                     ),

        .local_mac                          (LOCAL_MAC                 ),
        .local_ip                           (LOCAL_IP                  ),
        .local_port                         (LOCAL_PORT                ),

        .clk125m_o                          (clk125m                   ),
        
        .exter_mac                          (                          ),
        .exter_ip                           (                          ),
        .exter_port                         (                          ),

        .rx_data_length                     (rx_data_length            ),
        .data_overflow_i                    (                          ),
        .payload_valid_o                    (payload_valid_o           ),
        .payload_dat_o                      (payload_dat_o             ),

        .one_pkt_done                       (one_pkt_done              ),
        .pkt_error                          (pkt_error                 ),
        .debug_crc_check                    (debug_crc_check           ),

        .gmii_rx_clk                        (gmii_rx_clk               ),
        .gmii_rxd                           (gmii_rxd                  ),
        .gmii_rxdv                          (gmii_rxdv                 ) 
    );

    rgmii_to_gmii rx_rgmii_to_gmii(
        .reset                              (                          ),
        .rgmii_rx_clk                       (rgmii_rx_clk              ),
        .rgmii_rxd                          (rgmii_rxd                 ),
        .rgmii_rxdv                         (rgmii_rx_ctl              ),
        .gmii_rx_clk                        (gmii_rx_clk               ),
        .gmii_rxd                           (gmii_rxd                  ),
        .gmii_rxdv                          (gmii_rxdv                 ),
        .gmii_rxer                          (                          ) 
    );
    

endmodule