`timescale 1ns / 100ps
//---------------------------------------------------------------------------------------- 
// Created by:             wxhenry
// Created date:           2025/10/13 09:48:30 
// Version:                V1.0 
// File Name:              Buffer_tb.v 
// Descriptions:            
//                          
//---------------------------------------------------------------------------------------- 


module ConvertBuffer_tb ();
    reg clk;
    reg rst_n = 1;

    initial begin
        clk = 1'b1;
        forever #0.5 clk = ~clk;
    end
    initial begin
        // rst_n = 1'b1;
        // #0.1;
        rst_n = 1'b0;
        #1 rst_n = 1'b1;
    end

    // parameter W1 = 3;
    // parameter W2 = 8;

    parameter W1 = 8;
    parameter W2 = 3;
    reg [W1-1:0] in_data_down, out_data_up;
    wire [W2-1:0] out_data_down;

    reg frame_end_down, frame_end_up, in_valid_down, out_ready_up;

    reg [1:0] counter3 = 0;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter3 <= 3'b0;
        end else begin
            if (counter3 == 2) begin
                counter3 <= 0;
            end else begin
                counter3 <= counter3 + 1;
            end
        end
    end

    wire transmit = (counter3 == 2) ? 1'b1 : 1'b0;
    // wire transmit = 1'b1;

    ConvertBuffer #(
        .IN_W (W1),
        .OUT_W(W2)
    ) u_ConvertBuffer_down (
        .clk      (clk),
        .rst_n    (rst_n),
        .frame_end(frame_end_down),
        .in_ready (in_ready_down),
        .in_valid (in_valid_down),
        .in_data  (in_data_down),
        .out_ready(in_ready_up & transmit),
        .out_valid(out_valid_down),
        .out_data (out_data_down)
    );

    ConvertBuffer #(
        .IN_W (W2),
        .OUT_W(W1)
    ) u_ConvertBuffer_up (
        .clk      (clk),
        .rst_n    (rst_n),
        .frame_end(frame_end_up),
        .in_ready (in_ready_up),
        .in_valid (out_valid_down & transmit),
        .in_data  (out_data_down),
        .out_ready(out_ready_up),
        .out_valid(out_valid_up),
        .out_data (out_data_up)
    );

    task send_data_down(input [W1-1:0] data, input is_frame_end);
        begin
            // 等待ready信号
            in_valid_down  = 1'b1;
            in_data_down   = data;
            frame_end_down = is_frame_end;
            @(posedge clk);
            while (!in_ready_down) begin
                @(posedge clk);
            end
            in_valid_down = 1'b0;
        end
    endtask

    integer data;

    initial begin
        // dump
        $dumpfile("ConvertBuffer_wave.vcd");
        $dumpvars(0, ConvertBuffer_tb);

        // simulation
        in_data_down   = 0;
        in_valid_down  = 1'b0;
        out_ready_up   = 1'b1;

        frame_end_down = 1'b0;
        frame_end_up   = 1'b0;

        #1;
        wait (rst_n);
        @(posedge clk);

        // in_data_down   = 8'h00;
        for (data = 0; data < 5; data = data + 1) begin
            send_data_down(data, 1'b0);
            // @(posedge clk);
        end

        @(posedge clk);
        frame_end_down = 1'b1;
        @(posedge clk);
        frame_end_down = 1'b0;

        #20;

        @(posedge clk);
        frame_end_up = 1'b1;
        @(posedge clk);
        frame_end_up = 1'b0;

        #29;
        @(posedge clk);
        for (data = 0; data < 11; data = data + 1) begin
            send_data_down(data, 1'b0);
            // @(posedge clk);
        end

        @(posedge clk);
        frame_end_down = 1'b1;
        @(posedge clk);
        frame_end_down = 1'b0;

        #20;

        @(posedge clk);
        frame_end_up = 1'b1;
        @(posedge clk);
        frame_end_up = 1'b0;

    end

    initial begin
        #500;
        $finish;
    end

endmodule
// module Buffer_tb ();
//     reg clk;
//     reg rst_n;

//     initial begin
//         clk = 1'b1;
//         forever #0.5 clk = ~clk;
//     end
//     initial begin
//         rst_n = 1'b0;
//         #1 rst_n = 1'b1;
//     end

//     initial begin
//         // dump
//         $dumpfile("Buffer_wave.vcd");
//         $dumpvars(0, Buffer_tb);
//         // simulation
//         #100 $finish;
//     end

// endmodule
