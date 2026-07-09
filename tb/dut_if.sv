interface dut_if(input logic clk);
    logic rstn;
    logic valid;
    logic ready;
    logic [7:0] cmd;
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic [15:0] addr_in;
endinterface
