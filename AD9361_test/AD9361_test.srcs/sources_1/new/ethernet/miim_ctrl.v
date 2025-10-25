`timescale 1ns/100ps

module ethernet_miim_ctrl (
    input                               clk                        ,
    input                               rst_n                      ,       

    output reg           [   4: 0]      miim_phy_addr              ,
    output reg           [   4: 0]      miim_reg_addr              ,
    output reg           [  15: 0]      miim_write_data            ,
    output reg                          miim_write_en              ,

    output reg                          miim_read_en               ,
    input                [  15: 0]      miim_read_data             ,
    input                               miim_busy                  ,
    input                               miim_read_data_valid        
);

    localparam                          IDLE                        = 3'd0                 ;
    localparam                          MODE                        = 3'd1                 ;
    localparam                          WRITE                       = 3'd2                 ;
    localparam                          READ                        = 3'd3                 ;
    localparam                          WAIT                        = 3'd4                 ;

    localparam                          PHY_ADDR                    = 5'd0                 ;
    localparam                          NUM                         = 4                    ; 

    reg                [   2: 0]        state                       ;
    reg                [   3: 0]        cnt                         ;

    reg                [   4: 0]        reg_addr                    ;
    reg                [  15: 0]        write_data                  ;
    reg                [  15: 0]        read_data                   ;
    reg                                 write                       ;


    reg                                 start_flag                  ;
    reg                [   7: 0]        start_cnt                   ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start_cnt <= 8'b0;
        end 
        else begin
            if (start_flag == 8'd100) begin
                start_cnt <= start_cnt;
            end
            else begin
                start_cnt <= start_cnt + 1'b1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start_flag <= 1'b0;
        end 
        else begin
            if (start_cnt == 8'd99) begin
                start_flag <= 1'b1;
            end
            else 
                start_flag <= 1'b0;
        end
    end

    reg                                 busy_reg                    ;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            busy_reg <= 1'b0;
        end 
        else begin
            busy_reg <= miim_busy;
        end
    end

    wire                                busy_fall                 =busy_reg & (!miim_busy);
    wire                                finish                    =(cnt == NUM);
    wire                                start                     =finish ? 1'b0 : (start_flag | busy_fall);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            miim_phy_addr   <= 5'd0;
            miim_reg_addr   <= 5'd0;
            miim_write_data <= 16'd0;
            miim_write_en   <= 1'b0;
            miim_read_en    <= 1'b0;
        end else begin

                miim_write_en <= 1'b0;
                miim_read_en  <= 1'b0;

            case (state)
            
                IDLE: begin
                    if (start) begin
                        state <= MODE;
                    end
                end

                MODE: begin
                    if (write) begin
                        state <= WRITE;
                    end else begin
                        state <= READ;
                    end
                end

                WRITE: begin
                    state <= WAIT;
                    miim_phy_addr <= PHY_ADDR;
                    miim_reg_addr <= reg_addr;
                    miim_write_data <= write_data;
                    miim_write_en <= 1'b1;
                end
                
                READ: begin
                    state <= WAIT;
                    miim_phy_addr <= PHY_ADDR;
                    miim_reg_addr <= reg_addr;
                    miim_read_en <= 1'b1;
                end

                WAIT: begin
                    if (!miim_busy & (!miim_write_en & !miim_read_en)) begin
                        state <= IDLE;
                    end
                end

            endcase

        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 4'd0;
        end 
        else begin
            if (start) begin
                cnt <= cnt + 1'b1;
            end
        end
    end

   always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_addr <= 5'd0;
            write_data <= 16'd0;
            write <= 1'b0;
        end 
        else begin
            case(cnt)
                4'd0: begin
                    reg_addr <= 5'd0;
                    write_data <= 16'd0;
                    write <= 1'b0;
                end
                4'd1: begin
                    reg_addr <= 5'd4;          // Auto-Negotiation Advertisement Register
                    write_data <= 16'h01E1;    // Set Advertisement Capabilities
                end
                4'd2: begin
                    reg_addr <= 5'd0;          // Control Register
                    write_data <= 16'h1200;    // Restart Auto-Negotiation
                end
                default: begin
                    reg_addr <= 5'd0;
                    write_data <= 16'd0;
                end
            endcase
        end
    end


endmodule