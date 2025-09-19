`timescale 1ns/100ps

module ASCII_rom (
    input  [3:0] hex_data_in,
    output reg [7:0] ascii_data_out,
    input  [7:0] ascii_data_in,
    output reg [3:0] hex_data_out
);

    always @(*) begin
        case (hex_data_in)
            4'h0: ascii_data_out = "0";
            4'h1: ascii_data_out = "1";
            4'h2: ascii_data_out = "2";
            4'h3: ascii_data_out = "3";
            4'h4: ascii_data_out = "4";
            4'h5: ascii_data_out = "5";
            4'h6: ascii_data_out = "6";
            4'h7: ascii_data_out = "7";
            4'h8: ascii_data_out = "8";
            4'h9: ascii_data_out = "9";
            4'hA: ascii_data_out = "A";
            4'hB: ascii_data_out = "B";
            4'hC: ascii_data_out = "C";
            4'hD: ascii_data_out = "D";
            4'hE: ascii_data_out = "E";
            4'hF: ascii_data_out = "F";
        endcase
    end

    always @(*) begin
        case (ascii_data_in)
            "0": hex_data_out = 4'h0;
            "1": hex_data_out = 4'h1;
            "2": hex_data_out = 4'h2;
            "3": hex_data_out = 4'h3;
            "4": hex_data_out = 4'h4;
            "5": hex_data_out = 4'h5;
            "6": hex_data_out = 4'h6;
            "7": hex_data_out = 4'h7;
            "8": hex_data_out = 4'h8;
            "9": hex_data_out = 4'h9;
            "A","a": hex_data_out = 4'hA;
            "B","b": hex_data_out = 4'hB;
            "C","c": hex_data_out = 4'hC;
            "D","d": hex_data_out = 4'hD;
            "E","e": hex_data_out = 4'hE;
            "F","f": hex_data_out = 4'hF;
        endcase
    end

endmodule