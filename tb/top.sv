module top(input clk);
  dut instance1(clk);
  top_tb instance2(clk);
initial begin
  $display("Hello World!");
end
endmodule
