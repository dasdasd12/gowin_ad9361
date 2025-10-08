// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Tue Oct  7 15:51:20 2025
// Host        : LAPTOP-BU1J38GH running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/program1/Program/2019.1vivado_project/AD9361_test/AD9361_test.srcs/sources_1/ip/ila_1/ila_1_stub.v
// Design      : ila_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2019.1" *)
module ila_1(clk, probe0, probe1, probe2, probe3, probe4, probe5)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[11:0],probe2[11:0],probe3[0:0],probe4[2:0],probe5[10:0]" */;
  input clk;
  input [0:0]probe0;
  input [11:0]probe1;
  input [11:0]probe2;
  input [0:0]probe3;
  input [2:0]probe4;
  input [10:0]probe5;
endmodule
