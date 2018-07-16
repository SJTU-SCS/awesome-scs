`timescale 10 ns / 1 ns
`include "wavegen.v"  
module testbench1(x); //test module
	// define an output 
	output x;			
	// example of module wavegen
	wavegen example(x);
	// monitor the process
	initial $monitor("it's at time %d, x=%d", $time, x);
endmodule
