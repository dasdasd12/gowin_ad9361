// Converted from GMII_send.sv to Verilog-2001: GMII_send_converted.v
module GMII_send#(
    parameter                           BOARD_MAC                   = 48'h03_08_35_01_AE_C2,
    parameter                           BOARD_IP                    = {8'd192              ,8'd168,8'd3,8'd2},
    parameter                           BOARD_PORT                  = 16'h8000             ,
    parameter                           DES_MAC                     = 48'hff_ff_ff_ff_ff_ff,
    parameter                           DES_IP                      = {8'd192              ,8'd168,8'd3,8'd3},
    parameter                           DES_PORT                    = 16'h8000             ,
    parameter                           DATA_SIZE                   = 16'd1472             
    )(
    input                               rst_n                      ,
    input                               GMII_GTXCLK                ,
    output reg           [   7: 0]      GMII_TXD                   ,
    output reg                          GMII_TXEN                  ,
    output reg                          GMII_TXER                   
    );

    parameter                           IP_HEAD_CODE                = 64'h55_55_55_55_55_55_55_d5;
    parameter                           DES_MAC_CODE                = DES_MAC              ;
    parameter                           BOARD_MAC_CODE              = BOARD_MAC            ;
    parameter                           DATA_TYPE                   = 16'H0800             ;
    parameter                           MAC_DATA                    = {DES_MAC             ,BOARD_MAC,16'h0800};

    reg                [  31: 0]        packet_header[0:6]          ;
    reg                [  31: 0]        check_buffer                ;

    localparam                          IDLE                        = 0                    ;
    localparam                          CHECK_SUM                   = 1                    ;
    localparam                          PACKET_HEAD                 = 2                    ;
    localparam                          SEND_MAC                    = 3                    ;
    localparam                          SEND_HEADER                 = 4                    ;
    localparam                          SEND_DATA                   = 5                    ;
    localparam                          SEND_CRC                    = 6                    ;
    localparam                          DELAY                       = 7                    ;

    reg                [   2: 0]        state                       ;
    reg                [  10: 0]        send_cnt                    ;

    wire               [  31: 0]        crc_data                    ;
    reg                                 crc_en                      ;

    integer                             byte_index                  ;

always @(posedge GMII_GTXCLK) begin
    if (!rst_n) begin
        send_cnt    <= 11'd0;
        state       <= IDLE ;
        GMII_TXEN   <= 1'b0 ;
        GMII_TXER   <= 1'b0 ;
        GMII_TXD    <= 8'd0 ;
        crc_en      <= 1'b0 ;
    end else begin
        case (state)
            IDLE: begin

                send_cnt    <= 11'd0;

                GMII_TXEN   <= 1'b0 ;
                GMII_TXER   <= 1'b0 ;
                GMII_TXD    <= 8'd0 ;

                // prepare IP header
                packet_header[0] <= {16'h4500, DATA_SIZE + 16'd28};
                packet_header[1] <= {{5'b00000,11'd0},16'h4000};
                packet_header[2] <= {8'h80,8'h11,16'h0000};
                packet_header[3] <= BOARD_IP;
                packet_header[4] <= DES_IP;
                packet_header[5] <= {BOARD_PORT, DES_PORT};
                packet_header[6] <= {DATA_SIZE + 16'd8, 16'h0000};
                
                state            <= CHECK_SUM;
            end

            CHECK_SUM: begin
                send_cnt <= (send_cnt == 2) ? 0 : send_cnt + 1;

                if (send_cnt == 0) begin
                    check_buffer <= ((packet_header[0][15:0] + packet_header[0][31:16]) + (packet_header[1][15:0]
                                        + packet_header[1][31:16])) + (((packet_header[2][15:0] + packet_header[2][31:16]) + ((packet_header[3][15:0]
                                        + packet_header[3][31:16]))) + (packet_header[4][15:0] + packet_header[4][31:16]));
                end 
                else if (send_cnt == 1) begin
                    check_buffer[15:0] <= check_buffer[31:16] + check_buffer[15:0];
                end
                else if (send_cnt == 2) begin
                    packet_header[2][15:0] <= ~check_buffer[15:0];
                end
                if (send_cnt == 2) 
                    state <= PACKET_HEAD;
            end

            PACKET_HEAD: begin
                send_cnt <= (send_cnt == 7) ? 0 : send_cnt + 1;
                GMII_TXEN <= 1'b1;
                // extract byte from IP_HEAD_CODE: byte idx = 7 - send_cnt
                byte_index = 7 - send_cnt;
                GMII_TXD <= (IP_HEAD_CODE >> (byte_index * 8)) & 8'hFF;
                if (send_cnt == 7) state <= SEND_MAC;
            end

            SEND_MAC: begin
                send_cnt <= (send_cnt == 13) ? 0 : send_cnt + 1;
                crc_en <= 1'b1;
                // MAC_DATA has 112 bits; send byte (13 - send_cnt)
                byte_index = 13 - send_cnt;
                GMII_TXD <= (MAC_DATA >> (byte_index * 8)) & 8'hFF;
                if (send_cnt == 13) state <= SEND_HEADER;
            end

            SEND_HEADER: begin
                send_cnt <= (send_cnt == 27) ? 0 : send_cnt + 1;
                // index = send_cnt / 4, byte_in_word = 3 - (send_cnt % 4)
                byte_index = send_cnt >> 2;                         // word index
                GMII_TXD <= (packet_header[byte_index] >> ((3 - (send_cnt & 2'd3)) * 8)) & 8'hFF;
                if (send_cnt == 27) state <= SEND_DATA;
            end

            SEND_DATA: begin
                send_cnt <= (send_cnt == DATA_SIZE - 1) ? 0 : send_cnt + 1;
                GMII_TXD <= 8'hF0;
                if (send_cnt == DATA_SIZE - 1) state <= SEND_CRC;
            end

            SEND_CRC: begin
                send_cnt <= (send_cnt == 3) ? 0 : send_cnt + 1;
                crc_en <= 1'b0;
                if (send_cnt == 0) begin
                    GMII_TXD <= {~crc_data[24], ~crc_data[25], ~crc_data[26], ~crc_data[27],
                                 ~crc_data[28], ~crc_data[29], ~crc_data[30], ~crc_data[31]};
                end else if (send_cnt == 1) begin
                    GMII_TXD <= {~crc_data[16], ~crc_data[17], ~crc_data[18], ~crc_data[19],
                                 ~crc_data[20], ~crc_data[21], ~crc_data[22], ~crc_data[23]};
                end else if (send_cnt == 2) begin
                    GMII_TXD <= {~crc_data[8], ~crc_data[9], ~crc_data[10], ~crc_data[11],
                                 ~crc_data[12], ~crc_data[13], ~crc_data[14], ~crc_data[15]};
                end else if (send_cnt == 3) begin
                    GMII_TXD <= {~crc_data[0], ~crc_data[1], ~crc_data[2], ~crc_data[3],
                                 ~crc_data[4], ~crc_data[5], ~crc_data[6], ~crc_data[7]};
                end else begin
                    GMII_TXER <= 1'b1;
                end
                if (send_cnt == 3) state <= DELAY;
            end

            DELAY: begin
                // use send_cnt[3] as delay condition (16 cycles)
                send_cnt <= send_cnt[3] ? 0 : send_cnt + 1;
                GMII_TXEN <= 1'b0;
                GMII_TXER <= 1'b0;
                GMII_TXD <= 8'd0;
                if (send_cnt[3]) state <= IDLE;
            end

            default: state <= IDLE;
        endcase
    end
end

crc crc32_m0(
    .Clk                                (~GMII_GTXCLK              ),
    .Reset                              (1'b0                      ),
    .Data_in                            (GMII_TXD                  ),
    .Enable                             (crc_en                    ),
    .Crc                                (crc_data                  ),
    .CrcNext                            (                          ) 
    );

endmodule
