`timescale 1ns / 100ps

module mod_data(
    input                               clk_125m                   ,
    input                               data_clk                   ,
    input                               rst_n                      ,

    input                [   7: 0]      eth_rx_data                ,
    input                               eth_rx_data_valid          ,
    input                [  15: 0]      eth_rx_data_length         ,
    input                               one_pkg_done               ,
    input                               pkg_error                  ,

    output               [  11: 0]      tx_data_I                  ,
    output               [  11: 0]      tx_data_Q                  ,
    output                              tx_data_valid               

);
    wire                                bit_clk                     ;
    wire                                in_ready                    ;
    wire                                frame_end                   ;
    wire               [   2: 0]        bit_in                      ;
    wire                                bit_valid                   ;
    wire               [   7: 0]        pkg_fifo_data               ;
    wire                                data_valid                  ;

    reg                                 data_vaild_d0               ;
    wire                                data_valid_rise             ;
    
    always @(posedge bit_clk or negedge rst_n) begin
      if (!rst_n) begin
          data_vaild_d0 <= 1'b0;
      end
      else
          data_vaild_d0 <= data_valid;
    end

    assign                              data_valid_rise             = data_valid && (~data_vaild_d0);

    wire                                convert_valid               ;

    wire                                rempty                      ;

    assign                              convert_valid               = data_valid && ~rempty;

    async_fifo #(
      .DSIZE                              (8                         ),
      .ASIZE                              (12                        )
      ) u_async_fifo(
      .wclk                               (clk_125m                  ),
      .wrst_n                             (rst_n                     ),
      .winc                               (eth_rx_data_valid         ),
      .wdata                              (eth_rx_data               ),
      .wfull                              (                          ),
      .awfull                             (                          ),
      .rclk                               (bit_clk                   ),
      .rrst_n                             (rst_n                     ),
      .rinc                               (data_valid&&in_ready      ),
      .rdata                              (pkg_fifo_data             ),
      .rempty                             (rempty                    ),
      .arempty                            (                          ) 
    );

    reg convert_end;

    always @(posedge bit_clk or negedge rst_n) begin
      if (!rst_n) begin
          convert_end <= 1'b0;
      end
      else if (rempty == 1'b1 && in_ready == 1'b1) begin
          convert_end <= 1'b1;
      end
      else if(data_valid_rise) begin
          convert_end <= 1'b0;
      end
      else 
          convert_end <= convert_end;
    end

    reg convert_end_d0;

    always @(posedge bit_clk or negedge rst_n) begin
      if (!rst_n) begin
          convert_end_d0 <= 1'b0;
      end
      else begin
          convert_end_d0 <= convert_end;
      end
    end

    wire convert_end_pulse;

    assign convert_end_pulse = tx_data_valid && convert_end && (~convert_end_d0);


    wire                                convert_rstn                ;
    assign                              convert_rstn                = rst_n & (~frame_end) ;

    wire                                bit_in_valid                ;

    

    ConvertBuffer #(
      .IN_W                               (8                         ),
      .OUT_W                              (3                         ) 
    ) u_ConvertBuffer_test(
        .clk                                (bit_clk                   ),
        .rst_n                              (convert_rstn              ),
        .frame_end                          (convert_end_pulse         ),
        .in_ready                           (in_ready                  ),
        .in_valid                           (convert_valid             ),
        .in_data                            (pkg_fifo_data             ),
        .out_ready                          (bit_valid                 ),
        .out_valid                          (bit_in_valid              ),
        .out_data                           (bit_in                    ) 
    );

    data_mod u_data_mod(
        .clk                                (data_clk                  ),
        .rst_n                              (rst_n                     ),
        .bit_clk                            (bit_clk                   ),

        .frame_start                        (eth_rx_data_valid         ),
        .frame_end                          (frame_end                 ),
        
        .bit_in                             (bit_in                    ),
        .bit_in_valid                       (bit_in_valid              ),
        .byte_num                           (eth_rx_data_length[11:0]  ),
        .bit_valid                          (bit_valid                 ),

        .data_valid                         (data_valid                ),
        .tx_data_valid                      (tx_data_valid             ),
        .tx_data_I                          (tx_data_I                 ),
        .tx_data_Q                          (tx_data_Q                 ) 
    );

endmodule