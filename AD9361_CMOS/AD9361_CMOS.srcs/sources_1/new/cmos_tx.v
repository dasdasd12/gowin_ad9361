`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/04 16:48:04
// Design Name: 
// Module Name: cmos_tx
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


module cmos_tx(
    input  wire                         rst_n                      ,
    input  wire                         data_clk                   ,
	
    output wire                         tx_clk_out                 ,
    output wire                         tx_frame_out               ,
    output wire          [  11: 0]      tx_data_out                ,


    input  wire                         dac_valid                  ,
    input  wire          [  11: 0]      dac_data_I1                ,
    input  wire          [  11: 0]      dac_data_Q1                ,
    input  wire          [  11: 0]      dac_data_I2                ,
    input  wire          [  11: 0]      dac_data_Q2                ,
	
    input  wire                         phy_mode                    
    );

    parameter                           PHY_MODE_1R1T               = 1                    ;
    parameter                           PHY_MODE_2R2T               = 0                    ;

    //reg define
    reg                [   1: 0]        tx_data_cnt_reg             ;
    reg                [  11: 0]        tx_data_I1_reg              ;
    reg                [  11: 0]        tx_data_Q1_reg              ;
    reg                [  11: 0]        tx_data_I2_reg              ;
    reg                [  11: 0]        tx_data_Q2_reg              ;
    reg                [  11: 0]        tx_data_posedge_reg         ;
    reg                [  11: 0]        tx_data_negedge_reg         ;
    reg                                 tx_frame_reg                ;
    reg                                 tx_data_valid_reg           ;

    wire               [   2: 0]        tx_data_switch              ;

    //data cnt counter
    always @(posedge data_clk or negedge rst_n) begin
        if(!rst_n)begin
            tx_data_valid_reg<=1'b0;
        end
        else begin
            case(phy_mode)
                PHY_MODE_2R2T:begin                                     //2T2R
                    if(dac_valid == 1'b0 && tx_data_valid_reg == 1'b1 && tx_data_cnt_reg == 'd1)
                        tx_data_valid_reg <= 1'b0;
                    else if(dac_valid == 1'b1) 
                        tx_data_valid_reg <= 1'b1;
                end
                PHY_MODE_1R1T:begin                                 //1T1R
                    if(dac_valid == 1'b0 && tx_data_valid_reg == 1'b1)
                        tx_data_valid_reg <= 1'b0;
                    else if(dac_valid == 1'b1) 
                        tx_data_valid_reg <= 1'b1;
                end
                default:;
            endcase
        end
    end

    always @(posedge data_clk or negedge rst_n) begin
        if(!rst_n)begin
            tx_data_cnt_reg<='d0;
        end
        else begin
            if(tx_data_valid_reg == 1'b1 )begin
                case(phy_mode)
                    PHY_MODE_1R1T:begin                                 //1T1R
                        tx_data_cnt_reg <= 'd0;
                    end
                    PHY_MODE_2R2T:begin                                 //2T2R
                        if(tx_data_cnt_reg == 'd1) 
                            tx_data_cnt_reg <= 'd0;
                        else 
                            tx_data_cnt_reg <= tx_data_cnt_reg + 'd1;
                    end
                    default:;
                endcase
            end
        end
    end

    assign                              tx_data_switch              = {phy_mode,tx_data_cnt_reg};

    //input data regester
    always @(posedge data_clk or negedge rst_n) begin
        if(!rst_n)begin
            tx_data_I1_reg<='d0;
            tx_data_Q1_reg<='d0;
            tx_data_I2_reg<='d0;
            tx_data_Q2_reg<='d0;
        end
        else begin
            if(dac_valid == 1'b1&&tx_frame_reg) begin
                tx_data_I1_reg <= dac_data_I1;
                tx_data_Q1_reg <= dac_data_Q1;
                tx_data_I2_reg <= dac_data_I2;
                tx_data_Q2_reg <= dac_data_Q2;
            end
        end
    end

    //tx data out logical
    always @(posedge data_clk or negedge rst_n) begin
        if(!rst_n)begin
            tx_frame_reg<=1'b1;
            tx_data_posedge_reg<='d0;
            tx_data_negedge_reg<='d0;
        end
        else begin
            if(tx_data_valid_reg)begin
                case(tx_data_switch)
                3'b100: begin                                       // 1R1T
                    tx_frame_reg <= 1'b1;
                    tx_data_posedge_reg <= tx_data_I1_reg;
                    tx_data_negedge_reg <= tx_data_Q1_reg;
                end
                3'b001:begin                                  //2R2T
                    tx_frame_reg <= 1'b0;
                    tx_data_posedge_reg <= tx_data_I2_reg;
                    tx_data_negedge_reg <= tx_data_Q2_reg;
                end
                3'b000:begin
                    tx_frame_reg <= 1'b1;
                    tx_data_posedge_reg <= tx_data_I1_reg;
                    tx_data_negedge_reg <= tx_data_Q1_reg;
                end
                default : begin
                    tx_frame_reg <= 1'b0;
                    tx_data_posedge_reg <= 0;
                    tx_data_negedge_reg <= 0;
                end
                endcase
            end
        end
    end

    wire                                tx_frame_out_1r1t           ;
    wire                                tx_frame_out_2r2t           ;

    //CLK
    ODDR #(
        .DDR_CLK_EDGE                       ("SAME_EDGE"               ),// "OPPOSITE_EDGE" or "SAME_EDGE" 
        .INIT                               (1'b0                      ),// Initial value of Q: 1'b0 or 1'b1
        .SRTYPE                             ("SYNC"                    ) // Set/Reset type: "SYNC" or "ASYNC" 
    ) ODDR_data_clk_inst (
        .Q                                  (tx_clk_out                ),// 1-bit DDR output
        .C                                  (data_clk                  ),// 1-bit clock input
        .CE                                 (1'b1                      ),// 1-bit clock enable input
        .D1                                 (1'b0                      ),// 1-bit data input (positive edge)
        .D2                                 (1'b1                      ),// 1-bit data input (negative edge)
        .R                                  (1'b0                      ),// 1-bit reset
        .S                                  (1'b0                      ) // 1-bit set
    );
    //FRAME
    ODDR #(
        .DDR_CLK_EDGE                       ("SAME_EDGE"               ),// "OPPOSITE_EDGE" or "SAME_EDGE" 
        .INIT                               (1'b0                      ),// Initial value of Q: 1'b0 or 1'b1
        .SRTYPE                             ("SYNC"                    ) // Set/Reset type: "SYNC" or "ASYNC" 
    ) ODDR_frame_inst2 (
        .Q                                  (tx_frame_out_2r2t         ),// 1-bit DDR output
        .C                                  (data_clk                  ),// 1-bit clock input
        .CE                                 (1'b1                      ),// 1-bit clock enable input
        .D1                                 (tx_frame_reg              ),// 1-bit data input (positive edge)
        .D2                                 (tx_frame_reg              ),// 1-bit data input (negative edge)
        .R                                  (1'b0                      ),// 1-bit reset
        .S                                  (1'b0                      ) // 1-bit set
    );

    ODDR #(
        .DDR_CLK_EDGE                       ("SAME_EDGE"               ),// "OPPOSITE_EDGE" or "SAME_EDGE" 
        .INIT                               (1'b0                      ),// Initial value of Q: 1'b0 or 1'b1
        .SRTYPE                             ("SYNC"                    ) // Set/Reset type: "SYNC" or "ASYNC" 
    ) ODDR_frame_inst1 (
        .Q                                  (tx_frame_out_1r1t         ),// 1-bit DDR output
        .C                                  (data_clk                  ),// 1-bit clock input
        .CE                                 (1'b1                      ),// 1-bit clock enable input
        .D1                                 (1'b1                      ),// 1-bit data input (positive edge)
        .D2                                 (1'b0                      ),// 1-bit data input (negative edge)
        .R                                  (1'b0                      ),// 1-bit reset
        .S                                  (1'b0                      ) // 1-bit set
    );

    assign                             tx_frame_out               = (phy_mode==PHY_MODE_1R1T)?tx_frame_out_1r1t:tx_frame_out_2r2t;

    //DATA
    genvar i;
    generate
        for(i=0;i<12;i=i+1) begin
            ODDR #(
                .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
                .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
                .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
            ) ODDR_tx_data_inst (
                .Q(tx_data_out[i]),   // 1-bit DDR output
                .C(data_clk),   // 1-bit clock input
                .CE(1'b1), // 1-bit clock enable input
                .D1(tx_data_posedge_reg[i]), // 1-bit data input (positive edge)
                .D2(tx_data_negedge_reg[i]), // 1-bit data input (negative edge)
                .R(1'b0),   // 1-bit reset
                .S(1'b0)    // 1-bit set
            );
        end
    endgenerate

endmodule
