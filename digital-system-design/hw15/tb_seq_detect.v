`include "seq_detect.v"
module tb_seq_detect();
	// define signals
	reg clk=0, rst_n, din;
	wire flag;	  
	// create clock
	always #1 clk = ~clk;
	// initial module
	initial
	begin // create some signals
		rst_n = 1;
		#2 din = 0; #2 din = 1; #2 din = 1;
		#2 din = 0; #2 din = 1; #2 din = 1;
		#2 din = 0; #2 din = 0; #2 din = 1;
		#2 din = 1; #2 din = 0;	#2 rst_n = 0;
		#2 rst_n = 1; #2 din = 1; #2 din = 1;
		#2 din = 0; #2 din = 0; #2 din = 1;
		#2 din = 1; #2 din = 0; #2 $stop;
	end
	// example of seq_detect
	seq_detect example(flag, din, clk, rst_n);
endmodule
		
	