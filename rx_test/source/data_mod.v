`timescale 1ns/100ps

module data_mod(
    input                               clk                        ,
    input                               rst_n                      ,
    output reg                          bit_clk                    ,

    input                               frame_start                ,
    output reg                          frame_end                  ,

    input                [   2: 0]      bit_in                     ,
    input                [  11: 0]      byte_num                   ,
    input                               bit_in_valid               ,
    output                              bit_valid                  ,


    output                              data_valid                 ,
    output                              tx_data_valid              ,
    output reg           [  11: 0]      tx_data_I                  ,
    output reg           [  11: 0]      tx_data_Q                   
);

    localparam                           IDLE                        = 2'b00                ;
    localparam                           SYNC                        = 2'b01                ;
    localparam                           DATA                        = 2'b10                ;
    localparam                           DNUM                        = 2'b11                ;

    localparam                           DATA_NUM                    = 12'd400               ;

    reg                [   1: 0]        state                       ;

    localparam                           S                           = 12'd630   ;  //1892/3
    localparam                           C                           = 12'd261   ;  //783/3
    localparam                           NS                          = -12'd680  ;  //-1892/3
    localparam                           NC                          = -12'd261   ;  //-783/3

    assign                              bit_valid                   = (state == DATA) ? 1'b1 : 1'b0;
    assign                              data_valid                  = ((state == DNUM)||(state == DATA)) ? 1'b1 : 1'b0;
    assign                              tx_data_valid               = ((state == DNUM)||(state == DATA)||(state == SYNC)) ? 1'b1 : 1'b0;

    wire               [  15: 0]        bit3_num                    ;

    assign                              bit3_num                    = byte_num * 3         ;

    //control sample rate
    reg                [   4: 0]        clk_cnt                     ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_cnt <= 5'd0;
            bit_clk <= 1'b0;
        end 
        else if (clk_cnt == 5'd2) begin
            clk_cnt <= 5'd0;
            bit_clk <= ~bit_clk;
        end
        else begin
            clk_cnt <= clk_cnt + 1'b1;
        end
    end

    reg                [   15: 0]        cnt                         ; 

    always @(posedge bit_clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 16'd0;
            frame_end <= 1'b0;
        end 
        else begin
            case (state)
            
                IDLE: begin
                    frame_end <= 1'b0;
                    if (frame_start) begin
                        state <= SYNC;
                    end
                    else 
                        state <= IDLE;
                end

                SYNC: begin
                    if (cnt == 16'd99) begin
                        state <= DNUM;
                        cnt   <= 16'd0;
                    end
                    else begin
                        cnt <= cnt + 1'b1;
                    end
                end

                DNUM: begin
                    if (cnt == 16'd3) begin
                        state <= DATA;
                        cnt   <= 16'd0;
                    end
                    else begin
                        cnt   <= cnt + 1'b1;
                    end
                end

                DATA: begin
                    if (bit_in_valid == 1'b0) begin
                        state <= IDLE;
                        frame_end <= 1'b1;
                    end
                end

            endcase
        end
    end

    reg                [   2: 0]        tx_bit                      ;

    always @(posedge bit_clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_bit <= 3'd4;
        end 
        else if (state == DATA && bit_in_valid == 1'b1) begin
            tx_bit <= bit_in;
        end
        else if (state == DNUM ) begin
            tx_bit <= byte_num[(cnt*3)+:3];
        end
        else begin
            tx_bit <= 3'd4;
        end
    end

    reg                [   2: 0]        sample_bit                  ;

    always @(posedge bit_clk or negedge rst_n) begin
        if (!rst_n) begin
            sample_bit <= 3'b000;
        end 
        else if (state == IDLE) begin
            sample_bit <= 3'b000;
        end
        else if (state == SYNC) begin
            sample_bit <= sample_bit + 3'd3;
        end
        else if (state == DATA || state == DNUM) begin
            sample_bit <= sample_bit + tx_bit;
        end
    end

    always @(posedge bit_clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_data_I <= 12'd0;
            tx_data_Q <= 12'd0;
        end 
        else if(tx_data_valid) begin
            case(sample_bit)
                3'b000: begin 
                    tx_data_I <=  S; 
                    tx_data_Q <=  C; 
                end //0
                3'b001: begin 
                    tx_data_I <=  C; 
                    tx_data_Q <=  S; 
                end //45
                3'b010: begin 
                    tx_data_I <= NC;    
                    tx_data_Q <=  S; 
                end //90
                3'b011: begin 
                    tx_data_I <= NS;
                    tx_data_Q <=  C; 
                end //135
                3'b100: begin 
                    tx_data_I <= NS; 
                    tx_data_Q <= NC; 
                end //180
                3'b101: begin 
                    tx_data_I <= NC; 
                    tx_data_Q <= NS; 
                end //225
                3'b110: begin 
                    tx_data_I <=  C;    
                    tx_data_Q <= NS; 
                end //270
                3'b111: begin 
                    tx_data_I <=  S; 
                    tx_data_Q <= NC; 
                end
            endcase
        end
        else begin
            tx_data_I <= 12'd0;
            tx_data_Q <= 12'd0;
        end
    end


endmodule