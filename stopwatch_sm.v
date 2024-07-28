// stopwatch state machine 
// simple function, uses one button to control te start, stop, and clear of a counter
// pair with edge detector to control input and a counter to control delay

module stopwatch
  (
    i_clk,
	i_key,
	i_delay,
	o_stout,
	o_stclear
	);
	
  input i_clk;
  
  input i_key;        // input that starts stopwatch machine and stops it, clears if held
  
  input i_delay;        // input that uses delay to discern between start, stop, and clear
  
  output reg o_stout;       // output that will enable counter
  
  output reg o_stclear;     // output that will clear counter
  
 //--------------------------------------------------------------------------------
 // states that will change output signal
  
  reg [1:0] state_holder;
  
  reg [1:0] present_state;
  
  localparam st_start = 2'b10;
  
  localparam st_stop = 2'b00;
  
  localparam st_clear = 2'b01;
  

always @(*) begin
  case(present_state)
    st_clear : begin
	  if (i_delay == 1'b1)
	    state_holder <= st_clear;
	  else if (i_key && !i_delay)
	    state_holder <= st_start;
	  else 
	    state_holder <= st_stop;
	end 
	
	st_start : begin
	  if (i_key && !i_delay)
	    state_holder <= st_stop;
	  else if (i_delay == 1'b1)
	    state_holder <= st_clear;
	  else state_holder <= st_start;
	end
	
	st_stop : begin
	  if (i_key && !i_delay)
	    state_holder <= st_start;
	  else if (i_delay == 1'b1)
	    state_holder <= st_clear;
	  else 
	    state_holder <= st_stop;
	end
	
	default : state_holder <= st_stop;
  endcase
end 

always @(posedge i_clk) begin
  if (present_state == st_stop) begin
    o_stout   <= 1'b0;
	o_stclear <= 1'b0;
  end 
  
  else if (present_state == st_start) begin
    o_stout   <= 1'b1;
	o_stclear <= 1'b0;
  end 
  
  else if (present_state == st_clear) begin
    o_stout   <= 1'b0;
	o_stclear <= 1'b1;
  end 
  
end 

always @(posedge i_clk) 
  present_state <= state_holder;
  
endmodule 
  