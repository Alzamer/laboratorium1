`timescale 1ns / 1ps
module dut (
    input  logic clk,
    input  logic rstn,
    
    input  logic       valid,
    output logic       ready,
    input  logic [7:0] cmd,
    input  logic [7:0] data_in,
    output logic [7:0] data_out
);

    wire scl_line;
    wire sda_line;

    controller u_ctrl (
        .clk      (clk),
        .rstn     (rstn),
        .valid    (valid),
        .ready    (ready),
        .cmd      (cmd),
        .data_in  (data_in),
        .data_out (data_out),
        .scl      (scl_line),
        .sda      (sda_line)
    );

    M24CSM01 u_memory (
        .A1    (1'b0),
        .A2    (1'b0),
        .WP    (1'b0),
        .SDA   (sda_line), 
        .SCL   (scl_line), 
        .RESET (~rstn) 
    );

endmodule
