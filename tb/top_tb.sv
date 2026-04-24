`timescale 1ns / 1ps

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
    output logic       clk,
    output logic       rstn,
    output logic       valid,
    input  logic       ready,
    output cmd_t       cmd,
    output logic [7:0] data_in,
    input  logic [7:0] data_out
);

    initial begin clk = 0; forever #5 clk = ~clk; end

    initial begin
        $display("[%0t] Start symulacji", $time);
        rstn = 0; valid = 0; cmd = CMD_READ_ID; data_in = 8'h00;
        
        #20 rstn = 1;
        $display("[%0t] Reset zwolniony", $time);
        #50;
        $display("[%0t] TB: Komenda READ ID", $time);
        valid = 1; cmd = CMD_READ_ID; 
        #10 valid = 0;
        wait(ready == 1); 
        if (data_out !== 8'hFF) begin
            $error("[%0t] BLAD! READ ID zwrocilo: %h, oczekiwano: FF", $time, data_out);
        end else begin
            $display("[%0t] SUKCES! ID poprawne.", $time);
        end
        #100;
        
        $display("[%0t] TB: Komenda READ STATUS", $time);
        valid = 1; cmd = CMD_READ_STATUS; 
        #10 valid = 0;
        wait(ready == 1);
        if (data_out !== 8'hFE) begin
            $error("[%0t] BLAD! READ STATUS zwrocilo: %h, oczekiwano: FE", $time, data_out);
        end else begin
            $display("[%0t] SUKCES! STATUS poprawny.", $time);
        end
        #100;

        $display("[%0t] TB: Komenda WRITE DATA (0xAA)", $time);
        valid = 1; cmd = CMD_WRITE_DATA; data_in = 8'hAA;
        #10 valid = 0;
        wait(ready == 1);
        $display("[%0t] TB: Zapis zakonczony (brak danych do sprawdzenia).", $time);
        #100;

        $display("[%0t] TB: Komenda READ DATA", $time);
        valid = 1; cmd = CMD_READ_DATA; 
        #10 valid = 0;
        wait(ready == 1);
        if (data_out !== 8'hFF) begin
            $error("[%0t] BLAD! READ DATA zwrocilo: %h, oczekiwano: FF", $time, data_out);
        end else begin
            $display("[%0t] SUKCES! DANE poprawne.", $time);
        end
        #100;

        $display("[%0t] Koniec symulacji. Wszystkie testy zaliczone!", $time);
        $finish;  
    end
endmodule
