`timescale 1ns/100ps

module ethernet_tx_control(
    input                               rst_n                      ,

    input                               rx_mac_clk                 ,
    input                               rx_mac_valid               ,
    input                [   7: 0]      rx_mac_data                ,
    input                               rx_mac_last                ,
    input                               rx_mac_error               ,

    input                               rx_fcs_fwd_ena             ,
    input                               rx_jumbo_ena               ,
    input                               rx_statistics_valid        ,
    input                [  26: 0]      rx_statistics_vector       ,
    input                               rx_pause_req               ,
    input                [  15: 0]      rx_pause_val               ,
    
    output                              rx_error                   ,
    output                              rx_frm_flag                 

);

    parameter SPEED = 100;
    parameter DUPLEX = "TRUE";

    localparam IDLE      = 3'd0;
    localparam DATA      = 3'd1;
    localparam PAUSE     = 3'd2;

    reg                [   2: 0]        state                       ;

    

endmodule