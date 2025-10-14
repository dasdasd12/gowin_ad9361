`timescale 1ns/100ps

module data_mod(
    input                               clk                        ,
    input                               rst_n                      ,

    input                               frame_start                ,
    output                              frame_end                  ,

    input                [   2: 0]      bit_in                     ,
    output                              data_valid                 ,

    output reg           [  11: 0]      tx_data_I                  ,
    output reg           [  11: 0]      tx_data_Q                   
);

    localparam                           IDLE                        = 2'b00                ;
    localparam                           SYNC                        = 2'b01                ;
    localparam                           DATA                        = 2'b10                ;
    localparam                           DONE                        = 2'b11                ;

    reg                [   1: 0]        state                       ;

    localparam                           S                           = 12'd630   ;  //1892/3
    localparam                           C                           = 12'd261   ;  //783/3
    localparam                           NS                          = -12'd680  ;  //-1892/3
    localparam                           NC                          = -12'd261   ;  //-783/3

    assign                              data_valid                  = ((state == DATA)||(state == SYNC)) ? 1'b1 : 1'b0;
    assign                              frame_end                   = (state == DONE) ? 1'b1 : 1'b0;

    reg                [   4: 0]        clk_cnt                     ;
    reg                                 bit_clk                     ;

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

    //114 514 1717 710 

    reg                [  15: 0]        test_cnt                    ;

    reg                [   2: 0]        test_bit                    ;

    always @(posedge bit_clk or negedge rst_n) begin
        if (!rst_n) begin
            test_cnt <= 16'd0;
        end
        else if (test_cnt == 16'd12) begin
            test_cnt <= 16'd0;
        end
        else begin
            test_cnt <= test_cnt + 1'b1;
        end
    end

    always @(posedge bit_clk or negedge rst_n) begin
        if (!rst_n) begin
            test_bit <= 3'b000;
        end
        else case(test_cnt)
                16'd0:   test_bit <= 3'd1;
                16'd1:   test_bit <= 3'd2;
                16'd2:   test_bit <= 3'd3;

                16'd3:   test_bit <= 3'd4;
                16'd4:   test_bit <= 3'd5;
                16'd5:   test_bit <= 3'd6;

                16'd6:   test_bit <= 3'd7;
                16'd7:   test_bit <= 3'd0;
                16'd8:   test_bit <= 3'd1;
                16'd9:   test_bit <= 3'd2;

                16'd10:  test_bit <= 3'd3;
                16'd11:  test_bit <= 3'd4;
                16'd12:  test_bit <= 3'd5;

                default: test_bit <= 3'd0;
        endcase
    end

    reg                [   15: 0]        cnt                         ;

    always @(posedge bit_clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 16'd0;
        end 
        else begin
            case (state)
            
                IDLE: begin
                    if (1'b1) begin
                        state <= SYNC;
                    end
                end

                SYNC: begin
                    if (cnt == 16'd399) begin
                        state <= DATA;
                        cnt   <= 16'd0;
                    end
                    else begin
                        cnt <= cnt + 1'b1;
                    end
                end

                DATA: begin
                    if (cnt == 16'd399) begin
                        state <= DONE;
                        cnt   <= 16'd0;
                    end
                    else begin
                        cnt   <= cnt + 1'b1;
                    end
                end

                DONE: begin
                    if (cnt == 16'd399) begin
                        state <= IDLE;
                        cnt   <= 16'd0;
                    end
                    else begin
                        cnt   <= cnt + 1'b1;
                    end
                end

            endcase
        end
    end

    reg                [   2: 0]        tx_bit                      ;

    always @(posedge bit_clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_bit <= 3'b000;
        end 
        else if (state == DATA && cnt >= 10'd1) begin
            tx_bit <= test_bit;
        end
        else if (state == DATA && cnt == 10'd0) begin
            tx_bit <= 3'd4; //frame start symbol
        end
        else begin
            tx_bit <= 3'b000;
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
            sample_bit <= 3'b010;
        end
        else if (state == DATA) begin
            sample_bit <= sample_bit + tx_bit;
        end
        else if (state == DONE) begin
            sample_bit <= 3'b000;
        end
    end

    always @(posedge bit_clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_data_I <= 12'd0;
            tx_data_Q <= 12'd0;
        end 
        else if(data_valid) begin
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