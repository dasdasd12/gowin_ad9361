set_property -dict {PACKAGE_PIN Y9     IOSTANDARD LVCMOS33} [get_ports clk]          ; 

set_property -dict {PACKAGE_PIN M19     IOSTANDARD LVCMOS25 } [get_ports rx_clk_in]          ; ## G6   FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN N19     IOSTANDARD LVCMOS25 } [get_ports rx_frame_in]        ; ## D8   FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN P17     IOSTANDARD LVCMOS25 } [get_ports rx_data_in[1]]      ; ## H7   FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN P18     IOSTANDARD LVCMOS25 } [get_ports rx_data_in[0]]      ; ## H8   FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN N22     IOSTANDARD LVCMOS25 } [get_ports rx_data_in[3]]      ; ## G9   FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN P22     IOSTANDARD LVCMOS25 } [get_ports rx_data_in[2]]      ; ## G10  FMC_LPC_LA03_N
set_property -dict {PACKAGE_PIN M21     IOSTANDARD LVCMOS25 } [get_ports rx_data_in[5]]      ; ## H10  FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN M22     IOSTANDARD LVCMOS25 } [get_ports rx_data_in[4]]      ; ## H11  FMC_LPC_LA04_N
set_property -dict {PACKAGE_PIN J18     IOSTANDARD LVCMOS25 } [get_ports rx_data_in[7]]      ; ## D11  FMC_LPC_LA05_P
set_property -dict {PACKAGE_PIN K18     IOSTANDARD LVCMOS25 } [get_ports rx_data_in[6]]      ; ## D12  FMC_LPC_LA05_N
set_property -dict {PACKAGE_PIN L21     IOSTANDARD LVCMOS25 } [get_ports rx_data_in[9]]      ; ## C10  FMC_LPC_LA06_P
set_property -dict {PACKAGE_PIN L22     IOSTANDARD LVCMOS25 } [get_ports rx_data_in[8]]      ; ## C11  FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN T16     IOSTANDARD LVCMOS25 } [get_ports rx_data_in[11]]      ; ## H13  FMC_LPC_LA07_P
set_property -dict {PACKAGE_PIN T17     IOSTANDARD LVCMOS25 } [get_ports rx_data_in[10]]      ; ## H14  FMC_LPC_LA07_N

set_property -dict {PACKAGE_PIN J21     IOSTANDARD LVCMOS25} [get_ports tx_clk_out]                        ; ## G12  FMC_LPC_LA08_P
set_property -dict {PACKAGE_PIN R20     IOSTANDARD LVCMOS25} [get_ports tx_frame_out]                      ; ## D14  FMC_LPC_LA09_P
set_property -dict {PACKAGE_PIN N17     IOSTANDARD LVCMOS25} [get_ports tx_data_out[1]]                    ; ## H16  FMC_LPC_LA11_P
set_property -dict {PACKAGE_PIN N18     IOSTANDARD LVCMOS25} [get_ports tx_data_out[0]]                    ; ## H17  FMC_LPC_LA11_N
set_property -dict {PACKAGE_PIN P20     IOSTANDARD LVCMOS25} [get_ports tx_data_out[3]]                    ; ## G15  FMC_LPC_LA12_P
set_property -dict {PACKAGE_PIN P21     IOSTANDARD LVCMOS25} [get_ports tx_data_out[2]]                    ; ## G16  FMC_LPC_LA12_N
set_property -dict {PACKAGE_PIN L17     IOSTANDARD LVCMOS25} [get_ports tx_data_out[5]]                    ; ## D17  FMC_LPC_LA13_P
set_property -dict {PACKAGE_PIN M17     IOSTANDARD LVCMOS25} [get_ports tx_data_out[4]]                    ; ## D18  FMC_LPC_LA13_N
set_property -dict {PACKAGE_PIN R19     IOSTANDARD LVCMOS25} [get_ports tx_data_out[7]]                    ; ## C14  FMC_LPC_LA10_P
set_property -dict {PACKAGE_PIN T19     IOSTANDARD LVCMOS25} [get_ports tx_data_out[6]]                    ; ## C15  FMC_LPC_LA10_N
set_property -dict {PACKAGE_PIN K19     IOSTANDARD LVCMOS25} [get_ports tx_data_out[9]]                    ; ## C18  FMC_LPC_LA14_P
set_property -dict {PACKAGE_PIN K20     IOSTANDARD LVCMOS25} [get_ports tx_data_out[8]]                    ; ## C19  FMC_LPC_LA14_N
set_property -dict {PACKAGE_PIN J16     IOSTANDARD LVCMOS25} [get_ports tx_data_out[11]]                    ; ## H19  FMC_LPC_LA15_P
set_property -dict {PACKAGE_PIN J17     IOSTANDARD LVCMOS25} [get_ports tx_data_out[10]]                    ; ## H20  FMC_LPC_LA15_N

set_property -dict {PACKAGE_PIN A18     IOSTANDARD LVCMOS25} [get_ports ctrl_in[0]]                        ; ## H28  FMC_LPC_LA24_P
set_property -dict {PACKAGE_PIN A19     IOSTANDARD LVCMOS25} [get_ports ctrl_in[1]]                        ; ## H29  FMC_LPC_LA24_N
set_property -dict {PACKAGE_PIN D22     IOSTANDARD LVCMOS25} [get_ports ctrl_in[2]]                        ; ## G27  FMC_LPC_LA25_P
set_property -dict {PACKAGE_PIN C22     IOSTANDARD LVCMOS25} [get_ports ctrl_in[3]]                        ; ## G28  FMC_LPC_LA25_N

set_property -dict {PACKAGE_PIN G15     IOSTANDARD LVCMOS25} [get_ports en_agc]                        ; ## H22  FMC_LPC_LA19_P
set_property -dict {PACKAGE_PIN G16     IOSTANDARD LVCMOS25} [get_ports sync_in]                          ; ## H23  FMC_LPC_LA19_N
set_property -dict {PACKAGE_PIN A16     IOSTANDARD LVCMOS25} [get_ports resetb]                        ; ## H31  FMC_LPC_LA28_P
set_property -dict {PACKAGE_PIN J20     IOSTANDARD LVCMOS25} [get_ports enable]                             ; ## G18  FMC_LPC_LA16_P
set_property -dict {PACKAGE_PIN K21     IOSTANDARD LVCMOS25} [get_ports txnrx]                              ; ## G19  FMC_LPC_LA16_N

set_property -dict {PACKAGE_PIN F18     IOSTANDARD LVCMOS25 PULLTYPE PULLUP} [get_ports spi_enb]            ; ## D26  FMC_LPC_LA26_P
set_property -dict {PACKAGE_PIN E18     IOSTANDARD LVCMOS25} [get_ports spi_clk]                            ; ## D27  FMC_LPC_LA26_N
set_property -dict {PACKAGE_PIN E21     IOSTANDARD LVCMOS25} [get_ports spi_di]                           ; ## C26  FMC_LPC_LA27_P
set_property -dict {PACKAGE_PIN D21     IOSTANDARD LVCMOS25} [get_ports spi_do]                           ; ## C27  FMC_LPC_LA27_N

set_property -dict {PACKAGE_PIN W8      IOSTANDARD LVCMOS33} [get_ports uart_tx]                          ; ##    UART_TX
set_property -dict {PACKAGE_PIN V10     IOSTANDARD LVCMOS33} [get_ports uart_rx]                          ; ##    UART_RX

set_property -dict {PACKAGE_PIN G20     IOSTANDARD LVCMOS25} [get_ports ctrl_out[0]]                          ; ## G21
set_property -dict {PACKAGE_PIN G21     IOSTANDARD LVCMOS25} [get_ports ctrl_out[1]]                          ; ## G22
set_property -dict {PACKAGE_PIN E19     IOSTANDARD LVCMOS25} [get_ports ctrl_out[2]]                          ; ## H25
set_property -dict {PACKAGE_PIN E20     IOSTANDARD LVCMOS25} [get_ports ctrl_out[3]]                          ; ## H26
set_property -dict {PACKAGE_PIN G19     IOSTANDARD LVCMOS25} [get_ports ctrl_out[4]]                          ; ## G24
set_property -dict {PACKAGE_PIN F19     IOSTANDARD LVCMOS25} [get_ports ctrl_out[5]]                          ; ## G25
set_property -dict {PACKAGE_PIN E15     IOSTANDARD LVCMOS25} [get_ports ctrl_out[6]]                          ; ## D23
set_property -dict {PACKAGE_PIN D15     IOSTANDARD LVCMOS25} [get_ports ctrl_out[7]]                          ; ## D24

set_property -dict {PACKAGE_PIN Y11     IOSTANDARD LVCMOS33} [get_ports ctrl_out_led[0]]                          ; ##PMOD1 LED1
set_property -dict {PACKAGE_PIN AA11    IOSTANDARD LVCMOS33} [get_ports ctrl_out_led[2]]                          ; ##PMOD2 LED3
set_property -dict {PACKAGE_PIN Y10     IOSTANDARD LVCMOS33} [get_ports ctrl_out_led[4]]                          ; ##PMOD3 LED5
set_property -dict {PACKAGE_PIN AA9     IOSTANDARD LVCMOS33} [get_ports ctrl_out_led[6]]                          ; ##PMOD4 LED7
set_property -dict {PACKAGE_PIN AB11    IOSTANDARD LVCMOS33} [get_ports ctrl_out_led[1]]                          ; ##PMOD5 LED2
set_property -dict {PACKAGE_PIN AB10    IOSTANDARD LVCMOS33} [get_ports ctrl_out_led[3]]                          ; ##PMOD6 LED4
set_property -dict {PACKAGE_PIN AB9     IOSTANDARD LVCMOS33} [get_ports ctrl_out_led[5]]                          ; ##PMOD7 LED6
set_property -dict {PACKAGE_PIN AA8     IOSTANDARD LVCMOS33} [get_ports ctrl_out_led[7]]                          ; ##PMOD8 LED8

create_clock -name rx_clk -period 4.069 [get_ports rx_clk_in]