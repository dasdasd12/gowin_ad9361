`timescale 1ns / 100ps

module ad9361_FDD_DDR (
    input                               tx_clk                     ,
    input                               tx_clk_2x                  ,
    input                               rst_n                      ,

    input                               rx_clk_in                  ,
    //input                               rx_frame_in                ,
    //input                [  11: 0]      rx_data_in                 ,

    output                              tx_clk_out                 ,
    output reg                          tx_frame_out               ,
    output reg           [  11: 0]      tx_data_out                ,

    input                               txnrx                      ,
    input                               enable                     ,

    input                [  11: 0]      data_in_I                  ,
    input                [  11: 0]      data_in_Q                  ,
    output               [  11: 0]      data_out_I                 ,
    output               [  11: 0]      data_out_Q                  
    );

    wire                                rx_clk                      ;

    assign                              rx_clk                      = rx_clk_in            ;
    assign                              tx_clk_out                  = tx_clk               ;

    always@(negedge tx_clk_2x or negedge rst_n) begin
        if(!rst_n) begin
            tx_frame_out <= 1'b0;
            tx_data_out  <= 12'd0;
        end
        else if(enable) begin
            if(tx_clk == 1'b0) begin
                tx_frame_out <= 1'b1;
                tx_data_out  <= data_in_I;                              //transmit I data only
            end
            if(tx_clk == 1'b1) begin
                tx_frame_out <= 1'b0;
                tx_data_out  <= data_in_Q;                              //transmit Q data only
            end
        end
        else begin
            tx_frame_out <= 1'b0;
            tx_data_out  <= 12'd0;
        end
    end
    
endmodule