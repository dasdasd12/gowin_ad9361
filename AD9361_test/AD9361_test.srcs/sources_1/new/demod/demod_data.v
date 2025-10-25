`timescale 1ns/100ps

module demod_data(
    input                               clk_125m                   ,
    input                               data_clk                   ,
    input                               rst_n                      ,
    input                               rst_n_demod                ,
    
    input                [  11: 0]      rx_data_I                  ,
    input                [  11: 0]      rx_data_Q                  ,

    output                              eth_tx_start               ,
    input                               eth_tx_data_valid          ,
    output               [   8: 0]      eth_tx_data                ,
    output               [  15: 0]      eth_tx_data_length         ,
    input                               eth_tx_done                

    );

    wire                                frame_end                   ;
    wire                                frame_start                 ;

    assign                             eth_tx_start               = frame_end;

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
      .DATA_W                             (12                        ) 
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

    reg                [  15: 0]        data_cnt                    ;

    always @(posedge data_clk or negedge rst_n) begin
      if(!rst_n)
        data_cnt <= 16'd0;
      else if(frame_end)
        data_cnt <= 16'd0;
      else if(valid)
        data_cnt <= data_cnt + 1'b1;
    end

    assign                              valid_3212                  = (data_cnt <= 12'd3) ? valid : 1'b0;
    

    // output declaration of module ConvertBuffer
    wire                                out_valid_12                ;
    wire               [  11: 0]        out_data_12                 ;

    reg                                 eth_tx_done_d1              ;

    always @(posedge clk_125m or negedge rst_n) begin
      if(!rst_n)
        eth_tx_done_d1 <= 1'b0;
      else
        eth_tx_done_d1 <= eth_tx_done;
    end

    wire                                fifo_rst_n                  ;

    assign                              fifo_rst_n                  = rst_n & (~eth_tx_done_d1);
    
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
      .DSIZE                              (12                        ),
      .ASIZE                              (2                         )
    ) tx_data_num_async_fifo(
      .wclk                               (data_clk                  ),
      .wrst_n                             (rst_n                     ),
      .winc                               (out_valid_12              ),
      .wdata                              (out_data_12               ),
      .wfull                              (                          ),
      .awfull                             (                          ),
      .rclk                               (clk_125m                  ),
      .rrst_n                             (rst_n                     ),
      .rinc                               (frame_end                 ),
      .rdata                              (eth_tx_data_length        ),
      .rempty                             (                          ),
      .arempty                            (                          ) 
    );

    // output declaration of module ConvertBuffer
    wire                                out_valid_8                 ;
    wire               [   7: 0]        out_data_8                  ;
    wire                                convert_done_8              ;

    reg                [  12: 0]        byte_cnt                    ;

    always @(posedge data_clk or negedge rst_n) begin
      if(!rst_n)
        byte_cnt <= 13'd0;
      else if(frame_end)
        byte_cnt <= 13'd0;
      else if(out_valid_8)
        byte_cnt <= byte_cnt + 1'b1;
    end

    assign                              convert_done_8                 = (byte_cnt == out_data_12 && data_cnt > 12'd3) ? 1'b1 : 1'b0;
    assign                              valid_328                      = (data_cnt >  12'd3) ? (convert_done_8 ? 1'b0 : valid) : 1'b0;

    ConvertBuffer #(
      .IN_W                               (3                         ),
      .OUT_W                              (8                         ) 
    ) tx_ConvertBuffer(
      .clk                                (data_clk                  ),
      .rst_n                              (~frame_end_d1             ),
      .frame_end                          (                          ),
      .in_ready                           (                          ),
      .in_valid                           (valid_328                 ),
      .in_data                            (bit_out                   ),
      .out_ready                          (1'b1                      ),
      .out_valid                          (out_valid_8               ),
      .out_data                           (out_data_8                ) 
    );
    
    async_fifo #(
      .DSIZE                              (8                         ),
      .ASIZE                              (12                        )
    ) tx_data_async_fifo(
      .wclk                               (data_clk                  ),
      .wrst_n                             (fifo_rst_n                ),
      .winc                               (out_valid_8               ),
      .wdata                              (out_data_8                ),
      .wfull                              (                          ),
      .awfull                             (                          ),
      .rclk                               (clk_125m                  ),
      .rrst_n                             (fifo_rst_n                ),
      .rinc                               (eth_tx_data_valid         ),
      .rdata                              (eth_tx_data               ),
      .rempty                             (                          ),
      .arempty                            (                          ) 
    );

endmodule