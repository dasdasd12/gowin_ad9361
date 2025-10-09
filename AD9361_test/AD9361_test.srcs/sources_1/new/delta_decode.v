`timescale 1ns/100ps

module delta_decode (
    input                               clk                      ,
    input                               rst_n                    ,

    input                [   2: 0]      bit_in                   ,
    input                               valid                    ,
    output    reg        [   2: 0]      delta_out                    
);

    reg                [   2: 0]        bit_in_d1                   ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_in_d1 <= 3'b0;
        end 
        else if(valid) begin
            bit_in_d1 <= bit_in;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            delta_out <= 3'b0;
        end 
        else if(valid) begin
            delta_out <= bit_in - bit_in_d1;
        end
        else delta_out <= delta_out;
    end

endmodule