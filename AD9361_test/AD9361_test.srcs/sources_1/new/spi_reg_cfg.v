`timescale 1ns/100ps
module spi_reg_cfg (
    input                               clk                        ,
    input                               rst_n                      ,
    input                [  11: 0]      addr                       ,

    //spi
    output                              spi_enb                    ,
    output                              spi_clk                    ,
    output                              spi_di                     ,
    input                               spi_do                     ,

    //init port
    //output               [   7: 0]      spi_rd_data                ,
    output                              init_done                  ,
    output                              rd_done                    ,
    output               [   7: 0]      spi_rd_data_reg            ,

    //after init port
    input                               wr_flag                    ,
    input                [  19: 0]      wr_data                     
    );

    //AD9361 initial configuration
    wire                                spi_wr_end                  ;
    wire                                spi_wr_req                  ;
    wire               [   9: 0]        spi_wr_addr                 ;
    wire               [   7: 0]        spi_wr_data                 ;

    wire                                spi_rd_end                  ;
    wire                                spi_rd_req                  ;
    wire               [   9: 0]        spi_rd_addr                 ;
    wire               [   7: 0]        spi_rd_data                 ;

    ad9361_init u_init_cfg (
        //input
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),

        //output
    .spi_wr_end                         (spi_wr_end                ),
    .spi_wr_req                         (spi_wr_req                ),
    .spi_wr_addr                        (spi_wr_addr               ),
    .spi_wr_data                        (spi_wr_data               ),
    .spi_rd_addr                        (spi_rd_addr               ),
    .spi_rd_req                         (spi_rd_req                ),
    .spi_rd_end                         (spi_rd_end                ),
        //input
    .init_done                          (init_done                 ),
    .rd_done                            (rd_done                   ),

    .wr_flag                            (wr_flag                   ),
    .wr_data                            (wr_data                   ) 
    );

    spi u_spi (
    .clk                                (clk                       ),
    .rst_n                              (rst_n                     ),

    .wr_end                             (spi_wr_end                ),
    .wr_req                             (spi_wr_req                ),
    .wr_addr                            (spi_wr_addr               ),
    .wr_data                            (spi_wr_data               ),

    .rd_end                             (spi_rd_end                ),
    .rd_req                             (spi_rd_req                ),
    .rd_addr                            (spi_rd_addr               ),
    .rd_data                            (spi_rd_data               ),
 
    .spi_enb                            (spi_enb                   ),
    .spi_clk                            (spi_clk                   ),
    .spi_do                             (spi_do                    ),
    .spi_di                             (spi_di                    ) 
    );

    reg                [   7: 0]        spi_rd_rom[1022:0]          ;


    always @(posedge clk) begin
        if (spi_rd_end) begin
            spi_rd_rom[spi_rd_addr] <= spi_rd_data;
        end
    end

    assign                              spi_rd_data_reg             = spi_rd_rom[addr]     ;

endmodule
