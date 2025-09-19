module ad9361_cfg_rom(
    input                               clk                        ,
    input                [  11: 0]      addr                       ,
    output reg           [  19: 0]      data                        
);

    always @(posedge clk) begin
        case(addr)
            12'd0000: data <= 20'h3DF01;                            // SPIWrite [3DF]=01
            12'd0001: data <= 20'h29514;                            // SPIWrite [295]=14, Power up XO path (Default)
            12'd0002: data <= 20'h2A60E;                            // SPIWrite [2A6]=0E, Enable Master Bias
            12'd0003: data <= 20'h2A80E;                            // SPIWrite [2A8]=0E, Set Bandgap Trim
            12'd0004: data <= 20'h29208;                            // SPIWrite [292]=08, Set DCXO Coarse Tune[5:0]
            12'd0005: data <= 20'h29380;                            // SPIWrite [293]=80, Set DCXO Fine Tune [12:5]
            12'd0006: data <= 20'h29400;                            // SPIWrite [294]=00, Set DCXO Fine Tune [4:0]
            12'd0007: data <= 20'h2AB07;                            // SPIWrite [2AB]=07, Set RF PLL reflclk scale to REFCLK * 2
            12'd0008: data <= 20'h2ACFF;                            // SPIWrite [2AC]=FF, Set RF PLL reflclk scale to REFCLK * 2
            12'd0009: data <= 20'h00907;                            // SPIWrite [009]=07, Enable Clocks
            12'd0010: data <= 20'h40000;                            // WAIT 20 ms, waits 20 ms
            12'd0011: data <= 20'h04500;                            // SPIWrite [045]=00, Set BBPLL reflclk scale to REFCLK /1
            12'd0012: data <= 20'h04603;                            // SPIWrite [046]=03, Set BBPLL Loop Filter Charge Pump current
            12'd0013: data <= 20'h048E8;                            // SPIWrite [048]=E8, Set BBPLL Loop Filter C1, R1
            12'd0014: data <= 20'h0495B;                            // SPIWrite [049]=5B, Set BBPLL Loop Filter R2, C2, C1
            12'd0015: data <= 20'h04A35;                            // SPIWrite [04A]=35, Set BBPLL Loop Filter C3,R2
            12'd0016: data <= 20'h04BE0;                            // SPIWrite [04B]=E0, Allow calibration to occur and set cal count to 1024 for max accuracy
            12'd0017: data <= 20'h04E10;                            // SPIWrite [04E]=10, Set calibration clock to REFCLK/4 for more accuracy
            12'd0018: data <= 20'h04329;                            // SPIWrite [043]=29, BBPLL Freq Word (Fractional[7:0])
            12'd0019: data <= 20'h0425C;                            // SPIWrite [042]=5C, BBPLL Freq Word (Fractional[15:8])
            12'd0020: data <= 20'h04112;                            // SPIWrite [041]=12, BBPLL Freq Word (Fractional[23:16])
            12'd0021: data <= 20'h04418;                            // SPIWrite [044]=18, BBPLL Freq Word (Integer[7:0])
            12'd0022: data <= 20'h03F05;                            // SPIWrite [03F]=05, Start BBPLL Calibration
            12'd0023: data <= 20'h03F01;                            // SPIWrite [03F]=01, Clear BBPLL start calibration bit
            12'd0024: data <= 20'h04C86;                            // SPIWrite [04C]=86, Increase BBPLL KV and phase margin
            12'd0025: data <= 20'h04D01;                            // SPIWrite [04D]=01, Increase BBPLL KV and phase margin
            12'd0026: data <= 20'h04D05;                            // SPIWrite [04D]=05, Increase BBPLL KV and phase margin
            12'd0027: data <= 20'h40000;                            // WAIT 20 ms, Check BBPLL locked status  (0x05E[7]==1 is locked)
            12'd0028: data <= 20'h002DC;                            // SPIWrite [002]=DC, Setup Tx Digital Filters/ Channels
            12'd0029: data <= 20'h003DC;                            // SPIWrite [003]=DC, Setup Rx Digital Filters/ Channels
            12'd0030: data <= 20'h00403;                            // SPIWrite [004]=03, Select Rx input pin(A,B,C)/ Tx out pin (A,B)
            12'd0031: data <= 20'h00A12;                            // SPIWrite [00A]=12, Set BBPLL post divide rate
            12'd0032: data <= 20'h01008;                            // SPIWrite [010]=08, PPORT Config 1
            12'd0033: data <= 20'h01100;                            // SPIWrite [011]=00, PPORT Config 2
            12'd0034: data <= 20'h01210;                            // SPIWrite [012]=10, PPORT Config 3
            12'd0035: data <= 20'h0060F;                            // SPIWrite [006]=0F, PPORT Rx Delay (adjusts Tco Dataclk->Data)
            12'd0036: data <= 20'h00700;                            // SPIWrite [007]=00, PPORT TX Delay (adjusts setup/hold FBCLK->Data)
            12'd0037: data <= 20'h03C21;                            // SPIWrite [03C]=21, LVDS Settings
            12'd0038: data <= 20'h03DFF;                            // SPIWrite [03D]=00, LVDS polarity invert
            12'd0039: data <= 20'h03E0F;                            // SPIWrite [03E]=00, LVDS polarity invert
            12'd0040: data <= 20'h01800;                            // SPIWrite [018]=00, AuxDAC1 Word[9:2]
            12'd0041: data <= 20'h01900;                            // SPIWrite [019]=00, AuxDAC2 Word[9:2]
            12'd0042: data <= 20'h01A00;                            // SPIWrite [01A]=00, AuxDAC1 Config and Word[1:0]
            12'd0043: data <= 20'h01B00;                            // SPIWrite [01B]=00, AuxDAC2 Config and Word[1:0]
            12'd0044: data <= 20'h023FF;                            // SPIWrite [023]=FF, AuxDAC Manaul/Auto Control
            12'd0045: data <= 20'h02600;                            // SPIWrite [026]=00, AuxDAC Manual Select Bit/GPO Manual Select
            12'd0046: data <= 20'h03000;                            // SPIWrite [030]=00, AuxDAC1 Rx Delay
            12'd0047: data <= 20'h03100;                            // SPIWrite [031]=00, AuxDAC1 Tx Delay
            12'd0048: data <= 20'h03200;                            // SPIWrite [032]=00, AuxDAC2 Rx Delay
            12'd0049: data <= 20'h03300;                            // SPIWrite [033]=00, AuxDAC2 Tx Delay
            12'd0050: data <= 20'h00B00;                            // SPIWrite [00B]=00, Temp Sensor Setup (Offset)
            12'd0051: data <= 20'h00C00;                            // SPIWrite [00C]=00, Temp Sensor Setup (Temp Window)
            12'd0052: data <= 20'h00D03;                            // SPIWrite [00D]=03, Temp Sensor Setup (Periodic Measure)
            12'd0053: data <= 20'h00F04;                            // SPIWrite [00F]=04, Temp Sensor Setup (Decimation)
            12'd0054: data <= 20'h01C10;                            // SPIWrite [01C]=10, AuxADC Setup (Clock Div)
            12'd0055: data <= 20'h01D01;                            // SPIWrite [01D]=01, AuxADC Setup (Decimation/Enable)
            12'd0056: data <= 20'h03501;                            // SPIWrite [035]=00, Ctrl Out index
            12'd0057: data <= 20'h036FF;                            // SPIWrite [036]=FF, Ctrl Out [7:0] output enable
            12'd0058: data <= 20'h03A27;                            // SPIWrite [03A]=27, Set number of REFCLK cycles for 1us delay timer
            12'd0059: data <= 20'h02000;                            // SPIWrite [020]=00, GPO Auto Enable Setup in RX and TX
            12'd0060: data <= 20'h02703;                            // SPIWrite [027]=03, GPO Manual and GPO auto value in ALERT
            12'd0061: data <= 20'h02800;                            // SPIWrite [028]=00, GPO_0 RX Delay
            12'd0062: data <= 20'h02900;                            // SPIWrite [029]=00, GPO_1 RX Delay
            12'd0063: data <= 20'h02A00;                            // SPIWrite [02A]=00, GPO_2 RX Delay
            12'd0064: data <= 20'h02B00;                            // SPIWrite [02B]=00, GPO_3 RX Delay
            12'd0065: data <= 20'h02C00;                            // SPIWrite [02C]=00, GPO_0 TX Delay
            12'd0066: data <= 20'h02D00;                            // SPIWrite [02D]=00, GPO_1 TX Delay
            12'd0067: data <= 20'h02E00;                            // SPIWrite [02E]=00, GPO_2 TX Delay
            12'd0068: data <= 20'h02F00;                            // SPIWrite [02F]=00, GPO_3 TX Delay
            12'd0069: data <= 20'h26100;                            // SPIWrite [261]=00, Set Rx LO Power mode
            12'd0070: data <= 20'h2A100;                            // SPIWrite [2A1]=00, Set Tx LO Power mode
            12'd0071: data <= 20'h2480B;                            // SPIWrite [248]=0B, Enable Rx VCO LDO
            12'd0072: data <= 20'h2880B;                            // SPIWrite [288]=0B, Enable Tx VCO LDO
            12'd0073: data <= 20'h24602;                            // SPIWrite [246]=02, Set VCO Power down TCF bits
            12'd0074: data <= 20'h28602;                            // SPIWrite [286]=02, Set VCO Power down TCF bits
            12'd0075: data <= 20'h2498E;                            // SPIWrite [249]=8E, Set VCO cal length
            12'd0076: data <= 20'h2898E;                            // SPIWrite [289]=8E, Set VCO cal length
            12'd0077: data <= 20'h23B80;                            // SPIWrite [23B]=80, Enable Rx VCO cal
            12'd0078: data <= 20'h27B80;                            // SPIWrite [27B]=80, Enable Tx VCO cal
            12'd0079: data <= 20'h2430D;                            // SPIWrite [243]=0D, Set Rx prescaler bias
            12'd0080: data <= 20'h2830D;                            // SPIWrite [283]=0D, Set Tx prescaler bias
            12'd0081: data <= 20'h23D00;                            // SPIWrite [23D]=00, Clear Half VCO cal clock setting
            12'd0082: data <= 20'h27D00;                            // SPIWrite [27D]=00, Clear Half VCO cal clock setting
            12'd0083: data <= 20'h01504;                            // SPIWrite [015]=04, Set Dual Synth mode bit
            12'd0084: data <= 20'h01405;                            // SPIWrite [014]=05, Set Force ALERT State bit
            12'd0085: data <= 20'h01301;                            // SPIWrite [013]=01, Set ENSM FDD mode
            12'd0086: data <= 20'h40000;                            // WAIT 1 ms, waits 1 ms
            12'd0087: data <= 20'h23D04;                            // SPIWrite [23D]=04, Start RX CP cal
            12'd0088: data <= 20'h27D04;                            // SPIWrite [27D]=04, Start TX CP cal
            12'd0089: data <= 20'h23A4A;                            // SPIWrite [23A]=4A, Set VCO Output level[3:0]
            12'd0090: data <= 20'h239C3;                            // SPIWrite [239]=C3, Set Init ALC Value[3:0] and VCO Varactor[3:0]
            12'd0091: data <= 20'h2421F;                            // SPIWrite [242]=1F, Set VCO Bias Tcf[1:0] and VCO Bias Ref[2:0]
            12'd0092: data <= 20'h23878;                            // SPIWrite [238]=78, Set VCO Cal Offset[3:0]
            12'd0093: data <= 20'h24500;                            // SPIWrite [245]=00, Set VCO Cal Ref Tcf[2:0]
            12'd0094: data <= 20'h2510C;                            // SPIWrite [251]=0C, Set VCO Varactor Reference[3:0]
            12'd0095: data <= 20'h25070;                            // SPIWrite [250]=70, Set VCO Varactor Ref Tcf[2:0] and VCO Varactor Offset[3:0]
            12'd0096: data <= 20'h23B92;                            // SPIWrite [23B]=92, Set Synth Loop Filter charge pump current (Icp)
            12'd0097: data <= 20'h23ED4;                            // SPIWrite [23E]=D4, Set Synth Loop Filter C2 and C1
            12'd0098: data <= 20'h23FDF;                            // SPIWrite [23F]=DF, Set Synth Loop Filter  R1 and C3
            12'd0099: data <= 20'h24009;                            // SPIWrite [240]=09, Set Synth Loop Filter R3
            12'd0100: data <= 20'h27A4A;                            // SPIWrite [27A]=4A, Set VCO Output level[3:0]
            12'd0101: data <= 20'h279C1;                            // SPIWrite [279]=C1, Set Init ALC Value[3:0] and VCO Varactor[3:0]
            12'd0102: data <= 20'h28217;                            // SPIWrite [282]=17, Set VCO Bias Tcf[1:0] and VCO Bias Ref[2:0]
            12'd0103: data <= 20'h27878;                            // SPIWrite [278]=78, Set VCO Cal Offset[3:0]
            12'd0104: data <= 20'h28500;                            // SPIWrite [285]=00, Set VCO Cal Ref Tcf[2:0]
            12'd0105: data <= 20'h2910E;                            // SPIWrite [291]=0E, Set VCO Varactor Reference[3:0]
            12'd0106: data <= 20'h29070;                            // SPIWrite [290]=70, Set VCO Varactor Ref Tcf[2:0] and VCO Varactor Offset[3:0]
            12'd0107: data <= 20'h27B98;                            // SPIWrite [27B]=98, Set Synth Loop Filter charge pump current (Icp)
            12'd0108: data <= 20'h27ED4;                            // SPIWrite [27E]=D4, Set Synth Loop Filter C2 and C1
            12'd0109: data <= 20'h27FDF;                            // SPIWrite [27F]=DF, Set Synth Loop Filter  R1 and C3
            12'd0110: data <= 20'h28009;                            // SPIWrite [280]=09, Set Synth Loop Filter R3
            12'd0111: data <= 20'h23300;                            // SPIWrite [233]=00, Write Rx Synth Fractional Freq Word[7:0]
            12'd0112: data <= 20'h23400;                            // SPIWrite [234]=00, Write Rx Synth Fractional Freq Word[15:8]
            12'd0113: data <= 20'h23500;                            // SPIWrite [235]=00, Write Rx Synth Fractional Freq Word[22:16]
            12'd0114: data <= 20'h23200;                            // SPIWrite [232]=00, Write Rx Synth Integer Freq Word[10:8]
            12'd0115: data <= 20'h23128;                            // SPIWrite [231]=50, Write Rx Synth Integer Freq Word[7:0]
            12'd0116: data <= 20'h00544;                            // SPIWrite [005]=22, Set LO divider setting
            12'd0117: data <= 20'h27300;                            // SPIWrite [273]=00, Write Tx Synth Fractional Freq Word[7:0]
            12'd0118: data <= 20'h27400;                            // SPIWrite [274]=00, Write Tx Synth Fractional Freq Word[15:8]
            12'd0119: data <= 20'h27500;                            // SPIWrite [275]=00, Write Tx Synth Fractional Freq Word[22:16]
            12'd0120: data <= 20'h27200;                            // SPIWrite [272]=00, Write Tx Synth Integer Freq Word[10:8]
            12'd0121: data <= 20'h27150;                            // SPIWrite [271]=55, Write Tx Synth Integer Freq Word[7:0] (starts VCO cal)
            12'd0122: data <= 20'h00544;                            // SPIWrite [005]=22, Set LO divider setting
            12'd0123: data <= 20'h40000;                            // WAIT 20 ms, Check RX RF PLL lock status (0x247[1]==1 is locked)
            12'd0124: data <= 20'h40000;                            // WAIT 20 ms, Check TX RF PLL lock status (0x287[1]==1 is locked)
            12'd0125: data <= 20'h13F02;                            // SPIWrite [13F]=02, Start Clock
            12'd0126: data <= 20'h1380F;                            // SPIWrite [138]=0F, Addr Table Index
            12'd0127: data <= 20'h13978;                            // SPIWrite [139]=78, Gain
            12'd0128: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0129: data <= 20'h13B00;                            // SPIWrite [13B]=00, GM
            12'd0130: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0131: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0132: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0133: data <= 20'h1380E;                            // SPIWrite [138]=0E, Addr Table Index
            12'd0134: data <= 20'h13974;                            // SPIWrite [139]=74, Gain
            12'd0135: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0136: data <= 20'h13B0D;                            // SPIWrite [13B]=0D, GM
            12'd0137: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0138: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0139: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0140: data <= 20'h1380D;                            // SPIWrite [138]=0D, Addr Table Index
            12'd0141: data <= 20'h13970;                            // SPIWrite [139]=70, Gain
            12'd0142: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0143: data <= 20'h13B15;                            // SPIWrite [13B]=15, GM
            12'd0144: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0145: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0146: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0147: data <= 20'h1380C;                            // SPIWrite [138]=0C, Addr Table Index
            12'd0148: data <= 20'h1396C;                            // SPIWrite [139]=6C, Gain
            12'd0149: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0150: data <= 20'h13B1B;                            // SPIWrite [13B]=1B, GM
            12'd0151: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0152: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0153: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0154: data <= 20'h1380B;                            // SPIWrite [138]=0B, Addr Table Index
            12'd0155: data <= 20'h13968;                            // SPIWrite [139]=68, Gain
            12'd0156: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0157: data <= 20'h13B21;                            // SPIWrite [13B]=21, GM
            12'd0158: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0159: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0160: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0161: data <= 20'h1380A;                            // SPIWrite [138]=0A, Addr Table Index
            12'd0162: data <= 20'h13964;                            // SPIWrite [139]=64, Gain
            12'd0163: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0164: data <= 20'h13B25;                            // SPIWrite [13B]=25, GM
            12'd0165: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0166: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0167: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0168: data <= 20'h13809;                            // SPIWrite [138]=09, Addr Table Index
            12'd0169: data <= 20'h13960;                            // SPIWrite [139]=60, Gain
            12'd0170: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0171: data <= 20'h13B29;                            // SPIWrite [13B]=29, GM
            12'd0172: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0173: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0174: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0175: data <= 20'h13808;                            // SPIWrite [138]=08, Addr Table Index
            12'd0176: data <= 20'h1395C;                            // SPIWrite [139]=5C, Gain
            12'd0177: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0178: data <= 20'h13B2C;                            // SPIWrite [13B]=2C, GM
            12'd0179: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0180: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0181: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0182: data <= 20'h13807;                            // SPIWrite [138]=07, Addr Table Index
            12'd0183: data <= 20'h13958;                            // SPIWrite [139]=58, Gain
            12'd0184: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0185: data <= 20'h13B2F;                            // SPIWrite [13B]=2F, GM
            12'd0186: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0187: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0188: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0189: data <= 20'h13806;                            // SPIWrite [138]=06, Addr Table Index
            12'd0190: data <= 20'h13954;                            // SPIWrite [139]=54, Gain
            12'd0191: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0192: data <= 20'h13B31;                            // SPIWrite [13B]=31, GM
            12'd0193: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0194: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0195: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0196: data <= 20'h13805;                            // SPIWrite [138]=05, Addr Table Index
            12'd0197: data <= 20'h13950;                            // SPIWrite [139]=50, Gain
            12'd0198: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0199: data <= 20'h13B33;                            // SPIWrite [13B]=33, GM
            12'd0200: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0201: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0202: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0203: data <= 20'h13804;                            // SPIWrite [138]=04, Addr Table Index
            12'd0204: data <= 20'h1394C;                            // SPIWrite [139]=4C, Gain
            12'd0205: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0206: data <= 20'h13B34;                            // SPIWrite [13B]=34, GM
            12'd0207: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0208: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0209: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0210: data <= 20'h13803;                            // SPIWrite [138]=03, Addr Table Index
            12'd0211: data <= 20'h13948;                            // SPIWrite [139]=48, Gain
            12'd0212: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0213: data <= 20'h13B35;                            // SPIWrite [13B]=35, GM
            12'd0214: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0215: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0216: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0217: data <= 20'h13802;                            // SPIWrite [138]=02, Addr Table Index
            12'd0218: data <= 20'h13930;                            // SPIWrite [139]=30, Gain
            12'd0219: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0220: data <= 20'h13B3A;                            // SPIWrite [13B]=3A, GM
            12'd0221: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0222: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0223: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0224: data <= 20'h13801;                            // SPIWrite [138]=01, Addr Table Index
            12'd0225: data <= 20'h13918;                            // SPIWrite [139]=18, Gain
            12'd0226: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0227: data <= 20'h13B3D;                            // SPIWrite [13B]=3D, GM
            12'd0228: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0229: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0230: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0231: data <= 20'h13800;                            // SPIWrite [138]=00, Addr Table Index
            12'd0232: data <= 20'h13900;                            // SPIWrite [139]=00, Gain
            12'd0233: data <= 20'h13A00;                            // SPIWrite [13A]=00, Bias
            12'd0234: data <= 20'h13B3E;                            // SPIWrite [13B]=3E, GM
            12'd0235: data <= 20'h13F06;                            // SPIWrite [13F]=06, Write Words
            12'd0236: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0237: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0238: data <= 20'h13F02;                            // SPIWrite [13F]=02, Clear Write Bit
            12'd0239: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay for 3 ADCCLK/16 clock cycles (Dummy Write)
            12'd0240: data <= 20'h13C00;                            // SPIWrite [13C]=00, Delay ~1us (Dummy Write)
            12'd0241: data <= 20'h13F00;                            // SPIWrite [13F]=00, Stop Clock
            12'd0242: data <= 20'h1371A;                            // SPIWrite [137]=1A, Start Gain Table Clock
            12'd0243: data <= 20'h13000;                            // SPIWrite [130]=00, Gain Table Index
            12'd0244: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0245: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0246: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0247: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0248: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0249: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0250: data <= 20'h13001;                            // SPIWrite [130]=01, Gain Table Index
            12'd0251: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0252: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0253: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0254: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0255: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0256: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0257: data <= 20'h13002;                            // SPIWrite [130]=02, Gain Table Index
            12'd0258: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0259: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0260: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0261: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0262: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0263: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0264: data <= 20'h13003;                            // SPIWrite [130]=03, Gain Table Index
            12'd0265: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0266: data <= 20'h13201;                            // SPIWrite [132]=01, TIA & LPF Word
            12'd0267: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0268: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0269: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0270: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0271: data <= 20'h13004;                            // SPIWrite [130]=04, Gain Table Index
            12'd0272: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0273: data <= 20'h13202;                            // SPIWrite [132]=02, TIA & LPF Word
            12'd0274: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0275: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0276: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0277: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0278: data <= 20'h13005;                            // SPIWrite [130]=05, Gain Table Index
            12'd0279: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0280: data <= 20'h13203;                            // SPIWrite [132]=03, TIA & LPF Word
            12'd0281: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0282: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0283: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0284: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0285: data <= 20'h13006;                            // SPIWrite [130]=06, Gain Table Index
            12'd0286: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0287: data <= 20'h13204;                            // SPIWrite [132]=04, TIA & LPF Word
            12'd0288: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0289: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0290: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0291: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0292: data <= 20'h13007;                            // SPIWrite [130]=07, Gain Table Index
            12'd0293: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0294: data <= 20'h13205;                            // SPIWrite [132]=05, TIA & LPF Word
            12'd0295: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0296: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0297: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0298: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0299: data <= 20'h13008;                            // SPIWrite [130]=08, Gain Table Index
            12'd0300: data <= 20'h13101;                            // SPIWrite [131]=01, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0301: data <= 20'h13203;                            // SPIWrite [132]=03, TIA & LPF Word
            12'd0302: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0303: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0304: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0305: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0306: data <= 20'h13009;                            // SPIWrite [130]=09, Gain Table Index
            12'd0307: data <= 20'h13101;                            // SPIWrite [131]=01, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0308: data <= 20'h13204;                            // SPIWrite [132]=04, TIA & LPF Word
            12'd0309: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0310: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0311: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0312: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0313: data <= 20'h1300A;                            // SPIWrite [130]=0A, Gain Table Index
            12'd0314: data <= 20'h13101;                            // SPIWrite [131]=01, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0315: data <= 20'h13205;                            // SPIWrite [132]=05, TIA & LPF Word
            12'd0316: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0317: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0318: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0319: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0320: data <= 20'h1300B;                            // SPIWrite [130]=0B, Gain Table Index
            12'd0321: data <= 20'h13101;                            // SPIWrite [131]=01, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0322: data <= 20'h13206;                            // SPIWrite [132]=06, TIA & LPF Word
            12'd0323: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0324: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0325: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0326: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0327: data <= 20'h1300C;                            // SPIWrite [130]=0C, Gain Table Index
            12'd0328: data <= 20'h13101;                            // SPIWrite [131]=01, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0329: data <= 20'h13207;                            // SPIWrite [132]=07, TIA & LPF Word
            12'd0330: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0331: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0332: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0333: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0334: data <= 20'h1300D;                            // SPIWrite [130]=0D, Gain Table Index
            12'd0335: data <= 20'h13101;                            // SPIWrite [131]=01, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0336: data <= 20'h13208;                            // SPIWrite [132]=08, TIA & LPF Word
            12'd0337: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0338: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0339: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0340: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0341: data <= 20'h1300E;                            // SPIWrite [130]=0E, Gain Table Index
            12'd0342: data <= 20'h13101;                            // SPIWrite [131]=01, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0343: data <= 20'h13209;                            // SPIWrite [132]=09, TIA & LPF Word
            12'd0344: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0345: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0346: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0347: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0348: data <= 20'h1300F;                            // SPIWrite [130]=0F, Gain Table Index
            12'd0349: data <= 20'h13101;                            // SPIWrite [131]=01, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0350: data <= 20'h1320A;                            // SPIWrite [132]=0A, TIA & LPF Word
            12'd0351: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0352: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0353: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0354: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0355: data <= 20'h13010;                            // SPIWrite [130]=10, Gain Table Index
            12'd0356: data <= 20'h13101;                            // SPIWrite [131]=01, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0357: data <= 20'h1320B;                            // SPIWrite [132]=0B, TIA & LPF Word
            12'd0358: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0359: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0360: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0361: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0362: data <= 20'h13011;                            // SPIWrite [130]=11, Gain Table Index
            12'd0363: data <= 20'h13101;                            // SPIWrite [131]=01, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0364: data <= 20'h1320C;                            // SPIWrite [132]=0C, TIA & LPF Word
            12'd0365: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0366: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0367: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0368: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0369: data <= 20'h13012;                            // SPIWrite [130]=12, Gain Table Index
            12'd0370: data <= 20'h13101;                            // SPIWrite [131]=01, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0371: data <= 20'h1320D;                            // SPIWrite [132]=0D, TIA & LPF Word
            12'd0372: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0373: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0374: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0375: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0376: data <= 20'h13013;                            // SPIWrite [130]=13, Gain Table Index
            12'd0377: data <= 20'h13101;                            // SPIWrite [131]=01, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0378: data <= 20'h1320E;                            // SPIWrite [132]=0E, TIA & LPF Word
            12'd0379: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0380: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0381: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0382: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0383: data <= 20'h13014;                            // SPIWrite [130]=14, Gain Table Index
            12'd0384: data <= 20'h13102;                            // SPIWrite [131]=02, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0385: data <= 20'h13209;                            // SPIWrite [132]=09, TIA & LPF Word
            12'd0386: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0387: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0388: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0389: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0390: data <= 20'h13015;                            // SPIWrite [130]=15, Gain Table Index
            12'd0391: data <= 20'h13102;                            // SPIWrite [131]=02, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0392: data <= 20'h1320A;                            // SPIWrite [132]=0A, TIA & LPF Word
            12'd0393: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0394: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0395: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0396: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0397: data <= 20'h13016;                            // SPIWrite [130]=16, Gain Table Index
            12'd0398: data <= 20'h13102;                            // SPIWrite [131]=02, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0399: data <= 20'h1320B;                            // SPIWrite [132]=0B, TIA & LPF Word
            12'd0400: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0401: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0402: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0403: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0404: data <= 20'h13017;                            // SPIWrite [130]=17, Gain Table Index
            12'd0405: data <= 20'h13102;                            // SPIWrite [131]=02, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0406: data <= 20'h1320C;                            // SPIWrite [132]=0C, TIA & LPF Word
            12'd0407: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0408: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0409: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0410: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0411: data <= 20'h13018;                            // SPIWrite [130]=18, Gain Table Index
            12'd0412: data <= 20'h13102;                            // SPIWrite [131]=02, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0413: data <= 20'h1320D;                            // SPIWrite [132]=0D, TIA & LPF Word
            12'd0414: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0415: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0416: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0417: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0418: data <= 20'h13019;                            // SPIWrite [130]=19, Gain Table Index
            12'd0419: data <= 20'h13102;                            // SPIWrite [131]=02, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0420: data <= 20'h1320E;                            // SPIWrite [132]=0E, TIA & LPF Word
            12'd0421: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0422: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0423: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0424: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0425: data <= 20'h1301A;                            // SPIWrite [130]=1A, Gain Table Index
            12'd0426: data <= 20'h13102;                            // SPIWrite [131]=02, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0427: data <= 20'h1320F;                            // SPIWrite [132]=0F, TIA & LPF Word
            12'd0428: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0429: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0430: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0431: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0432: data <= 20'h1301B;                            // SPIWrite [130]=1B, Gain Table Index
            12'd0433: data <= 20'h13102;                            // SPIWrite [131]=02, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0434: data <= 20'h13210;                            // SPIWrite [132]=10, TIA & LPF Word
            12'd0435: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0436: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0437: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0438: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0439: data <= 20'h1301C;                            // SPIWrite [130]=1C, Gain Table Index
            12'd0440: data <= 20'h13102;                            // SPIWrite [131]=02, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0441: data <= 20'h1322B;                            // SPIWrite [132]=2B, TIA & LPF Word
            12'd0442: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0443: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0444: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0445: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0446: data <= 20'h1301D;                            // SPIWrite [130]=1D, Gain Table Index
            12'd0447: data <= 20'h13102;                            // SPIWrite [131]=02, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0448: data <= 20'h1322C;                            // SPIWrite [132]=2C, TIA & LPF Word
            12'd0449: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0450: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0451: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0452: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0453: data <= 20'h1301E;                            // SPIWrite [130]=1E, Gain Table Index
            12'd0454: data <= 20'h13104;                            // SPIWrite [131]=04, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0455: data <= 20'h13227;                            // SPIWrite [132]=27, TIA & LPF Word
            12'd0456: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0457: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0458: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0459: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0460: data <= 20'h1301F;                            // SPIWrite [130]=1F, Gain Table Index
            12'd0461: data <= 20'h13104;                            // SPIWrite [131]=04, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0462: data <= 20'h13228;                            // SPIWrite [132]=28, TIA & LPF Word
            12'd0463: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0464: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0465: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0466: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0467: data <= 20'h13020;                            // SPIWrite [130]=20, Gain Table Index
            12'd0468: data <= 20'h13104;                            // SPIWrite [131]=04, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0469: data <= 20'h13229;                            // SPIWrite [132]=29, TIA & LPF Word
            12'd0470: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0471: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0472: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0473: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0474: data <= 20'h13021;                            // SPIWrite [130]=21, Gain Table Index
            12'd0475: data <= 20'h13104;                            // SPIWrite [131]=04, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0476: data <= 20'h1322A;                            // SPIWrite [132]=2A, TIA & LPF Word
            12'd0477: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0478: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0479: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0480: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0481: data <= 20'h13022;                            // SPIWrite [130]=22, Gain Table Index
            12'd0482: data <= 20'h13104;                            // SPIWrite [131]=04, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0483: data <= 20'h1322B;                            // SPIWrite [132]=2B, TIA & LPF Word
            12'd0484: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0485: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0486: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0487: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0488: data <= 20'h13023;                            // SPIWrite [130]=23, Gain Table Index
            12'd0489: data <= 20'h13124;                            // SPIWrite [131]=24, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0490: data <= 20'h13221;                            // SPIWrite [132]=21, TIA & LPF Word
            12'd0491: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0492: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0493: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0494: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0495: data <= 20'h13024;                            // SPIWrite [130]=24, Gain Table Index
            12'd0496: data <= 20'h13124;                            // SPIWrite [131]=24, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0497: data <= 20'h13222;                            // SPIWrite [132]=22, TIA & LPF Word
            12'd0498: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0499: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0500: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0501: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0502: data <= 20'h13025;                            // SPIWrite [130]=25, Gain Table Index
            12'd0503: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0504: data <= 20'h13220;                            // SPIWrite [132]=20, TIA & LPF Word
            12'd0505: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0506: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0507: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0508: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0509: data <= 20'h13026;                            // SPIWrite [130]=26, Gain Table Index
            12'd0510: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0511: data <= 20'h13221;                            // SPIWrite [132]=21, TIA & LPF Word
            12'd0512: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0513: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0514: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0515: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0516: data <= 20'h13027;                            // SPIWrite [130]=27, Gain Table Index
            12'd0517: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0518: data <= 20'h13222;                            // SPIWrite [132]=22, TIA & LPF Word
            12'd0519: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0520: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0521: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0522: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0523: data <= 20'h13028;                            // SPIWrite [130]=28, Gain Table Index
            12'd0524: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0525: data <= 20'h13223;                            // SPIWrite [132]=23, TIA & LPF Word
            12'd0526: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0527: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0528: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0529: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0530: data <= 20'h13029;                            // SPIWrite [130]=29, Gain Table Index
            12'd0531: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0532: data <= 20'h13224;                            // SPIWrite [132]=24, TIA & LPF Word
            12'd0533: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0534: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0535: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0536: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0537: data <= 20'h1302A;                            // SPIWrite [130]=2A, Gain Table Index
            12'd0538: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0539: data <= 20'h13225;                            // SPIWrite [132]=25, TIA & LPF Word
            12'd0540: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0541: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0542: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0543: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0544: data <= 20'h1302B;                            // SPIWrite [130]=2B, Gain Table Index
            12'd0545: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0546: data <= 20'h13226;                            // SPIWrite [132]=26, TIA & LPF Word
            12'd0547: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0548: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0549: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0550: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0551: data <= 20'h1302C;                            // SPIWrite [130]=2C, Gain Table Index
            12'd0552: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0553: data <= 20'h13227;                            // SPIWrite [132]=27, TIA & LPF Word
            12'd0554: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0555: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0556: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0557: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0558: data <= 20'h1302D;                            // SPIWrite [130]=2D, Gain Table Index
            12'd0559: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0560: data <= 20'h13228;                            // SPIWrite [132]=28, TIA & LPF Word
            12'd0561: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0562: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0563: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0564: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0565: data <= 20'h1302E;                            // SPIWrite [130]=2E, Gain Table Index
            12'd0566: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0567: data <= 20'h13229;                            // SPIWrite [132]=29, TIA & LPF Word
            12'd0568: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0569: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0570: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0571: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0572: data <= 20'h1302F;                            // SPIWrite [130]=2F, Gain Table Index
            12'd0573: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0574: data <= 20'h1322A;                            // SPIWrite [132]=2A, TIA & LPF Word
            12'd0575: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0576: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0577: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0578: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0579: data <= 20'h13030;                            // SPIWrite [130]=30, Gain Table Index
            12'd0580: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0581: data <= 20'h1322B;                            // SPIWrite [132]=2B, TIA & LPF Word
            12'd0582: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0583: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0584: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0585: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0586: data <= 20'h13031;                            // SPIWrite [130]=31, Gain Table Index
            12'd0587: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0588: data <= 20'h1322C;                            // SPIWrite [132]=2C, TIA & LPF Word
            12'd0589: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0590: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0591: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0592: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0593: data <= 20'h13032;                            // SPIWrite [130]=32, Gain Table Index
            12'd0594: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0595: data <= 20'h1322D;                            // SPIWrite [132]=2D, TIA & LPF Word
            12'd0596: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0597: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0598: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0599: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0600: data <= 20'h13033;                            // SPIWrite [130]=33, Gain Table Index
            12'd0601: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0602: data <= 20'h1322E;                            // SPIWrite [132]=2E, TIA & LPF Word
            12'd0603: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0604: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0605: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0606: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0607: data <= 20'h13034;                            // SPIWrite [130]=34, Gain Table Index
            12'd0608: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0609: data <= 20'h1322F;                            // SPIWrite [132]=2F, TIA & LPF Word
            12'd0610: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0611: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0612: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0613: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0614: data <= 20'h13035;                            // SPIWrite [130]=35, Gain Table Index
            12'd0615: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0616: data <= 20'h13230;                            // SPIWrite [132]=30, TIA & LPF Word
            12'd0617: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0618: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0619: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0620: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0621: data <= 20'h13036;                            // SPIWrite [130]=36, Gain Table Index
            12'd0622: data <= 20'h13144;                            // SPIWrite [131]=44, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0623: data <= 20'h13231;                            // SPIWrite [132]=31, TIA & LPF Word
            12'd0624: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0625: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0626: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0627: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0628: data <= 20'h13037;                            // SPIWrite [130]=37, Gain Table Index
            12'd0629: data <= 20'h13164;                            // SPIWrite [131]=64, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0630: data <= 20'h1322E;                            // SPIWrite [132]=2E, TIA & LPF Word
            12'd0631: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0632: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0633: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0634: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0635: data <= 20'h13038;                            // SPIWrite [130]=38, Gain Table Index
            12'd0636: data <= 20'h13164;                            // SPIWrite [131]=64, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0637: data <= 20'h1322F;                            // SPIWrite [132]=2F, TIA & LPF Word
            12'd0638: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0639: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0640: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0641: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0642: data <= 20'h13039;                            // SPIWrite [130]=39, Gain Table Index
            12'd0643: data <= 20'h13164;                            // SPIWrite [131]=64, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0644: data <= 20'h13230;                            // SPIWrite [132]=30, TIA & LPF Word
            12'd0645: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0646: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0647: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0648: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0649: data <= 20'h1303A;                            // SPIWrite [130]=3A, Gain Table Index
            12'd0650: data <= 20'h13164;                            // SPIWrite [131]=64, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0651: data <= 20'h13231;                            // SPIWrite [132]=31, TIA & LPF Word
            12'd0652: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0653: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0654: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0655: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0656: data <= 20'h1303B;                            // SPIWrite [130]=3B, Gain Table Index
            12'd0657: data <= 20'h13164;                            // SPIWrite [131]=64, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0658: data <= 20'h13232;                            // SPIWrite [132]=32, TIA & LPF Word
            12'd0659: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0660: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0661: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0662: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0663: data <= 20'h1303C;                            // SPIWrite [130]=3C, Gain Table Index
            12'd0664: data <= 20'h13164;                            // SPIWrite [131]=64, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0665: data <= 20'h13233;                            // SPIWrite [132]=33, TIA & LPF Word
            12'd0666: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0667: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0668: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0669: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0670: data <= 20'h1303D;                            // SPIWrite [130]=3D, Gain Table Index
            12'd0671: data <= 20'h13164;                            // SPIWrite [131]=64, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0672: data <= 20'h13234;                            // SPIWrite [132]=34, TIA & LPF Word
            12'd0673: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0674: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0675: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0676: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0677: data <= 20'h1303E;                            // SPIWrite [130]=3E, Gain Table Index
            12'd0678: data <= 20'h13164;                            // SPIWrite [131]=64, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0679: data <= 20'h13235;                            // SPIWrite [132]=35, TIA & LPF Word
            12'd0680: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0681: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0682: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0683: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0684: data <= 20'h1303F;                            // SPIWrite [130]=3F, Gain Table Index
            12'd0685: data <= 20'h13164;                            // SPIWrite [131]=64, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0686: data <= 20'h13236;                            // SPIWrite [132]=36, TIA & LPF Word
            12'd0687: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0688: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0689: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0690: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0691: data <= 20'h13040;                            // SPIWrite [130]=40, Gain Table Index
            12'd0692: data <= 20'h13164;                            // SPIWrite [131]=64, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0693: data <= 20'h13237;                            // SPIWrite [132]=37, TIA & LPF Word
            12'd0694: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0695: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0696: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0697: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0698: data <= 20'h13041;                            // SPIWrite [130]=41, Gain Table Index
            12'd0699: data <= 20'h13164;                            // SPIWrite [131]=64, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0700: data <= 20'h13238;                            // SPIWrite [132]=38, TIA & LPF Word
            12'd0701: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0702: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0703: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0704: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0705: data <= 20'h13042;                            // SPIWrite [130]=42, Gain Table Index
            12'd0706: data <= 20'h13165;                            // SPIWrite [131]=65, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0707: data <= 20'h13238;                            // SPIWrite [132]=38, TIA & LPF Word
            12'd0708: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0709: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0710: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0711: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0712: data <= 20'h13043;                            // SPIWrite [130]=43, Gain Table Index
            12'd0713: data <= 20'h13166;                            // SPIWrite [131]=66, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0714: data <= 20'h13238;                            // SPIWrite [132]=38, TIA & LPF Word
            12'd0715: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0716: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0717: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0718: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0719: data <= 20'h13044;                            // SPIWrite [130]=44, Gain Table Index
            12'd0720: data <= 20'h13167;                            // SPIWrite [131]=67, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0721: data <= 20'h13238;                            // SPIWrite [132]=38, TIA & LPF Word
            12'd0722: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0723: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0724: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0725: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0726: data <= 20'h13045;                            // SPIWrite [130]=45, Gain Table Index
            12'd0727: data <= 20'h13168;                            // SPIWrite [131]=68, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0728: data <= 20'h13238;                            // SPIWrite [132]=38, TIA & LPF Word
            12'd0729: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0730: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0731: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0732: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0733: data <= 20'h13046;                            // SPIWrite [130]=46, Gain Table Index
            12'd0734: data <= 20'h13169;                            // SPIWrite [131]=69, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0735: data <= 20'h13238;                            // SPIWrite [132]=38, TIA & LPF Word
            12'd0736: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0737: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0738: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0739: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0740: data <= 20'h13047;                            // SPIWrite [130]=47, Gain Table Index
            12'd0741: data <= 20'h1316A;                            // SPIWrite [131]=6A, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0742: data <= 20'h13238;                            // SPIWrite [132]=38, TIA & LPF Word
            12'd0743: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0744: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0745: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0746: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0747: data <= 20'h13048;                            // SPIWrite [130]=48, Gain Table Index
            12'd0748: data <= 20'h1316B;                            // SPIWrite [131]=6B, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0749: data <= 20'h13238;                            // SPIWrite [132]=38, TIA & LPF Word
            12'd0750: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0751: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0752: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0753: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0754: data <= 20'h13049;                            // SPIWrite [130]=49, Gain Table Index
            12'd0755: data <= 20'h1316C;                            // SPIWrite [131]=6C, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0756: data <= 20'h13238;                            // SPIWrite [132]=38, TIA & LPF Word
            12'd0757: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0758: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0759: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0760: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0761: data <= 20'h1304A;                            // SPIWrite [130]=4A, Gain Table Index
            12'd0762: data <= 20'h1316D;                            // SPIWrite [131]=6D, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0763: data <= 20'h13238;                            // SPIWrite [132]=38, TIA & LPF Word
            12'd0764: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0765: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0766: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0767: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0768: data <= 20'h1304B;                            // SPIWrite [130]=4B, Gain Table Index
            12'd0769: data <= 20'h1316E;                            // SPIWrite [131]=6E, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0770: data <= 20'h13238;                            // SPIWrite [132]=38, TIA & LPF Word
            12'd0771: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0772: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0773: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0774: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0775: data <= 20'h1304C;                            // SPIWrite [130]=4C, Gain Table Index
            12'd0776: data <= 20'h1316F;                            // SPIWrite [131]=6F, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0777: data <= 20'h13238;                            // SPIWrite [132]=38, TIA & LPF Word
            12'd0778: data <= 20'h13320;                            // SPIWrite [133]=20, DC Cal bit & Dig Gain Word
            12'd0779: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0780: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0781: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0782: data <= 20'h1304D;                            // SPIWrite [130]=4D, Gain Table Index
            12'd0783: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0784: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0785: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0786: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0787: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0788: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0789: data <= 20'h1304E;                            // SPIWrite [130]=4E, Gain Table Index
            12'd0790: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0791: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0792: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0793: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0794: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0795: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0796: data <= 20'h1304F;                            // SPIWrite [130]=4F, Gain Table Index
            12'd0797: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0798: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0799: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0800: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0801: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0802: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0803: data <= 20'h13050;                            // SPIWrite [130]=50, Gain Table Index
            12'd0804: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0805: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0806: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0807: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0808: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0809: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0810: data <= 20'h13051;                            // SPIWrite [130]=51, Gain Table Index
            12'd0811: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0812: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0813: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0814: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0815: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0816: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0817: data <= 20'h13052;                            // SPIWrite [130]=52, Gain Table Index
            12'd0818: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0819: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0820: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0821: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0822: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0823: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0824: data <= 20'h13053;                            // SPIWrite [130]=53, Gain Table Index
            12'd0825: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0826: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0827: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0828: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0829: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0830: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0831: data <= 20'h13054;                            // SPIWrite [130]=54, Gain Table Index
            12'd0832: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0833: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0834: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0835: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0836: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0837: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0838: data <= 20'h13055;                            // SPIWrite [130]=55, Gain Table Index
            12'd0839: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0840: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0841: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0842: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0843: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0844: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0845: data <= 20'h13056;                            // SPIWrite [130]=56, Gain Table Index
            12'd0846: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0847: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0848: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0849: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0850: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0851: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0852: data <= 20'h13057;                            // SPIWrite [130]=57, Gain Table Index
            12'd0853: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0854: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0855: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0856: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0857: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0858: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0859: data <= 20'h13058;                            // SPIWrite [130]=58, Gain Table Index
            12'd0860: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0861: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0862: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0863: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0864: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0865: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0866: data <= 20'h13059;                            // SPIWrite [130]=59, Gain Table Index
            12'd0867: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0868: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0869: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0870: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0871: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0872: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0873: data <= 20'h1305A;                            // SPIWrite [130]=5A, Gain Table Index
            12'd0874: data <= 20'h13100;                            // SPIWrite [131]=00, Ext LNA, Int LNA, & Mixer Gain Word
            12'd0875: data <= 20'h13200;                            // SPIWrite [132]=00, TIA & LPF Word
            12'd0876: data <= 20'h13300;                            // SPIWrite [133]=00, DC Cal bit & Dig Gain Word
            12'd0877: data <= 20'h1371E;                            // SPIWrite [137]=1E, Write Words
            12'd0878: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay 3 ADCCLK/16 cycles
            12'd0879: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0880: data <= 20'h1371A;                            // SPIWrite [137]=1A, Clear Write Bit
            12'd0881: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0882: data <= 20'h13400;                            // SPIWrite [134]=00, Dummy Write to delay ~1us
            12'd0883: data <= 20'h13700;                            // SPIWrite [137]=00, Stop Gain Table Clock
            12'd0884: data <= 20'h0FAEA;                            // SPIWrite [0FA]=EA, Gain Control Mode Select
            12'd0885: data <= 20'h0FB08;                            // SPIWrite [0FB]=08, Full Table/Digital Gain Select
            12'd0886: data <= 20'h0FC03;                            // SPIWrite [0FC]=03, ADC Overrange Sample Size
            12'd0887: data <= 20'h0FD4C;                            // SPIWrite [0FD]=4C, Max Full/LMT Gain Table Index
            12'd0888: data <= 20'h0FE48;                            // SPIWrite [0FE]=48, Peak Overload Wait Time
            12'd0889: data <= 20'h1008F;                            // SPIWrite [100]=8F, Max Digital Gain
            12'd0890: data <= 20'h1010A;                            // SPIWrite [101]=0A, AGC Inner High Threshold
            12'd0891: data <= 20'h10308;                            // SPIWrite [103]=08, Large LMT Step Size
            12'd0892: data <= 20'h1042F;                            // SPIWrite [104]=2F, ADC Small Overload Threshold
            12'd0893: data <= 20'h1053A;                            // SPIWrite [105]=3A, ADC Large Overload Threshold
            12'd0894: data <= 20'h10622;                            // SPIWrite [106]=22, ADC Overload Step Sizes
            12'd0895: data <= 20'h10731;                            // SPIWrite [107]=31, Large LMT Overload Threshold
            12'd0896: data <= 20'h10839;                            // SPIWrite [108]=39, Small LMT Overload Threshold
            12'd0897: data <= 20'h1110A;                            // SPIWrite [111]=0A, Settling Delay
            12'd0898: data <= 20'h11A27;                            // SPIWrite [11A]=27, Initial LMT Gain Limit
            12'd0899: data <= 20'h1200C;                            // SPIWrite [120]=0C, Prevent Inc & AGC Inner Low Thresh
            12'd0900: data <= 20'h121AA;                            // SPIWrite [121]=AA, LMT Overload Exceeded Counters
            12'd0901: data <= 20'h122AA;                            // SPIWrite [122]=AA, ADC Overload Exceeded Counters
            12'd0902: data <= 20'h12311;                            // SPIWrite [123]=11, AGC Inner High & Low Step Sizes
            12'd0903: data <= 20'h124F5;                            // SPIWrite [124]=F5, Gain Update Counter<7:0>
            12'd0904: data <= 20'h1253B;                            // SPIWrite [125]=3B, Gain Update Counter<15:8>
            12'd0905: data <= 20'h12803;                            // SPIWrite [128]=03, Digital Sat Exceeded Counter
            12'd0906: data <= 20'h12956;                            // SPIWrite [129]=56, AGC Outer High & Low Thresholds
            12'd0907: data <= 20'h12A22;                            // SPIWrite [12A]=22, AGC Outer High & Low Step Sizes
            12'd0908: data <= 20'h1FB0A;                            // SPIWrite [1FB]=0A, RX Freq Corner (MHz)
            12'd0909: data <= 20'h1FC00;                            // SPIWrite [1FC]=00, RX Freq Corner (Khz)
            12'd0910: data <= 20'h1F808;                            // SPIWrite [1F8]=08, Rx BBF Tune Divider[7:0]
            12'd0911: data <= 20'h1F91E;                            // SPIWrite [1F9]=1E, RX BBF Tune Divider[8]
            12'd0912: data <= 20'h1D53F;                            // SPIWrite [1D5]=3F, Set Rx Mix LO CM
            12'd0913: data <= 20'h1C003;                            // SPIWrite [1C0]=03, Set GM common mode
            12'd0914: data <= 20'h1E202;                            // SPIWrite [1E2]=02, Enable Rx1 Filter Tuner
            12'd0915: data <= 20'h1E302;                            // SPIWrite [1E3]=02, Enable Rx2 Filter Tuner
            12'd0916: data <= 20'h01680;                            // SPIWrite [016]=80, Start RX Filter Tune
            12'd0917: data <= 20'h1E203;                            // SPIWrite [1E2]=03, Disable Rx Filter Tuner (Rx1)
            12'd0918: data <= 20'h1E303;                            // SPIWrite [1E3]=03, Disable Rx Filter Tuner (Rx2)
            12'd0919: data <= 20'h0D607;                            // SPIWrite [0D6]=07, TX BBF Tune Divier[7:0]
            12'd0920: data <= 20'h0D71E;                            // SPIWrite [0D7]=1E, TX BBF Tune Divider[8]
            12'd0921: data <= 20'h0CA22;                            // SPIWrite [0CA]=22, Enable Tx Filter Tuner
            12'd0922: data <= 20'h01640;                            // SPIWrite [016]=40, Start Tx Filter Tune
            12'd0923: data <= 20'h0CA26;                            // SPIWrite [0CA]=26, Disable Tx Filter Tuner (Both Channels)
            12'd0924: data <= 20'h40000;                            // WAIT 20 ms, Read RXBBF C3(MSB)
            12'd0925: data <= 20'h40000;                            // WAIT 20 ms, Read RXBBF C3(LSB)
            12'd0926: data <= 20'h40000;                            // WAIT 20 ms, Read RXBBF R2346
            12'd0927: data <= 20'h1DB20;                            // SPIWrite [1DB]=20, Set TIA selcc[2:0]
            12'd0928: data <= 20'h1DD00;                            // SPIWrite [1DD]=00, Set RX TIA1 C MSB[6:0]
            12'd0929: data <= 20'h1DF00;                            // SPIWrite [1DF]=00, Set RX TIA2 C MSB[6:0]
            12'd0930: data <= 20'h1DC63;                            // SPIWrite [1DC]=63, Set RX TIA1 C LSB[5:0]
            12'd0931: data <= 20'h1DE63;                            // SPIWrite [1DE]=63, Set RX TIA2 C LSB[5:0]
            12'd0932: data <= 20'h0D214;                            // SPIWrite [0D2]=14, TX Secondary Filter PDF Cap cal[5:0]
            12'd0933: data <= 20'h0D10C;                            // SPIWrite [0D1]=0C, TX Secondary Filter PDF Res cal[3:0]
            12'd0934: data <= 20'h0D056;                            // SPIWrite [0D0]=56, Pdampbias
            12'd0935: data <= 20'h40000;                            // WAIT 20 ms, Read RxBBF C3 MSB after calibration
            12'd0936: data <= 20'h40000;                            // WAIT 20 ms, Read RxBBF C3 LSB after calibration
            12'd0937: data <= 20'h40000;                            // WAIT 20 ms, Read RxBBF R3 after calibration
            12'd0938: data <= 20'h20000;                            // SPIWrite [200]=00
            12'd0939: data <= 20'h20100;                            // SPIWrite [201]=00
            12'd0940: data <= 20'h20200;                            // SPIWrite [202]=00
            12'd0941: data <= 20'h20324;                            // SPIWrite [203]=24
            12'd0942: data <= 20'h20424;                            // SPIWrite [204]=24
            12'd0943: data <= 20'h20500;                            // SPIWrite [205]=00
            12'd0944: data <= 20'h20600;                            // SPIWrite [206]=00
            12'd0945: data <= 20'h2077C;                            // SPIWrite [207]=7C
            12'd0946: data <= 20'h20854;                            // SPIWrite [208]=54
            12'd0947: data <= 20'h2093C;                            // SPIWrite [209]=3C
            12'd0948: data <= 20'h20A4B;                            // SPIWrite [20A]=4B
            12'd0949: data <= 20'h20B34;                            // SPIWrite [20B]=34
            12'd0950: data <= 20'h20C4E;                            // SPIWrite [20C]=4E
            12'd0951: data <= 20'h20D33;                            // SPIWrite [20D]=33
            12'd0952: data <= 20'h20E00;                            // SPIWrite [20E]=00
            12'd0953: data <= 20'h20F7F;                            // SPIWrite [20F]=7F
            12'd0954: data <= 20'h2107E;                            // SPIWrite [210]=7E
            12'd0955: data <= 20'h2117F;                            // SPIWrite [211]=7F
            12'd0956: data <= 20'h21249;                            // SPIWrite [212]=49
            12'd0957: data <= 20'h21348;                            // SPIWrite [213]=48
            12'd0958: data <= 20'h21449;                            // SPIWrite [214]=49
            12'd0959: data <= 20'h2154C;                            // SPIWrite [215]=4C
            12'd0960: data <= 20'h2164B;                            // SPIWrite [216]=4B
            12'd0961: data <= 20'h2174C;                            // SPIWrite [217]=4C
            12'd0962: data <= 20'h2182E;                            // SPIWrite [218]=2E
            12'd0963: data <= 20'h21998;                            // SPIWrite [219]=98
            12'd0964: data <= 20'h21A1B;                            // SPIWrite [21A]=1B
            12'd0965: data <= 20'h21B13;                            // SPIWrite [21B]=13
            12'd0966: data <= 20'h21C98;                            // SPIWrite [21C]=98
            12'd0967: data <= 20'h21D1B;                            // SPIWrite [21D]=1B
            12'd0968: data <= 20'h21E13;                            // SPIWrite [21E]=13
            12'd0969: data <= 20'h21F98;                            // SPIWrite [21F]=98
            12'd0970: data <= 20'h2201B;                            // SPIWrite [220]=1B
            12'd0971: data <= 20'h22127;                            // SPIWrite [221]=27
            12'd0972: data <= 20'h22227;                            // SPIWrite [222]=27
            12'd0973: data <= 20'h22340;                            // SPIWrite [223]=40
            12'd0974: data <= 20'h22440;                            // SPIWrite [224]=40
            12'd0975: data <= 20'h2252C;                            // SPIWrite [225]=2C
            12'd0976: data <= 20'h22600;                            // SPIWrite [226]=00
            12'd0977: data <= 20'h22700;                            // SPIWrite [227]=00
            12'd0978: data <= 20'h40000;                            // WAIT 20 ms, Masked Read:  Read lower 6 bits, overwrite [7:6] below
            12'd0979: data <= 20'h0A05F;                            // SPIWrite [0A0]=5F, Set TxQuadcal NCO frequency
            12'd0980: data <= 20'h0A380;                            // SPIWrite [0A3]=80, Set TxQuadcal NCO frequency (Only update bits [7:6])
            12'd0981: data <= 20'h0A17B;                            // SPIWrite [0A1]=7B, Set TxQuadcal M[1:0]
            12'd0982: data <= 20'h0A9FF;                            // SPIWrite [0A9]=FF, Set Tx Quad Cal Count
            12'd0983: data <= 20'h0A27F;                            // SPIWrite [0A2]=7F, Set Tx Quad Cal Kexp
            12'd0984: data <= 20'h0A501;                            // SPIWrite [0A5]=01, Set Tx Quad Cal Magnitude Threshhold
            12'd0985: data <= 20'h0A601;                            // SPIWrite [0A6]=01, Set Tx Quad Cal Magnitude Threshhold
            12'd0986: data <= 20'h0AA25;                            // SPIWrite [0AA]=25, Set Tx Quad Cal Gain Table index
            12'd0987: data <= 20'h0A4F0;                            // SPIWrite [0A4]=F0, Set Tx Quad Cal Setting Count
            12'd0988: data <= 20'h0AE00;                            // SPIWrite [0AE]=00, Set Tx Quad Cal LPF Gain index incase Split table mode used
            12'd0989: data <= 20'h1933F;                            // SPIWrite [193]=3F, BBDC Cal setting
            12'd0990: data <= 20'h1900F;                            // SPIWrite [190]=0F, Set BBDC tracking shift M value, only applies when BB DC tracking enabled
            12'd0991: data <= 20'h19401;                            // SPIWrite [194]=01, BBDC Cal setting
            12'd0992: data <= 20'h01601;                            // SPIWrite [016]=01, Start BBDC offset cal
            12'd0993: data <= 20'h18520;                            // SPIWrite [185]=20, Set RF DC offset Wait Count
            12'd0994: data <= 20'h18632;                            // SPIWrite [186]=32, Set RF DC Offset Count[7:0]
            12'd0995: data <= 20'h18724;                            // SPIWrite [187]=24, Settings for RF DC cal
            12'd0996: data <= 20'h18B83;                            // SPIWrite [18B]=83, Settings for RF DC cal
            12'd0997: data <= 20'h18805;                            // SPIWrite [188]=05, Settings for RF DC cal
            12'd0998: data <= 20'h18930;                            // SPIWrite [189]=30, Settings for RF DC cal
            12'd0999: data <= 20'h01602;                            // SPIWrite [016]=02, RFDC Max Cal Time: 59923.828 us
            12'd1000: data <= 20'h01610;                            // SPIWrite [016]=10, TXQuad Max Cal Time: 3075.000 us
            12'd1001: data <= 20'h16803;                            // SPIWrite [168]=03, Set RX Quadcal Tone Level
            12'd1002: data <= 20'h16E25;                            // SPIWrite [16E]=25, Set Rx Gain index to use during RX Quadcal
            12'd1003: data <= 20'h16A75;                            // SPIWrite [16A]=75, Set Kexp Phase
            12'd1004: data <= 20'h16B15;                            // SPIWrite [16B]=15, Set Kexp Amplitude
            12'd1005: data <= 20'h169CF;                            // SPIWrite [169]=CF
            12'd1006: data <= 20'h18BAD;                            // SPIWrite [18B]=AD
            12'd1007: data <= 20'h01210;                            // SPIWrite [012]=10, Cals done, Set PPORT Config
            12'd1008: data <= 20'h01301;                            // SPIWrite [013]=01, Set ENSM FDD/TDD bit
            12'd1009: data <= 20'h01584;                            // SPIWrite [015]=84, Set Dual Synth Mode, FDD External Control bits properly
            12'd1010: data <= 20'h07328;                            // SPIWrite [073]=28
            12'd1011: data <= 20'h07400;                            // SPIWrite [074]=00
            12'd1012: data <= 20'h07528;                            // SPIWrite [075]=28
            12'd1013: data <= 20'h07600;                            // SPIWrite [076]=00
            12'd1014: data <= 20'h1500B;                            // SPIWrite [150]=0B, RSSI Measurement Duration 0, 1
            12'd1015: data <= 20'h15100;                            // SPIWrite [151]=00, RSSI Measurement Duration 2, 3
            12'd1016: data <= 20'h152FF;                            // SPIWrite [152]=FF, RSSI Weighted Multiplier 0
            12'd1017: data <= 20'h15300;                            // SPIWrite [153]=00, RSSI Weighted Multiplier 1
            12'd1018: data <= 20'h15400;                            // SPIWrite [154]=00, RSSI Weighted Multiplier 2
            12'd1019: data <= 20'h15500;                            // SPIWrite [155]=00, RSSI Weighted Multiplier 3
            12'd1020: data <= 20'h15600;                            // SPIWrite [156]=00, RSSI Delay
            12'd1021: data <= 20'h15700;                            // SPIWrite [157]=00, RSSI Wait
            12'd1022: data <= 20'h1580D;                            // SPIWrite [158]=0D, RSSI Mode Select
            12'd1023: data <= 20'h15C69;                            // SPIWrite [15C]=69, Power Measurement Duration
            12'd1024: data <= 20'h0025C;                            // SPIWrite [002]=5C, Set # transmitters enabled
            12'd1025: data <= 20'h0035C;                            // SPIWrite [003]=5C, Set # receivers enabled
            //start tx rx ensm
            12'd1026: data <= 20'h01407;
            12'd1027: data <= 20'h01423;

            12'd1028: data <= 20'h80000;                            // INIT_END
            default:
                data <= 20'h00000;
        endcase
    end

endmodule
