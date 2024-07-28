// test bench for edge detector 
`include "s_edge_det.v"

module sedge_tb;

reg r_clk;

reg r_sw0;

wire w_out;

// 50 MHz clock ----------------------------------------------------------------------------
initial begin
	r_clk = 0;
	forever 
		 #10 r_clk = ~r_clk; // 10 second delay since we want it to be on for half the period cycle
end 

sedge se0
  ( 
    .i_sw0(r_sw0),
	.i_clk(r_clk),
	.o_out(w_out)
	);
	
//---------------------------------------------------------------------------------------------------
//aim for 5 total input pulses with varying lengths. Total time: 
//---------------------------------------------------------------------------------------------------

// Could use 'r_sw0 <= !r_sw0' loop instead, but doing it discretely like this makes it easier to find mistakes
initial begin
  r_sw0 <= 1'b0;
  #5
  r_sw0 <= 1'b1;
  #5
  r_sw0 <= 1'b0;
  #10
  r_sw0 <= 1'b1;
  #10
  r_sw0 <= 1'b0;
  #15
  r_sw0 <= 1'b1;
  #15
  r_sw0 <= 1'b0;
  #30
  r_sw0 <= 1'b1;
  #30
  r_sw0 <= 1'b0;
  #100
  r_sw0 <= 1'b1;
  #100
  r_sw0 <= 1'b0;
  #500
  r_sw0 <= 1'b1;
  #500
  r_sw0 <= 1'b0;
  #5
  $display("Test is complete");
  $finish;
end 

initial begin
  $monitor("time = $t, clk = %b, sw0 = %b, out= %b", $time, r_clk, r_sw0, w_out);
  $dumpfile("sedge.vcd");
  $dumpvars();
end
endmodule
  