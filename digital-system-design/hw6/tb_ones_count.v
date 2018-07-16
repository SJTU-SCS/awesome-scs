`include "ones_count.v"
module tb_ones_count();
	// define signals
	reg [7:0] dat_in;
	wire [3:0] count;	  
	// initially set dat_in	
	initial	
	begin
		dat_in = 8'b0000_0000;
	end
	// use always module to change dat_in
	always 
	begin
		#1 dat_in = dat_in + 1;		  
		if (dat_in == 8'b0000_0000)
			$stop;
		else ;
	end
	// example of ones_count
	ones_count example(count, dat_in);
	// monitor the process
	initial $monitor("it's at time %d, dat_in=%b, count=%b", $time, dat_in, count);
endmodule
	

