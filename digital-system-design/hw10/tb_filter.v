`include "filter.v"
module tb_filter();
	// define signals
	reg clock, reset, sig_in, sig_out;
	// create clock
	always #1 clock = ~clock;
	// create signals
	initial 
	begin
		clock = 0;
		reset = 1;
		#2 sig_in = 0; #2 sig_in = 1;
		#2 sig_in = 0; #2 sig_in = 1;
		#2 sig_in = 1; #2 sig_in = 0;
		#2 sig_in = 0; #2 sig_in = 1;
		#2 sig_in = 0; #2 reset = 0;
		#1 reset = 1;  #2 sig_in = 0;
		#2 sig_in = 0; #2 sig_in = 1;
		#1 $stop;
	end	   
	// example of filter
	filter example(sig_out, clock, reset, sig_in); 
endmodule