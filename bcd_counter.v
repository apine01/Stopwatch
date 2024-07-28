// binary counter that displays in decimal

module bcd_counter 
  #(parameter MOD = 10, BUS_WIDTH = 4)
  ( 
    i_clk,
    i_sclr,
    i_cin,
    o_cnt,
    o_cout
	);
  
  input i_clk;  // clock that drives counter
  
  input i_sclr; // clears counter when 1
  
  input i_cin;  // input that enables counter 
  
  output reg [BUS_WIDTH-1:0] o_cnt = 0; // counter output
  
  output reg o_cout = 0;               // output wave when counter reaches counter eaches modulus
  
// ----------------------------------------------------------------------------------------------------------
// Counter triggered at every rising edge of the input clock speed
// ----------------------------------------------------------------------------------------------------------
  
always @(posedge i_clk) begin 
  if (i_sclr == 1'b1)                                   // clears if sclr is 1
    o_cnt <= 0;
  else if (i_clk && i_cin && o_cnt < MOD - 1)           // only enables circuit if cin input is on
    o_cnt <= o_cnt + 1;                              
  else if (o_cnt == MOD - 1 && i_cin) begin             // modulus will clear counter when it reaches value
    o_cnt <= 0;
	o_cout <= 1;                                        // sends output signal cout when it resets at modulus value
  end 
  if (o_cout == 1)
    o_cout <= 0;                                        // clears cout by next clock cycle
end 
endmodule
  
  
  
  
  