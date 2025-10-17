set_property PACKAGE_PIN AK17 [get_ports clk_p]
set_property IOSTANDARD LVDS [get_ports clk_p]

set_property PACKAGE_PIN N27 [get_ports rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports rst_n]

# ldo_on D1 always high

set_property PACKAGE_PIN AB20 [get_ports ldo_on]
set_property IOSTANDARD LVCMOS18 [get_ports ldo_on]

# tx_data_out[11] H19
# tx_data_out[10] H20
# tx_data_out[9]  C18
# tx_data_out[8]  C19
# tx_data_out[7]  C14
# tx_data_out[6]  C15
# tx_data_out[5]  D17
# tx_data_out[4]  D18
# tx_data_out[3]  G15
# tx_data_out[2]  G16
# tx_data_out[1]  H16
# tx_data_out[0]  H17

set_property IOSTANDARD LVCMOS18 [get_ports {tx_data_out[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {tx_data_out[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {tx_data_out[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {tx_data_out[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {tx_data_out[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {tx_data_out[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {tx_data_out[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {tx_data_out[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {tx_data_out[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {tx_data_out[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {tx_data_out[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {tx_data_out[0]}]

set_property PACKAGE_PIN W25 [get_ports {tx_data_out[11]}]
set_property PACKAGE_PIN Y25 [get_ports {tx_data_out[10]}]
set_property PACKAGE_PIN V27 [get_ports {tx_data_out[9]}]
set_property PACKAGE_PIN V28 [get_ports {tx_data_out[8]}]
set_property PACKAGE_PIN U24 [get_ports {tx_data_out[7]}]
set_property PACKAGE_PIN U25 [get_ports {tx_data_out[6]}]
set_property PACKAGE_PIN W28 [get_ports {tx_data_out[5]}]
set_property PACKAGE_PIN Y28 [get_ports {tx_data_out[4]}]
set_property PACKAGE_PIN U26 [get_ports {tx_data_out[3]}]
set_property PACKAGE_PIN U27 [get_ports {tx_data_out[2]}]
set_property PACKAGE_PIN AB24 [get_ports {tx_data_out[1]}]
set_property PACKAGE_PIN AC24 [get_ports {tx_data_out[0]}]

#DATA_CLK_P G6
#DATA_CLK_N G7

set_property PACKAGE_PIN W23 [get_ports rx_clk_in]
set_property IOSTANDARD LVCMOS18 [get_ports rx_clk_in]

#FB_CLK_P G12
#FB_CLK_N G13

set_property PACKAGE_PIN V26 [get_ports tx_clk_out]
set_property IOSTANDARD LVCMOS18 [get_ports tx_clk_out]

#TX_FRAME_P D14
#TX_FRAME_N D15

set_property PACKAGE_PIN T22 [get_ports tx_frame_out]
set_property IOSTANDARD LVCMOS18 [get_ports tx_frame_out]

#SPI_DI C26
#SPI_DO C27
#SPI_ENB D26
#SPI_CLK D27

set_property PACKAGE_PIN AF34 [get_ports spi_do]
set_property IOSTANDARD LVCMOS18 [get_ports spi_do]
set_property PACKAGE_PIN AE33 [get_ports spi_di]
set_property IOSTANDARD LVCMOS18 [get_ports spi_di]
set_property PACKAGE_PIN AG31 [get_ports spi_clk]
set_property IOSTANDARD LVCMOS18 [get_ports spi_clk]
set_property PACKAGE_PIN AG32 [get_ports spi_enb]
set_property IOSTANDARD LVCMOS18 [get_ports spi_enb]

#ENABLE G18
#TXNRX G19
#RESETB H31
#EN_AGC H22
#SYNC_IN H23


set_property PACKAGE_PIN AB22 [get_ports txnrx]
set_property IOSTANDARD LVCMOS18 [get_ports txnrx]
set_property PACKAGE_PIN AA22 [get_ports enable]
set_property IOSTANDARD LVCMOS18 [get_ports enable]
set_property PACKAGE_PIN AE27 [get_ports resetb]
set_property IOSTANDARD LVCMOS18 [get_ports resetb]

set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_BUFG]
