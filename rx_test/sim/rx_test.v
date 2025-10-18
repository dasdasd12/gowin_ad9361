`timescale 1ns/100ps

module rx_test(

);

    reg clk_125m;
    reg data_clk;
    reg rst_n;

    initial begin
        rst_n = 1'b0;
        data_clk = 1'b0;
        clk_125m = 1'b0;
        #50 
        rst_n = 1'b1;
    end

    always #4 clk_125m = ~clk_125m;
    always #5 data_clk = ~data_clk;

    // output declaration of module mod_data
    wire [11:0] tx_data_I;
    wire [11:0] tx_data_Q;
    wire        tx_data_valid;
    wire [7:0]  eth_rx_data;
    wire        eth_rx_data_valid;
    wire [15:0] eth_rx_data_length;
    wire        one_pkg_done;
    wire        pkg_error; 

    mod_data u_mod_data(
        .clk_125m           	(clk_125m            ),
        .data_clk           	(data_clk            ),
        .rst_n              	(rst_n               ),
        .eth_rx_data        	(eth_rx_data         ),
        .eth_rx_data_valid  	(eth_rx_data_valid   ),
        .eth_rx_data_length 	(eth_rx_data_length  ),
        .one_pkg_done       	(one_pkg_done        ),
        .pkg_error          	(pkg_error           ),
        .tx_data_I          	(tx_data_I           ),
        .tx_data_Q          	(tx_data_Q           ),
        .tx_data_valid      	(tx_data_valid       )
    );

    // output declaration of module test_module

    
    test_module u_test_module(
        .clk_125m           	(clk_125m            ),
        .rst_n              	(rst_n               ),
        .eth_rx_data        	(eth_rx_data         ),
        .eth_rx_data_valid  	(eth_rx_data_valid   ),
        .eth_rx_data_length 	(eth_rx_data_length  ),
        .one_pkg_done       	(one_pkg_done        ),
        .pkg_error          	(pkg_error           )
    );


    initial begin
        $dumpfile("rx_test.vcd");
        $dumpvars(0,rx_test);
    end

    initial begin
        #300000 $finish;
    end
    
    

endmodule