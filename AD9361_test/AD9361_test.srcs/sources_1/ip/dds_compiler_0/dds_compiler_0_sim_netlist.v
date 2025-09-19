// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Wed Sep 10 17:34:51 2025
// Host        : LAPTOP-BU1J38GH running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top dds_compiler_0 -prefix
//               dds_compiler_0_ dds_compiler_0_sim_netlist.v
// Design      : dds_compiler_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcku040-ffva1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dds_compiler_0,dds_compiler_v6_0_18,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dds_compiler_v6_0_18,Vivado 2019.1" *) 
(* NotValidForBitStream *)
module dds_compiler_0
   (aclk,
    aresetn,
    m_axis_data_tvalid,
    m_axis_data_tdata,
    m_axis_phase_tvalid,
    m_axis_phase_tdata);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 aclk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME aclk_intf, ASSOCIATED_BUSIF M_AXIS_PHASE:S_AXIS_CONFIG:M_AXIS_DATA:S_AXIS_PHASE, ASSOCIATED_RESET aresetn, ASSOCIATED_CLKEN aclken, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input aclk;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 aresetn_intf RST" *) (* x_interface_parameter = "XIL_INTERFACENAME aresetn_intf, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input aresetn;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_DATA TVALID" *) (* x_interface_parameter = "XIL_INTERFACENAME M_AXIS_DATA, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0" *) output m_axis_data_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_DATA TDATA" *) output [7:0]m_axis_data_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_PHASE TVALID" *) (* x_interface_parameter = "XIL_INTERFACENAME M_AXIS_PHASE, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0" *) output m_axis_phase_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_PHASE TDATA" *) output [31:0]m_axis_phase_tdata;

  wire aclk;
  wire aresetn;
  wire [7:0]m_axis_data_tdata;
  wire m_axis_data_tvalid;
  wire [31:0]m_axis_phase_tdata;
  wire m_axis_phase_tvalid;
  wire NLW_U0_debug_axi_resync_in_UNCONNECTED;
  wire NLW_U0_debug_core_nd_UNCONNECTED;
  wire NLW_U0_debug_phase_nd_UNCONNECTED;
  wire NLW_U0_event_phase_in_invalid_UNCONNECTED;
  wire NLW_U0_event_pinc_invalid_UNCONNECTED;
  wire NLW_U0_event_poff_invalid_UNCONNECTED;
  wire NLW_U0_event_s_config_tlast_missing_UNCONNECTED;
  wire NLW_U0_event_s_config_tlast_unexpected_UNCONNECTED;
  wire NLW_U0_event_s_phase_chanid_incorrect_UNCONNECTED;
  wire NLW_U0_event_s_phase_tlast_missing_UNCONNECTED;
  wire NLW_U0_event_s_phase_tlast_unexpected_UNCONNECTED;
  wire NLW_U0_m_axis_data_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_phase_tlast_UNCONNECTED;
  wire NLW_U0_s_axis_config_tready_UNCONNECTED;
  wire NLW_U0_s_axis_phase_tready_UNCONNECTED;
  wire [0:0]NLW_U0_debug_axi_chan_in_UNCONNECTED;
  wire [27:0]NLW_U0_debug_axi_pinc_in_UNCONNECTED;
  wire [27:0]NLW_U0_debug_axi_poff_in_UNCONNECTED;
  wire [27:0]NLW_U0_debug_phase_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_data_tuser_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_phase_tuser_UNCONNECTED;

  (* C_ACCUMULATOR_WIDTH = "28" *) 
  (* C_AMPLITUDE = "0" *) 
  (* C_CHANNELS = "1" *) 
  (* C_CHAN_WIDTH = "1" *) 
  (* C_DEBUG_INTERFACE = "0" *) 
  (* C_HAS_ACLKEN = "0" *) 
  (* C_HAS_ARESETN = "1" *) 
  (* C_HAS_M_DATA = "1" *) 
  (* C_HAS_M_PHASE = "1" *) 
  (* C_HAS_PHASEGEN = "1" *) 
  (* C_HAS_PHASE_OUT = "1" *) 
  (* C_HAS_SINCOS = "1" *) 
  (* C_HAS_S_CONFIG = "0" *) 
  (* C_HAS_S_PHASE = "0" *) 
  (* C_HAS_TLAST = "0" *) 
  (* C_HAS_TREADY = "0" *) 
  (* C_LATENCY = "3" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MODE_OF_OPERATION = "0" *) 
  (* C_MODULUS = "9" *) 
  (* C_M_DATA_HAS_TUSER = "0" *) 
  (* C_M_DATA_TDATA_WIDTH = "8" *) 
  (* C_M_DATA_TUSER_WIDTH = "1" *) 
  (* C_M_PHASE_HAS_TUSER = "0" *) 
  (* C_M_PHASE_TDATA_WIDTH = "32" *) 
  (* C_M_PHASE_TUSER_WIDTH = "1" *) 
  (* C_NEGATIVE_COSINE = "0" *) 
  (* C_NEGATIVE_SINE = "0" *) 
  (* C_NOISE_SHAPING = "0" *) 
  (* C_OPTIMISE_GOAL = "0" *) 
  (* C_OUTPUTS_REQUIRED = "0" *) 
  (* C_OUTPUT_FORM = "0" *) 
  (* C_OUTPUT_WIDTH = "8" *) 
  (* C_PHASE_ANGLE_WIDTH = "8" *) 
  (* C_PHASE_INCREMENT = "2" *) 
  (* C_PHASE_INCREMENT_VALUE = "101000111101011100001010,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" *) 
  (* C_PHASE_OFFSET = "0" *) 
  (* C_PHASE_OFFSET_VALUE = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" *) 
  (* C_POR_MODE = "0" *) 
  (* C_RESYNC = "0" *) 
  (* C_S_CONFIG_SYNC_MODE = "0" *) 
  (* C_S_CONFIG_TDATA_WIDTH = "1" *) 
  (* C_S_PHASE_HAS_TUSER = "0" *) 
  (* C_S_PHASE_TDATA_WIDTH = "1" *) 
  (* C_S_PHASE_TUSER_WIDTH = "1" *) 
  (* C_USE_DSP48 = "0" *) 
  (* C_XDEVICEFAMILY = "kintexu" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  dds_compiler_0_dds_compiler_v6_0_18 U0
       (.aclk(aclk),
        .aclken(1'b1),
        .aresetn(aresetn),
        .debug_axi_chan_in(NLW_U0_debug_axi_chan_in_UNCONNECTED[0]),
        .debug_axi_pinc_in(NLW_U0_debug_axi_pinc_in_UNCONNECTED[27:0]),
        .debug_axi_poff_in(NLW_U0_debug_axi_poff_in_UNCONNECTED[27:0]),
        .debug_axi_resync_in(NLW_U0_debug_axi_resync_in_UNCONNECTED),
        .debug_core_nd(NLW_U0_debug_core_nd_UNCONNECTED),
        .debug_phase(NLW_U0_debug_phase_UNCONNECTED[27:0]),
        .debug_phase_nd(NLW_U0_debug_phase_nd_UNCONNECTED),
        .event_phase_in_invalid(NLW_U0_event_phase_in_invalid_UNCONNECTED),
        .event_pinc_invalid(NLW_U0_event_pinc_invalid_UNCONNECTED),
        .event_poff_invalid(NLW_U0_event_poff_invalid_UNCONNECTED),
        .event_s_config_tlast_missing(NLW_U0_event_s_config_tlast_missing_UNCONNECTED),
        .event_s_config_tlast_unexpected(NLW_U0_event_s_config_tlast_unexpected_UNCONNECTED),
        .event_s_phase_chanid_incorrect(NLW_U0_event_s_phase_chanid_incorrect_UNCONNECTED),
        .event_s_phase_tlast_missing(NLW_U0_event_s_phase_tlast_missing_UNCONNECTED),
        .event_s_phase_tlast_unexpected(NLW_U0_event_s_phase_tlast_unexpected_UNCONNECTED),
        .m_axis_data_tdata(m_axis_data_tdata),
        .m_axis_data_tlast(NLW_U0_m_axis_data_tlast_UNCONNECTED),
        .m_axis_data_tready(1'b0),
        .m_axis_data_tuser(NLW_U0_m_axis_data_tuser_UNCONNECTED[0]),
        .m_axis_data_tvalid(m_axis_data_tvalid),
        .m_axis_phase_tdata(m_axis_phase_tdata),
        .m_axis_phase_tlast(NLW_U0_m_axis_phase_tlast_UNCONNECTED),
        .m_axis_phase_tready(1'b0),
        .m_axis_phase_tuser(NLW_U0_m_axis_phase_tuser_UNCONNECTED[0]),
        .m_axis_phase_tvalid(m_axis_phase_tvalid),
        .s_axis_config_tdata(1'b0),
        .s_axis_config_tlast(1'b0),
        .s_axis_config_tready(NLW_U0_s_axis_config_tready_UNCONNECTED),
        .s_axis_config_tvalid(1'b0),
        .s_axis_phase_tdata(1'b0),
        .s_axis_phase_tlast(1'b0),
        .s_axis_phase_tready(NLW_U0_s_axis_phase_tready_UNCONNECTED),
        .s_axis_phase_tuser(1'b0),
        .s_axis_phase_tvalid(1'b0));
endmodule

(* C_ACCUMULATOR_WIDTH = "28" *) (* C_AMPLITUDE = "0" *) (* C_CHANNELS = "1" *) 
(* C_CHAN_WIDTH = "1" *) (* C_DEBUG_INTERFACE = "0" *) (* C_HAS_ACLKEN = "0" *) 
(* C_HAS_ARESETN = "1" *) (* C_HAS_M_DATA = "1" *) (* C_HAS_M_PHASE = "1" *) 
(* C_HAS_PHASEGEN = "1" *) (* C_HAS_PHASE_OUT = "1" *) (* C_HAS_SINCOS = "1" *) 
(* C_HAS_S_CONFIG = "0" *) (* C_HAS_S_PHASE = "0" *) (* C_HAS_TLAST = "0" *) 
(* C_HAS_TREADY = "0" *) (* C_LATENCY = "3" *) (* C_MEM_TYPE = "1" *) 
(* C_MODE_OF_OPERATION = "0" *) (* C_MODULUS = "9" *) (* C_M_DATA_HAS_TUSER = "0" *) 
(* C_M_DATA_TDATA_WIDTH = "8" *) (* C_M_DATA_TUSER_WIDTH = "1" *) (* C_M_PHASE_HAS_TUSER = "0" *) 
(* C_M_PHASE_TDATA_WIDTH = "32" *) (* C_M_PHASE_TUSER_WIDTH = "1" *) (* C_NEGATIVE_COSINE = "0" *) 
(* C_NEGATIVE_SINE = "0" *) (* C_NOISE_SHAPING = "0" *) (* C_OPTIMISE_GOAL = "0" *) 
(* C_OUTPUTS_REQUIRED = "0" *) (* C_OUTPUT_FORM = "0" *) (* C_OUTPUT_WIDTH = "8" *) 
(* C_PHASE_ANGLE_WIDTH = "8" *) (* C_PHASE_INCREMENT = "2" *) (* C_PHASE_INCREMENT_VALUE = "101000111101011100001010,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" *) 
(* C_PHASE_OFFSET = "0" *) (* C_PHASE_OFFSET_VALUE = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" *) (* C_POR_MODE = "0" *) 
(* C_RESYNC = "0" *) (* C_S_CONFIG_SYNC_MODE = "0" *) (* C_S_CONFIG_TDATA_WIDTH = "1" *) 
(* C_S_PHASE_HAS_TUSER = "0" *) (* C_S_PHASE_TDATA_WIDTH = "1" *) (* C_S_PHASE_TUSER_WIDTH = "1" *) 
(* C_USE_DSP48 = "0" *) (* C_XDEVICEFAMILY = "kintexu" *) (* downgradeipidentifiedwarnings = "yes" *) 
module dds_compiler_0_dds_compiler_v6_0_18
   (aclk,
    aclken,
    aresetn,
    s_axis_phase_tvalid,
    s_axis_phase_tready,
    s_axis_phase_tdata,
    s_axis_phase_tlast,
    s_axis_phase_tuser,
    s_axis_config_tvalid,
    s_axis_config_tready,
    s_axis_config_tdata,
    s_axis_config_tlast,
    m_axis_data_tvalid,
    m_axis_data_tready,
    m_axis_data_tdata,
    m_axis_data_tlast,
    m_axis_data_tuser,
    m_axis_phase_tvalid,
    m_axis_phase_tready,
    m_axis_phase_tdata,
    m_axis_phase_tlast,
    m_axis_phase_tuser,
    event_pinc_invalid,
    event_poff_invalid,
    event_phase_in_invalid,
    event_s_phase_tlast_missing,
    event_s_phase_tlast_unexpected,
    event_s_phase_chanid_incorrect,
    event_s_config_tlast_missing,
    event_s_config_tlast_unexpected,
    debug_axi_pinc_in,
    debug_axi_poff_in,
    debug_axi_resync_in,
    debug_axi_chan_in,
    debug_core_nd,
    debug_phase,
    debug_phase_nd);
  input aclk;
  input aclken;
  input aresetn;
  input s_axis_phase_tvalid;
  output s_axis_phase_tready;
  input [0:0]s_axis_phase_tdata;
  input s_axis_phase_tlast;
  input [0:0]s_axis_phase_tuser;
  input s_axis_config_tvalid;
  output s_axis_config_tready;
  input [0:0]s_axis_config_tdata;
  input s_axis_config_tlast;
  output m_axis_data_tvalid;
  input m_axis_data_tready;
  output [7:0]m_axis_data_tdata;
  output m_axis_data_tlast;
  output [0:0]m_axis_data_tuser;
  output m_axis_phase_tvalid;
  input m_axis_phase_tready;
  output [31:0]m_axis_phase_tdata;
  output m_axis_phase_tlast;
  output [0:0]m_axis_phase_tuser;
  output event_pinc_invalid;
  output event_poff_invalid;
  output event_phase_in_invalid;
  output event_s_phase_tlast_missing;
  output event_s_phase_tlast_unexpected;
  output event_s_phase_chanid_incorrect;
  output event_s_config_tlast_missing;
  output event_s_config_tlast_unexpected;
  output [27:0]debug_axi_pinc_in;
  output [27:0]debug_axi_poff_in;
  output debug_axi_resync_in;
  output [0:0]debug_axi_chan_in;
  output debug_core_nd;
  output [27:0]debug_phase;
  output debug_phase_nd;

  wire \<const0> ;
  wire \<const1> ;
  wire aclk;
  wire aresetn;
  wire [7:0]m_axis_data_tdata;
  wire [27:0]\^m_axis_phase_tdata ;
  wire m_axis_phase_tvalid;
  wire NLW_i_synth_debug_axi_resync_in_UNCONNECTED;
  wire NLW_i_synth_debug_core_nd_UNCONNECTED;
  wire NLW_i_synth_debug_phase_nd_UNCONNECTED;
  wire NLW_i_synth_event_phase_in_invalid_UNCONNECTED;
  wire NLW_i_synth_event_pinc_invalid_UNCONNECTED;
  wire NLW_i_synth_event_poff_invalid_UNCONNECTED;
  wire NLW_i_synth_event_s_config_tlast_missing_UNCONNECTED;
  wire NLW_i_synth_event_s_config_tlast_unexpected_UNCONNECTED;
  wire NLW_i_synth_event_s_phase_chanid_incorrect_UNCONNECTED;
  wire NLW_i_synth_event_s_phase_tlast_missing_UNCONNECTED;
  wire NLW_i_synth_event_s_phase_tlast_unexpected_UNCONNECTED;
  wire NLW_i_synth_m_axis_data_tlast_UNCONNECTED;
  wire NLW_i_synth_m_axis_phase_tlast_UNCONNECTED;
  wire NLW_i_synth_m_axis_phase_tvalid_UNCONNECTED;
  wire NLW_i_synth_s_axis_config_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_phase_tready_UNCONNECTED;
  wire [0:0]NLW_i_synth_debug_axi_chan_in_UNCONNECTED;
  wire [27:0]NLW_i_synth_debug_axi_pinc_in_UNCONNECTED;
  wire [27:0]NLW_i_synth_debug_axi_poff_in_UNCONNECTED;
  wire [27:0]NLW_i_synth_debug_phase_UNCONNECTED;
  wire [0:0]NLW_i_synth_m_axis_data_tuser_UNCONNECTED;
  wire [30:27]NLW_i_synth_m_axis_phase_tdata_UNCONNECTED;
  wire [0:0]NLW_i_synth_m_axis_phase_tuser_UNCONNECTED;

  assign debug_axi_chan_in[0] = \<const0> ;
  assign debug_axi_pinc_in[27] = \<const0> ;
  assign debug_axi_pinc_in[26] = \<const0> ;
  assign debug_axi_pinc_in[25] = \<const0> ;
  assign debug_axi_pinc_in[24] = \<const0> ;
  assign debug_axi_pinc_in[23] = \<const0> ;
  assign debug_axi_pinc_in[22] = \<const0> ;
  assign debug_axi_pinc_in[21] = \<const0> ;
  assign debug_axi_pinc_in[20] = \<const0> ;
  assign debug_axi_pinc_in[19] = \<const0> ;
  assign debug_axi_pinc_in[18] = \<const0> ;
  assign debug_axi_pinc_in[17] = \<const0> ;
  assign debug_axi_pinc_in[16] = \<const0> ;
  assign debug_axi_pinc_in[15] = \<const0> ;
  assign debug_axi_pinc_in[14] = \<const0> ;
  assign debug_axi_pinc_in[13] = \<const0> ;
  assign debug_axi_pinc_in[12] = \<const0> ;
  assign debug_axi_pinc_in[11] = \<const0> ;
  assign debug_axi_pinc_in[10] = \<const0> ;
  assign debug_axi_pinc_in[9] = \<const0> ;
  assign debug_axi_pinc_in[8] = \<const0> ;
  assign debug_axi_pinc_in[7] = \<const0> ;
  assign debug_axi_pinc_in[6] = \<const0> ;
  assign debug_axi_pinc_in[5] = \<const0> ;
  assign debug_axi_pinc_in[4] = \<const0> ;
  assign debug_axi_pinc_in[3] = \<const0> ;
  assign debug_axi_pinc_in[2] = \<const0> ;
  assign debug_axi_pinc_in[1] = \<const0> ;
  assign debug_axi_pinc_in[0] = \<const0> ;
  assign debug_axi_poff_in[27] = \<const0> ;
  assign debug_axi_poff_in[26] = \<const0> ;
  assign debug_axi_poff_in[25] = \<const0> ;
  assign debug_axi_poff_in[24] = \<const0> ;
  assign debug_axi_poff_in[23] = \<const0> ;
  assign debug_axi_poff_in[22] = \<const0> ;
  assign debug_axi_poff_in[21] = \<const0> ;
  assign debug_axi_poff_in[20] = \<const0> ;
  assign debug_axi_poff_in[19] = \<const0> ;
  assign debug_axi_poff_in[18] = \<const0> ;
  assign debug_axi_poff_in[17] = \<const0> ;
  assign debug_axi_poff_in[16] = \<const0> ;
  assign debug_axi_poff_in[15] = \<const0> ;
  assign debug_axi_poff_in[14] = \<const0> ;
  assign debug_axi_poff_in[13] = \<const0> ;
  assign debug_axi_poff_in[12] = \<const0> ;
  assign debug_axi_poff_in[11] = \<const0> ;
  assign debug_axi_poff_in[10] = \<const0> ;
  assign debug_axi_poff_in[9] = \<const0> ;
  assign debug_axi_poff_in[8] = \<const0> ;
  assign debug_axi_poff_in[7] = \<const0> ;
  assign debug_axi_poff_in[6] = \<const0> ;
  assign debug_axi_poff_in[5] = \<const0> ;
  assign debug_axi_poff_in[4] = \<const0> ;
  assign debug_axi_poff_in[3] = \<const0> ;
  assign debug_axi_poff_in[2] = \<const0> ;
  assign debug_axi_poff_in[1] = \<const0> ;
  assign debug_axi_poff_in[0] = \<const0> ;
  assign debug_axi_resync_in = \<const0> ;
  assign debug_core_nd = \<const0> ;
  assign debug_phase[27] = \<const0> ;
  assign debug_phase[26] = \<const0> ;
  assign debug_phase[25] = \<const0> ;
  assign debug_phase[24] = \<const0> ;
  assign debug_phase[23] = \<const0> ;
  assign debug_phase[22] = \<const0> ;
  assign debug_phase[21] = \<const0> ;
  assign debug_phase[20] = \<const0> ;
  assign debug_phase[19] = \<const0> ;
  assign debug_phase[18] = \<const0> ;
  assign debug_phase[17] = \<const0> ;
  assign debug_phase[16] = \<const0> ;
  assign debug_phase[15] = \<const0> ;
  assign debug_phase[14] = \<const0> ;
  assign debug_phase[13] = \<const0> ;
  assign debug_phase[12] = \<const0> ;
  assign debug_phase[11] = \<const0> ;
  assign debug_phase[10] = \<const0> ;
  assign debug_phase[9] = \<const0> ;
  assign debug_phase[8] = \<const0> ;
  assign debug_phase[7] = \<const0> ;
  assign debug_phase[6] = \<const0> ;
  assign debug_phase[5] = \<const0> ;
  assign debug_phase[4] = \<const0> ;
  assign debug_phase[3] = \<const0> ;
  assign debug_phase[2] = \<const0> ;
  assign debug_phase[1] = \<const0> ;
  assign debug_phase[0] = \<const0> ;
  assign debug_phase_nd = \<const0> ;
  assign event_phase_in_invalid = \<const0> ;
  assign event_pinc_invalid = \<const0> ;
  assign event_poff_invalid = \<const0> ;
  assign event_s_config_tlast_missing = \<const0> ;
  assign event_s_config_tlast_unexpected = \<const0> ;
  assign event_s_phase_chanid_incorrect = \<const0> ;
  assign event_s_phase_tlast_missing = \<const0> ;
  assign event_s_phase_tlast_unexpected = \<const0> ;
  assign m_axis_data_tlast = \<const0> ;
  assign m_axis_data_tuser[0] = \<const0> ;
  assign m_axis_data_tvalid = m_axis_phase_tvalid;
  assign m_axis_phase_tdata[31] = \^m_axis_phase_tdata [27];
  assign m_axis_phase_tdata[30] = \^m_axis_phase_tdata [27];
  assign m_axis_phase_tdata[29] = \^m_axis_phase_tdata [27];
  assign m_axis_phase_tdata[28] = \^m_axis_phase_tdata [27];
  assign m_axis_phase_tdata[27:0] = \^m_axis_phase_tdata [27:0];
  assign m_axis_phase_tlast = \<const0> ;
  assign m_axis_phase_tuser[0] = \<const0> ;
  assign s_axis_config_tready = \<const1> ;
  assign s_axis_phase_tready = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  (* C_ACCUMULATOR_WIDTH = "28" *) 
  (* C_AMPLITUDE = "0" *) 
  (* C_CHANNELS = "1" *) 
  (* C_CHAN_WIDTH = "1" *) 
  (* C_DEBUG_INTERFACE = "0" *) 
  (* C_HAS_ACLKEN = "0" *) 
  (* C_HAS_ARESETN = "1" *) 
  (* C_HAS_M_DATA = "1" *) 
  (* C_HAS_M_PHASE = "1" *) 
  (* C_HAS_PHASEGEN = "1" *) 
  (* C_HAS_PHASE_OUT = "1" *) 
  (* C_HAS_SINCOS = "1" *) 
  (* C_HAS_S_CONFIG = "0" *) 
  (* C_HAS_S_PHASE = "0" *) 
  (* C_HAS_TLAST = "0" *) 
  (* C_HAS_TREADY = "0" *) 
  (* C_LATENCY = "3" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MODE_OF_OPERATION = "0" *) 
  (* C_MODULUS = "9" *) 
  (* C_M_DATA_HAS_TUSER = "0" *) 
  (* C_M_DATA_TDATA_WIDTH = "8" *) 
  (* C_M_DATA_TUSER_WIDTH = "1" *) 
  (* C_M_PHASE_HAS_TUSER = "0" *) 
  (* C_M_PHASE_TDATA_WIDTH = "32" *) 
  (* C_M_PHASE_TUSER_WIDTH = "1" *) 
  (* C_NEGATIVE_COSINE = "0" *) 
  (* C_NEGATIVE_SINE = "0" *) 
  (* C_NOISE_SHAPING = "0" *) 
  (* C_OPTIMISE_GOAL = "0" *) 
  (* C_OUTPUTS_REQUIRED = "0" *) 
  (* C_OUTPUT_FORM = "0" *) 
  (* C_OUTPUT_WIDTH = "8" *) 
  (* C_PHASE_ANGLE_WIDTH = "8" *) 
  (* C_PHASE_INCREMENT = "2" *) 
  (* C_PHASE_INCREMENT_VALUE = "101000111101011100001010,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" *) 
  (* C_PHASE_OFFSET = "0" *) 
  (* C_PHASE_OFFSET_VALUE = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" *) 
  (* C_POR_MODE = "0" *) 
  (* C_RESYNC = "0" *) 
  (* C_S_CONFIG_SYNC_MODE = "0" *) 
  (* C_S_CONFIG_TDATA_WIDTH = "1" *) 
  (* C_S_PHASE_HAS_TUSER = "0" *) 
  (* C_S_PHASE_TDATA_WIDTH = "1" *) 
  (* C_S_PHASE_TUSER_WIDTH = "1" *) 
  (* C_USE_DSP48 = "0" *) 
  (* C_XDEVICEFAMILY = "kintexu" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  dds_compiler_0_dds_compiler_v6_0_18_viv i_synth
       (.aclk(aclk),
        .aclken(1'b0),
        .aresetn(aresetn),
        .debug_axi_chan_in(NLW_i_synth_debug_axi_chan_in_UNCONNECTED[0]),
        .debug_axi_pinc_in(NLW_i_synth_debug_axi_pinc_in_UNCONNECTED[27:0]),
        .debug_axi_poff_in(NLW_i_synth_debug_axi_poff_in_UNCONNECTED[27:0]),
        .debug_axi_resync_in(NLW_i_synth_debug_axi_resync_in_UNCONNECTED),
        .debug_core_nd(NLW_i_synth_debug_core_nd_UNCONNECTED),
        .debug_phase(NLW_i_synth_debug_phase_UNCONNECTED[27:0]),
        .debug_phase_nd(NLW_i_synth_debug_phase_nd_UNCONNECTED),
        .event_phase_in_invalid(NLW_i_synth_event_phase_in_invalid_UNCONNECTED),
        .event_pinc_invalid(NLW_i_synth_event_pinc_invalid_UNCONNECTED),
        .event_poff_invalid(NLW_i_synth_event_poff_invalid_UNCONNECTED),
        .event_s_config_tlast_missing(NLW_i_synth_event_s_config_tlast_missing_UNCONNECTED),
        .event_s_config_tlast_unexpected(NLW_i_synth_event_s_config_tlast_unexpected_UNCONNECTED),
        .event_s_phase_chanid_incorrect(NLW_i_synth_event_s_phase_chanid_incorrect_UNCONNECTED),
        .event_s_phase_tlast_missing(NLW_i_synth_event_s_phase_tlast_missing_UNCONNECTED),
        .event_s_phase_tlast_unexpected(NLW_i_synth_event_s_phase_tlast_unexpected_UNCONNECTED),
        .m_axis_data_tdata(m_axis_data_tdata),
        .m_axis_data_tlast(NLW_i_synth_m_axis_data_tlast_UNCONNECTED),
        .m_axis_data_tready(1'b0),
        .m_axis_data_tuser(NLW_i_synth_m_axis_data_tuser_UNCONNECTED[0]),
        .m_axis_data_tvalid(m_axis_phase_tvalid),
        .m_axis_phase_tdata({\^m_axis_phase_tdata [27],NLW_i_synth_m_axis_phase_tdata_UNCONNECTED[30:27],\^m_axis_phase_tdata [26:0]}),
        .m_axis_phase_tlast(NLW_i_synth_m_axis_phase_tlast_UNCONNECTED),
        .m_axis_phase_tready(1'b0),
        .m_axis_phase_tuser(NLW_i_synth_m_axis_phase_tuser_UNCONNECTED[0]),
        .m_axis_phase_tvalid(NLW_i_synth_m_axis_phase_tvalid_UNCONNECTED),
        .s_axis_config_tdata(1'b0),
        .s_axis_config_tlast(1'b0),
        .s_axis_config_tready(NLW_i_synth_s_axis_config_tready_UNCONNECTED),
        .s_axis_config_tvalid(1'b0),
        .s_axis_phase_tdata(1'b0),
        .s_axis_phase_tlast(1'b0),
        .s_axis_phase_tready(NLW_i_synth_s_axis_phase_tready_UNCONNECTED),
        .s_axis_phase_tuser(1'b0),
        .s_axis_phase_tvalid(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2019.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
ag49RSaXLOG4xxULlDyO1h9Bt1tXxD8QSYAdgfsZmsYA2qz7wg+SSUXB8JjzU2owt7o4eSmQVBkv
9kufty+oIQ==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
beER7wF1A3pmXiXm1TFX9IvmAFUcJ13uMC6TseJWrR0JDHD/O3dKRM6PO4Up/CFQ2H37nKClSGcK
Xug89GBtLfoDpFLh+xP2Vy07zuqOy7uywLvaukELsTzPf+0n/Xp60hkmPlC81KPi1DXhJUhJdbqA
yi5TP4w1WPUjCtK/688=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
uJZzBmpzrESHK9uJTBRGbyDZMxFeU9+2SClZZYLsPBAU9V9oQiK75ubhJObpnmwewUOoBxz3zJhu
34asP1BGbunyLgeJYr0OiNow3a8XihoRSYbIdKxKq3vjl4MLatqJEBLCN8Uqf0Pu+E+jWbMFfcxy
YAnzqN8sgF4OZI5wLBzPXafQi1767wu3Wtw/sQe5anCy8TAyLarP9ast1O9Vj15Rk2tLtgm/LZqR
yZd0qKSqmW4A81G6x+ixR2y/IqQ1qALI1NCgPfvH4Ieyq7XPyblqlNyParNLhG2wjr0y4ofNWp/3
h4o2c+vYiIrkx6rmzrp/rUIybZ9A9HDZaA+ciA==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
MfuZTTml919Hbg0Ib2VBuKuYX6+OjqUB2INt3NN2eutVeJhuMufRcsa0q1J3vztEmpkdGV6+RTfb
HKoQKFD6EwJ10b0AcDFjpD8+L6fGReFnvS0g731shB/OodUdaV8giQpoNHCm2XtoKsv/Lgqn+U27
EV3lJK6Lt+nUx6DUsocHc5RcvRHw58/myY6ZtXqFDMXJfFOVK18LSGHnEg1OXkFqEApSxPVexe3t
s0jVQDZRqkFortHzVNrWx73GPD4RFe+7vmA/hegviTOrtvw99UpoL8yyjZyO3WOlde1quROnWZtl
8BwV/r+EPBUPh50jKc+nVMUwLKYH8/iDFUIpsA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_02", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bJsfCx8emG9lVb/vjASSH6y78U+06ketn/XvcxXkuwOnvwxs7wpKbvKxuP4Ht/qw/W2x/0Yf02kE
WBxMF+BnpDUX67X5j60mOzT2j0ZYCuFJN9kbpdHjz3Ekw/u9MBVbJppIZsHCWkzk8bOejCc+dey6
uKr6E3w+/K97/Rld2HkJp2oTONv039xGcZEjeSi0lePhlRX0rhSfD0ixFje/nMEadDX5qmjf3+jt
/VeShbed51E8U6v7e1T5QOk3TdFmkYjH+NGfYuQg3iCCVd/1LP9eqPJHZkzv46tJ9yquR6upFVae
N2f7q08udoFP14ZZMSWY0FVcj+R8uc1SpoZ08w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
DD7F0WIA2tCJDGGyuiJBMJ6VkyzlY4wTm+PBxGw32rno1Lc5XJ6R/MdpajSKtZkvW3jP5SII6hW8
/NoKV4ROiGDYzmMIubH+jq3u0TtkWxCL8+cj3SNuMEayY39+8F4sUjaZEFERxcl1JK64XpQCcPdd
qDExjxIvRWRuuTD424M=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Z8r/pZDFkssalgvLpiT5lxxnKwN27AIWvhfsYdefLfSuxYTC5pbsQO/glsRgaQ+pfMXTafAs1c8M
dypCXo6c0EAVYWrPv6LXzncAvpvkgF3equA0GovqWA9u1DpNOwpg1+9zyuK298jIW0FY3V+8XZYP
i9enkYei0sCGexSdPzqATDbRzjzApbpnBZpWe6z4en7Wb9o0cFYVvU0I2D694fRndQa2DDTk5yRa
yG9QYOCPabDGrsr3xHF371LpdUv9XcgOm45jMWa9bZ1oL2S9hL6xUIjS0C8vlmUWEtNohYiiamIC
mjfkGqLNOX02xYC0DG4kzfO01bAlP3sDf4JdCw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lfBjYiGsQJ9a35GLufYrg0/JqEAR2tyUF8iDFuvrxR3MexLdX92O+PxJvwyxAFZ1gYsyVpSZ027o
naqd0lKf01j+6XsaQjbQmuW5hhP/9giWFzEWIi1qX71xDV1cFkwZFdDvxhymX4EZIx2TzEOQ+qcn
8lrIhAbTBVB/dyN4kaJPXEwyoWYHXFQ9Mp0dY0IVJUpjc+xT2u4ZDuJUhel3cRZs8aJtAXqul/rj
yOisnDcck+2yjNhn8vUh9wIjZPcI/Y5Eqzlllf0m4DHOiwl72l+PZBN2qXErUiX6kfxn4pt0j5U3
AjHXFJ/O8f+y6ts9Igk31v6xBd0taLHrLPH62w==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
I7sRIonKXFC9X83g/pjtrPIsQJbzvnj0VK2qo0rVf4VJuuWDKVw8Kj6QgKO4vt4IK/ClkatIXRMu
WTGDXBBLm3caCFUTaf5MyOFkwA7iIIwEmgdzgpMdLglvchr/3WSxwV03Uys28rd7qQ5aWvrmIaGZ
aYuNjqWLtRg8jvwevaOQHn1l8unBrX8p9HeKu3+U9yl+/u6erKQUpdA/BECWlOlx7s/bMkYNCnbi
dO5S98eBAiZnl8+lKoYa7dNiw/i9BT4PSSxAnrg4aBPECkWmjdhkhHpHY6kvQrK7N5/KyLe3skXU
wu9bPG4KBy/mw+RtPH49i7+J2t/59tsmn5HbaA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 47520)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
