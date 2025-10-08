-makelib ies_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../AD9361_test.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3_clk_wiz.v" \
  "../../../../AD9361_test.srcs/sources_1/ip/clk_wiz_3/clk_wiz_3.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

