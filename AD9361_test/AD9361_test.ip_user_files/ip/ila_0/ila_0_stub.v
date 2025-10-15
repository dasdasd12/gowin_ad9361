// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Wed Oct 15 13:33:35 2025
// Host        : LAPTOP-BU1J38GH running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/program1/Program/2019.1vivado_project/AD9361_test/AD9361_test.srcs/sources_1/ip/ila_0/ila_0_stub.v
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2019.1" *)
module ila_0(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8, probe9, probe10, probe11, probe12, probe13, probe14)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[11:0],probe1[11:0],probe2[11:0],probe3[11:0],probe4[0:0],probe5[2:0],probe6[0:0],probe7[0:0],probe8[0:0],probe9[0:0],probe10[12:0],probe11[11:0],probe12[0:0],probe13[7:0],probe14[0:0]" */;
  input clk;
  input [11:0]probe0;
  input [11:0]probe1;
  input [11:0]probe2;
  input [11:0]probe3;
  input [0:0]probe4;
  input [2:0]probe5;
  input [0:0]probe6;
  input [0:0]probe7;
  input [0:0]probe8;
  input [0:0]probe9;
  input [12:0]probe10;
  input [11:0]probe11;
  input [0:0]probe12;
  input [7:0]probe13;
  input [0:0]probe14;
endmodule
