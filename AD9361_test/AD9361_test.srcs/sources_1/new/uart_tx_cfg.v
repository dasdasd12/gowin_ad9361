`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/15 20:50:16
// Design Name: 
// Module Name: uart_tx_cfg
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


module uart_tx_cfg(
    input                               clk                        ,
    input                               rst_n                      ,
    input                               rd_done                    ,
    input                [   7: 0]      spi_rd_data_reg            ,
    output                              uart_tx                    ,
    output reg           [  11: 0]      addr                       ,
    output                              tx_done                     
    );

    localparam                          IDLE                        = 2'b00                ,
                                        SEND                        = 2'b01                ;

    localparam                          BIT_NUM                     = 4'd7                 ;

    wire               [  15: 0]        data_ascii                  ;
    wire               [BIT_NUM*8-1: 0] data_per_frame              ;
    wire                                tx_data_ready               ;
    wire               [   7: 0]        tx_data                     ;
    wire               [  23: 0]        addr_ascii                  ;
    wire                                tx_data_valid               ;
    wire                                rd_posedge                  ;
    reg                                 tx_data_valid_reg           ;
    reg                [   3: 0]        tx_cnt                      ;
    reg                [   2: 0]        state                       ;
    reg                                 rd_done_d1                  ;

    assign                              tx_done                     = addr == 12'h1022     ;
    assign                              data_per_frame              = {addr_ascii,8'h20,data_ascii,8'h0A};
    assign                              tx_data                     = data_per_frame[(BIT_NUM-tx_cnt)*8-1 -: 8];
    assign                              tx_data_valid               = rd_done && ~tx_done  ;
    assign                              rd_posedge                  = rd_done & ~rd_done_d1;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rd_done_d1 <= 1'b0;
        end
        else begin
            rd_done_d1 <= rd_done;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            tx_data_valid_reg <= 1'b0;
        end
        else begin
            tx_data_valid_reg <= tx_data_valid;
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            addr <= 12'd0;
        end
        else if(state == IDLE) begin
            addr <= 12'd0;
        end
        else if(state == SEND) begin
            if(rd_done && tx_data_ready && tx_cnt == BIT_NUM-1) begin
                addr <= addr + 12'd1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            tx_cnt <= 4'd0;
        end
        else if(state == SEND && tx_data_ready) begin
            if(tx_cnt == BIT_NUM-1) begin
                tx_cnt <= 4'd0;
            end
            else begin
                tx_cnt <= tx_cnt + 4'd1;
            end
        end
        else begin
            tx_cnt <= tx_cnt;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
        end
        else begin
            case(state)
                IDLE: begin
                    if(rd_posedge && ~tx_done) begin
                        state <= SEND;
                    end
                    else begin
                        state <= IDLE;
                    end
                end
                SEND: begin
                    if (tx_done)
                        state <= IDLE;
                    else
                        state <= SEND;
                end
                default: state <= IDLE;
            endcase
        end
    end

    
    generate
        genvar i;
        for(i=1; i<=3; i=i+1) begin: addr_num2ascii
            ASCII_rom u_ascii_rom (
    .hex_data_in                        (addr[(i*4)-1 -: 4]        ),
    .ascii_data_out                     (addr_ascii[(i*8)-1 -: 8]  ) 
            );
        end
    endgenerate


    generate
        genvar j;
        for(j=1; j<=2; j=j+1) begin: data_num2ascii
            ASCII_rom u_ascii_rom (
    .hex_data_in                        (spi_rd_data_reg[(j*4)-1 -: 4]),
    .ascii_data_out                     (data_ascii[(j*8)-1 -: 8]  ) 
            );
        end
    endgenerate

    uart_tx #(
    .CLK_FRE                            (100                       ),
    .BAUD_RATE                          (115200                    ) 
    ) u_uart_tx(
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),
    .tx_data                            (tx_data                   ),
    .tx_data_valid                      (tx_data_valid & tx_data_valid_reg),
    .tx_data_ready                      (tx_data_ready             ),
    .tx_pin                             (uart_tx                   ) 
    );

endmodule
