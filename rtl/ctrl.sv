`timescale 1ns / 1ps

module controller (
    input  logic        clk,
    input  logic        rstn,
    
    input  logic        valid,
    output logic        ready,
    input  logic [7:0]  cmd,
    input  logic [7:0]  data_in,
    output logic [7:0]  data_out,
    
    output logic        scl,
    inout  wire         sda
);

    localparam CMD_READ_ID     = 8'h01;
    localparam CMD_READ_STATUS = 8'h02;
    localparam CMD_READ_DATA   = 8'h03;
    localparam CMD_WRITE_DATA  = 8'h04;

    logic sda_out, sda_en, scl_out;
    assign sda = sda_en ? sda_out : 1'bz;
    assign scl = scl_out;
    logic sda_in;
    assign sda_in = sda;

    logic [7:0] clk_div;
    logic i2c_tick;
    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            clk_div <= 0;
            i2c_tick <= 0;
        end else begin
            if (clk_div == 8'd49) begin
                clk_div <= 0;
                i2c_tick <= 1'b1;
            end else begin
                clk_div <= clk_div + 1;
                i2c_tick <= 1'b0;
            end
        end
    end

    typedef enum logic [4:0] {
        ST_IDLE, ST_START, ST_DEV_ADDR_W, ST_ACK1, 
        ST_ADDR_HIGH, ST_ACK2, ST_ADDR_LOW, ST_ACK3,
        ST_WRITE_DATA, ST_ACK4,
        ST_RESTART, ST_DEV_ADDR_R, ST_ACK5, 
        ST_READ_DATA, ST_NACK, ST_STOP
    } state_t;

    state_t state;
    logic [7:0] shift_reg, saved_cmd, saved_data;
    logic [3:0] bit_cnt;

    localparam DEV_ADDR_W = 8'hA0; 
    localparam DEV_ADDR_R = 8'hA1; 

    assign ready = (state == ST_IDLE);

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state <= ST_IDLE;
            scl_out <= 1'b1;
            sda_out <= 1'b1;
            sda_en  <= 1'b1;
            data_out <= 8'h00;
        end else if (i2c_tick) begin
            case (state)
                ST_IDLE: begin
                    scl_out <= 1'b1; sda_out <= 1'b1; sda_en <= 1'b1;
                    if (valid) begin
                        saved_cmd <= cmd; saved_data <= data_in;
                        state <= ST_START;
                    end
                end

                ST_START: begin
                    sda_out <= 1'b0; scl_out <= 1'b1;
                    state <= ST_DEV_ADDR_W;
                    shift_reg <= DEV_ADDR_W; bit_cnt <= 7;
                end

                ST_DEV_ADDR_W: begin
                    scl_out <= 1'b0; sda_out <= shift_reg[bit_cnt]; sda_en <= 1'b1;
                    if (bit_cnt == 0) state <= ST_ACK1; else bit_cnt <= bit_cnt - 1;
                end
                ST_ACK1: begin
                    scl_out <= 1'b0; sda_en <= 1'b0;
                    state <= ST_ADDR_HIGH;
                    shift_reg <= (saved_cmd == CMD_READ_ID) ? 8'hFF : 8'h00; bit_cnt <= 7;
                end

                ST_ADDR_HIGH: begin
                    scl_out <= 1'b0; sda_out <= shift_reg[bit_cnt]; sda_en <= 1'b1;
                    if (bit_cnt == 0) state <= ST_ACK2; else bit_cnt <= bit_cnt - 1;
                end
                ST_ACK2: begin
                    scl_out <= 1'b0; sda_en <= 1'b0;
                    state <= ST_ADDR_LOW;
                    shift_reg <= (saved_cmd == CMD_READ_STATUS) ? 8'hFE : 8'h00; bit_cnt <= 7;
                end

                ST_ADDR_LOW: begin
                    scl_out <= 1'b0; sda_out <= shift_reg[bit_cnt]; sda_en <= 1'b1;
                    if (bit_cnt == 0) state <= ST_ACK3; else bit_cnt <= bit_cnt - 1;
                end
                ST_ACK3: begin
                    scl_out <= 1'b0; sda_en <= 1'b0;
                    if (saved_cmd == CMD_WRITE_DATA) begin
                        state <= ST_WRITE_DATA; shift_reg <= saved_data; bit_cnt <= 7;
                    end else state <= ST_RESTART;
                end

                ST_WRITE_DATA: begin
                    scl_out <= 1'b0; sda_out <= shift_reg[bit_cnt]; sda_en <= 1'b1;
                    if (bit_cnt == 0) state <= ST_ACK4; else bit_cnt <= bit_cnt - 1;
                end
                ST_ACK4: begin scl_out <= 1'b0; sda_en <= 1'b0; state <= ST_STOP; end

                ST_RESTART: begin sda_out <= 1'b1; scl_out <= 1'b1; sda_en <= 1'b1; state <= ST_DEV_ADDR_R; shift_reg <= DEV_ADDR_R; bit_cnt <= 7; end
                ST_DEV_ADDR_R: begin sda_out <= 1'b0; scl_out <= 1'b0; sda_out <= shift_reg[bit_cnt]; sda_en <= 1'b1; if (bit_cnt == 0) state <= ST_ACK5; else bit_cnt <= bit_cnt - 1; end
                ST_ACK5: begin scl_out <= 1'b0; sda_en <= 1'b0; state <= ST_READ_DATA; bit_cnt <= 7; end
                
                ST_READ_DATA: begin
                    scl_out <= 1'b0; sda_en <= 1'b0; shift_reg[bit_cnt] <= sda_in;
                    if (bit_cnt == 0) state <= ST_NACK; else bit_cnt <= bit_cnt - 1;
                end
                ST_NACK: begin scl_out <= 1'b0; sda_out <= 1'b1; sda_en <= 1'b1; data_out <= shift_reg; state <= ST_STOP; end

                ST_STOP: begin scl_out <= 1'b1; sda_out <= 1'b0; sda_en <= 1'b1; state <= ST_IDLE; end
                default: state <= ST_IDLE;
            endcase
            if (state != ST_IDLE && state != ST_START && state != ST_STOP && state != ST_RESTART) scl_out <= ~scl_out;
        end
    end
endmodule
