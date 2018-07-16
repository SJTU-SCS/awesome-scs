`include "mux2x1.v"
module tb_mux2x1();
	// define signals
	reg [1:0] din;
	reg sel;
	wire dout;		
	// initial din and sel 
	initial
	begin	
		din = 2'b10;
		sel = 0;
	end		  	 
    // change sel periodicly   
	always #1 sel = ~sel; 
	// example of mux2x1 module
	mux2x1 example(dout, sel, din);  
	//monitor the process
	initial $monitor("it's at time %d, din=%b, sel=%b dout=%d", $time, din, sel, dout);
endmodule
	
