`include "moore.v" 
`include "mealy.v"
module top();
	// define signals
	reg clk=1, rst_n, din;
	wire flag1, flag2;	  
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
	// example of moore and meanly
	moore example1(flag1, din, clk, rst_n);
	mealy example2(flag2, din, clk, rst_n);
endmodule

