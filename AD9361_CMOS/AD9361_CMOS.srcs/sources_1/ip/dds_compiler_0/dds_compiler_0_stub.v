// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sun Oct  5 18:02:51 2025
// Host        : LAPTOP-BU1J38GH running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top dds_compiler_0 -prefix
//               dds_compiler_0_ dds_compiler_0_stub.v
// Design      : dds_compiler_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dds_compiler_v6_0_18,Vivado 2019.1" *)
module dds_compiler_0(aclk, aresetn, m_axis_data_tvalid, 
  m_axis_data_tdata, m_axis_phase_tvalid, m_axis_phase_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,aresetn,m_axis_data_tvalid,m_axis_data_tdata[31:0],m_axis_phase_tvalid,m_axis_phase_tdata[23:0]" */;
  input aclk;
  input aresetn;
  output m_axis_data_tvalid;
  output [31:0]m_axis_data_tdata;
  output m_axis_phase_tvalid;
  output [23:0]m_axis_phase_tdata;
endmodule
