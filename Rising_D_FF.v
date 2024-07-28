// rising edge D Flip Flop

module DFlipFlop 
  (
    i_D,
    i_clk,
	i_prn,
	i_clrn,
	o_Q
	);

  input  i_D;    // Data input 
  
  input  i_clk;  // clock input 
  
  input  i_prn;  // preset forces Q = 1 when it is asserted low
  
  input  i_clrn; // clear foces Q = 0 when asserted low
  
  output reg o_Q;    // output Q 
always @(posedge i_clk) begin
  if (!i_prn)
    o_Q <= 1'b1;  
  else if (!i_clrn)
    o_Q <= 1'b0;
  else 
    o_Q <= i_D; 
end 
endmodule 
	
   
    	