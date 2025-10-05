`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/05 18:20:02
// Design Name: 
// Module Name: CMOS_tt
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


module CMOS_tt(

    );

    reg                                 rst_n                       ;
    reg                                 rx_clk_in                   ;

    initial begin
        rst_n = 1'b0;
        rx_clk_in = 1'b0;
        #20;
        rst_n = 1'b1;
    end

    always #5 rx_clk_in = ~rx_clk_in;

    // output declaration of module ad9361_cmos
    wire                                data_clk                    ;

    wire                                tx_clk_out                  ;
    wire                                tx_frame_out                ;
    wire               [  11: 0]        tx_data_out                 ;

    //tx_test 
    wire                                m_axis_data_tvalid          ;
    wire               [  31: 0]        m_axis_data_tdata           ;

    dds_compiler_0 u_dds_compiler_0 (
    .aclk                               (rx_clk_in                 ),
    .aresetn                            (rst_n                     ),
    .m_axis_data_tvalid                 (m_axis_data_tvalid        ),
    .m_axis_data_tdata                  (m_axis_data_tdata         ),
    .m_axis_phase_tvalid                (                          ),
    .m_axis_phase_tdata                 (                          ) 
    );

    wire                                tx_data_valid               ;
    wire               [  11: 0]        tx_data_I                   ;
    wire               [  11: 0]        tx_data_Q                   ;

    assign                              tx_data_valid               = m_axis_data_tvalid   ;
    assign                              tx_data_I                   = m_axis_data_tdata[27:16];
    assign                              tx_data_Q                   = m_axis_data_tdata[11:0];
    
    ad9361_cmos u_ad9361_cmos(
        .ref_clk200m                        (                          ),
        .rst_n                              (rst_n                     ),
        .data_clk                           (data_clk                  ),
        .rx_clk_in                          (rx_clk_in                 ),
        .rx_data_in                         (                          ),
        .rx_frame_in                        (                          ),
        .adc_1r1t_valid                     (                          ),
        .adc_2r2t_valid                     (                          ),
        .adc_data_I1                        (                          ),
        .adc_data_Q1                        (                          ),
        .adc_data_I2                        (                          ),
        .adc_data_Q2                        (                          ),
        .tx_clk_out                         (tx_clk_out                ),
        .tx_frame_out                       (tx_frame_out              ),
        .tx_data_out                        (tx_data_out               ),
        .dac_valid                          (tx_data_valid             ),
        .dac_data_I1                        (tx_data_I                 ),
        .dac_data_Q1                        (tx_data_Q                 ),
        .dac_data_I2                        (                          ),
        .dac_data_Q2                        (                          ),
        .idelay_en                          (                          ),
        .idelay_tap                         (                          ),
        .phy_mode                           (1'b1                      ) 
    );
    
endmodule
