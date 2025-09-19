set_property PACKAGE_PIN AK17 [get_ports clk_p]
set_property IOSTANDARD LVDS [get_ports clk_p]

set_property PACKAGE_PIN N27 [get_ports rst_n]
set_property IOSTANDARD LVCMOS25 [get_ports rst_n]

set_property PACKAGE_PIN L24 [get_ports ldo_on]
set_property IOSTANDARD LVCMOS25 [get_ports ldo_on]

set_property IOSTANDARD LVCMOS25 [get_ports {tx_data_out[11]}]
set_property IOSTANDARD LVCMOS25 [get_ports {tx_data_out[10]}]
set_property IOSTANDARD LVCMOS25 [get_ports {tx_data_out[9]}]
set_property IOSTANDARD LVCMOS25 [get_ports {tx_data_out[8]}]
set_property IOSTANDARD LVCMOS25 [get_ports {tx_data_out[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {tx_data_out[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {tx_data_out[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {tx_data_out[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {tx_data_out[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {tx_data_out[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {tx_data_out[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {tx_data_out[0]}]

set_property PACKAGE_PIN L22 [get_ports {tx_data_out[11]}]
set_property PACKAGE_PIN K23 [get_ports {tx_data_out[10]}]
set_property PACKAGE_PIN N21 [get_ports {tx_data_out[9]}]
set_property PACKAGE_PIN M21 [get_ports {tx_data_out[8]}]
set_property PACKAGE_PIN P20 [get_ports {tx_data_out[7]}]
set_property PACKAGE_PIN P21 [get_ports {tx_data_out[6]}]
set_property PACKAGE_PIN N22 [get_ports {tx_data_out[5]}]
set_property PACKAGE_PIN M22 [get_ports {tx_data_out[4]}]
set_property PACKAGE_PIN N24 [get_ports {tx_data_out[3]}]
set_property PACKAGE_PIN M24 [get_ports {tx_data_out[2]}]
set_property PACKAGE_PIN L25 [get_ports {tx_data_out[1]}]
set_property PACKAGE_PIN K25 [get_ports {tx_data_out[0]}]

set_property PACKAGE_PIN P24 [get_ports rx_clk_in]
set_property IOSTANDARD LVCMOS25 [get_ports rx_clk_in]

set_property PACKAGE_PIN R23 [get_ports tx_clk_out]
set_property IOSTANDARD LVCMOS25 [get_ports tx_clk_out]

set_property PACKAGE_PIN H27 [get_ports tx_frame_out]
set_property IOSTANDARD LVCMOS25 [get_ports tx_frame_out]

set_property PACKAGE_PIN AL8 [get_ports spi_do]
set_property IOSTANDARD LVCMOS25 [get_ports spi_do]
set_property PACKAGE_PIN AK8 [get_ports spi_di]
set_property IOSTANDARD LVCMOS25 [get_ports spi_di]
set_property PACKAGE_PIN AL9 [get_ports spi_clk]
set_property IOSTANDARD LVCMOS25 [get_ports spi_clk]
set_property PACKAGE_PIN AK10 [get_ports spi_enb]
set_property IOSTANDARD LVCMOS25 [get_ports spi_enb]

set_property PACKAGE_PIN H24 [get_ports txnrx]
set_property IOSTANDARD LVCMOS25 [get_ports txnrx]
set_property PACKAGE_PIN J23 [get_ports enable]
set_property IOSTANDARD LVCMOS25 [get_ports enable]
set_property PACKAGE_PIN AH9 [get_ports resetb]
set_property IOSTANDARD LVCMOS25 [get_ports resetb]
set_property PACKAGE_PIN AD9 [get_ports en_agc]
set_property IOSTANDARD LVCMOS25 [get_ports en_agc]
set_property PACKAGE_PIN AD8 [get_ports sync_in]
set_property IOSTANDARD LVCMOS25 [get_ports sync_in]

#ctrl_out[0] G21
#ctrl_out[1] G22
#ctrl_out[2] H25
#ctrl_out[3] H26
#ctrl_out[4] G24
#ctrl_out[5] G25
#ctrl_out[6] D23
#ctrl_out[7] D24

set_property IOSTANDARD LVCMOS25 [get_ports {ctrl_out[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ctrl_out[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ctrl_out[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ctrl_out[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ctrl_out[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ctrl_out[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ctrl_out[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ctrl_out[7]}]

set_property PACKAGE_PIN AJ9 [get_ports {ctrl_out[0]}]
set_property PACKAGE_PIN AJ8 [get_ports {ctrl_out[1]}]
set_property PACKAGE_PIN AF9 [get_ports {ctrl_out[2]}]
set_property PACKAGE_PIN AG9 [get_ports {ctrl_out[3]}]
set_property PACKAGE_PIN AE8 [get_ports {ctrl_out[4]}]
set_property PACKAGE_PIN AF8 [get_ports {ctrl_out[5]}]
set_property PACKAGE_PIN AD10 [get_ports {ctrl_out[6]}]
set_property PACKAGE_PIN AE10 [get_ports {ctrl_out[7]}]

set_property INTERNAL_VREF 0.9 [get_iobanks 65]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_BUFG]
