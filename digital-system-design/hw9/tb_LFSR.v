`include "LFSR.v"
module tb_LFSR();
	// define signals
	wire [1:26] q;
	reg clk, rst_n, load;
	wire [1:26] din=26'b1;
	// create clock
	always #1 clk = ~clk;
	initial 
	begin
		clk = 0;
		rst_n = 1;
		load = 0;
		#15 rst_n = 0;
		#1  rst_n = 1;
		#50 load = 1;
		#1  load = 0;	  
		#10 $stop;
	end
	// example of LFSR
	LFSR example(q, clk, rst_n, load, din);	
	// monitor the process
	initial $monitor("it's at time %d, q=%b, rst_n=%d, load=%b", $time, q, rst_n, load);
endmodule
		
		