// GMII_send_trim_raw.v
// Trimmed version of GMII_send for raw Ethernet payload (no IP/UDP), keeps CRC.
// - Removes IP/UDP header construction and checksum logic.
// - Sends MAC (dest + src) + EtherType (customizable) + payload + CRC.
// - Default DATA_SIZE set to 1500 (max standard MTU payload). Adjust if needed.

module GMII_send#(
    parameter                           BOARD_MAC                   = 48'h03_08_35_01_AE_C2,
    parameter                           DES_MAC                     = 48'hff_ff_ff_ff_ff_ff,
    parameter                           ETHERTYPE                   = 16'h88B5             , // custom Ethertype for raw payload (change as needed)
    parameter                           DATA_SIZE                   = 16'd1500             // payload length in bytes (max 1500 for standard MTU)
    )(
    input                               rst_n                      ,
    input                               GMII_GTXCLK                ,
    // Optional: supply payload byte-by-byte from user logic. If not used, module sends 0xF0 pattern.
    input                [   7: 0]      DATA_BYTE                  ,// optional payload source (sampled each byte send)
    input                               DATA_VALID                 ,// when high, DATA_BYTE is used; when low, pattern used
    output reg           [   7: 0]      GMII_TXD                   ,
    output reg                          GMII_TXEN                  ,
    output reg                          GMII_TXER                   
    );

    // Preamble + SFD (7 x 0x55 + 0xD5)
    parameter                           IP_HEAD_CODE                = 64'h55_55_55_55_55_55_55_d5;

    // MAC data: dest(48) + src(48) + ethertype(16) = 112 bits
    parameter                           MAC_DATA                    = {DES_MAC             , BOARD_MAC, ETHERTYPE};

    // State machine
    localparam                          IDLE                        = 0                    ;
    localparam                          SEND_PREAMBLE               = 1                    ;
    localparam                          SEND_MAC                    = 2                    ;
    localparam                          SEND_DATA                   = 3                    ;
    localparam                          SEND_CRC                    = 4                    ;
    localparam                          DELAY                       = 5                    ;

    reg                [   2: 0]        state                       ;
    reg                [  10: 0]        send_cnt                    ;
    integer                             byte_index                  ;

    wire               [  31: 0]        crc_data                    ;
    reg                                 crc_en                      ;

    // Internal default pattern when DATA_VALID is low
    wire               [   7: 0]        default_pattern           =8'hF0;

    always @(posedge GMII_GTXCLK) begin
        if (!rst_n) begin
            state <= IDLE;
            send_cnt <= 11'd0;
            GMII_TXEN <= 1'b0;
            GMII_TXER <= 1'b0;
            GMII_TXD <= 8'd0;
            crc_en <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    send_cnt <= 11'd0;
                    GMII_TXEN <= 1'b0;
                    GMII_TXER <= 1'b0;
                    GMII_TXD <= 8'd0;
                    crc_en <= 1'b0;
                    // start sending immediately - change condition if you need gating
                    state <= SEND_PREAMBLE;
                end

                SEND_PREAMBLE: begin
                    send_cnt <= (send_cnt == 7) ? 0 : send_cnt + 1;
                    GMII_TXEN <= 1'b1;
                    byte_index = 7 - send_cnt;
                    GMII_TXD <= (IP_HEAD_CODE >> (byte_index * 8)) & 8'hFF;
                    if (send_cnt == 7) state <= SEND_MAC;
                end

                SEND_MAC: begin
                    // send 14 bytes: dest(6) + src(6) + ethertype(2) => indices 13 downto 0
                    send_cnt <= (send_cnt == 13) ? 0 : send_cnt + 1;
                    crc_en <= 1'b1;                                 // start CRC at MAC/ethertype
                    byte_index = 13 - send_cnt;
                    GMII_TXD <= (MAC_DATA >> (byte_index * 8)) & 8'hFF;
                    if (send_cnt == 13) state <= SEND_DATA;
                end

                SEND_DATA: begin
                    // send DATA_SIZE bytes of payload
                    if (send_cnt == DATA_SIZE - 1) begin
                        send_cnt <= 11'd0;
                        state <= SEND_CRC;
                    end else begin
                        send_cnt <= send_cnt + 1;
                    end
                    // choose payload source
                    GMII_TXD <= (DATA_VALID) ? DATA_BYTE : default_pattern;
                end

                SEND_CRC: begin
                    // send 4 bytes CRC (big-endian pieces as original)
                    send_cnt <= (send_cnt == 3) ? 0 : send_cnt + 1;
                    crc_en <= 1'b0;
                    case (send_cnt)
                        0: GMII_TXD <= {~crc_data[24], ~crc_data[25], ~crc_data[26], ~crc_data[27],
                                       ~crc_data[28], ~crc_data[29], ~crc_data[30], ~crc_data[31]};
                        1: GMII_TXD <= {~crc_data[16], ~crc_data[17], ~crc_data[18], ~crc_data[19],
                                       ~crc_data[20], ~crc_data[21], ~crc_data[22], ~crc_data[23]};
                        2: GMII_TXD <= {~crc_data[8], ~crc_data[9], ~crc_data[10], ~crc_data[11],
                                       ~crc_data[12], ~crc_data[13], ~crc_data[14], ~crc_data[15]};
                        3: GMII_TXD <= {~crc_data[0], ~crc_data[1], ~crc_data[2], ~crc_data[3],
                                       ~crc_data[4], ~crc_data[5], ~crc_data[6], ~crc_data[7]};
                        default: GMII_TXD <= 8'd0;
                    endcase
                    if (send_cnt == 3) state <= DELAY;
                end

                DELAY: begin
                    // short gap between frames; adjust as needed
                    send_cnt <= (send_cnt == 7) ? 0 : send_cnt + 1;
                    GMII_TXEN <= 1'b0;
                    GMII_TXER <= 1'b0;
                    GMII_TXD <= 8'd0;
                    if (send_cnt == 7) state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

    // instantiate CRC module (assumes same interface exists)
    crc crc32_m0(
    .Clk                                (~GMII_GTXCLK              ),
    .Reset                              (1'b0                      ),
    .Data_in                            (GMII_TXD                  ),
    .Enable                             (crc_en                    ),
    .Crc                                (crc_data                  ),
    .CrcNext                            (                          ) 
    );

endmodule
