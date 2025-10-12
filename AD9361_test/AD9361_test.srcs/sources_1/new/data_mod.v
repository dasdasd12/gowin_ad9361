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

    parameter                           IDLE                        = 2'b00                ;
    parameter                           SYNC                        = 2'b01                ;
    parameter                           DATA                        = 2'b10                ;
    parameter                           DONE                        = 2'b11                ;

    reg                [   1: 0]        state                       ;

    parameter                           S                           = 12'b0111_0110_0100   ;  //1892
    parameter                           C                           = 12'b0011_0000_1111   ;  //783
    parameter                           NS                          = 12'b1000_1001_1100   ;  //-1892
    parameter                           NC                          = 12'b1100_1111_0001   ;  //-783

    assign                              data_valid                  = (state == DATA) ? 1'b1 : 1'b0;
    assign                              frame_end                   = (state == DONE) ? 1'b1 : 1'b0;

    reg                [   9: 0]        cnt                         ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 10'd0;
        end 
        else begin
            case (state)
            
                IDLE: begin
                    if (frame_start) begin
                        state <= SYNC;
                    end
                end

                SYNC: begin
                    if (cnt == 10'd1023) begin
                        state <= DATA;
                        cnt   <= 10'd0;
                    end
                    else begin
                        cnt <= cnt + 1'b1;
                    end
                end

                DATA: begin
                    if (cnt == 10'd1023) begin
                        state <= DONE;
                        cnt   <= 10'd0;
                    end
                    else begin
                        cnt   <= cnt + 1'b1;
                    end
                end

                DONE: begin
                    state <= IDLE;
                end

            endcase
        end
    end

    reg                [   2: 0]        tx_bit                      ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_bit <= 3'b000;
        end 
        else if (state == DATA && cnt >= 10'd1) begin
            tx_bit <= bit_in;
        end
        else begin
            tx_bit <= 3'b000;
        end
    end

    reg                [   2: 0]        sample_bit                  ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sample_bit <= 3'b000;
        end 
        else if (state == IDLE) begin
            sample_bit <= 3'b000;
        end
        else if (state == SYNC) begin
            sample_bit <= sample_bit + 3'b010;
        end
        else if (state == DATA) begin
            sample_bit <= sample_bit + tx_bit;
        end
        else if (state == DONE) begin
            sample_bit <= 3'b000;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_data_I <= 12'd0;
            tx_data_Q <= 12'd0;
        end 
        else case(sample_bit)
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


endmodule