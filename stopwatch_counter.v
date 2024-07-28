// counter for stopwatch
// made by cascading multiple counters with the dsired modulus

`include "bcd_counter.v"

module min_counter
  #(parameter modulus = 500000, S_width = 25)
  (
    i_clk,
	i_sclr,
	i_en,
	o_sec_3,
	o_sec_2,
	o_sec_1,
	o_sec_0,
	o_min_1,
	o_min_0,
	o_hr_1,
	o_hr_0
	);
	
  input i_clk;
  
  input i_sclr;
  
  input i_en; 
  
  output [3:0] o_sec_3;			// .0x place seconds
  
  output [3:0] o_sec_2;			// .x place for seconds
  
  output [3:0] o_sec_1;			// 00:00:x0 place for seconds
  
  output [3:0] o_sec_0;			// 00:00:x0 place for seconds
  
  output [3:0] o_min_1;			//  00:0x:00 place for minutes
  
  output [3:0] o_min_0;			// 00:x0:00 place for hours
  
  output [3:0] o_hr_1;			// 0x:00:00 place for hours
  
  output [3:0] o_hr_0;			// x0:00:00 place for hours
  
// wires ------------------------------------------------------------------------------------
 
  wire [S_width-1:0] w_100cnt;          // output from counter that will send out 100 Hz
  
  wire w_100cout;         // output pulse that will enable the .0x place for seconds
  
  wire w_s3_cout;         // output pulse that will enable the .x place for seconds
  
  wire w_s2_cout;         // output pulse that will enable the  00:00:0x  place for seocnds
  
  wire w_s1_cout;         // output pulse that will enable the  00:00:x0  place for seconds
  
  wire w_s0_cout;         // output pulse that will enable the  00:0x:00  place for mins
  
  wire w_m1_cout;         // output pulse that will enable the 00:x0:00  place for mins
   
  wire w_m0_cout;         // output pulse that will enable the 0x:00:00  place for hours
	
  wire w_h1_cout;         // output pulse that will enable the x0:00:00  place for mins
  
  wire w_h0_cout;        // output pulse from last circuit, unused
  
//--------------------------------------------------------------------------------------------------------
// first counter that starts sequence, with an input clock of 50 MHz
// Its cout pulse will generte our 100ths place for seconds, 100 Hz

bcd_counter #(.MOD(modulus), .BUS_WIDTH(S_width)) cnt100
  ( 
    .i_clk(i_clk),
    .i_sclr(i_sclr),
    .i_cin(i_en),
    .o_cnt(w_100cnt),
    .o_cout(w_100cout)
	);

//--------------------------------------------------------------------------------------------------------
//counters that will counter in secs,mins, hrs

// seconds,  00:00:00.0x
bcd_counter #(.MOD(10), .BUS_WIDTH(4)) cnts0_01
  ( 
    .i_clk(i_clk),
    .i_sclr(i_sclr),
    .i_cin(w_100cout),
    .o_cnt(o_sec_3),
    .o_cout(w_s3_cout)
	);

// seconds,  00:00:00.x
bcd_counter #(.MOD(10), .BUS_WIDTH(4)) cnts0_1
  ( 
    .i_clk(i_clk),
    .i_sclr(i_sclr),
    .i_cin(w_s3_cout),
    .o_cnt(o_sec_2),
    .o_cout(w_s2_cout)
	);

// seconds,  00:00:0x
bcd_counter #(.MOD(10), .BUS_WIDTH(4)) cnts1_0
  ( 
    .i_clk(i_clk),
    .i_sclr(i_sclr),
    .i_cin(w_s2_cout),
    .o_cnt(o_sec_1),
    .o_cout(w_s1_cout)
	);
	
// seconds,  00:00:x0
bcd_counter #(.MOD(6), .BUS_WIDTH(4)) cnts10_0
  ( 
    .i_clk(i_clk),
    .i_sclr(i_sclr),
    .i_cin(w_s1_cout),
    .o_cnt(o_sec_0),
    .o_cout(w_s0_cout)
	);

// minutes,  00:0x:00 
bcd_counter #(.MOD(10), .BUS_WIDTH(4)) cntm1_0
  ( 
    .i_clk(i_clk),
    .i_sclr(i_sclr),
    .i_cin(w_s0_cout),
    .o_cnt(o_min_1),
    .o_cout(w_m1_cout)
	);
	
// minutes,  00:x0:00 
bcd_counter #(.MOD(6), .BUS_WIDTH(4)) cntm10_0
  ( 
    .i_clk(i_clk),
    .i_sclr(i_sclr),
    .i_cin(w_m1_cout),
    .o_cnt(o_min_0),
    .o_cout(w_m0_cout)
	);

// hours,  0x:00:00 
bcd_counter #(.MOD(10), .BUS_WIDTH(4)) cnth1_0
  ( 
    .i_clk(i_clk),
    .i_sclr(i_sclr),
    .i_cin(w_m0_cout),
    .o_cnt(o_hr_1),
    .o_cout(w_h1_cout)
	);

// hours,  x0:00:00 
bcd_counter #(.MOD(10), .BUS_WIDTH(4)) cnth10_0
  ( 
    .i_clk(i_clk),
    .i_sclr(i_sclr),
    .i_cin(w_h1_cout),
    .o_cnt(o_hr_0),
    .o_cout(w_h0_cout)
	);
	
endmodule