`include "mealy.v"
module top2();
	// define signals
	reg clk=1, rst_n, din;
	wire flag;	  
	// create clock
	always #1 clk = ~clk;
	// initial module
	initial
	begin // create some signals
		rst_n = 0; din = 1;
		#2 din = 0; #2 din = 1; #2 din = 0;
		#2 din = 1; #2 din = 0; #2 din = 1;
		#2 din = 0; #2 din = 1; #2 din = 0;
		#2 din = 0; #2 din = 1;	#2 rst_n = 1;
		#2 rst_n = 0; #2 din = 0; #2 din = 1;
		#2 din = 0; #2 din = 1; #2 din = 0;
		#2 din = 1; #2 din = 0; #2 din = 1;
		#2 $stop;
	end
	// example of moore
	mealy example(flag, din, clk, rst_n);
endmodule