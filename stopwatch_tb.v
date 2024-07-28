// test bunch for stop watch state machine
`include "stopwatch_sm.v"
`include "stopwatch_counter.v" // also includes bcd counter
`include "s_edge_det.v"

module stopwatch_tb;

  reg r_clk;
  
  reg r_key;     // button that controls state of stopwatch
  
//----------------------------------------------------------------------------------------------------------------------------
//wire connections to connect various modules

  wire w_key;        // edge detector output that connects to stopwatch module
 
  wire w_stout;      // output of state machine, enables counter
  
  wire w_stclear;    // clears counter when output is high
  
  wire w_cout;       // output of delay counter, will drive delay input of stopwatch
  
//delay counter wires---------------------------------------------------------------

  wire w_clr;         // clear for delay counter, will not be used
  assign w_clr = 1'b0; // asserted low so it never clears unless it hits the modulus value
  
  wire [8:0] w_dcnt;        // delay counter output, not used
// stopwatch counter wires-------------------------------------------------------
  
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

// edge detector --------------------------------------------------------

sedge edge1
  ( 
    .i_sw0(r_key),
	.i_clk(r_clk),
	.o_out(w_key)
	);

// stopwatch module -------------------------------------------------------------------------------------

stopwatch stop0
  (
    .i_clk(r_clk),
	.i_key(w_key),
	.i_delay(w_cout),
	.o_stout(w_stout),
	.o_stclear(w_stclear)
	);
	
// delay counter module -----------------------------------------------------------------
// make delay same as last time, set modulus = 500 and get a 10,000 ns delay
// delay is short simply for test purposes, for real world application, it would be increased to over 2 seconds

bcd_counter #(.MOD(500), .BUS_WIDTH(9)) bcd1
  ( 
    .i_clk(r_clk),
    .i_sclr(w_clr),
    .i_cin(r_key),
    .o_cnt(w_dcnt),
    .o_cout(w_cout)
	);

// stopwatch counter that will be enabled when the state machine outputs correctly
// lower modulus to speed it up
min_counter
  #(.modulus(5), .S_width(4)) min0
  (
    .i_clk(r_clk),
	.i_sclr(w_stclear),
	.i_en(w_stout),
	.o_sec_3(w_sec_3),
	.o_sec_2(w_sec_2),
	.o_sec_1(w_sec_1),
	.o_sec_0(w_sec_0),
	.o_min_1(w_min_1),
	.o_min_0(w_min_0),
	.o_hr_1(w_hr_1),
	.o_hr_0(w_hr_0)
	);

// cycle through each state to ensure function
// Test lasts 
initial begin 
  r_key <= 1'b0;
  #100
  r_key <= 1'b1;   // starts
  #100
  r_key <= 1'b0; 
  #400000 // 400,000 ns
  
  
  r_key <= 1'b1;   // stops, but not clear
  #100 
  r_key <= 1'b0;
  #500
  
  r_key <= 1'b1;  // starts again
  #10009 // 10,009 ns, long enough for delay, stops and then clears, stays stopped
  r_key <= 1'b0;
  #100
  
  r_key <= 1'b1; // starts after it has stopped
  #100
  r_key <= 1'b0;
  #100
  
  r_key <= 1'b1; // stops 
  #10500 // 10,500 ns, long enough for delay, should clear and then stop
  r_key <= 1'b0;
  #100
  
  $display("Test is complete");
  $finish;
end 


initial begin
  $dumpfile("stopwatch_tb.vcd");
  $dumpvars();
end
endmodule

