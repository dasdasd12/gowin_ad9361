`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/04 16:44:56
// Design Name: 
// Module Name: ad9361_cmos
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


module ad9361_cmos(
    input  wire                         ref_clk200m                ,//200m idelay ctrl ref clock
    input  wire                         rst_n                      ,
    output wire                         data_clk                   ,
	
	//ad936x io port
    input  wire                         rx_clk_in                  ,
    input  wire          [  11: 0]      rx_data_in                 ,
    input  wire                         rx_frame_in                ,

	//adc result
    output wire                         adc_1r1t_valid             ,
    output wire                         adc_2r2t_valid             ,
    output wire          [  11: 0]      adc_data_I1                ,
    output wire          [  11: 0]      adc_data_Q1                ,
    output wire          [  11: 0]      adc_data_I2                ,
    output wire          [  11: 0]      adc_data_Q2                ,
	//ad936x io tx
    output wire                         tx_clk_out                 ,
    output wire                         tx_frame_out               ,
    output wire          [  11: 0]      tx_data_out                ,

	// dac  output 
    input  wire                         dac_valid                  ,
    input  wire          [  11: 0]      dac_data_I1                ,
    input  wire          [  11: 0]      dac_data_Q1                ,
    input  wire          [  11: 0]      dac_data_I2                ,
    input  wire          [  11: 0]      dac_data_Q2                ,
	//var load idelay signals
    input  wire          [  12: 0]      idelay_en                  ,
    input  wire          [   4: 0]      idelay_tap                 ,
    input  wire                         phy_mode                    //==1 is r1 mode;  == 2 is r2 mode
    );

    wire                                sync_rstn                   ;
    reg                                 rst_n_r3_reg                ;
    reg                                 rst_n_r2_reg                ;
    reg                                 rst_n_r1_reg                ;
    reg                                 rst_n_r0_reg                ;

    always@(posedge data_clk)begin
        rst_n_r3_reg                <=              rst_n_r2_reg;
        rst_n_r2_reg                <=              rst_n_r1_reg;
        rst_n_r1_reg                <=              rst_n_r0_reg;
        rst_n_r0_reg                <=              rst_n;
    end

    assign                              sync_rstn                   = rst_n_r3_reg         ;

    // output declaration of module cmos_rx
    cmos_rx u_cmos_rx(
        .ref_clk200m                        (ref_clk200m               ),
        .rst_n                              (sync_rstn                 ),
        .data_clk                           (data_clk                  ),
        .rx_clk_in                          (rx_clk_in                 ),
        .rx_data_in                         (rx_data_in                ),
        .rx_frame_in                        (rx_frame_in               ),
        .adc_1r1t_valid                     (adc_1r1t_valid            ),
        .adc_2r2t_valid                     (adc_2r2t_valid            ),
        .adc_data_I1                        (adc_data_I1               ),
        .adc_data_Q1                        (adc_data_Q1               ),
        .adc_data_I2                        (adc_data_I2               ),
        .adc_data_Q2                        (adc_data_Q2               ),
        .idelay_en                          (idelay_en                 ),
        .idelay_tap                         (idelay_tap                ),
        .phy_mode                           (phy_mode                  ) 
    );

    // output declaration of module cmos_tx
    cmos_tx u_cmos_tx(
        .rst_n                              (sync_rstn                 ),
        .data_clk                           (data_clk                  ),
        
        .tx_clk_out                         (tx_clk_out                ),
        .tx_frame_out                       (tx_frame_out              ),
        .tx_data_out                        (tx_data_out               ),

        .dac_valid                          (dac_valid                 ),
        .dac_data_I1                        (dac_data_I1               ),
        .dac_data_Q1                        (dac_data_Q1               ),
        .dac_data_I2                        (dac_data_I2               ),
        .dac_data_Q2                        (dac_data_Q2               ),
        .phy_mode                           (phy_mode                  ) 
    );
    
    


endmodule
