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

module top (
    // input                               clk_p                      ,
    // input                               clk_n                      ,
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
    //output                              ldo_on                     ,
    output                              en_agc                     ,
    output                              sync_in                    ,
    output                              resetb                     ,

    output               [   7: 0]      ctrl_out_led                
);

    wire                                rst_n                       ;

    assign                              ctrl_out_led                = ~ctrl_out            ;

    assign                              rst_n                       = ~rst                 ;

  // output declaration of module clk_wiz_0
  //wire                                clk                         ;
  // wire                                rx_clk                      ;
  // wire                                rx_clk_2x                   ;
  // wire                                locked                      ;

  // clk_wiz_0 u_clk_wiz_0(
  // .clk_out1                           (rx_clk                    ),
  // .clk_out2                           (rx_clk_2x                 ),
  // .resetn                             (rst_n                     ),
  // .locked                             (locked                    ),
  // .clk_in1                            (rx_clk_in                 ) 
  // );

  // IBUFDS #(
  // .CAPACITANCE                        ("DONT_CARE"               ),// "LOW", "NORMAL", "DONT_CARE" (Virtex-4 only)
  // .DIFF_TERM                          ("FALSE"                   ),// Differential Termination (Virtex-4/5, Spartan-3E/3A)
  // .IBUF_DELAY_VALUE                   ("0"                       ),// Specify the amount of added input delay for
  // .IFD_DELAY_VALUE                    ("AUTO"                    ),// Specify the amount of added delay for input
  // .IOSTANDARD                         ("DEFAULT"                 ) // Specify the input I/O standard
  // ) IBUFDS_inst (
  // .O                                  (clk                       ),// Buffer output
  // .I                                  (clk_p                     ),// Diff_p buffer input (connect directly to top-level port)
  // .IB                                 (clk_n                     ) // Diff_n buffer input (connect directly to top-level port)
  // );

  // output declaration of module ad9361_FDD_DDR
  // wire               [  11: 0]        data_out_I                  ;
  // wire               [  11: 0]        data_out_Q                  ;
  // reg                [  11: 0]        data_in_I                   ;
  // reg                [  11: 0]        data_in_Q                   ;

  // output declaration of module spi_reg_cfg
    wire                                init_done                   ;
    //wire               [   7: 0]        spi_rd_data                 ;
    wire                                rd_done                     ;
    wire               [   7: 0]        spi_rd_data_reg             ;
    wire                                tx_done                     ;
    wire               [  11: 0]        addr                        ;
    wire               [  19: 0]        wr_data                     ;
    wire                                wr_flag                     ;
    wire                                rd_start                    ;

  spi_reg_cfg u_spi_reg_cfg (
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),
    .addr                               (addr                      ),

    .spi_enb                            (spi_enb                   ),
    .spi_clk                            (spi_clk                   ),
    .spi_di                             (spi_di                    ),
    .spi_do                             (spi_do                    ),

    //.spi_rd_data                        (spi_rd_data               ),

    .init_done                          (init_done                 ),
    .rd_done                            (rd_done                   ),
    .spi_rd_data_reg                    (spi_rd_data_reg           ),

    .wr_flag                            (wr_flag                   ),
    .wr_data                            (wr_data                   ),
    .rd_start                           (rd_start                  ) 
  );

  uart_tx_cfg u_uart_tx_cfg (
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),

    .uart_tx                            (uart_tx                   ),
    .rd_done                            (rd_done                   ),
    .spi_rd_data_reg                    (spi_rd_data_reg           ),
    .addr                               (addr                      ),
    .tx_done                            (tx_done                   ) 
  );

  uart_rx_cfg u_uart_rx_cfg (
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),
    .rx_en                              (1'b1                      ),
    .uart_rx                            (uart_rx                   ),
    .wr_data                            (wr_data                   ),
    .wr_flag                            (wr_flag                   ),
    .rd_start                           (rd_start                  ) 
  );

  // ad9361_FDD_DDR u_ad9361_FDD_DDR(
  // .tx_clk                             (rx_clk                    ),
  // .tx_clk_2x                          (rx_clk_2x                 ),
  // .rst_n                              (rst_n                     ),
  // .rx_clk_in                          (rx_clk_in                 ),
  // //.rx_frame_in                        (rx_frame_in               ),
  // //.rx_data_in                         (rx_data_in                ),
  // .tx_clk_out                         (tx_clk_out                ),
  // .tx_frame_out                       (tx_frame_out              ),
  // .tx_data_out                        (tx_data_out               ),
  // .txnrx                              (init_done                 ),
  // .enable                             (init_done                 ),
  // .data_in_I                          (data_in_I                 ),
  // .data_in_Q                          (data_in_Q                 ),
  // .data_out_I                         (data_out_I                ),
  // .data_out_Q                         (data_out_Q                ) 
  // );

  // output declaration of module dds_compiler_0
  // wire                                m_axis_data_tvalid          ;
  // wire               [   7: 0]        m_axis_data_tdata           ;
  // wire                                m_axis_phase_tvalid         ;
  // wire               [  31: 0]        m_axis_phase_tdata          ;

  // dds_compiler_0 u_dds_compiler_0(
  // .aclk                               (clk                       ),
  // .aresetn                            (rst_n                     ),
  // .m_axis_data_tvalid                 (m_axis_data_tvalid        ),
  // .m_axis_data_tdata                  (m_axis_data_tdata         ),
  // .m_axis_phase_tvalid                (m_axis_phase_tvalid       ),
  // .m_axis_phase_tdata                 (m_axis_phase_tdata        ) 
  // );

  // reg                [   7: 0]        sin_reg                     ;

  // always@(posedge rx_clk or negedge rst_n) begin
  //     if(!rst_n) begin
  //         sin_reg <= 8'b0;
  //     end
  //     else if(m_axis_data_tvalid) begin
  //         sin_reg <= m_axis_data_tdata;
  //     end
  // end

  // always@(posedge rx_clk or negedge rst_n) begin
  //     if(!rst_n) begin
  //         data_in_I <= 12'b0;
  //         data_in_Q <= 12'b0;
  //     end
  //     else begin
  //         data_in_I <= {sin_reg,4'b0000};
  //         data_in_Q <= 12'b0;
  //     end
  // end

  // reg                [   7: 0]        test_reg                    ;
  // reg                                 init_done                   ;

  // always@(posedge clk or negedge rst_n) begin
  //     if(!rst_n) begin
  //         test_reg <= 8'b0;
  //         init_done <= 1'b0;
  //     end
  //     else if(test_reg == 8'd200) begin
  //         test_reg <= test_reg;
  //         init_done <= 1'b1;
  //     end
  //     else begin
  //         test_reg <= test_reg + 1'b1;
  //     end
  // end

  // ila_0 u_ila_0 (
  // .clk                                (clk                       ),// input wire clk
  // .probe0                             (rx_clk_in                 ),
  // .probe1                             (spi_rd_data               ),
  // .probe2                             (init_done                 ),
  // .probe3                             (ctrl_out                  ) 
  // );
  
  // output declaration of module clk_wiz_1
    wire                                ref_clk200m                 ;
    wire                                locked                      ;
    wire                                clk_12288                   ;

  clk_wiz_1 u_clk_wiz_0 (
    .clk_out1                           (ref_clk200m               ),
    .clk_out2                           (clk_12288                 ),
    .resetn                             (rst_n                     ),
    .locked                             (locked                    ),
    .clk_in1                            (clk                       ) 
  );

  // output declaration of module vio_0
    wire               [   3: 0]        probe_out0                  ;
  
  vio_0 u_vio_0(
    .clk                                (ref_clk200m               ),
    .probe_in0                          (                          ),
    .probe_out0                         (probe_out0                ) 
  );


    wire                                m_axis_data_tvalid          ;
    wire               [  31: 0]        m_axis_data_tdata           ;
    wire                                m_axis_phase_tvalid         ;
    wire               [  31: 0]        m_axis_phase_tdata          ;
    wire                                data_clk                    ;

  dds_compiler_1 u_dds_compiler_0 (
    .aclk                               (data_clk                  ),
    .aresetn                            (rst_n                     ),
    .m_axis_data_tvalid                 (m_axis_data_tvalid        ),
    .m_axis_data_tdata                  (m_axis_data_tdata         ),
    .m_axis_phase_tvalid                (m_axis_phase_tvalid       ),
    .m_axis_phase_tdata                 (m_axis_phase_tdata        ) 
  );

  // output declaration of module ad9361_phy
    wire                                adc_d1q1_valid              ;
    wire               [  11: 0]        adc_data_d1                 ;
    wire               [  11: 0]        adc_data_q1                 ;

    wire                                dac_valid                   ;
    wire               [  11: 0]        dac_data_d1                 ;
    wire               [  11: 0]        dac_data_q1                 ;

  ad9361_phy u_ad9361_phy (
    .ref_clk200m                        (ref_clk200m               ),
    .rst_n                              (rst_n                     ),
    .data_clk                           (data_clk                  ),

    .rx_clk_in_p                        (rx_clk_in_p               ),
    .rx_clk_in_n                        (rx_clk_in_n               ),
    .rx_data_in_p                       (rx_data_in_p              ),
    .rx_data_in_n                       (rx_data_in_n              ),
    .rx_frame_in_p                      (rx_frame_in_p             ),
    .rx_frame_in_n                      (rx_frame_in_n             ),
    .adc_d1q1_valid                     (adc_d1q1_valid            ),
    .adc_d2q2_valid                     (                          ),
    .adc_data_d1                        (adc_data_d1               ),
    .adc_data_q1                        (adc_data_q1               ),
    .adc_data_d2                        (                          ),
    .adc_data_q2                        (                          ),

      //.tx_clk_out_p                       (tx_clk_out_p              ),
      //.tx_clk_out_n                       (tx_clk_out_n              ),
    .tx_frame_out_p                     (tx_frame_out_p            ),
    .tx_frame_out_n                     (tx_frame_out_n            ),
    .tx_data_out_p                      (tx_data_out_p             ),
    .tx_data_out_n                      (tx_data_out_n             ),
    .dac_valid                          (dac_valid                 ),
    .dac_data_d1                        (dac_data_d1               ),
    .dac_data_q1                        (dac_data_q1               ),
    .dac_data_d2                        (                          ),
    .dac_data_q2                        (                          ),

    .idelay_en                          (6'b111_111                ),
    .idelay_tap                         (probe_out0                ),
    .phy_mode                           (1'b1                      ) 
  );

  ila_1 u_ila_1 (
    .clk                                (clk_12288                 ),
    .probe0                             (adc_d1q1_valid            ),
    .probe1                             (adc_data_d1               ),
    .probe2                             (adc_data_q1               ) 
  );

    reg                [  11: 0]        dac_reg_d_0                 ;
    reg                [  11: 0]        dac_reg_q_0                 ;

  always @(posedge data_clk or negedge rst_n) begin
      if (!rst_n) begin
          dac_reg_d_0 <= 12'b0;
          dac_reg_q_0 <= 12'b0;
      end else begin
          dac_reg_d_0 <= m_axis_data_tdata[27:16];
          dac_reg_q_0 <= m_axis_data_tdata[11:0];
      end
  end

    assign                              dac_valid                   = m_axis_data_tvalid   ;

//   parameter space='d0;

//   assign                              dac_data_q1                 = {m_axis_data_tdata[27:16+space], {space{1'b0}}};
//   assign                              dac_data_d1                 = {m_axis_data_tdata[11:0+space], {space{1'b0}}};

    assign                              dac_data_d1                 = m_axis_data_tdata[27:16];
    assign                              dac_data_q1                 = m_axis_data_tdata[11:0];

//   reg data_bit = 1'b0;
//   always @(posedge data_clk or negedge rst_n) begin
//     if (!rst_n) begin
//       data_bit <= 1'b0;
//     end else begin
//       data_bit <= ~data_bit;
//     end
//   end

//   reg [26:0] second_count = 0;

//   always @(posedge data_clk or negedge rst_n) begin
//     if (!rst_n) begin
//       second_count <= 0;
//     end else begin
//       second_count <= second_count + 1'b1;
//     end
//   end

//   reg [3:0] move = 4'd0;
//   always @(posedge data_clk or negedge rst_n) begin
//     if (!rst_n) begin
//       move <= 4'd0;
//     end else if (second_count == 0) begin
//       move <= move + 1'b1;
//       if (move == 4'd11) begin
//         move <= 4'd0;
//       end
//     end
//   end


//   assign dac_data_q1 = {11'b0, data_bit} << move;
//   assign dac_data_d1 = {11'b0, ~data_bit} << move;

  //assign                              dac_data_q1                 = 12'b1111_1111_1101    ;
  //assign                              dac_data_d1                 = 12'h000              ;

    wire                                data_clk_out                ;

  clk_wiz_2 u_clk_wiz_2 (
    .clk_out1                           (data_clk_out              ),
    .clk_in1                            (data_clk                  ) 
  );

  OBUFDS #(
    .IOSTANDARD                         ("LVDS_25"                 ) // Specify the output I/O standard
  ) OBUFDS_inst_clk (
    .O                                  (tx_clk_out_p              ),// Diff_p output
    .OB                                 (tx_clk_out_n              ),// Diff_n output
    .I                                  (data_clk_out              ) // Buffer input
  );

  // ila_1 u_ila_0 (
  // .clk                                (ref_clk200m               ),// input wire clk
  // .probe0                             (dac_data_q1               ),
  // .probe1                             (u_ad9361_phy.phy_tx_inst.tx_data_d1_reg),
  // .probe2                             (u_ad9361_phy.phy_tx_inst.tx_data_q1_reg),
  // .probe3                             (u_ad9361_phy.phy_tx_inst.tx_frame_reg),
  // .probe4                             (u_ad9361_phy.phy_tx_inst.tx_data_posedge_reg),
  // .probe5                             (u_ad9361_phy.phy_tx_inst.data_clk),
  // .probe6                             (u_ad9361_phy.phy_tx_inst.tx_data_negedge_reg) 
  // );

    assign                              resetb                      = rst_n                ;
    assign                              txnrx                       = init_done            ;
    assign                              enable                      = init_done            ;
  // assign                              ldo_on                      = 1'b1                 ;
    assign                              en_agc                      = 1'b0                 ;
    assign                              sync_in                     = 1'b1                 ;

endmodule
