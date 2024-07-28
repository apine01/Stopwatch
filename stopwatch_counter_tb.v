//test bench for stopwatch counter
`include "stopwatch_counter.v"

module min_counter_tb;

  reg r_clk;
  
  reg r_sclr;
  
  reg r_en;
  
  wire [3:0] w_sec_3;			// .0x place seconds
  
  wire [3:0] w_sec_2;			// .x place for seconds
  
  wire [3:0] w_sec_1;			// 00:00:x0 place for seconds
  
  wire [3:0] w_sec_0;			// 00:00:x0 place for seconds
  
  wire [3:0] w_min_1;			//  00:0x:00 place for minutes
  
  wire [3:0] w_min_0;			// 00:x0:00 place for hours
  
  wire [3:0] w_hr_1;			// 0x:00:00 place for hours
  
  wire [3:0] w_hr_0;			// x0:00:00 place for hours
  
  
//clock generation-----------------------------------------------------
initial r_clk = 0;
always  #10 r_clk = ~r_clk;

//---------------------------------------------------------------------------------------------------------------
//make modulus 5 to speed up counting proccess by 100000 times to ensure later segments work
// Test lasts 1s + 100ns
min_counter
  #(.modulus(5), .S_width(4)) min0
  (
    .i_clk(r_clk),
	.i_sclr(r_sclr),
	.i_en(r_en),
	.o_sec_3(w_sec_3),
	.o_sec_2(w_sec_2),
	.o_sec_1(w_sec_1),
	.o_sec_0(w_sec_0),
	.o_min_1(w_min_1),
	.o_min_0(w_min_0),
	.o_hr_1(w_hr_1),
	.o_hr_0(w_hr_0)
	);
	
integer delay;

initial delay = 10**9;
 
initial begin
  r_sclr <= 1'b0;
  r_en   <= 1'b1;
  #delay  // 1s
  r_sclr <= 1'b1;
  #40
  r_sclr <= 1'b0;
  r_en   <= 1'b0;
  #60
  $display("Test is complete");
  $finish;
end 

initial begin
  $dumpfile("stopwatch_counter2.vcd");
  $dumpvars();
end
endmodule