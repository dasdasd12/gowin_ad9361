`timescale 1ns / 100ps

module A8pskmod_test(
    input                               clk                        ,
    input                               rst_n                      ,

    output reg   signed  [  11: 0]      tx_data_I                  ,
    output reg   signed  [  11: 0]      tx_data_Q                   
);

    parameter S = 12'd1892; 
    parameter C = 12'd783; 

    reg                [   4: 0]        cnt                         ;
    reg                                 clk_2M                      ;

    reg                [   2: 0]        simbol_bit                  ;
 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 5'd0;
            clk_2M <= 1'b0;
        end 
        else if (cnt == 5'd24) begin
            cnt <= 5'd0;
            clk_2M <= ~clk_2M;
        end
        else begin
            cnt <= cnt + 1'b1;
        end
    end

    always @(posedge clk_2M or negedge rst_n) begin
        if (!rst_n) begin
            simbol_bit <= 3'b0;
        end 
        else begin
            simbol_bit <= simbol_bit + 1'b1;
        end
    end

    always @(posedge clk_2M or negedge rst_n) begin
        if (!rst_n) begin
            tx_data_I <= 0;
            tx_data_Q <= 0;
        end 
        else begin
            case (simbol_bit)
                3'b000: begin 
                    tx_data_I <=  C; 
                    tx_data_Q <=  S; 
                end //0
                3'b001: begin 
                    tx_data_I <=  S; 
                    tx_data_Q <=  C; 
                end //45
                3'b011: begin 
                    tx_data_I <= -S;    
                    tx_data_Q <=  C; 
                end //90
                3'b010: begin 
                    tx_data_I <= -C;
                    tx_data_Q <=  S; 
                end //135
                3'b110: begin 
                    tx_data_I <= -C; 
                    tx_data_Q <= -S; 
                end //180
                3'b111: begin 
                    tx_data_I <= -S; 
                    tx_data_Q <= -C; 
                end //225
                3'b101: begin 
                    tx_data_I <=  S;    
                    tx_data_Q <= -C; 
                end //270
                3'b100: begin 
                    tx_data_I <=  C; 
                    tx_data_Q <= -S; 
                end //315
                default: begin 
                    tx_data_I <=  12'd0;   
                    tx_data_Q <=  12'd0; 
                end
            endcase
        end
    end




endmodule