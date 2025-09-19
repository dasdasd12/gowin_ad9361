`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/09/10 13:33:45
// Design Name: 
// Module Name: spi_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module spi_sim(

    );

    reg                                 clk                         ;
    reg                                 rst_n                       ;

    wire                                spi_enb                     ;
    wire                                spi_clk                     ;
    wire                                spi_di                      ;

    wire                                init_done                   ;

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0;
        #100
        rst_n = 1'b1;
    end

    always #1 clk=~clk;

    spi_reg_cfg spi_reg_cfg(
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),

    .spi_enb                            (spi_enb                   ),
    .spi_clk                            (spi_clk                   ),
    .spi_di                             (spi_di                    ),
    .spi_do                             (spi_do                    ),

    .init_done                          (init_done                 ) 
    );
endmodule
