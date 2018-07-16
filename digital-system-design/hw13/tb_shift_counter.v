`include "shift_counter.v"
module tb_shift_counter();
	// define signals
	reg clk=1'b0;
	wire [7:0] count;
	reg reset;
	// create a clock
	always #1 clk = ~clk;
	// initial module
	initial
	begin
		reset = 1'b0;
		#34 reset = 1'b1;
		#2 reset = 1'b0; 
		#20 $stop;
	end
	// example of shift_counter
	shift_counter example(count, clk, reset);
	// monitor the process
	initial $monitor("it's at time %d, count=%b, reset=%b", $time, count, reset); 
endmodule

