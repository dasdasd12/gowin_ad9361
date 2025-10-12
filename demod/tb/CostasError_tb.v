`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/05 14:05:17 
// Version:                V1.0 
// File Name:              CostasError_tb.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 

module CostasError_tb ();
    reg clk;
    reg rst_n;

    initial begin
        $dumpfile("error_wave.vcd");  // 指定生成的波形文件名为 "wave.vcd"
        $dumpvars(0, CostasError_tb);  // 记录所有层次的信号
    end

    initial begin
        clk = 1'b1;
        forever #0.5 clk = ~clk;
    end
    initial begin
        rst_n = 1'b1;
        #1 rst_n = 1'b0;
        #1 rst_n = 1'b1;
    end

    localparam TEST_NUM = 100;

    reg signed [12-1:0] x_in, y_in, x_ins[0:TEST_NUM-1], y_ins[0:TEST_NUM-1];
    wire signed [ 8-1:0] error_out;
    wire signed [11-1:0] phase_out;


    integer              i = 0;
    initial begin
        #2;
        for (i = 0; i < TEST_NUM - 1; i = i + 1) begin
            #1;
        end
        #5 $finish;
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_in <= 0;
            y_in <= 0;
        end else begin
            x_in = x_ins[i];
            y_in = y_ins[i];
        end
    end

    CostasError8 #(
        .DATA_W (12),
        .ADDR_W (8),
        .ERROR_W(8)
    ) u_CostasError8 (
        .clk      (clk),
        .rst_n    (rst_n),
        .x_in     (x_in),
        .y_in     (y_in),
        .error_out(error_out),
        .phase_out(phase_out)
    );

    initial begin
        x_ins[0]  = -2000;
        x_ins[1]  = -1995;
        x_ins[2]  = -1983;
        x_ins[3]  = -1963;
        x_ins[4]  = -1935;
        x_ins[5]  = -1900;
        x_ins[6]  = -1856;
        x_ins[7]  = -1805;
        x_ins[8]  = -1747;
        x_ins[9]  = -1682;
        x_ins[10] = -1610;
        x_ins[11] = -1532;
        x_ins[12] = -1447;
        x_ins[13] = -1357;
        x_ins[14] = -1261;
        x_ins[15] = -1160;
        x_ins[16] = -1054;
        x_ins[17] = -944;
        x_ins[18] = -830;
        x_ins[19] = -713;
        x_ins[20] = -593;
        x_ins[21] = -471;
        x_ins[22] = -347;
        x_ins[23] = -221;
        x_ins[24] = -95;
        x_ins[25] = 31;
        x_ins[26] = 158;
        x_ins[27] = 284;
        x_ins[28] = 409;
        x_ins[29] = 532;
        x_ins[30] = 654;
        x_ins[31] = 772;
        x_ins[32] = 888;
        x_ins[33] = 1000;
        x_ins[34] = 1107;
        x_ins[35] = 1211;
        x_ins[36] = 1309;
        x_ins[37] = 1402;
        x_ins[38] = 1490;
        x_ins[39] = 1572;
        x_ins[40] = 1647;
        x_ins[41] = 1715;
        x_ins[42] = 1777;
        x_ins[43] = 1832;
        x_ins[44] = 1879;
        x_ins[45] = 1918;
        x_ins[46] = 1950;
        x_ins[47] = 1974;
        x_ins[48] = 1990;
        x_ins[49] = 1998;
        x_ins[50] = 1998;
        x_ins[51] = 1990;
        x_ins[52] = 1974;
        x_ins[53] = 1950;
        x_ins[54] = 1918;
        x_ins[55] = 1879;
        x_ins[56] = 1832;
        x_ins[57] = 1777;
        x_ins[58] = 1715;
        x_ins[59] = 1647;
        x_ins[60] = 1572;
        x_ins[61] = 1490;
        x_ins[62] = 1402;
        x_ins[63] = 1309;
        x_ins[64] = 1211;
        x_ins[65] = 1107;
        x_ins[66] = 999;
        x_ins[67] = 888;
        x_ins[68] = 772;
        x_ins[69] = 654;
        x_ins[70] = 532;
        x_ins[71] = 409;
        x_ins[72] = 284;
        x_ins[73] = 158;
        x_ins[74] = 31;
        x_ins[75] = -95;
        x_ins[76] = -221;
        x_ins[77] = -347;
        x_ins[78] = -471;
        x_ins[79] = -593;
        x_ins[80] = -713;
        x_ins[81] = -830;
        x_ins[82] = -944;
        x_ins[83] = -1054;
        x_ins[84] = -1160;
        x_ins[85] = -1261;
        x_ins[86] = -1357;
        x_ins[87] = -1447;
        x_ins[88] = -1532;
        x_ins[89] = -1610;
        x_ins[90] = -1682;
        x_ins[91] = -1747;
        x_ins[92] = -1805;
        x_ins[93] = -1856;
        x_ins[94] = -1900;
        x_ins[95] = -1935;
        x_ins[96] = -1963;
        x_ins[97] = -1983;
        x_ins[98] = -1995;
        x_ins[99] = -2000;
    end
    initial begin
        y_ins[0]  = 0;
        y_ins[1]  = -126;
        y_ins[2]  = -253;
        y_ins[3]  = -378;
        y_ins[4]  = -502;
        y_ins[5]  = -624;
        y_ins[6]  = -743;
        y_ins[7]  = -859;
        y_ins[8]  = -972;
        y_ins[9]  = -1081;
        y_ins[10] = -1185;
        y_ins[11] = -1285;
        y_ins[12] = -1380;
        y_ins[13] = -1469;
        y_ins[14] = -1552;
        y_ins[15] = -1629;
        y_ins[16] = -1699;
        y_ins[17] = -1762;
        y_ins[18] = -1819;
        y_ins[19] = -1868;
        y_ins[20] = -1909;
        y_ins[21] = -1943;
        y_ins[22] = -1969;
        y_ins[23] = -1987;
        y_ins[24] = -1997;
        y_ins[25] = -1999;
        y_ins[26] = -1993;
        y_ins[27] = -1979;
        y_ins[28] = -1957;
        y_ins[29] = -1927;
        y_ins[30] = -1890;
        y_ins[31] = -1844;
        y_ins[32] = -1791;
        y_ins[33] = -1732;
        y_ins[34] = -1665;
        y_ins[35] = -1591;
        y_ins[36] = -1511;
        y_ins[37] = -1425;
        y_ins[38] = -1333;
        y_ins[39] = -1236;
        y_ins[40] = -1134;
        y_ins[41] = -1027;
        y_ins[42] = -916;
        y_ins[43] = -801;
        y_ins[44] = -684;
        y_ins[45] = -563;
        y_ins[46] = -440;
        y_ins[47] = -316;
        y_ins[48] = -190;
        y_ins[49] = -63;
        y_ins[50] = 63;
        y_ins[51] = 190;
        y_ins[52] = 316;
        y_ins[53] = 440;
        y_ins[54] = 563;
        y_ins[55] = 684;
        y_ins[56] = 801;
        y_ins[57] = 916;
        y_ins[58] = 1027;
        y_ins[59] = 1134;
        y_ins[60] = 1236;
        y_ins[61] = 1333;
        y_ins[62] = 1425;
        y_ins[63] = 1511;
        y_ins[64] = 1591;
        y_ins[65] = 1665;
        y_ins[66] = 1732;
        y_ins[67] = 1791;
        y_ins[68] = 1844;
        y_ins[69] = 1890;
        y_ins[70] = 1927;
        y_ins[71] = 1957;
        y_ins[72] = 1979;
        y_ins[73] = 1993;
        y_ins[74] = 1999;
        y_ins[75] = 1997;
        y_ins[76] = 1987;
        y_ins[77] = 1969;
        y_ins[78] = 1943;
        y_ins[79] = 1909;
        y_ins[80] = 1868;
        y_ins[81] = 1819;
        y_ins[82] = 1762;
        y_ins[83] = 1699;
        y_ins[84] = 1629;
        y_ins[85] = 1552;
        y_ins[86] = 1469;
        y_ins[87] = 1380;
        y_ins[88] = 1285;
        y_ins[89] = 1185;
        y_ins[90] = 1081;
        y_ins[91] = 972;
        y_ins[92] = 859;
        y_ins[93] = 743;
        y_ins[94] = 624;
        y_ins[95] = 502;
        y_ins[96] = 378;
        y_ins[97] = 253;
        y_ins[98] = 126;
        y_ins[99] = 0;
    end
endmodule
