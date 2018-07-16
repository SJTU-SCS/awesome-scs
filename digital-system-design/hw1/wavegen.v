`timescale 10 ns / 1 ns
module	wavegen(x);
	// generate wave
	output reg x;
	// use initial module to change value
	initial 				 
	begin
		     x = 0; 
		#0.2 x = 1;
		#0.1 x = 0;
		#0.9 x = 1;
		#1.0 x = 0;
		#0.2 x = 1;
		#0.3 x = 0;
		#0.5 x = 1;
	end
endmodule