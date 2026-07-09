`timescale 1ns / 1ps
import uvm_pkg::*;
import my_uvm_pkg::*;
`include "uvm_macros.svh"

module top ();
    logic clk;
    initial clk = 0;
    always #5 clk = ~clk;
    dut_if vif(.clk(clk));

    initial begin
        vif.rstn = 1'b0;
        #20 vif.rstn = 1'b1;
    end

    dut instance1 (
        .clk     (vif.clk),
        .rstn    (vif.rstn),
        .valid   (vif.valid),
        .ready   (vif.ready),
        .cmd     (vif.cmd),
        .data_in (vif.data_in),
        .data_out(vif.data_out),
        .addr_in (vif.addr_in)
    );

    initial begin
        uvm_config_db#(virtual dut_if)::set(null, "*", "vif_name", vif);
        run_test(); 
    end
endmodule
