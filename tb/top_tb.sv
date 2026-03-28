module top_tb (
    output logic clk,
    output logic rstn
);
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        $display("[%0t] Start symulacji", $time);
        rstn = 0;
	$display("[%0t] ", $time);
	#20;
        rstn = 1;
        $display("[%0t] Reset zwolniony", $time);
        #100;
        $display("[%0t] Koniec", $time);
        $finish; 
    end
endmodule
