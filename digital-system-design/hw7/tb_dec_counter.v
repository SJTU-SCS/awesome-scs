`include "dec_counter.v"
module tb_dec_counter();
	// define signals
	reg [7:0] clk;
	wire [3:0] count;
	reg reset;
	// initially set clk and reset
	initial 
	begin 
		clk = 0;
		reset  =1'b0;	  		  
	end
	// create a clk and change reset every 7 time units
	always 
	begin
		#1 clk = clk + 1;  
		if (clk == 8'b0000_0000)
			$stop;
		else ;	  
	end
	always
	begin
		#18 reset = 1; 
		#1 reset = 0;	 
	end
	// example of dec_counter
	dec_counter example(count, clk, reset);
	// monitor the process
	initial $monitor("it's at time %d, clk=%d, count=%d, reset=%b", $time, clk, count, reset);	  
endmodule
	