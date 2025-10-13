-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Mon Oct 13 22:44:23 2025
-- Host        : LAPTOP-BU1J38GH running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/program1/Program/2019.1vivado_project/AD9361_test/AD9361_test.srcs/sources_1/ip/ila_1/ila_1_stub.vhdl
-- Design      : ila_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ila_1 is
  Port ( 
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe1 : in STD_LOGIC_VECTOR ( 11 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 11 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe4 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe5 : in STD_LOGIC_VECTOR ( 10 downto 0 );
    probe6 : in STD_LOGIC_VECTOR ( 11 downto 0 );
    probe7 : in STD_LOGIC_VECTOR ( 11 downto 0 );
    probe8 : in STD_LOGIC_VECTOR ( 11 downto 0 );
    probe9 : in STD_LOGIC_VECTOR ( 11 downto 0 );
    probe10 : in STD_LOGIC_VECTOR ( 13 downto 0 );
    probe11 : in STD_LOGIC_VECTOR ( 17 downto 0 );
    probe12 : in STD_LOGIC_VECTOR ( 17 downto 0 );
    probe13 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe14 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    probe15 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    probe16 : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );

end ila_1;

architecture stub of ila_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe0[0:0],probe1[11:0],probe2[11:0],probe3[0:0],probe4[2:0],probe5[10:0],probe6[11:0],probe7[11:0],probe8[11:0],probe9[11:0],probe10[13:0],probe11[17:0],probe12[17:0],probe13[0:0],probe14[1:0],probe15[1:0],probe16[7:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ila,Vivado 2019.1";
begin
end;
