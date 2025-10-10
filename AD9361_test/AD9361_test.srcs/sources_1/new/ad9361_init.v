`timescale 1ns/100ps



module ad9361_init (
    input                               clk                        ,
    input                               rst_n                      ,

        //ctrl
    input                               spi_wr_end                 ,
    output reg                          spi_wr_req                 ,
    output reg           [   9: 0]      spi_wr_addr                ,
    output reg           [   7: 0]      spi_wr_data                ,

    input                               spi_rd_end                 ,
    output reg                          spi_rd_req                 ,
    output reg           [   9: 0]      spi_rd_addr                ,

    output reg                          init_done                  ,
    output reg                          rd_done                    ,
    
    input                               wr_flag                    ,
    input                [  19: 0]      wr_data                    ,
    input                               rd_start                    
    );
    
    reg                [   1: 0]        state                       ;
    reg                [   1: 0]        state_next                  ;
    reg                                 wait_vld                    ;
    reg                [  23: 0]        wait_cnt                    ;
    reg                [  11: 0]        addr                        ;
    reg                [   9: 0]        rd_addr                     ;
    wire               [  19: 0]        rom_data                    ;

    reg                                 wr_en                       ;

    wire                                spi_wr_trg                =state==2'b00&&(rom_data[19:18]==2'b00||wr_en);
    wire                                wait_trg                  =state==2'b00&&rom_data[19:18]==2'b01;
    wire                                spi_rd_trg                =state==2'b00&&init_done&&~rd_done;
    wire                                init_end                  =state==2'b00&&rom_data[19:18]==2'b10;

    `ifdef DEBUG    
        //for debug set wait = 0;
        wire                                wait_end                  =wait_vld&&wait_cnt==24'd2;
        wire                                rd_end                    =state==2'b00&&rd_addr==10'd50;

    `else

        wire                                rd_end                    =state==2'b00&&rd_addr==10'd1022;
        wire                                wait_end                  =wait_vld&&wait_cnt==24'd15_000_000;

    `endif

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            wr_en <= 1'b0;
        end
        else if(wr_flag) begin
            wr_en <= 1'b1;
        end
        else if(spi_wr_end) begin
            wr_en <= 1'b0;
        end
        else wr_en <= wr_en;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            wait_vld <=  1'b0;
        end
        else if(wait_end) begin
            wait_vld <=  1'b0;
        end
        else if(wait_trg) begin
            wait_vld <=  1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            wait_cnt <=  24'd0;
        end
        else if(!wait_vld) begin
            wait_cnt <=  24'd0;
        end
        else begin
            wait_cnt <=  wait_cnt + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <=  2'd0;
        end
        else begin
            state <=  state_next;
        end
    end

    always @(*) begin
        case(state)
            2'b00 :
                state_next = spi_wr_trg ? 2'b01 : spi_rd_trg ? 2'b11 : (wait_trg ? 2'b10 : 2'b00);
            2'b01 :
                state_next = spi_wr_end ? 2'b00 : 2'b01;
            2'b10 :
                state_next = wait_end   ? 2'b00 : 2'b10;
            2'b11 :
                state_next = spi_rd_end ? 2'b00 : 2'b11;
        endcase
    end

    `ifdef DEBUG
        //debug 
        always @(posedge clk or negedge rst_n) begin
            if(!rst_n) begin
                addr <=  12'd1020;
            end
            else if((spi_wr_trg || wait_trg )&& ~init_done) begin
                addr <=  addr + 1'b1;
            end
        end
    `else 
        always @(posedge clk or negedge rst_n) begin
            if(!rst_n) begin
                addr <=  12'd0;
            end
            else if((spi_wr_trg || wait_trg )&& ~init_done) begin
                addr <=  addr + 1'b1;
            end
        end
    `endif

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rd_addr <= 10'b0;
        end
        else if (rd_start) begin
            rd_addr <= 10'b0;
        end
        else if(spi_rd_trg) begin
            rd_addr <= rd_addr + 1'b1;
        end
    end

    ad9361_cfg_rom_v5 u_rom(
    .clk                                (clk                       ),
    .addr                               (addr                      ),
    .data                               (rom_data                  ) 
    );

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            spi_wr_req <= 1'b0;
        end
        else begin
            spi_wr_req <= spi_wr_trg;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            spi_rd_req <= 1'b0;
        end
        else begin
            spi_rd_req <= spi_rd_trg;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            spi_wr_addr <= 10'b0;
        end
        else if(spi_wr_trg && ~init_done) begin
            spi_wr_addr <= rom_data[17:8];
        end
        else if(spi_wr_trg && init_done) begin
            spi_wr_addr <= wr_data[17:8];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            spi_wr_data <= 8'b0;
        end
        else if(spi_wr_trg && ~init_done) begin
            spi_wr_data <= rom_data[7:0];
        end
        else if(spi_wr_trg && init_done) begin
            spi_wr_data <= wr_data[7:0];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            spi_rd_addr <= 10'b0;
        end
        else if(spi_rd_trg) begin
            spi_rd_addr <= rd_addr;                                 //read device version for the last read
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            init_done <= 1'b0;
        end
        else if(init_end) begin
            init_done <= 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rd_done <= 1'b0;
        end
        else if(rd_end) begin
            rd_done <= 1'b1;
        end
        else if(rd_start) begin
            rd_done <= 1'b0;
        end
    end

endmodule
