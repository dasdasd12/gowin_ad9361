`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/04 16:32:51
// Design Name: 
// Module Name: ad9361_interface_cmos
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


module ad9361_interface_cmos(
        input                               clk                        ,
        input                               rst_n                      ,

        output                              data_clk                   ,//data_ref_clk
        input                               phy_mode                   ,
        input                [  12: 0]      idelay_en                  ,
        input                [   4: 0]      idelay_tap                 ,
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
        output                              resetb                      
    );

    wire                                init_done                   ;
    wire                                ref_clk200m                 ;
    
    clk_wiz_2 u_clk_wiz_2 (
        .clk_out1                           (ref_clk200m               ),
        .clk_in1                            (clk                       ) 
    );

    spi_reg_cfg u_spi_reg_cfg (
        .clk                                (clk                       ),
        .rst_n                              (rst_n                     ),
        .addr                               (addr                      ),

        .spi_enb                            (spi_enb                   ),
        .spi_clk                            (spi_clk                   ),
        .spi_di                             (spi_di                    ),
        .spi_do                             (spi_do                    ),

        .init_done                          (init_done                 ),
        .rd_done                            (rd_done                   ),
        .spi_rd_data_reg                    (spi_rd_data_reg           ),

        .wr_flag                            (wr_flag                   ),
        .wr_data                            (wr_data                   ),
        .rd_start                           (rd_start                  ) 
    );

    // output declaration of module ad9361_cmos
    wire                                dac_valid                   ;
    wire               [  11: 0]        dac_data_I1                 ;
    wire               [  11: 0]        dac_data_Q1                 ;

    wire                                adc_1r1t_valid              ;
    wire                                adc_2r2t_valid              ;
    wire               [  11: 0]        adc_data_I1                 ;
    wire               [  11: 0]        adc_data_Q1                 ;

    assign                              rx_data_I                   = adc_data_I1          ;
    assign                              rx_data_Q                   = adc_data_Q1          ;
    assign                              rx_data_valid               = adc_1r1t_valid       ;

    assign                              dac_valid                   = tx_data_valid        ;
    assign                              dac_data_I1                 = tx_data_I            ;
    assign                              dac_data_Q1                 = tx_data_Q            ;


    ad9361_cmos u_ad9361_cmos(
        .ref_clk200m                        (ref_clk200m               ),
        .rst_n                              (rst_n                     ),
        .data_clk                           (data_clk                  ),

        .rx_clk_in                          (rx_clk_in                 ),
        .rx_data_in                         (rx_data_in                ),
        .rx_frame_in                        (rx_frame_in               ),

        .adc_1r1t_valid                     (adc_1r1t_valid            ),
        .adc_2r2t_valid                     (                          ),
        .adc_data_I1                        (adc_data_I1               ),
        .adc_data_Q1                        (adc_data_Q1               ),
        .adc_data_I2                        (                          ),
        .adc_data_Q2                        (                          ),

        .tx_clk_out                         (tx_clk_out                ),
        .tx_frame_out                       (tx_frame_out              ),
        .tx_data_out                        (tx_data_out               ),

        .dac_valid                          (dac_valid                 ),
        .dac_data_I1                        (dac_data_I1               ),
        .dac_data_Q1                        (dac_data_Q1               ),
        .dac_data_I2                        (                          ),
        .dac_data_Q2                        (                          ),

        .idelay_en                          (idelay_en                 ),
        .idelay_tap                         (idelay_tap                ),
        .phy_mode                           (phy_mode                  ) 
    );
    
    assign                              resetb                      = rst_n                ;
    assign                              txnrx                       = init_done            ;
    assign                              enable                      = init_done            ;
    assign                              en_agc                      = 1'b0                 ;
    assign                              sync_in                     = 1'b1                 ;

    assign                              ctrl_out_led                = ~ctrl_out            ;

endmodule
