// synchronous edge detector
// takes input pulse, must be clock period size or larger, returns an output with the same width as the clock period
`include "Rising_D_FF.v"

module sedge 
  ( 
    i_sw0,
	i_clk,
	o_out
	);

  input i_sw0;
  
  input i_clk;
  
  output o_out;
  
  wire d0_out; // output of 1st d flop
  
  wire d1_out; // output of 2nd d flop
  
  wire o_and; // output from and gate
  
  reg prn = 1'b1;  // prn not asserted
  
  reg clrn =  1'b1; // clrn not asserted
  
//-----------------------------------------------------------------------------
// first d flip flop 
DFlipFlop dff0 (
                 i_sw0,
                 i_clk,
	             prn,
	             clrn,
	             d0_out
	             );

// 2nd d flip flop
DFlipFlop dff1 (
                 d0_out, // receives output of first d flip flop as its input
                 i_clk,
	             prn,
	             clrn,
	             d1_out
	             );
// and gate before last d flip flop
  assign o_and = d0_out & ~d1_out; // output that will be inputted into final d_flipflop
  
// final d flip flop
DFlipFlop dff2 (
                 o_and,
                 i_clk,
	             prn,
	             clrn,
	             o_out
	             );
endmodule

  


 

  
  