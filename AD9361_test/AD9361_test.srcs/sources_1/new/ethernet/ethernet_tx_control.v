`timescale 1ns/100ps

module ethernet_tx_control (
    input                               clk                        ,
    input                               rst_n                      ,       
     
    input                               tx_start                   ,        

    input                               tx_done                    ,

    output                              tx_en_pulse                ,
    output               [  15: 0]      data_length                 
);

    reg [2:0] state;
    reg [31:0] data_num;


endmodule