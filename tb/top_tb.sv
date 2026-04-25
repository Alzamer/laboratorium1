`timescale 1ns / 1ps

module top_tb (
    output logic       clk,
    output logic       rstn,
    output logic       valid,
    input  logic       ready,
    output logic [7:0] cmd,
    output logic [7:0] data_in,
    input  logic [7:0] data_out
);

    initial begin clk = 0; forever #5 clk = ~clk; end

    initial begin
        $display("[%0t] Start symulacji", $time);
        rstn = 0; valid = 0; cmd = 8'h00; data_in = 8'h00;
        
        #20 rstn = 1;
        $display("[%0t] Reset zwolniony", $time);
        #50;
        
        // 1. READ ID (0x01)
        $display("[%0t] TB: Komenda READ ID", $time);
        valid = 1; cmd = 8'h01; 
        #10 valid = 0;
        wait(ready == 1); 
        $display("[%0t] TB: Odebrano ID: %h", $time, data_out);
        #100;
        
        // 2. READ STATUS (0x02)
        $display("[%0t] TB: Komenda READ STATUS", $time);
        valid = 1; cmd = 8'h02; 
        #10 valid = 0;
        wait(ready == 1);
        $display("[%0t] TB: Odebrano STATUS: %h", $time, data_out);
        #100;

        // 3. WRITE DATA (0x04)
        $display("[%0t] TB: Komenda WRITE DATA (0xAA)", $time);
        valid = 1; cmd = 8'h04; data_in = 8'hAA;
        #10 valid = 0;
        wait(ready == 1);
        $display("[%0t] TB: Zapis zakonczony", $time);
        #100;

        // 4. READ DATA (0x03)
        $display("[%0t] TB: Komenda READ DATA", $time);
        valid = 1; cmd = 8'h03; 
        #10 valid = 0;
        wait(ready == 1);
        $display("[%0t] TB: Odebrano DANE: %h", $time, data_out);
        #100;

        $display("[%0t] Koniec symulacji", $time);
        $finish;  
    end
endmodule
