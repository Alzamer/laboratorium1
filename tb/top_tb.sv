`timescale 1ns / 1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

package tb_pkg;
    typedef enum logic [7:0] {
        CMD_READ_ID     = 8'h01,
        CMD_READ_STATUS = 8'h02,
        CMD_READ_DATA   = 8'h03,
        CMD_WRITE_DATA  = 8'h04
    } cmd_t;
endpackage

import tb_pkg::*;

module top_tb (
    output logic        clk,
    output logic        rstn,
    output logic        valid,
    input  logic        ready,
    output cmd_t        cmd,
    output logic [15:0] addr_in,
    output logic [7:0]  data_in,
    input  logic [7:0]  data_out
);

    initial begin clk = 0; forever #5 clk = ~clk; end

    initial begin
        `uvm_info("TEST", "========================================", UVM_MEDIUM)
        `uvm_info("TEST", "Hello, World!", UVM_MEDIUM)
        `uvm_info("TEST", "========================================", UVM_MEDIUM)

        `uvm_info("TEST", "Start symulacji", UVM_LOW)
        rstn = 0; valid = 0; cmd = CMD_READ_ID; addr_in = 16'h0000; data_in = 8'h00;
        
        #20 rstn = 1;
        #50;
        valid = 1; cmd = CMD_READ_ID; #10 valid = 0; wait(ready == 1);
        if (data_out !== 8'hFF) begin
            `uvm_error("TEST", $sformatf("BLAD ID! Otrzymano: %h", data_out))
        end else begin
            `uvm_info("TEST", "Odczyt ID poprawny.", UVM_LOW)
        end
        #100;

        valid = 1; cmd = CMD_READ_STATUS; #10 valid = 0; wait(ready == 1); #100;

        for (int i = 0; i < 5; i++) begin
            logic [15:0] rand_addr = $urandom();
            logic [7:0]  rand_data = $urandom();

            `uvm_info("TEST", $sformatf("ITERACJA %0d: Test adresu %h", i, rand_addr), UVM_LOW)
            
            valid = 1; cmd = CMD_WRITE_DATA; addr_in = rand_addr; data_in = rand_data;
            #10 valid = 0; wait(ready == 1); #100;

            valid = 1; cmd = CMD_READ_DATA; addr_in = rand_addr;
            #10 valid = 0; wait(ready == 1);
            
            `uvm_info("TEST", $sformatf("Odczytano dane: %h", data_out), UVM_MEDIUM)
            #100;
        end

        `uvm_info("TEST", "Koniec symulacji. Fuzzing zakonczony!", UVM_LOW)
        $finish;  
    end
endmodule
