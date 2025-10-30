
//this module uses chip max98357A 
module FM_processor (
    //data ports
    input [11:0] data_in,
    input fm_enable,
    //system ports
    input clk,//LRCLK ONLY supports 8kHz, 16kHz, 32kHz, 44.1kHz,48kHz, 88.2kHz and 96kHz frequencies. 
    input rst_n,
    //IIS ports
    output reg LRCLK,//LRCLK ONLY supports 8kHz, 16kHz, 32kHz, 44.1kHz,48kHz, 88.2kHz and 96kHz frequencies. 
    //Do not remove LRCLK while BCLK is present.
    output BCLK,
    output reg DIN,
    output GAIN_SLOT,
    output reg SD_MODE //Drive SD_MODE low to put the ICs into shutdown.
);

    parameter RESOLUTION = 32;
    parameter SAMPLE_RATE = 96_000;
    parameter CHANNEL_MODE = 0; //0: stereo, 1: left only, 2: right only

    localparam IDLE=3'd0;
    localparam START_UP=3'd1;
    localparam DATA=3'd2;
    localparam SLEEP =3'd3;

    reg [2:0] state;
    wire start_up_enable;

    assign start_up_enable = SAMPLE_RATE == 8000 & RESOLUTION == 16 ;

    reg [11:0] data_in_d1;
    reg [11:0] data_in_d2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_in_d1 <= 1'b0;
            data_in_d2 <= 1'b0;
        end else begin
            data_in_d1 <= data_in;
            data_in_d2 <= data_in_d1;
        end
    end
    
    reg [2:0] wait_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wait_cnt <= 3'd0;
        end 
        else if (state == START_UP) begin
            if (wait_cnt == 3'd5) begin
                wait_cnt <= 3'd0;
            end else begin
                wait_cnt <= wait_cnt + 1'b1;
            end
        end 
        else begin
            wait_cnt <= 3'd0;
        end
    end

    reg [7:0] lrclk_cnt;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lrclk_cnt <= 8'd12;
            LRCLK <= 1'b0;
        end
        else if(state == DATA) begin
            if (lrclk_cnt == RESOLUTION - 1'b1) begin
                lrclk_cnt <= 8'd0;
                LRCLK <= ~LRCLK;
            end else begin
                lrclk_cnt <= lrclk_cnt + 1'b1;
            end
        end
        else 
            lrclk_cnt <= 8'd12;
    end

    assign BCLK = (state == DATA) ? clk : 1'b0; 

    reg [RESOLUTION-1:0] din_reg0;
    reg [RESOLUTION-1:0] din_reg1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            din_reg0 <= 'd0;
        end
        else if (state == DATA) begin
            if (lrclk_cnt == RESOLUTION - 1 & RESOLUTION == 16) begin
                din_reg0 <= {data_in_d2,4'b0};
            end 
            else if (lrclk_cnt == RESOLUTION - 1 & RESOLUTION == 32) begin
                din_reg0 <= {data_in_d2,20'b0};
            end
            else begin
                din_reg0 <= din_reg0;
            end
        end
        else begin
            din_reg0 <= 'd0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            din_reg1 <= 1'b0;
        end
        else if (state == DATA ) begin
            din_reg1 <= din_reg0[RESOLUTION-1-lrclk_cnt];
        end
        else begin
            din_reg1 <= 1'b0;
        end
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            DIN <= 1'b0;
        end
        else begin
            DIN <= din_reg1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= SLEEP;
            SD_MODE <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start_up_enable) begin
                        state <= START_UP;
                    end else begin
                        state <= DATA; 
                    end
                end
                START_UP: begin
                    if (wait_cnt == 3'd5)
                        state <= DATA;
                    else 
                        state <= START_UP;
                end
                DATA: begin
                    if (!fm_enable)
                        state <= SLEEP;
                    else 
                        state <= DATA;
                end
                SLEEP: begin
                    SD_MODE <= 1'b0;
                    if (fm_enable) begin
                        state <= IDLE;
                        SD_MODE <= 1'b1;
                    end
                    else begin
                        state <= SLEEP;
                    end
                end
            endcase
        end
    end

endmodule

