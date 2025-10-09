`timescale 1ns / 100ps

module A8pskmod_test(
    input                               clk                        ,
    input                               rst_n                      ,

    output reg           [  11: 0]      tx_data_I                  ,
    output reg           [  11: 0]      tx_data_Q                   
);

    parameter S  = 12'b0111_0110_0100;  //1892
    parameter C  = 12'b0011_0000_1111;  //783
    parameter NS = 12'b1000_1001_1100;  //-1892
    parameter NC = 12'b1100_1111_0001;  //-783

    reg                [   4: 0]        cnt                         ;
    reg                                 bit_clk                      ;

    reg                [   2: 0]        simbol_bit                  ;

    reg                [   2: 0]        delta_bit                   ;
 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 5'd0;
            bit_clk <= 1'b0;
        end 
        else if (cnt == 5'd2) begin
            cnt <= 5'd0;
            bit_clk <= ~bit_clk;
        end
        else begin
            cnt <= cnt + 1'b1;
        end
    end

    always @(posedge bit_clk or negedge rst_n) begin
        if (!rst_n) begin
            delta_bit <= 3'b0;
        end 
        else begin
            delta_bit <= delta_bit + 1'b1;
        end
    end

    always @(posedge bit_clk or negedge rst_n) begin                                        
        if (!rst_n) begin
            simbol_bit <= 3'b0;
        end
        else begin
            simbol_bit <= simbol_bit + delta_bit;
        end
    end                                          

    always @(posedge bit_clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_data_I <= 0;
            tx_data_Q <= 0;
        end 
        else begin
            case (simbol_bit)
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
                end //315
                default: begin 
                    tx_data_I <=  12'd0;   
                    tx_data_Q <=  12'd0; 
                end
            endcase
        end
    end




endmodule