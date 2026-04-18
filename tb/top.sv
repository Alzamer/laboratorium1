module top ();
    logic clk_sig;
    logic rstn_sig;

    dut instance1 (
        .clk(clk_sig),
        .rstn(rstn_sig)
    );

    top_tb instance2 (
        .clk(clk_sig),
        .rstn(rstn_sig)
    );
endmodule
