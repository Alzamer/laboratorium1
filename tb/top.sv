`timescale 1ns / 1ps
module top ();
    logic clk_sig;
    logic rstn_sig;
    logic       valid_sig;
    logic       ready_sig;
    logic [7:0] cmd_sig;
    logic [7:0] data_in_sig;
    logic [7:0] data_out_sig;
    wire [15:0] addr_in;
    dut instance1 (
        .clk      (clk_sig),
        .rstn     (rstn_sig),
        .valid    (valid_sig),
        .ready    (ready_sig),
        .cmd      (cmd_sig),
        .data_in  (data_in_sig),
        .data_out (data_out_sig),
	.addr_in(addr_in)
    );

    top_tb instance2 (
        .clk      (clk_sig),
        .rstn     (rstn_sig),
        .valid    (valid_sig),
        .ready    (ready_sig),
        .cmd      (cmd_sig),
        .data_in  (data_in_sig),
        .data_out (data_out_sig),
	.addr_in(addr_in)
    );
endmodule
